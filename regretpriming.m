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
    enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]); % limit recognized presses to 1!, space, left, right, up, down arrows MAC
%     enabledKeys = RestrictKeysForKbCheck([]); % for debugging
    
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


%% Hide cursor, stop input in command screen
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
% Colors
cfg.textColor = [0, 0, 0]; % black
% cfg.bgColor = [255, 255, 255];
cfg.bgColor = [1, 1, 1]; % white
cfg.instColA = [0, 0.4078, 0.5451]; %DeepSkyBlue4
cfg.instColB = [0.8039, 0.5843, 0.0471]; %DarkGoldenRod3
cfg.p1Col = [0, 0, 0.8039]; %MediumBlue
cfg.p2Col = [0.4314, 0.4824, 0.5451]; % LightSteelBlue4
cfg.winCol = [.1333, .5451, .1333]; %ForestGreen
% Positions
cfg.screenCenter = [xCenter, yCenter]; % center coordinatesf
cfg.topTextYpos = screenYpixels * 2/40; % Screen Y positions of top/instruction text
cfg.botTextYpos = screenYpixels * 35/40; % Screen Y positions of bottom/result text
cfg.waitTextYpos = screenYpixels * 38/40; % Y position of lowest "Please Wait" text


%% Screen 0: Participant number entry 

screenXpixels=cfg.screenSize.x;
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, cfg.fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, cfg.textColor);
    
inputReq1 = 'Tasti il numero sopra il tuo computer come due cifre \n e premi ''Enter'': '; % ITALIAN
fail1='Si prega tastere esattamente due cifre \n e premi ''Enter'': '; % ITALIAN
inputReq2 = 'Tasti il dato come e'' scritto su lavagna \n e premi ''Enter'': '; % ITALIAN
fail2='Si prega tastere quattro numeri \n e premi ''Enter'': '; % ITALIAN
    
    [nx, ny1, textRect1]=DrawFormattedText(window, inputReq1, 0, 0, cfg.bgColor); % draws a dummy version of text just to get measurements
    [nx, ny2, textRect2]=DrawFormattedText(window, inputReq2, 0, ny1, cfg.bgColor); % draws a dummy version of text just to get measurements
	textWidth1 = textRect1(3)-textRect1(1); % figures width of bounding rectangle of text
	textWidth2 = textRect2(3)-textRect2(1); % figures width of bounding rectangle of text
    xPos1 = cfg.screenCenter(1) - textWidth1/2; % sets x position half the text length back from center 
    xPos2 = cfg.screenCenter(1) - textWidth2/2; % sets x position half the text length back from center 
    yPos = cfg.screenCenter(2);
    yPos2 = yPos + ny1; 
Screen('Flip', window)

aOK=0; % initial value for aOK

while aOK ~= 1
    
    compNum = GetEchoStringForm(window, inputReq1, xPos1, yPos, cfg.textColor); % displays string in PTB; allows backspace
    
    % HOW TO GET THIS TO ALLOW REPEATED INPUT?
%     TRY BREAK OR RETURN
% TRY CATCH INSTEAD - step back in a while loop
    % compNum = input('Enter the number of your computer and then press "Enter": ') % ENGLISH
    % compNum = input('Tasti il numero sopra il tuo computer e poi premi "Enter": ') % ITALIAN
    switch isempty(compNum)
        case 1 %deals with both cancel and X presses
            Screen('Flip', window)
            compNum = GetEchoStringForm(window, fail1, xPos1, yPos, cfg.textColor); % displays string in PTB; allows backspace
        case 0
            if length(compNum) ~=2 || str2num(compNum) <= 1 || str2num(compNum) >= 18
                aOK = 0;
                Screen('Flip', window)
                compNum = GetEchoStringForm(window, fail1, xPos1, yPos, cfg.textColor); % displays string in PTB; allows backspace
            else
                aOK = 1;
                Screen('Flip', window)
                
            end
    end
                Screen('Flip', window)

end

aOK=0; % initial value for aOK

while aOK ~= 1
    
    insertDate = GetEchoStringForm(window, inputReq2, xPos2, yPos2, cfg.textColor); % displays string in PTB; allows backspace
    
    % HOW TO GET THIS TO ALLOW REPEATED INPUT?
%     TRY BREAK OR RETURN
    % compNum = input('Enter the date as written on the whiteboard and then press "Enter": ') % ENGLISH
    % compNum = input('Tasti il dato come ? scritto su lavagna e poi premi "Enter": ') % ITALIAN
    switch isempty(insertDate)
        case 1 %deals with both cancel and X presses
            Screen('Flip', window)
            insertDate = GetEchoStringForm(window, fail2, xPos2, yPos2, cfg.textColor); % displays string in PTB; allows backspace
        case 0
            if length(insertDate) ~= 4;
                aOK = 0;
            Screen('Flip', window)
                insertDate = GetEchoStringForm(window, fail2, xPos2, yPos2, cfg.textColor); % displays string in PTB; allows backspace
            else
                aOK = 1;
                Screen('Flip', window)
            end
    end
                Screen('Flip', window)

end

particNum = [insertDate, compNum];

%% call scripts
% [gamesdatafilename]=games(particNum, DateTime, window, windowRect, 48, enabledKeys, cfg);
%    [gamesdatafilename]=games(subNo, anni, w, wRect, NUMROUNDS, enabledKeys, cfg)
% patentTaskInstructions(window, windowRect, enabledKeys, cfg, player1maxbid);
% [totalEarnings] = regretTask(particNum, DateTime, window, windowRect, enabledKeys);% Clear the workspace and the screen
%       regretTask(particNum, DateTime, window, windowRect, enabledKeys);
[total1shotEarnings, wof1shotRatingDuration] = regretTask1shot(particNum, DateTime, window, windowRect, enabledKeys, screenNumber, cfg);
%     [total1shotEarnings, wof1shotRatingDuration] = regretTask1shot(particNum, DateTime, window, windowRect, enabledKeys, screenNumber, cfg)% Clear the workspace and the screen
% [player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, 'fictive', 4, enabledKeys);
%     [player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, 'fictive', player1maxbid, enabledKeys);
%     [player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, player2Strategy, player1maxbid, enabledKeys)
% [winningsMPL, earningsRaven] = questionnaires(particNum, DateTime, window, windowRect)
% [rating, ratingDuration, normalizedChoice, computerSide] = debrief_slider(particNum, DateTime, window, windowRect, enabledKeys)
%     [rating, ratingDuration, normalizedChoice, computerSide] = debrief_slider(particNum, DateTi me,  wi n dow, windowRect, enabledKeys)
% [winnings2x2, chosenGame, opponentChoice]=games2x2winnings(gamesdatafilename, cfg, window);

winnings2x2 = 9;
player1Earnings = 10;
winningsMPL = 3.85;
earningsRaven = 6;

payouts(cfg, window, 10, 'Show-up pagamento', winnings2x2, 'Rows & Colums', total1shotEarnings, ...
    'Ruota della fortuna', player1Earnings, 'Patent Race', winningsMPL, 'Lista dei prezzi', ...
    earningsRaven, 'Puzzles')
% payouts(winnings2x2, gamesdatafilename, total1shotEarnings, player1Earnings, winningsMPL, earningsRaven)
sca;

% big log file
% rating, ratingDuration, normalizedChoice, computerSide

RestrictKeysForKbCheck([]); % re-recognize all key presses
ListenChar(0); % reenable transmission of keypresses to Matlab command window
ShowCursor;

          