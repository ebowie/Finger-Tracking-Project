% Create a video input object.
vid = videoinput('winvideo');
% Create a figure window. This example turns off the default
% toolbar, menubar, and figure numbering.
figure('Toolbar','none',...
'Menubar', 'none',...
'NumberTitle','Off',...
'Name','My Preview Window');
% Create the image object in which you want to display
% the video preview data. Make the size of the image
% object match the dimensions of the video frames.
vidRes = get(vid, 'VideoResolution');
nBands = get(vid, 'NumberOfBands');
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
% Display the video data in your GUI.
preview(vid, hImage);