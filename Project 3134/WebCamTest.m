vid = videoinput('winvideo', 1, 'YUY2_640x480');
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;

vid.ReturnedColorspace = 'grayscale';

preview(vid);

pause(10.0);

stoppreview(vid);

vid.ReturnedColorspace = 'rgb';

preview(vid);

pause(10.0);

stoppreview(vid);

vid.ReturnedColorspace = 'YCbCr';

preview(vid);

pause(10.0);

closepreview(vid);