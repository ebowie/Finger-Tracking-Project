%Program RGB Tracking and drawing
%Author: Eric Bowers and Danial Zekleik 
%Date:4/14/2014
%Purpose: To track color objects and then ploting the coordinates on to
%white axes.
function varargout = FinalTrackingObject(varargin)
% Last Modified by GUIDE v2.5 14-Apr-2014 22:45:28
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FinalTrackingObject_OpeningFcn, ...
                   'gui_OutputFcn',  @FinalTrackingObject_OutputFcn, ...
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

% --- Executes just before FinalTrackingObject is made visible.
function FinalTrackingObject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FinalTrackingObject (see VARARGIN)

% Choose default command line output for FinalTrackingObject
handles.output = hObject;
handles.video = videoinput('winvideo',1)%video format and id.
set(handles.video, 'FramesPerTrigger', Inf)%infinite frames.
set(handles.video, 'ReturnedColorspace', 'rgb')%video color space.
set(handles.axes1,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);% Remove Axis marks

handles.video.FrameGrabInterval = 1;%the object acquires every first frame;
set(handles.axes2,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks
%start video
start(handles.video)
set(handles.axes1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FinalTrackingObject wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = FinalTrackingObject_OutputFcn(hObject, eventdata, handles) 
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
%stop video
stop(handles.video);

% Flush all the image data stored in the memory buffer.
flushdata(handles.video);

% Clear all variables
clear all;
close all;
end

% --- Executes on button press in DrawPad.
function DrawPad_Callback(hObject, eventdata, handles)
% hObject    handle to DrawPad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DrawPad
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
b = 0
setappdata(0,'var',b);

else
b =1;
setappdata(0,'var',b);


end;
end

% --- Executes on button press in Blue.
function Blue_Callback(hObject, eventdata, handles)
% hObject    handle to Blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Blue
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
a= 6;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end

end

% --- Executes on button press in Green.
function Green_Callback(hObject, eventdata, handles)
% hObject    handle to Green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Green
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
a= 5;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
end

% --- Executes on button press in Red.
function Red_Callback(hObject, eventdata, handles)
% hObject    handle to Red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Red
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
a= 4;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end

end

% --- Executes on button press in Orange.
function Orange_Callback(hObject, eventdata, handles)
% hObject    handle to Orange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Orange
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
a= 3;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
end

% --- Executes on button press in Purple.
function Purple_Callback(hObject, eventdata, handles)
% hObject    handle to Purple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Purple
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
a= 2;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
end

% --- Executes on button press in Gray.
function Gray_Callback(hObject, eventdata, handles)
% hObject    handle to Gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Gray
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
a= 7;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
end

% --- Executes on button press in Black.
function Black_Callback(hObject, eventdata, handles)
% hObject    handle to Black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Black
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
a= 0;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
end

% --- Executes on button press in Yellow.
function Yellow_Callback(hObject, eventdata, handles)
% hObject    handle to Yellow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Yellow
%activates the radio button for this color
if (get(hObject,'Value') == get(hObject,'Max'))
a= 1;
setappdata(0,'var2',a);
else
    a=-1;
setappdata(0,'var2',a);
end
end

% --- Executes on button press in GreenTracking.
function GreenTracking_Callback(hObject, eventdata, handles)
% hObject    handle to GreenTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GreenTracking
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
    filter = imsubtract(data(:,:,2), rgb2gray(data));
    %Use a median filter to filter out noise
    filter = medfilt2(filter, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    filter = im2bw(filter,0.05);
    
    % Remove all those pixels less than 300px
    filter = bwareaopen(filter,300);
    
    % Label all the connected components in the image.
    bw = bwlabel(filter, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow(data)
    
    hold(handles.axes1);
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        BoxBounds = stats(object).BoundingBox;
        BoxCentroids = stats(object).Centroid;
        rectangle('Position',BoxBounds,'EdgeColor','g','LineWidth',2)
        plot(handles.axes1,BoxCentroids(1),BoxCentroids(2), '-m+')
         if ~isempty(BoxBounds)  %  Get the centroid of remaining blobs
                     centX = BoxCentroids(1); centY = BoxCentroids(2);
         end
        a=text(BoxCentroids(1)+15,BoxCentroids(2), strcat('X: ', num2str(round(BoxCentroids(1))), '    Y: ', num2str(round(BoxCentroids(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
        % gets the data for what color is selected
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
            elseif(c == 7)
                handles.color = [0.49,0.49,0.49];
            else
                    handles.color = [0,1,0];
            end
            %this starts ploting colors on the axes2
        plot(handles.axes2,-centX,-centY, 'o','LineWidth', 5,'color', handles.color,'MarkerSize',5);
            %this keeps multple plots on the axes2
                axis(handles.axes2,[-170,-10,-170,-10])
      end
    end
    %this save the axes2 plots
    F = getframe(handles.axes2);

imwrite(F.cdata, fullfile('C:\Users\Eric\Google Drive\Project 3134\FinalProject','GreenAxe.jpg'));
    hold off
    
end
hold off
else
    cla(handles.axes2,'reset');
    while(1)
                    set(handles.axes2,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks

     
    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    
    % Display the image
    imshow(data)
    end
end
end

% --- Executes on button press in RedTracking.
function RedTracking_Callback(hObject, eventdata, handles)
% hObject    handle to RedTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RedTracking
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
            filter = imsubtract(data(:,:,1), rgb2gray(data));
            %Use a median filter to filter out noise
            filter = medfilt2(filter, [3 3]);
            % Convert the resulting grayscale image into a binary image.
            filter = im2bw(filter,0.11);

            % Remove all those pixels less than 300px
            filter = bwareaopen(filter,300);

            % Label all the connected components in the image.
            bw = bwlabel(filter, 8);

            % Here we do the image blob analysis.
            % We get a set of properties for each labeled region.
            stats = regionprops(bw, 'BoundingBox', 'Centroid');
           

            % Display the image
            imshow(data)
          
               

            
             
            hold(handles.axes1);
            
            %This is a loop to bound the red objects in a rectangular box.
            for object = 1:length(stats)
                BoxBounds = stats(object).BoundingBox;
                BoxCentroids = stats(object).Centroid;
                
                rectangle('Position',BoxBounds,'EdgeColor','r','LineWidth',2)
                plot(handles.axes1,BoxCentroids(1),BoxCentroids(2), '-m+')
                 if ~isempty(BoxBounds)  %  Get the centroid of remaining blobs
                     centX = BoxCentroids(1); centY = BoxCentroids(2);
                 end
                a=text(BoxCentroids(1)+15,BoxCentroids(2), strcat('X: ', num2str(round(BoxCentroids(1))), '    Y: ', num2str(round(BoxCentroids(2)))));
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
            elseif(c == 7)
                handles.color = [0.49,0.49,0.49];
            else
                    handles.color = [1,0,0];
            end
                plot(handles.axes2,-centX,-centY, 'o','LineWidth', 5,'color', handles.color,'MarkerSize',5);
                axis(handles.axes2,[-170,-10,-170,-10])            
                end   
               
            end
     

                
                
                hold off;
                
               F = getframe(handles.axes2);

imwrite(F.cdata, fullfile('C:\Users\Eric\Google Drive\Project 3134\FinalProject','RedAxe.jpg'));
            
    
         
        end
        hold off;
                
else
  cla(handles.axes2,'reset');              
 while(1)
                 set(handles.axes2,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks

    
    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    
    % Display the image
    imshow(data)
end
    
 
end
end

% --- Executes on button press in BlueTracking.
function BlueTracking_Callback(hObject, eventdata, handles)
% hObject    handle to BlueTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BlueTracking
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
    filter = imsubtract(data(:,:,3), rgb2gray(data));
    %Use a median filter to filter out noise
    filter = medfilt2(filter, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    filter = im2bw(filter,0.10);
    
    % Remove all those pixels less than 300px
    filter = bwareaopen(filter,300);
    
    % Label all the connected components in the image.
    bw = bwlabel(filter, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow(data)
    
    hold(handles.axes1);
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        BoxBounds = stats(object).BoundingBox;
        BoxCentroids = stats(object).Centroid;
        rectangle('Position',BoxBounds,'EdgeColor','b','LineWidth',2)
        plot(BoxCentroids(1),BoxCentroids(2), '-m+')
         if ~isempty(BoxBounds)  %  Get the centroid of remaining blobs
                centX = BoxCentroids(1);centY = BoxCentroids(2);
         end
        a=text(BoxCentroids(1)+15,BoxCentroids(2), strcat('X: ', num2str(round(BoxCentroids(1))), '    Y: ', num2str(round(BoxCentroids(2)))));
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
            elseif(c == 7)
                handles.color = [0.49,0.49,0.49];
            else
                    handles.color = [0,0,1];
            end
      plot(handles.axes2,-centX,-centY,'o','LineWidth', 5,'color', handles.color,'MarkerSize',5);
                axis(handles.axes2,[-170,-10,-170,-10])
 
      end
  
    end
    hold off
     F = getframe(handles.axes2);

imwrite(F.cdata, fullfile('C:\Users\Eric\Google Drive\Project 3134\FinalProject','BlueAxe.jpg'));
end
 
    hold off;
    
else
    cla(handles.axes2,'reset');
    while(1)
                    set(handles.axes2,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks

     
    % Get the snapshot of the current frame
    data = getsnapshot(handles.video);
    
    
    % Display the image
    imshow(data)
    end
end

end