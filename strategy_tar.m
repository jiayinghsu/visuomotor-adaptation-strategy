% Purpose: Make Target files
% 12 Target locations (spaced 30 deg apart) 
% 75 degree rotation
% 372 trials total, 3 blocks 

clear; clc; close all

%% ---------------
% ABRUPT
% ----------------

exp_param = struct();
exp_param.sub = 1; 
exp_param.type = 'rotation';
exp_param.ver = 1;

exp_param.namefile = ['EXP1_V', int2str(exp_param.ver), '_SUB', int2str(exp_param.sub ),'.tgt']; 
exp_param.rot_size = 75; 

exp_param.num_target = 12;  
exp_param.target_dist = 70; 

% dist is not actual distance but just 
% an index 

exp_param.target_location = [ 0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330]; 
exp_param.tgt_reps = [31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31];

%% ---------------
% ALL PERMUTATIONS
% ----------------

unique_conditions = exp_param.target_location';
con_size = length(unique_conditions);

%% ---------------
% REPETITIONS, PSEUDORANDOMIZED
% ----------------

all_trials = []; 

for ri = 1:exp_param.tgt_reps
    
    all_trials = [all_trials; unique_conditions(randperm(con_size), :)];
    
end


%% ---------------
% CREATE REACH CYCLES
% ----------------

nC_baseline = 36; % Baseline trials

nC_rotation = 300; % Rotation rotation

nC_washout = 36; % Washout trials 
nT_total = nC_baseline + nC_rotation + nC_washout; % Total number of trials


%% ---------------
% CREATE TRIAL INDEX
% ----------------

% index start, finish

Trial = struct();

Trial.baseline(1) = 1;
Trial.baseline(2) = nC_baseline; % block 1

Trial.rotation(1) = Trial.baseline(2) + 1;
Trial.rotation(2) = Trial.baseline(2) + nC_rotation; % block 3

Trial.washout(1) = Trial.rotation(2) + 1;
Trial.washout(2) = Trial.rotation(2) + nC_washout; % block 4

%% ---------------
% CREATE TARGET TABLE
% ----------------
header = {'trial_num','tgt_dist','tgt_location','rotation', 'online_fb', ... 
    'endpoint_fb', 'between_blocks', 'event_code'};

T = table();

T.trial_num = (1:nT_total)';

T.tgt_dist = ones(nT_total, 1) * exp_param.target_dist;

% Movement target.
T.tgt_location = ones(nT_total, 1); T.tgt_location(Trial.baseline(1):Trial.washout(2)) = all_trials(:, 1);

% Place holder rotation angle
T.rotation = zeros(nT_total, 1);

% online Feedback
T.online_fb = zeros(nT_total, 1);

% endpoint Feedback
T.endpoint_fb = ones(nT_total, 1);

% Between block messages

T.between_blocks = zeros(nT_total, 1);

raw_events = repmat(1:372, 1, 1)';

T.event_code = raw_events(1:nT_total, 1);

%% ---------------
% FILL IN ROTATION SIZES
% ----------------

T.rotation(Trial.rotation(1):Trial.rotation(2)) = exp_param.rot_size;
        

%% ---------------
% SET BETWEEN BLOCK MESSAGES
% ----------------

T.between_blocks(Trial.baseline(2)) = 0;
T.between_blocks(Trial.rotation(2)) = 0;
T.between_blocks(Trial.washout(2)) = 0;

%% ---------------
% SAVE TARGET FILE
% ----------------

% dummy = table2dataset(T);
dummy = table2array(T);
set = double(dummy);

writetable(T, 'jiaying_tar_06June2020.csv')
%If you ever need strings in here use this way

set(:,1) = 1:size(set,1);
%Add in last Betweenblocks
%set(end,15) = 1;
%Variables header file

%If you ever need strings in here use this way
fid = fopen(exp_param.namefile,'wt');
[rows,cols] = size(set);
fprintf(fid,'%s\t',header{:});
for i = 1:rows
    fprintf(fid,'\n');
    for j = 1:cols
        fprintf(fid,'%3.2f\t',set(i,j));
    end
end
fclose(fid);
