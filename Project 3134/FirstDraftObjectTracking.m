
function varargout = FirstDraftObjectTracking(varargin)
% FIRSTDRAFTOBJECTTRACKING MATLAB code for FirstDraftObjectTracking.fig
%      FIRSTDRAFTOBJECTTRACKING, by itself, creates a new FIRSTDRAFTOBJECTTRACKING or raises the existing
%      singleton*.
%
%      H = FIRSTDRAFTOBJECTTRACKING returns the handle to a new FIRSTDRAFTOBJECTTRACKING or the handle to
%      the existing singleton*.
%
%      FIRSTDRAFTOBJECTTRACKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRSTDRAFTOBJECTTRACKING.M with the given input arguments.
%
%      FIRSTDRAFTOBJECTTRACKING('Property','Value',...) creates a new FIRSTDRAFTOBJECTTRACKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FirstDraftObjectTracking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FirstDraftObjectTracking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FirstDraftObjectTracking

% Last Modified by GUIDE v2.5 13-Apr-2014 22:55:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FirstDraftObjectTracking_OpeningFcn, ...
                   'gui_OutputFcn',  @FirstDraftObjectTracking_OutputFcn, ...
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
end

% --- Executes just before FirstDraftObjectTracking is made visible.
function FirstDraftObjectTracking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FirstDraftObjectTracking (see VARARGIN)

% Choose default command line output for FirstDraftObjectTracking
handles.output = hObject;
handles.video = videoinput('winvideo',1);
set(handles.video, 'FramesPerTrigger', Inf);
set(handles.video, 'ReturnedColorspace', 'rgb')
set(handles.axes1,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);
handles.video.FrameGrabInterval = 1;
set(handles.axes2,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks

start(handles.video)
set(handles.axes1);






% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FirstDraftObjectTracking wait for user response (see UIRESUME)
% uiwait(handles.FirstDraftObjectTracking);
end

% --- Outputs from this function are returned to the command line.
function varargout = FirstDraftObjectTracking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in StartCamera.
function StartCamera_Callback(hObject, eventdata, handles)
% hObject    handle to StartCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

while(1)
    
    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    
    % Display the image
    imshow(data)
end
end    

% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.video);

% Flush all the image data stored in the memory buffer.
flushdata(handles.video);

