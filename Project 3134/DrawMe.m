%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program Name : Painting software Using Red Detection                    %
% Author       : Arindam Bose                                             %
% Version      : 1.5                                                      %
% Description  : This program detects user's finger's position by red     %
%                color recognition and paint in a white space. The        %
%                default color is blue. Color can be changed to any       %
%                color. A basic GUI is made to save the picture in JPG,   %
%                PNG and BMP format.                                      %
% Copyright    : © Arindam Bose, All right reserved.                      %
% Thanks       : 41 Complete GUI Examples by Matt Fig.                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = draw(redThresh)
if nargin < 1
    redThresh = 0.15;  % Threshold for Red detection, adjust it for different environment
end

drawStruct.color = [0 0 1];  % Default Color: Blue
drawStruct.listOfColor = {[],[0 0 1],[1 0 0],[0 1 0],[1 1 0],[0 0 0]};  % List of other colors: Blue, Red, Green, Yellow, Black
drawStruct.format = {[],'jpg','png','bmp'};  % List of Image formats
drawStruct.figh = figure('Units','pixels',...  % Main GUI Page
              'Position',[10 50 600 650],...
              'Menubar','none',...
              'Name','DrawMe',...
              'NumberTitle','off',...
              'Resize','on');
drawStruct.axs = axes('Units','pixels',...  % Axis property
            'Position',[5 5 590 640],...
            'Xlim',[-6 0],...
            'YLim',[-4.5 0],...
            'DrawMode','fast');
set(drawStruct.axs,'xTickLabel',[],'yTickLabel',[],'xTick',[],'yTick',[]);  % Remove Axis marks


vidDevice = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ...
                    'ROI', [1 1 640 480], ...
                    'ReturnedColorSpace', 'rgb');  % Input Video from current adapter
vidInfo = imaqhwinfo(vidDevice);  % Acquire video information
hblob = vision.BlobAnalysis('AreaOutputPort', false, ... 
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MaximumBlobArea', 3000, ...
                                'MaximumCount', 1);  % Make system object for blob analysis
hshapeinsRedBox = vision.ShapeInserter('BorderColor', 'Custom', ...
                                    'CustomBorderColor', [1 0 0], ...
                                    'Fill', true, ...
                                    'FillColor', 'Custom', ...
                                    'CustomFillColor', [1 0 0], ...
                                    'Opacity', 0.4);  % Make system object for Red Filled Box
htextinsCent = vision.TextInserter('Text', '+      X:%5.2f, Y:%5.2f', ...
                                    'LocationSource', 'Input port', ...
                                    'Color', [1 1 0], ...
                                    'FontSize', 14);  % Make system object for Text: Centroid Infication
                           
hVideoIn = vision.VideoPlayer('Name', 'Final Video', ...
                                'Position', [60+vidInfo.MaxWidth 100 vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);   % Make system object for output video stream
% hMarker = vision.MarkerInserter('Shape','Circle','Fill','true','FillColor','Black');
nFrame = true;  % Initialize number of frame counter
centX = 1; centY = 1;  % Feature Centroid initialization
%% Processing Iteration
while nFrame
    rgbFrame = step(vidDevice);  % Extract Single Frame
    diffFrame = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame));  % Extract Red component
    diffFrame = medfilt2(diffFrame, [3 3]);  % Applying Medial Filter for denoising
    binFrame = im2bw(diffFrame, redThresh);  % Convert to binary image using red threshold
    binFrame = bwareaopen(binFrame,800);  % Discard small areas
    [centroid, bbox] = step(hblob, binFrame);  % Get the reqired statistics of remaining blobs
    if ~isempty(bbox)  %  Get the centroid of remaining blobs
        centX = centroid(1); centY = centroid(2);
    end
    vidIn = step(hshapeinsRedBox, rgbFrame, bbox);  % Put a Red bounding box in input video stream    
    vidIn = step(htextinsCent, vidIn, [centX centY], [uint16(centX)-6 uint16(centY)-9]);  % Write centroid
    step(hVideoIn, vidIn);  % Show the output video stream
    plot(-centX/100, -centY/100, 'o', ...
            'LineWidth', 5, ...
            'color', drawStruct.color, ...
            'MarkerSize',5);
    axis([-6,0,-4.5,0])
    set(drawStruct.axs,'xticklabel',[],'yticklabel',[],'xtick',[],'ytick',[]); 
    hold on; box on;
end

   
end