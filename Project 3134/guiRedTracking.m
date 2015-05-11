function varargout = guiRedTracking(varargin)
% GUIREDTRACKING MATLAB code for guiRedTracking.fig
%      GUIREDTRACKING, by itself, creates a new GUIREDTRACKING or raises the existing
%      singleton*.
%
%      H = GUIREDTRACKING returns the handle to a new GUIREDTRACKING or the handle to
%      the existing singleton*.
%
%      GUIREDTRACKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIREDTRACKING.M with the given input arguments.
%
%      GUIREDTRACKING('Property','Value',...) creates a new GUIREDTRACKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiRedTracking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiRedTracking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiRedTracking

% Last Modified by GUIDE v2.5 21-Mar-2014 12:26:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiRedTracking_OpeningFcn, ...
                   'gui_OutputFcn',  @guiRedTracking_OutputFcn, ...
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


% --- Executes just before guiRedTracking is made visible.
function guiRedTracking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiRedTracking (see VARARGIN)

% Choose default command line output for guiRedTracking
handles.output = hObject;

handles.video = videoinput('winvideo',1);
set(handles.video, 'FramesPerTrigger', Inf);
set(handles.video, 'ReturnedColorspace', 'rgb')
handles.video.FrameGrabInterval = 5;
start(handles.video)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiRedTracking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiRedTracking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
while(handles.video.FramesAcquired<=200)
    
    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    % Now to track red objects in real time
    % we have to subtract the red component 
    % from the grayscale image to extract the red components in the image.
    diff_im = imsubtract(data(:,:,1), rgb2gray(data));
    %Use a median filter to filter out noise
    diff_im = medfilt2(diff_im, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,0.25);
    
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,300);
    
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow(data)
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    
    hold off
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.video);

% Flush all the image data stored in the memory buffer.
flushdata(handles.video);

% Clear all variables
clear all
sprintf('%s','That was all about Image tracking, Guess that was pretty easy :) ')
close all;

