clear all;
close all;
clc;

% Constructing a video input interface 
vid = videoinput('winvideo',1,'YUY2_640x480');

% setting the frame rate as 12 (it will depend on your webcam device also)
set(vid,'FramesPerTrigger',12);
set(vid,'FrameGrabInterval',10); 
start(vid);
wait(vid,Inf);

% Retrieve the frames and timestamps for each frame.
[frames,time] = getdata(vid, get(vid,'FramesAvailable'));

% Calculate frame rate by averaging difference between each frame's timestamp
framerate = mean(1./diff(time));
capturetime = 30;

%The FrameGrabInterval property specifies how often frames are stored from 
%the video stream. For instance, if we set it to 5, then only 1 in 5 frames
%is kept -- the other 4 frames will be discarded. Using the framerate, 
%determine how often you want to get frames
interval = get(vid,'FrameGrabInterval');

%To determine how many frames to acquire in total, calculate the total 
%number of frames that would be acquired at the device's frame rate, 
%and then divide by the FrameGrabInterval.
numframes = floor(capturetime * framerate / interval);

%If a large number of frames will be acquired, it is more practical to log 
%the images to disk rather than to memory. 
%Using the Image Acquisition Toolbox, you can log images directly %
%to an AVI file. We configure this using the LoggingMode property.
set(vid,'LoggingMode','disk');

%Create an AVI file object to log to, using the avifile command. 
%We must specify the filename to use, and the frame rate that 
%the AVI file should be played back at. Then, set the DiskLogger property 
%of the video input object to the AVI file.
avi = avifile('video.avi','fps',framerate);
set(vid,'DiskLogger',avi);
start(vid);
pause(10.0);
wait(vid,Inf); % Wait for the capture to complete before continuing.

%Once the capture is completed, retrieve the AVI file object, and use the 
%close function to release the resources associated with it.

wait(vid,Inf); % Wait for the capture to complete before continuing.

avi = get(vid,'DiskLogger');
avi = close(avi);

%When you are done with the video input object, you should use 
%the delete function to free the hardware resources associated with it, 
%and remove it from the workspace using the clear function.
delete(vid);
clear vid;


