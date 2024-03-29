% Create a video input object.
vid = videoinput('winvideo');


% Create a figure window. This example turns off the default
% toolbar and menubar in the figure.
hFig = figure('Toolbar','none',...
'Menubar', 'none',...
'NumberTitle','Off',...
'Name','My Custom Preview GUI');

% Set up the push buttons
uicontrol('String', 'Start Preview',...
'Callback', 'preview(vid)',...
'Units','normalized',...
'Position',[0 0 0.15 .07]);

uicontrol('String', 'Stop Preview',...
'Callback', 'stoppreview(vid)',...
'Units','normalized',...
'Position',[.17 0 .15 .07]);

uicontrol('String', 'Close',...
'Callback', 'close(gcf)',...
'Units','normalized',...
'Position',[0.34 0 .15 .07]);

% Create the text label for the timestamp
hTextLabel = uicontrol('style','text','String','Timestamp', ...
'Units','normalized',...
'Position',[0.85 -.04 .15 .08]);

% Create the image object in which you want to
% display the video preview data.
vidRes = get(vid, 'VideoResolution');
imWidth = vidRes(1);
imHeight = vidRes(2);
nBands = get(vid, 'NumberOfBands');
hImage = image( zeros(imHeight, imWidth, nBands) );

% Specify the size of the axes that contains the image object
% so that it displays the image at the right resolution and
% centers it in the figure window.
figSize = get(hFig,'Position');
figWidth = figSize(3);
figHeight = figSize(4);
set(gca,'unit','pixels',...
'position',[ ((figWidth - imWidth)/2)...
((figHeight - imHeight)/2)...
imWidth imHeight ]);


% Set up the update preview window function.
setappdata(hImage,'UpdatePreviewWindowFcn',@mypreview_fcn);

% Make handle to text label available to update function.
setappdata(hImage,'HandleToTimestampLabel',hTextLabel);

preview(vid, hImage);