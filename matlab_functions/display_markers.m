function display_markers(path_markers, window, pixWidth, pixHeight, centerX, centerY)

%==========================================================================
% Purpose: 
% 1. Display pupil surface markers in each of the four screen corners
% (press SPACEBAR to exit).
% 2. Enable easy resizing of markers
% 3. Enable marker distance from screen corners to be easily adjusted
% Author: Tom Bullock, UCSB Attention Lab
% Date: 02.05.18
% Notes: 
% Marker size may need to be changed depending on distance from screen and 
% moving markers away from corners may be necessary for successful
% detection.  
% This example script imports Markers 01-04 (make sure the stim path below
% is correct).
% Note to self: for physical printing, enlarging 160% in print dialogue box 
% to create 4.5*4.5 cm markers works well
%==========================================================================

% settings
sSize=150; % set the size of each marker (pixels)
cAdj=20; % set distance from corners of screen (pixels)

% make texture (import markers)
for i=1:4
    imageWindow(i) = Screen('MakeTexture',window, imread([path_markers '/' sprintf('marker_%02d_mod2.',i),'png']));
end

% draw textures to corners of screen
for i=1:4
    if i==1
        theseDims = [centerX-pixWidth/2+cAdj, centerY-pixHeight/2+cAdj, centerX-pixWidth/2+sSize+cAdj, centerY-pixHeight/2+sSize+cAdj];
    elseif i==2
        theseDims = [centerX+pixWidth/2-sSize-cAdj, centerY-pixHeight/2+cAdj, centerX+pixWidth/2-cAdj, centerY-pixHeight/2+sSize+cAdj];
    elseif i==3
        theseDims = [centerX+pixWidth/2-sSize-cAdj, centerY+pixHeight/2-sSize-cAdj, centerX+pixWidth/2-cAdj, centerY+pixHeight/2-cAdj];
    elseif i==4
        theseDims = [centerX-pixWidth/2+cAdj, centerY+pixHeight/2-sSize-cAdj, centerX-pixWidth/2+sSize+cAdj, centerY+pixHeight/2-cAdj];
    end
    % draw textures to window
    Screen('DrawTexture',window,imageWindow(i),[],theseDims);
end
% 
% % draw a fixation cross at center
% fixSize = 80;
% Screen('TextSize',window,fixSize);
% Screen('DrawText',window,'+',centerX-11,centerY-11);

% flip textures to screen
% Screen('Flip',window)

% wait for spacebar press to end stimulus presentation
% FlushEvents('KeyDown');
% go = upper(GetChar);
% 
% while go ~= ' ' 
%     go = upper(GetChar);
% end


end

