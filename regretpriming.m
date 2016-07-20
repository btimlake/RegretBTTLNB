clear all;

% addpath(matlabroot,'REGRET_task');
% addpath(matlabroot,'patentTaskBTMP');
% addpath(matlabroot,'ratingslider');
% addpath(matlabroot,'games');
% addpath(matlabroot,'games/stimoli');
addpath('REGRET_task');
addpath('patentTaskBTMP');
addpath('ratingslider');
addpath('games');
addpath('games/stimoli');

addpath('REGRET_task', 'patentTaskBTMP', 'ratingslider');

sca;
close all;
clearvars;
DateTime=datestr(now,'ddmm-HHMM');      % Get date and time for log file
KbName('UnifyKeyNames');

%% check what OS the software is running on

if ismac
    % Code to run on Mac plaform 
    disp('Mac');
    disabledKeys=[];
    skipSyncTest=[];
    screenRes=[];
    enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]); % limit recognized presses to 1!, space, left, right, up, down arrows MAC

elseif isunix
    % Code to run on Linux plaform
    disp('Unix');
elseif ispc
    % Code to run on Windows platform
    disp('PC');
    enabledKeys = RestrictKeysForKbCheck([37,38,39,40,32,49]); % limit recognized presses to 1!, space, left, right, up, down arrows PC

else
    disp('Platform not supported')
end

%% Screen 0: Participant number entry [delete when combined with Patent Race]

%%% Enter participant number (taken from:
%%% http://www.academia.edu/2614964/Creating_experiments_using_Matlab_and_Psychtoolbox)
fail1='Please enter a participant number.'; %error  message
prompt = {'Enter participant number:'};
dlg_title ='New Participant';
num_lines = 1;
def = {'0'};
answer = inputdlg(prompt,dlg_title,num_lines,def);%presents box to enterdata into
switch isempty(answer)
    case 1 %deals with both cancel and X presses 
        error(fail1)
    case 0
        particNum=(answer{1});
end

% uncomment INLAB
% HideCursor;

%% Psychtoolbox setup
PsychDefaultSetup(2);

% Screen('Preference', 'SkipSyncTests', 1); %Uncomment INLAB

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
% screenNumber = max(screens);
screenNumber = 0;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]); % for one screen setup 
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); % for two-screen setup

%% call scripts
% games(particNum, DateTime, window, windowRect, 5, enabledKeys);
%%% games(participant number, date/time, window size, window rectangle size,number of rounds)
% WaitSecs(2)
% patentInstruct;
% regretTask;
regretTask1shot;
[player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, 'random', 5, enabledKeys);

sca;

RestrictKeysForKbCheck([]); % re-recognize all key presses

ShowCursor;

          