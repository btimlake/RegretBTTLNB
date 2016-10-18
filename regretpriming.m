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
addpath('REGRET_task', 'patentTaskBTMP', 'ratingslider', 'instructions', 'games', 'games/stimoli', 'questionnaires');

KbName('UnifyKeyNames');

showUp = 5; % fee for coming to the experiment; base payment amount

%% VARIABLES
player1maxbid1=5; % Patent Race first Role
player1maxbid2=4; % Patent Race second Role
gamestrials = 48; % Trials for 2x2 games
prtrials = 5; % Trials for each role in Patent Race

DateTime=datestr(now,'ddmm-HHMM');      % Get date and time for log file

playOrder = [player1maxbid1, player1maxbid2];

%% check what OS the software is running on; limit keyboard/mouse input

if ismac
    % Code to run on Mac plaform 
    disp('Mac');
    disabledKeys=[];
    skipSyncTest=[];
    screenRes=[];
    enabledKeys = RestrictKeysForKbCheck([30, 34, 44, 79, 80, 81,82]); % limit recognized presses to 1!, 5%, space, left, right, up, down arrows MAC
%     enabledKeys = RestrictKeysForKbCheck([]); % for debugging
elseif isunix
    % Code to run on Linux plaform
    disp('Unix');
elseif ispc
    % Code to run on Windows platform
    disp('PC');
    enabledKeys = RestrictKeysForKbCheck([49,53,32,37,38,39,40]); % limit recognized presses to 1!, 5%, space, left, up, right, down arrows PC

else
    disp('Platform not supported')
end

%     enabledKeys = RestrictKeysForKbCheck([30, 34, 44, 79, 80, 81,82]); % limit recognized presses to 1!, 5%, space, left, right, up, down arrows MAC
%     enabledKeys = RestrictKeysForKbCheck([49,53,32,37,38,39,40]); % limit recognized presses to 1!, 5%, space, left, right, up, down arrows PC

% Hide cursor, stop input in command screen
% uncomment INLAB
HideCursor;
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
cfg.font = 'Courier New';
cfg.fontSize = round(screenYpixels * 2/80);
% cfg.fontSize = round(screenYpixels * 2/60);
cfg.fontSizeSmall = round(screenYpixels * 2/100);
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
cfg.uppTextYpos = screenYpixels * 6/40;
cfg.botTextYpos = screenYpixels * 35/40; % Screen Y positions of bottom/result text
cfg.waitTextYpos = screenYpixels * 38/40; % Y position of lowest "Please Wait" text
% cfg.leftTextXpos = screenXpixels * .035; % X position for Raven prompt
% cfg.LeftTextXpos = screenXpixels*.035; % position for Raven prompts

%% Screen 0: Participant number entry 
    Screen('TextFont', window, cfg.font);
    Screen('TextSize', window, cfg.fontSizeSmall);
    Screen('TextStyle', window);
    Screen('TextColor', window, cfg.textColor);
    
inputReq1 = 'Inserisci le due cifre sopra \n il tuo computer e premi "Invio": '; % ITALIAN
fail1='Si prega inserisci esattamente due cifre \n e premi "Invio": '; % ITALIAN
inputReq2 = 'Inserisci la data come e'' scritta \n sulla lavagna e premi "Invio": '; % ITALIAN
fail2='Si prega inserisci quattro numeri \n e premi "Invio": '; % ITALIAN
    
    [nx, ny1, textRect1]=DrawFormattedText(window, inputReq1, 0, 0, cfg.bgColor); % draws a dummy version of text just to get measurements
    [nx, ny2, textRect2]=DrawFormattedText(window, inputReq2, 0, ny1, cfg.bgColor); % draws a dummy version of text just to get measurements
	textWidth1 = textRect1(3)-textRect1(1); % figures width of bounding rectangle of text
	textWidth2 = textRect2(3)-textRect2(1); % figures width of bounding rectangle of text
    cfg.xPos1 = cfg.screenCenter(1) - textWidth1/2; % sets x position half the text length back from center 
    cfg.xPos2 = cfg.screenCenter(1) - textWidth2/2; % sets x position half the text length back from center 
    cfg.yPos = cfg.screenCenter(2);
    cfg.yPos2 = cfg.yPos + ny1; 
