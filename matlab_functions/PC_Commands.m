%==========================================================================
% Purpose: Enable pupil capture to be controlled with MATLAB and PTB3. 
% Author: Tom Bullock, UCSB Attention Lab
% Date: 02.18.18
% Notes: You must run sample_mm.py to set up the python middle man server
% with pupil_capture before attempting to initialize the UDP connection 
% from MATLAB.
%==========================================================================

clear 
close
clc

%% pupil link UDP setup

setenv('PATH', 'C:\Users\Ivrylab\Anaconda2')
hUDP = udp('169.254.209.148', 11111,'Timeout',0.5);
pause(1)
fopen(hUDP);
pause(1)


%% run deubal

addpath(genpath('C:\Users\ivrylab\Dropbox\'))
run_abrupt_pl(hUDP)



%% close hUDP link and clear object

fclose(hUDP);
clear

%% helper functions

% start/stop calibration (press esc. to quit) 
Pupil_Manual_Markers_Calibration(hUDP)

% start/stop calibration (press esc. to quit) 
fwrite(hUDP,'START_CAL')
%fwrite(hUDP,'STOP_CAL')

% start/stop recording 

SjNum = 999; 
SjSession = 1;
SjCondition = 1;
ExpID = 'ab';
% send this command to start the recording and set a custom name for the
% directory. Note that START_REC must be present and followed by a space in
% order for the recording to start ('START_REC XXX').  You can do what you 
% want with regards to customizing the file name, fields etc.
fwrite(hUDP,sprintf('START_REC sj%d_se%02d_cd%02d_%s',SjNum,SjSession,SjCondition,ExpID))

% send an event code/trigger
fwrite(hUDP,'4') % e.g. send trigger value '2'.  Note that the values you 

% stop recording
fwrite(hUDP,'STOP_REC')

fwrite(hUDP,'START_REC')


