function varargout = myCameraGUI2(varargin)
% MYCAMERAGUI2 MATLAB code for mycameragui2.fig
%      MYCAMERAGUI2, by itself, creates a new MYCAMERAGUI2 or raises the existing
%      singleton*.
%
%      H = MYCAMERAGUI2 returns the handle to a new MYCAMERAGUI2 or the handle to
%      the existing singleton*.
%
%      MYCAMERAGUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYCAMERAGUI2.M with the given input arguments.
%
%      MYCAMERAGUI2('Property','Value',...) creates a new MYCAMERAGUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myCameraGUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myCameraGUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mycameragui2

% Last Modified by GUIDE v2.5 20-Mar-2014 14:42:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myCameraGUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @myCameraGUI2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mycameragui2 is made visible.
function myCameraGUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mycameragui2 (see VARARGIN)

% Choose default command line output for mycameragui2
handles.output = hObject;

% Create video object
% Putting the object into manual trigger mode and then
% starting the object will make GETSNAPSHOT return faster
% since the connection to the camera will already have
% been established.
handles.video = videoinput('winvideo', 1);

set(handles.video,'ReturnedColorSpace','rgb');
set(handles.video,'TimerPeriod', 0.05, ...
'TimerFcn',['if(~isempty(gco)),'...
'handles=guidata(gcf);'... % Update handles
'image(getsnapshot(handles.video));'... % Get picture using GETSNAPSHOT and put it into axes using IMAGE
'set(handles.cameraAxes,''ytick'',[],''xtick'',[]),'... % Remove tickmarks and labels that are inserted when using IMAGE
'else '...
'delete(imaqfind);'... % Clean up - delete any image acquisition objects
'end']);
triggerconfig(handles.video,'manual');
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually stop it

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mycameragui2 wait for user response (see UIRESUME)
uiwait(handles.myCameraGUI);


% --- Outputs from this function are returned to the command line.
function varargout = myCameraGUI2_OutputFcn(hObject, eventdata, handles)
% varargout cell array for returning output args (see VARARGOUT);
% hObject handle to figure
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;


% --- Executes on button press in startStopCamera.
function startStopCamera_Callback(hObject, eventdata, handles)
% hObject handle to startStopCamera (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)

% Start/Stop Camera
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
    % Camera is off. Change button string and start camera.
    set(handles.startStopCamera,'String','Stop Camera')
    start(handles.video)
    set(handles.startAcquisition,'Enable','on');
    set(handles.captureImage,'Enable','on');
    
else
    % Camera is on. Stop camera and change button string.
    set(handles.startStopCamera,'String','Start Camera')
    stop(handles.video)
    set(handles.startAcquisition,'Enable','off');
    set(handles.captureImage,'Enable','off');
   
    release(handles.video);
    
end




% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in RedTracking.
function RedTracking_Callback(hObject, eventdata, handles)
% hObject    handle to RedTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes6)
%% Initialization
redThresh = 0.25; % Threshold for red detection


vidInfo = imaqhwinfo(handles.video); % Acquire input video property
hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MinimumBlobArea', 800, ...
                                'MaximumBlobArea', 3000, ...
                                'MaximumCount', 10);
hshapeinsRedBox = vision.ShapeInserter('BorderColor', 'Custom', ... % Set Red box handling
                                        'CustomBorderColor', [1 0 0], ...
                                        'Fill', true, ...
                                        'FillColor', 'Custom', ...
                                        'CustomFillColor', [1 0 0], ...
                                        'Opacity', 0.4);
htextins = vision.TextInserter('Text', 'Number of Red Object: %2d', ... % Set text for number of blobs
                                    'Location',  [7 2], ...
                                    'Color', [1 0 0], ... // red color
                                    'FontSize', 12);
htextinsCent = vision.TextInserter('Text', '+      X:%4d, Y:%4d', ... % set text for centroid
                                    'LocationSource', 'Input port', ...
                                    'Color', [1 1 0], ... // yellow color
                                    'FontSize', 14);

nFrame = 0; % Frame number initialization

%%Processing Loop
while(1)
    rgbFrame = step(handles.video); % Acquire single frame
    rgbFrame = flipdim(rgbFrame,2); % obtain the mirror image for displaying
    diffFrame = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get red component of the image
    diffFrame = medfilt2(diffFrame, [3 3]); % Filter out the noise by using median filter
    binFrame = im2bw(diffFrame, redThresh); % Convert the image into binary image with the red objects as white
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    centroid = uint16(centroid); % Convert the centroids into Integer for further steps 
    rgbFrame(1:20,1:165,:) = 0; % put a black region on the output stream
    vidIn = step(hshapeinsRedBox, rgbFrame, bbox); % Instert the red box
    for object = 1:1:length(bbox(:,1)) % Write the corresponding centroids
        centX = centroid(object,1); centY = centroid(object,2);
        vidIn = step(htextinsCent, vidIn, [centX centY], [centX-6 centY-9]); 
    end
    vidIn = step(htextins, vidIn, uint8(length(bbox(:,1)))); % Count the number of blobs
    step(hVideoIn, vidIn); % Output video stream
    nFrame = nFrame+1;
end

%% Clearing Memory
release(hVideoIn); % Release all memory and buffer used
release(handles.video);
% clear all;

clc;



% --- Executes when user attempts to close myCameraGUI2.
function myCameraGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to myCameraGUI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
delete(imaqfind);



    