Screen('Flip', window)

aOK=0; % initial value for aOK

while aOK ~= 1
    
    compNum = GetEchoStringForm(window, inputReq1, cfg.xPos1, cfg.yPos, cfg.textColor); % displays string in PTB; allows backspace
    
    % HOW TO GET THIS TO ALLOW REPEATED INPUT?
%     TRY BREAK OR RETURN
% TRY CATCH INSTEAD - step back in a while loop
    % compNum = input('Enter the number of your computer and then press "Enter": ') % ENGLISH
    % compNum = input('Tasti il numero sopra il tuo computer e poi premi "Enter": ') % ITALIAN
    switch isempty(compNum)
        case 1 %deals with both cancel and X presses
            Screen('Flip', window)
            compNum = GetEchoStringForm(window, fail1, cfg.xPos1, cfg.yPos, cfg.textColor); % displays string in PTB; allows backspace
        case 0
            if length(compNum) ~= 2 || str2num(compNum) <= 0 || str2num(compNum) >= 25
%                 aOK = 0;
                Screen('Flip', window)
%                 compNum = GetEchoStringForm(window, fail1, cfg.xPos1, cfg.yPos, cfg.textColor); % displays string in PTB; allows backspace
%                 break

            else
                aOK = 1;
                Screen('Flip', window)
                
            end
    end
                Screen('Flip', window)

end

aOK=0; % initial value for aOK

while aOK ~= 1
    
    insertDate = GetEchoStringForm(window, inputReq2, cfg.xPos2, cfg.yPos2, cfg.textColor); % displays string in PTB; allows backspace
    
    % HOW TO GET THIS TO ALLOW REPEATED INPUT?
%     TRY BREAK OR RETURN
    % compNum = input('Enter the date as written on the whiteboard and then press "Enter": ') % ENGLISH
    % compNum = input('Tasti il dato come ? scritto su lavagna e poi premi "Enter": ') % ITALIAN
    switch isempty(insertDate)
        case 1 %deals with both cancel and X presses
            Screen('Flip', window)
            insertDate = GetEchoStringForm(window, fail2, cfg.xPos2, cfg.yPos2, cfg.textColor); % displays string in PTB; allows backspace
        case 0
            if length(insertDate) ~= 4;
                aOK = 0;
            Screen('Flip', window)
                insertDate = GetEchoStringForm(window, fail2, cfg.xPos2, cfg.yPos2, cfg.textColor); % displays string in PTB; allows backspace
            else
                aOK = 1;
                Screen('Flip', window)
            end
    end
                Screen('Flip', window)

end

particNum = [insertDate, compNum];

%% call scripts
% TEMP VARIABLES FOR TESTING
% gamesdatafilename = 'sub123422-1610-2253_1games2x2.dat';
% total1shotEarnings = 8;
% p1GameEarnings = 8.85;
% earningsRaven = 6;
% winningsMPL = 3.85;
% winnings2x2 = 1;

[gamesdatafilename]=games(particNum, DateTime, window, windowRect, gamestrials, enabledKeys, cfg);
%    [gamesdatafilename]=games(subNo, anni, w, wRect, NUMROUNDS, enabledKeys, cfg)

patentTaskInstructions(window, windowRect, enabledKeys, cfg, player1maxbid1);

[wofPracticeEarnings] = regretTask(particNum, DateTime, window, windowRect, enabledKeys, 10);
%       regretTask(particNum, DateTime, window, windowRect, enabledKeys,
%       trials); % trials should be no more than 10
[wof1shotChoice, total1shotEarnings, wof1shotForegoneAmount, wof1shotReError] = regretTask1shot(particNum, DateTime, window, windowRect, enabledKeys, screenNumber, cfg);
%     [total1shotEarnings, wof1shotRatingDuration] = regretTask1shot(particNum, DateTime, window, windowRect, enabledKeys, screenNumber, cfg)% Clear the workspace and the screen

