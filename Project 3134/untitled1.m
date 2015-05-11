function varargout = untitled1(varargin)
% UNTITLED1 MATLAB code for untitled1.fig
%      UNTITLED1, by itself, creates a new UNTITLED1 or raises the existing
%      singleton*.
%
%      H = UNTITLED1 returns the handle to a new UNTITLED1 or the handle to
%      the existing singleton*.
%
%      UNTITLED1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED1.M with the given input arguments.
%
%      UNTITLED1('Property','Value',...) creates a new UNTITLED1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled1

% Last Modified by GUIDE v2.5 19-Mar-2014 20:09:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled1_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
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


% --- Executes just before untitled1 is made visible.
function untitled1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled1 (see VARARGIN)

% Choose default command line output for untitled1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles.video = videoinput('winvideo', 1);
set(handles.video,'TimerPeriod', 0.05, ...
      'TimerFcn',['if(~isempty(gco)),'...
                      'handles=guidata(gcf);'...                                 % Update handles
                      'image(getsnapshot(handles.video));'...                    % Get picture using GETSNAPSHOT and put it into axes using IMAGE
                      'set(handles.cameraAxes,''ytick'',[],''xtick'',[]),'...    % Remove tickmarks and labels that are inserted when using IMAGE
                  'else '...
                      'delete(imaqfind);'...                                     % Clean up - delete any image acquisition objects
                  'end']);
triggerconfig(handles.video,'manual');
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually stop it

% UIWAIT makes untitled1 wait for user response (see UIRESUME)
% uiwait(handles.MyCameraGUI);


% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close MyCameraGUI.
function MyCameraGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MyCameraGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
delete(imaqfind);

% --- Executes on button press in startStopCamera.
function startStopCamera_Callback(hObject, eventdata, handles)
% hObject    handle to startStopCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
end