% Clear all variables
clear all;
close all;
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in Red.
function Red_Callback(hObject, eventdata, handles)
% hObject    handle to Red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global h;
global c;
% Hint: get(hObject,'Value') returns toggle state of Red
set(handles.axes1);
stop(handles.video)
start(handles.video)
if (get(hObject,'Value') == get(hObject,'Max'))
        
        hold(handles.axes2);   
        while(1)
            set(handles.axes2,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks

            % Get the snapshot of the current frame
            data = getsnapshot(handles.video);

            % Now to track red objects in real time
            % we have to subtract the red component 
            % from the grayscale image to extract the red components in the image.
            diff_im = imsubtract(data(:,:,1), rgb2gray(data));
            %Use a median filter to filter out noise
            diff_im = medfilt2(diff_im, [3 3]);
            % Convert the resulting grayscale image into a binary image.
            diff_im = im2bw(diff_im,0.11);

            % Remove all those pixels less than 300px
            diff_im = bwareaopen(diff_im,300);

            % Label all the connected components in the image.
            bw = bwlabel(diff_im, 8);

            % Here we do the image blob analysis.
            % We get a set of properties for each labeled region.
            stats = regionprops(bw, 'BoundingBox', 'Centroid');
           

            % Display the image
            imshow(data)
          
               

            
             
            hold(handles.axes1);
            
            %This is a loop to bound the red objects in a rectangular box.
            for object = 1:length(stats)
                bb = stats(object).BoundingBox;
                bc = stats(object).Centroid;
                
                rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
                plot(handles.axes1,bc(1),bc(2), '-m+')
                 if ~isempty(bb)  %  Get the centroid of remaining blobs
                     centX = bc(1); centY = bc(2);
                 end
                a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
                set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
                 h = getappdata(0,'var');
                if(h == 0)
                     c = getappdata(0,'var2');
            if(c == 0)
                    handles.color =[0,0,0];
            elseif(c == 1)
                    handles.color = [1,1,0];
            elseif(c == 2)
                 handles.color = [0.75,0,0.75];
            elseif( c == 3)
                 handles.color = [0.87,0.49,0];
            elseif( c == 4)
                handles.color = [1,0,0];
            elseif(c == 5)
                handles.color = [0,1,0];
            elseif(c == 6)
                handles.color = [0,0,1];
            else
                    handles.color = [1,0,0];
            end
                plot(handles.axes2,-centX,-centY, 'o','LineWidth', 5,'color', handles.color,'MarkerSize',5);
                axis(handles.axes2,[-140,-30,-140,-30])            
                end   
               
            end
     

                
                
                hold off;
                
               F = getframe(handles.axes2);

imwrite(F.cdata, fullfile('C:\Users\Eric\Google Drive\Project 3134','RedAxe.jpg'));
            
    
         
        end
        hold off;
                
else
                
 while(1)
    cla(handles.axes2,'reset');
    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    
    % Display the image
    imshow(data)
end
    
 
end
end 
% --- Executes on button press in Green.
function Green_Callback(hObject, eventdata, handles)
% hObject    handle to Green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global h;
global c;
% Hint: get(hObject,'Value') returns toggle state of Green
stop(handles.video)
start(handles.video)
if (get(hObject,'Value') == get(hObject,'Max'))
  
    hold(handles.axes2);
   
while(1)
                set(handles.axes2,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks

    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    % Now to track red objects in real time
    % we have to subtract the red component 
    % from the grayscale image to extract the red components in the image.
    diff_im = imsubtract(data(:,:,2), rgb2gray(data));
    %Use a median filter to filter out noise
    diff_im = medfilt2(diff_im, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,0.05);
    
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,300);
    
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow(data)
    
    hold(handles.axes1);
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','g','LineWidth',2)
        plot(handles.axes1,bc(1),bc(2), '-m+')
         if ~isempty(bb)  %  Get the centroid of remaining blobs
                     centX = bc(1); centY = bc(2);
         end
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
         h = getappdata(0,'var');
      if(h == 0)
           c = getappdata(0,'var2');
            if(c == 0)
                    handles.color =[0,0,0];
            elseif(c == 1)
                    handles.color = [1,1,0];
            elseif(c == 2)
                 handles.color = [0.75,0,0.75];
            elseif( c == 3)
                 handles.color = [0.87,0.49,0];
            elseif( c == 4)
                handles.color = [1,0,0];
            elseif(c == 5)
                handles.color = [0,1,0];
            elseif(c == 6)
                handles.color = [0,0,1];
            else
                    handles.color = [0,1,0];
            end
        plot(handles.axes2,-centX,-centY, 'o','LineWidth', 5,'color', handles.color,'MarkerSize',5);
                axis(handles.axes2,[-140,-30,-140,-30])
      end
    end
    F = getframe(handles.axes2);

imwrite(F.cdata, fullfile('C:\Users\Eric\Google Drive\Project 3134','GreenAxe.jpg'));
    hold off
    
end
hold off
else
    while(1)
     cla(handles.axes2,'reset');
    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    
    % Display the image
    imshow(data)
    end
end
end
% --- Executes on button press in Blue.
function Blue_Callback(hObject, eventdata, handles)
% hObject    handle to Blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global centX;
global centY;
global h;
global c;   


% Hint: get(hObject,'Value') returns toggle state of Blue
stop(handles.video)
start(handles.video)
 
if (get(hObject,'Value') == get(hObject,'Max'))
    
   
   hold(handles.axes2);
  
while(1)
  
            set(handles.axes2,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks

    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    % Now to track red objects in real time
    % we have to subtract the red component 
    % from the grayscale image to extract the red components in the image.
    diff_im = imsubtract(data(:,:,3), rgb2gray(data));
    %Use a median filter to filter out noise
    diff_im = medfilt2(diff_im, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,0.10);
    
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,300);
    
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow(data)
    
    hold(handles.axes1);
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','b','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
         if ~isempty(bb)  %  Get the centroid of remaining blobs
                centX = bc(1);centY = bc(2);
         end
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
       h = getappdata(0,'var');
      if(h == 0)
          c = getappdata(0,'var2');
            if(c == 0)
                    handles.color =[0,0,0];
            elseif(c == 1)
                    handles.color = [1,1,0];
            elseif(c == 2)
                 handles.color = [0.75,0,0.75];
            elseif( c == 3)
                 handles.color = [0.87,0.49,0];
            elseif( c == 4)
                handles.color = [1,0,0];
            elseif(c == 5)
                handles.color = [0,1,0];
            elseif(c == 6)
                handles.color = [0,0,1];
            else
                    handles.color = [0,0,1];
            end
      plot(handles.axes2,-centX,-centY, 'o','LineWidth', 5,'color', handles.color,'MarkerSize',5);
                axis(handles.axes2,[-140,-30,-140,-30])
 
      end
  
    end
    hold off
     F = getframe(handles.axes2);

imwrite(F.cdata, fullfile('C:\Users\Eric\Google Drive\Project 3134','BlueAxe.jpg'));
end
 
    hold off;
    
else
    while(1)
     cla(handles.axes2,'reset');
    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    
    % Display the image
    imshow(data)
    end
end

end

% --- Executes on button press in DrawPad.


% Hint: get(hObject,'Value') returns toggle state of DrawPad


% --- Executes on button press in DrawPad.
function DrawPad_Callback(hObject, eventdata,handles)
% hObject    handle to DrawPad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
b = 0
setappdata(0,'var',b);

else
b =1;
setappdata(0,'var',b);


end;
% Hint: get(hObject,'Value') returns toggle state of DrawPad
end


% --- Executes on button press in Black.
function Black_Callback(hObject, eventdata, handles)
% hObject    handle to Black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
a= 0;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
% Hint: get(hObject,'Value') returns toggle state of Black
end


% --- Executes on button press in Yellow.
function Yellow_Callback(hObject, eventdata, handles)
% hObject    handle to Yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
a= 1;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
% Hint: get(hObject,'Value') returns toggle state of Yellow
end


% --- Executes on button press in Purple.
function Purple_Callback(hObject, eventdata, handles)
% hObject    handle to Purple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
a= 2;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
% Hint: get(hObject,'Value') returns toggle state of Purple
end


% --- Executes on button press in Orange.
function Orange_Callback(hObject, eventdata, handles)
% hObject    handle to Orange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
a= 3;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
% Hint: get(hObject,'Value') returns toggle state of Orange
end

% --- Executes on button press in RedColor.
function RedColor_Callback(hObject, eventdata, handles)
% hObject    handle to RedColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
a= 4;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
% Hint: get(hObject,'Value') returns toggle state of RedColor
end

% --- Executes on button press in GreenColor.
function GreenColor_Callback(hObject, eventdata, handles)
% hObject    handle to GreenColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
a= 5;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
% Hint: get(hObject,'Value') returns toggle state of GreenColor
end

% --- Executes on button press in BlueColor.
function BlueColor_Callback(hObject, eventdata, handles)
% hObject    handle to BlueColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
a= 6;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
% Hint: get(hObject,'Value') returns toggle state of BlueColor
end
