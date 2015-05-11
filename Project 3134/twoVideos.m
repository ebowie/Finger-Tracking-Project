

obj1 = videoinput('winvideo',1,'YUY2_320x240','Tag','Webcam1');
obj2 = videoinput('winvideo',1,'YUY2_320x240','Tag','Webcam2');

out1 = imaqfind('Tag', 'videoinput');
out2 = imaqfind('Tag', 'videoinput');

preview(out1);
preview(out2);