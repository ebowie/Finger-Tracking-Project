aviObject = avifile('myVideo.avi');   % Create a new AVI file
for iFrame = 1:100                    % Capture 100 frames
  % ...
  % You would capture a single image I from your webcam here
  % ...
  F = im2frame(I);                    % Convert I to a movie frame
  aviObject = addframe(aviObject,F);  % Add the frame to the AVI file
end
aviObject = close(aviObject);         % Close the AVI file