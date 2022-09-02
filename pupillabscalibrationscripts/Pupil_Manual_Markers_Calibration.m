function calibrate_fin = Pupil_Manual_Markers_Calibration(hUDP, centerX, centerY, pixWidth, pixHeight,  window, InExpSystem)
%==========================================================================
% Purpose: Run manual markers calibration for PUPIL using PTB3
% Author: Tom Bullock, UCSB Atention Lab
% Date: 02.09.18
% Notes:
% This script might be useful if you are a) running pupil_capture on
% a separate machine to your PTB stimulus presentation machine, or b)
% running pupil capture and PTB on the same machine and using an
% "X-screens" linux setup (pupil capture cannot project calibration to an
% X-screen)
%
% This will be a lot more useful when I can get MATLAB to talk to pupil
% capture and receive feedback.  Currently it hangs if it doesn't detect a
% calibration point.  I think the key is to subscribe to
% notify.calibration...see matairj scripts!!!
%==========================================================================

if hUDP ~= 0
    fwrite(hUDP,'STOP_REC'); % JUST IN CASE A RECORDING WAS ALREADY GOING...
    fwrite(hUDP, 'START_REC');
    pause(1); % include pause so first events don't get sent before recording starts
end



% calibration settings
sSize=300; % set the size of each marker (pixels) (200 pix =3.5 cm)
cAdj=250; % set distance from corners of screen for markers 2:5 (pixels)
sAdj=300; % set distance from sides of screen for markers 6:10 (pixels)
sDuration = 3; % set duration of each marker (s)
isiDuration=.5; % set duration between each marker (s)

if InExpSystem
    stimPath = 'C:\Dropbox\VICE\JT\DEUBAL\Functions\pupillabscalibrationscripts';
else
    stimPath = '/Users/newxjy/Desktop/Grad_School/UCB_PB/CognAc_Lab/Projects/Math_Jiaying_23Mar2020/Pupil_labs/pupillabscalibrationscripts';
end

% load marker stimuli and create textures
imageWindow(1) = Screen('MakeTexture',window,imread([stimPath '/' 'calibration_marker.jpg']));
imageWindow(2) = Screen('MakeTexture',window,imread([stimPath '/' 'calibration_marker_stop.jpg']));

% initiate calibration
% press space
thisText = 'Press SPACE to start calibration';
[normBoundsRect]=Screen('TextBounds',window,thisText);
%Screen('DrawText',window,thisText,centerX-round(normBoundsRect(3)/2),centerY,[0,0,0 ]);
%Screen('Flip',window)%
%FlushEvents('KeyDown');
% while 1
%     keyisdown = KbCheck(-1,2);
%     if keyisdown == 1
%         break
%     end
% end

if hUDP ~= 0
    % Start the calibration
    fwrite(hUDP,'START_CAL')
    
    % JT's annotation about calibration start and stop
    fwrite(hUDP, '0')
    pause(1)
end


% loop through marker placements
for j=1
    for i=randperm(9)
        
        if i==1 % center
            theseDims = [centerX-sSize/2, centerY-sSize/2, centerX+sSize/2, centerY+sSize/2];
        elseif i==2 % top left
            theseDims = [centerX-pixWidth/2+cAdj, centerY-pixHeight/2+cAdj, centerX-pixWidth/2+sSize+cAdj, centerY-pixHeight/2+sSize+cAdj];
        elseif i==3 % top right
            theseDims = [centerX+pixWidth/2-sSize-cAdj, centerY-pixHeight/2+cAdj, centerX+pixWidth/2-cAdj, centerY-pixHeight/2+sSize+cAdj];
        elseif i==4 % bottom right
            theseDims = [centerX+pixWidth/2-sSize-cAdj, centerY+pixHeight/2-sSize-cAdj, centerX+pixWidth/2-cAdj, centerY+pixHeight/2-cAdj];
        elseif i==5 % bottom left
            theseDims = [centerX-pixWidth/2+cAdj, centerY+pixHeight/2-sSize-cAdj, centerX-pixWidth/2+sSize+cAdj, centerY+pixHeight/2-cAdj];
            
        elseif i==6 % center left
            theseDims = [centerX-pixWidth/2-sSize/2+sAdj, centerY-sSize/2, centerX-pixWidth/2+sSize/2+sAdj, centerY+sSize/2];
        elseif i==7 % center top
            theseDims = [centerX-sSize/2, centerY-pixHeight/2-sSize/2+sAdj, centerX+sSize/2, centerY-pixHeight/2+sSize/2+sAdj];
        elseif i==8 % center right
            theseDims = [centerX+pixWidth/2-sAdj-sSize/2, centerY-sSize/2, centerX+pixWidth/2+sSize/2-sAdj, centerY+sSize/2];
        elseif i==9 % center bottom
            theseDims = [centerX-sSize/2, centerY+pixHeight/2-sSize/2-sAdj, centerX+sSize/2, centerY+pixHeight/2+sSize/2-sAdj];
        end
        
        % draw texture to screen
        Screen('DrawTexture',window,imageWindow(1),[],theseDims);
        
        % flip to screen
        Screen('Flip',window);
        
        % marker duration
        pause(sDuration)
        
        % ISI
        Screen('Flip',window);
        
        % isi duration
        pause(isiDuration)
        
    end
end

% present the STOP calibration marker at center
theseDims = [centerX-sSize/2, centerY-sSize/2, centerX+sSize/2, centerY+sSize/2];
Screen('DrawTexture',window,imageWindow(2),[],theseDims);

% flip to screen
Screen('Flip',window);

% present for marker duration
pause(sDuration)

if hUDP ~= 0
    
    % stop calibration
    fwrite(hUDP,'STOP_CAL')
    pause(1)
    
    fwrite(hUDP, '0')
    pause(1)
    calibrate_fin = 1; 
else
    
    
    % fwrite(hUDP,'STOP_REC');
    
    calibrate_fin = 1;
    
end