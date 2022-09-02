%==========================================================================
% Purpose: Enable pupil capture to be controlled with MATLAB and PTB3. 
% Author: Tom Bullock, UCSB Attention Lab
% Date: 02.18.18
% Notes: You must run sample_mm.py to set up the python middle man server
% with pupil_capture before attempting to initialize the UDP connection 
% from MATLAB. p
%==========================================================================

clear 
close
clc

%% set python path and start server

setenv('PATH', '/Users/newxjy/anaconda3')
% type cd ./Dropbox/VICE/JT/DEUBAL/Functions/pupil_middleman-master/
% python pupil_mm.py
pause(1)

%% pupil link UDP setup

% when connecting with another computer 
hUDP = udp('127.0.0.1', 11111, 'Timeout',0.5);

% when using your own computer
%hUDP = udp('169.254.181.27', 11111, 'Timeout',0.5);

pause(1)
fopen(hUDP);
pause(1)

%% run number game 
run_strategy(hUDP)

%% start_calibration
fwrite(hUDP, 'START_CAL')
%fwrite(hUDP, 'STOP_CAL')

%% close hUDP link and clear object

fclose(hUDP);
clear

%% HELPER FUNCTIONS 

Pupil_Manual_Markers_Calibration(hUDP)

% start/stop calibration (press esc. to quit) 
% fwrite(hUDP,'START_CAL')
% fwrite(hUDP,'STOP_CAL')

% start/stop recording 

fwrite(hUDP,'START_REC')

% start recording 
SjNum = 999; 
SjSession = 1;
SjCondition = 1;
ExpID = 'ab';
% send this command to start the recording and set a custom name for the
% directory. Note that START_REC must be present and followed by a space in
% order for the recording to start ('START_REC XXX').  You can do what you 
% want with regards to customizing the file name, fields etc.
fwrite(hUDP,sprintf('START_REC abc'))
pause(1);   % include pause so first events don't get sent before recording starts

% send an event code/trigger

% fwrite(hUDP,'222') % e.g. send trigger value '2'.  Note that the values you 

% stop recording

fwrite(hUDP,'STOP_REC')
pause(1)