[player1Choice1, player2Choice1, p1GameEarnings1] = patentTaskBTMP(particNum, DateTime, window, windowRect, cfg, 'fictive', player1maxbid1, prtrials, 1);
[player1Choice2, player2Choice2, p1GameEarnings2] = patentTaskBTMP(particNum, DateTime, window, windowRect, cfg, 'fictive', player1maxbid2, prtrials, 2);
p1GameEarnings = p1GameEarnings1+p1GameEarnings2; % total of the two
%     [p1GameEarnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, enabledKeys, player2Strategy, player1maxbid, trials, block);
%     [player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, player2Strategy, player1maxbid, enabledKeys)

[rating, ratingDuration, normalizedChoice, computerSide] = debrief_slider(particNum, DateTime, window, windowRect, enabledKeys);
%     [rating, ratingDuration, normalizedChoice, computerSide] = debrief_slider(particNum, DateTi me,  wi n dow, windowRect, enabledKeys)

[ravenChoice, ravenWinnings] = Raven(cfg, particNum, DateTime, window, windowRect);

[choiceMPL, winningsMPL] = MPL(cfg, particNum, DateTime, window, windowRect, enabledKeys);

[cit] = CITquestionnaire(cfg, particNum, DateTime, window, windowRect, enabledKeys);
%   [winningsMPL, earningsRaven] = questionnaires(particNum, DateTime, window, windowRect)

[sex, sexNum, age, eduLevel, field] = agesex(cfg, particNum, DateTime, window);

[winnings2x2, chosenGame2x2, opponentChoice2x2]=games2x2winnings(gamesdatafilename, cfg, window);

[totalEarnings]=payouts(cfg, window, particNum, DateTime, showUp, 'Show-up pagamento', winnings2x2, 'Righe e Colonne', total1shotEarnings, ...
    'Ruota della fortuna', p1GameEarnings, 'Patent Race', winningsMPL, 'Lista dei Prezzi', ...
    ravenWinnings, 'Puzzles');
%   [totalEarnings] = payouts(cfg, window, va rargin) % must follow pattern of (amount1, label1, amount2, label2, ? amountn, labeln)

% big log file
% rating, ratingDuration, normalizedChoice, computerSide

filepointer = ['sub' num2str(particNum) '-' num2str(DateTime) '_9all'];
save(['sub' num2str(particNum) '-' num2str(DateTime) '_9all'], 'particNum', 'age', 'sex', 'field', 'eduLevel', ...
    'wof1shotChoice', 'total1shotEarnings', 'wof1shotForegoneAmount', 'wof1shotReError', ...
    'playOrder', 'player1Choice1', 'player2Choice1', 'player1Choice2', 'player2Choice2', 'p1GameEarnings', ...
    'ravenChoice', 'ravenWinnings', 'choiceMPL', 'winningsMPL', 'cit', ...
    'winnings2x2', 'chosenGame2x2', 'opponentChoice2x2', 'totalEarnings');

% fprintf(filepointer,'%u %u %u %u %u %c %s %s // %u %u %g3 %i %i %i %i %i %i %i %i %i\n', ...
%                 particNum, ...
%                 compNum, ... 
%                 DateTime, ...
%                 insertDate, ...               
%                 age, ...
%                 sex, ...
%                 field, ...
%                 eduLevel, ...
%                 //
%                 wof1shotChoice, ...
%                 total1shotEarnings, ...
%                 wof1shotemotionalRating, ...
%                 player1Choice1, ...
%                 player2Choice1, ...
%                 player1Choice2, ...
%                 player2Choice2, ...
%                 p1GameEarnings, ...
%                 ravenChoice, ...
%                 choiceMPL, ...
%                 cit);
%                 field, ...
%                 field, 

sca; % clear all, clear screen
RestrictKeysForKbCheck([]); % re-recognize all key presses
ListenChar(0); % reenable transmission of keypresses to Matlab command window
ShowCursor; % reveal mouse cursor

          