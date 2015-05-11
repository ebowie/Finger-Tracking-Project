%First construct a video input interface

vid = videoinput('winvideo',1,'YUY2_640x480');
%You'll need to adjust the last bit for your webcam. To find a list of webcam devices (and other things besides) use:

imaqhwinfo
%The following makes the first webcam into an object

a=imaqhwinfo('winvideo',1)
%Find the list of supported video formats with

a.SupportedFormats
%You'll then want to determine your frame rate (more on this here):

set(vid,'FramesPerTrigger',100);
start(vid);
wait(vid,Inf);

% Retrieve the frames and timestamps for each frame.
[frames,time] = getdata(vid, get(vid,'FramesAvailable'));

% Calculate frame rate by averaging difference between each frame's timestamp
framerate = mean(1./diff(time))
%The FrameGrabInterval property specifies how often frames are stored from the video stream. For instance, if we set it to 5, then only 1 in 5 frames is kept -- the other 4 frames will be discarded. Using the framerate, determine how often you want to get frames

set(vid,'FrameGrabInterval',10);
%To determine how many frames to acquire in total, calculate the total number of frames that would be acquired at the device's frame rate, and then divide by the FrameGrabInterval.

capturetime = 100;
interval = get(vid,'FrameGrabInterval');
numframes = floor(capturetime * framerate / interval)
%You are now ready to record and play with video using the getdata command (peekdata is also helpful), however...

%If a large number of frames will be acquired, it is more practical to log the images to disk rather than to memory. Using the Image Acquisition Toolbox, you can log images directly to an AVI file. We configure this using the LoggingMode property.

set(vid,'LoggingMode','disk');
%Create an AVI file object to log to, using the avifile command. We must specify the filename to use, and the frame rate that the AVI file should be played back at. Then, set the DiskLogger property of the video input object to the AVI file.

avi = avifile('timelapsevideo','fps',framerate);
set(vid,'DiskLogger',avi);
%Start the time-lapse acquisition, and wait for the acquisition to complete. Note that the Image Acquisition Toolbox does not tie up MATLAB® while it is acquiring. You can start the acquisition and keep working in MATLAB.

start(vid);
wait(vid,Inf); % Wait for the capture to complete before continuing.
%Once the capture is completed, retrieve the AVI file object, and use the close function to release the resources associated with it.

avi = get(vid,'DiskLogger');
avi = close(avi);
%When you are done with the video input object, you should use the delete function to free the hardware resources associated with it, and remove it from the workspace using the clear function.

delete(vid);
clear vid;
%A large portion, but not all, of the above was drawn from here.

%When you hit start(vid) you may notice that there's a bit of a delay before frames begin to be acquired. This is bad if you're trying to synchronize the video with something. In this case, you'll want to try working with the trigger:

triggerconfig(vid,'manual');
start(vid); %There'll be a delay here, but nothing is being captured
trigger(vid); %Use this line when you want the capture to start. There should be v