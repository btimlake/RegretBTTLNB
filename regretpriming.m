clear all;
sca;
close all;
clearvars;

%% Setup
% addpath(matlabroot,'REGRET_task');
% addpath(matlabroot,'patentTaskBTMP');
% addpath(matlabroot,'ratingslider');
% addpath(matlabroot,'games');
% addpath(matlabroot,'games/stimoli');
% addpath('REGRET_task');
% addpath('patentTaskBTMP');
% addpath('ratingslider');
% addpath('games');
% addpath('games/stimoli');
addpath('REGRET_task', 'patentTaskBTMP', 'ratingslider', 'instructions', 'games', 'games/stimoli');

KbName('UnifyKeyNames');

%% VARIABLES
player1maxbid=5;
DateTime=datestr(now,'ddmm-HHMM');      % Get date and time for log file

%% check what OS the software is running on

if ismac
    % Code to run on Mac plaform 
    disp('Mac');
    disabledKeys=[];
    skipSyncTest=[];
    screenRes=[];
%     enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]); % limit recognized presses to 1!, space, left, right, up, down arrows MAC
    enabledKeys = RestrictKeysForKbCheck([]); % for debugging
    
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

ListenChar(2); %disable transmission of keypresses to Matlab command window; press CTRL+C to reenable

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
[xCenter, yCenter] = RectCenter(windowRect);

%% Creat cfg structure to be passed into subsequent functions
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
cfg.screenSize.x = screenXpixels; 
cfg.screenSize.y = screenYpixels;
cfg.fontSize = round(screenYpixels * 2/40);
cfg.textColor = [0, 0, 0]; % black
% cfg.bgColor = [255, 255, 255];
cfg.bgColor = [1, 1, 1];
cfg.screenCenter = [xCenter, yCenter]; % center coordinatesf

% TEMP
gamesdatafilename = 'sub444-2208-2048_4games2x2.dat'

%% call scripts
% [gamesdatafilename]=games(particNum, DateTime, window, windowRect, 10, enabledKeys);
% %     [gamesdatafilename]=games(subNo, anni, w, wRect, NUMROUNDS, enabledKeys)
% WaitSecs(2)
% patentTaskInstructions(window, windowRect, enabledKeys, cfg, player1maxbid);
% % regretTask(particNum, DateTime, window, windowRect, enabledKeys);
%     [totalEarnings] = regretTask(particNum, DateTime, window, windowRect, enabledKeys)% Clear the workspace and the screen
[total1shotEarnings, wof1shotRatingDuration] = regretTask1shot(particNum, DateTime, window, windowRect, enabledKeys, screenNumber);
% %     [total1shotEarnings, wof1shotRatingDuration] = regretTask1shot(particNum, DateTime, window, windowRect, enabledKeys, screenNumber)% Clear the workspace and the screen
% [player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, 'fictive', 4, enabledKeys);
% [player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, 'fictive', player1maxbid, enabledKeys);
%     [player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, player2Strategy, player1maxbid, enabledKeys)
% [winningsMPL, earningsRaven] = questionnaires(particNum, DateTime, window, windowRect)
% [rating, ratingDuration, normalizedChoice, computerSide] = debrief_slider(particNum, DateTime, window, windowRect, enabledKeys)
% [rating, ratingDuration, normalizedChoice, computerSide] = debrief_slider(particNum, DateTi me,  wi n dow, windowRect, enabledKeys)
[winnings2x2, chosenGame, opponentChoice]=games2x2winnings(gamesdatafilename, cfg, window);
% payouts(winnings2x2, gamesdatafilename, total1shotEarnings, player1Earnings, winningsMPL, earningsRaven)
sca;

% big log file
% rating, ratingDuration, normalizedChoice, computerSide

RestrictKeysForKbCheck([]); % re-recognize all key presses
ListenChar(0); % reenable transmission of keypresses to Matlab command window
ShowCursor;

          