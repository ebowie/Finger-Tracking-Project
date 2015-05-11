function varargout = MOTION(varargin)
% MOTION MATLAB code for MOTION.fig
%      MOTION, by itself, creates a new MOTION or raises the existing
%      singleton*.
%
%      H = MOTION returns the handle to a new MOTION or the handle to
%      the existing singleton*.
%
%      MOTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTION.M with the given input arguments.
%
%      MOTION('Property','Value',...) creates a new MOTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MOTION_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MOTION_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MOTION

% Last Modified by GUIDE v2.5 08-Apr-2012 22:40:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MOTION_OpeningFcn, ...
                   'gui_OutputFcn',  @MOTION_OutputFcn, ...
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


% --- Executes just before MOTION is made visible.
function MOTION_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MOTION (see VARARGIN)

% Choose default command line output for MOTION
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MOTION wait for user response (see UIRESUME)
% uiwait(handles.MOTION);




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
%imaqreset;
error=50;
s=25;
vid=videoinput('winvideo',1,'YUY2_640x480');% take video input
triggerconfig(vid,'manual');  % after triggering only we get video
set(vid,'FramesPerTrigger',1); %only 1 frame per trigger
set(vid,'TriggerRepeat', Inf); %repeating trigger infinite timf
set(vid,'ReturnedColorSpace','rgb');% colour space used is rgb
 
i=0;
start(vid);% video is started
 
 
%adjusting for background noise
 
for n=1:50
    trigger(vid);
    temp=getdata(vid,1);
    f(:,:,mod(n,2)+1)=temp(2);
    g=f(:,:,1)~=f(:,:,2);
    imshow(g);
    %sm(1,n)=backgroundcheck(g);
end
clear g;
clear temp;
 
 %f=zeros(480,640,2);
%s=max(sm(25:50));
if (nargin==0)
    error=2;
end
s=(s*(error+100))/100;% calculate sensitivity
clear sm;
clc
disp('backbround sensitivity=');%display sensitivity
disp(s);
 
 
disp('winvideo', 1);
prev=getsnapshot(vid);%take video snpshot as previous one 
while(1)
% for mk=1:100
 j=0;
    trigger(vid);
    temp=getdata(vid,1);% take video data
    axes(handles.axes2); %point to the axes where u want to display the frame
    imshow(temp);  %show the frame on axes
    g=getsnapshot(vid); %get current frame 
    %f(:,:,mod(i,2)+1)=temp;
 
    %g=f(:,:,1)~=f(:,:,2);
   %g=rgb2gray(g);
    a=prev-g; %take difference between 2 frames
    a=rgb2gray(a);
    %compp=sum(sum(a));
   %disp(compp);
   %err=((s/10)*100*50);
   %disp(err);
   prev=g; % store current frame as previous frame
    if((sum(sum(a))/100)>(s/10)*100*50)%check if difference between frames is greater than threshold
     disp('motion detected');%yes than motion detected
     axes(handles.axes3);
      imshow(a);%show difference as snapshot 
      imwrite(g,'captured.jpeg');%store difference to folder
       j=j+1;% continue the loop
    else
        disp('no motion');
        pause(1)
    end
   
   
        
    if(mod(j,6)==0)  %check if motion detected 6 times
        clc;
        disp('MOTION DETECTOR ON ->');
%         y=y(1:3000); %  to play the alarm
%       0  for a=1:4
%             wavplay(y,4500,'sync');
%         end
    end
 
%     disp('difference');
%     disp(sum(sum(sum(a))));
   i=i+1;%continue the loop
 
 
%end
%end  
%global vid
%stop(vid);
 end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global vid
stop(vid);

% to stop the video
