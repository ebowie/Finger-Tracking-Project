%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program Name : Red Object Detection and Tracking                        %
% Author       : Arindam Bose                                             %
% Version      : 1.05                                                     %
% Description  : How to detect and track red objects in Live Video        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
redThresh = 0.25; % Threshold for red detection
vid = imaq.VideoDevice('winvideo', 1);
set(vid,'ReturnedColorSpace', 'rgb');
handles.hblob=set('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MinimumBlobArea', 800, ...
                                'MaximumBlobArea', 3000, ...
                                'MaximumCount', 10);
handles.hshape = set('BorderColor', 'Custom', ... % Set Red box handling
                                        'CustomBorderColor', [1 0 0], ...
                                        'Fill', true, ...
                                        'FillColor', 'Custom', ...
                                        'CustomFillColor', [1 0 0], ...
                                        'Opacity', 0.4);
handles.textins = set('Text', 'Number of Red Object: %2d', ... % Set text for number of blobs
                                    'Location',  [7 2], ...
                                    'Color', [1 0 0], ... // red color
                                    'FontSize', 12);
hanldes.textinsCent = set('Text', '+      X:%4d, Y:%4d', ... % set text for centroid
                                    'LocationSource', 'Input port', ...
                                    'Color', [1 1 0], ... // yellow color
                                    'FontSize', 14);
 start(vidIn)

nFrame = 0; % Frame number initialization

%% Processing Loop
while(nFrame < 20)
    rgbFrame = step(vid); % Acquire single frame
    rgbFrame = flipdim(rgbFrame,2); % obtain the mirror image for displaying
    diffFrame = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get red component of the image
    diffFrame = medfilt2(diffFrame, [3 3]); % Filter out the noise by using median filter
    binFrame = im2bw(diffFrame, redThresh); % Convert the image into binary image with the red objects as white
    [centroid, bbox] = step(handles.hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    centroid = uint16(centroid); % Convert the centroids into Integer for further steps 
    rgbFrame(1:20,1:165,:) = 0; % put a black region on the output stream
    vidIn = step(handles.hshape, rgbFrame, bbox); % Instert the red box
    for object = 1:1:length(bbox(:,1)) % Write the corresponding centroids
        centX = centroid(object,1); centY = centroid(object,2);
        vidIn = step(handles.textinsCent, vidIn, [centX centY], [centX-6 centY-9]); 
    end
    vidIn = step(handles.textins, vidIn, uint8(length(bbox(:,1)))); % Count the number of blobs
    step(vidIn); % Output video stream
    nFrame = nFrame+1;
end
%% Clearing Memory
release(hVideoIn); % Release all memory and buffer used
release(vid);
% clear all;
clc;