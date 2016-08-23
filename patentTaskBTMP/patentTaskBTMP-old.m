% Function to run graphical patent race task
% So far only setup so participant is the strong player
% And only 2 methods of weak player strategies implemented, 'RL', and
% learning from 'Fictive' earnings.
% Tobias Larsen, November 2015
% modified and amended Ben Timberlake, Feburary 2016


function [player1Earnings] = patentTaskBTMP(particNum, DateTime, window, windowRect, player2Strategy)

% clearvars -except particNum DateTime window windowRect;  

% DateTime=datestr(now,'ddmm-HHMM');      % Get date and time for log file
PRIZE=10;                               % Winnings aside from bidding endowment, currently a fixed value
NUMROUNDS=5;                           % Number of rounds played against this opponent
PLAYER1MAXBID=5;                        % Endowment for player1
PLAYER2MAXBID=4;                        % Endowment for player2
TAU=2;                                  % Softmax temperature
player1Options=zeros(1,6);              % Not used yet, maybe never will...
player2Options=5*ones(1,5);             % Keeps track of the values for each betting amount
player1Earnings=nan(NUMROUNDS,1);       % Keeps track of winnings for player1
player2Earnings=nan(NUMROUNDS,1);       % Keeps track of winnings for player2
player1Choice=nan(NUMROUNDS,1);         % Keeps track of player1 choices
player2Choice=nan(NUMROUNDS,1);         % Keeps track of player2 choices
trialLength=nan(NUMROUNDS,1);           % Keeps track of length of each trial
% player2Strategy='Fictive';
player2Strategy='random'; %COMMENT AFTER DEBUGGING
% Shorter delays
fixationDelay = 1 + (2-1).*rand(NUMROUNDS,1); % Creates array of random fixation cross presentation time of 1-2 seconds
feedbackDelay = 1 + (3-1).*rand(NUMROUNDS,1); % Creates array of random delay between choice and feedback of 1-3 seconds
% Longer delays
% fixationDelay = 4 + (8-4).*rand(NUMROUNDS,1); % Creates array of random fixation cross presentation time of 4-8 seconds
% feedbackDelay = 2 + (6-2).*rand(NUMROUNDS,1); % Creates array of random delay between choice and feedback of 2-6 seconds
KbName('UnifyKeyNames');
RestrictKeysForKbCheck([37,39,32]); % limit recognized presses to left and right arrows PC
%RESTORE AFTER DEBUGGING
% if (nargin<1)                           % If the function is called without update method
%     player2Strategy='random';
% end
% Screen('Preference', 'SkipSyncTests', 1); %COMMENT AFTER DEBUGGING (or change 1 to 0)

%% Screen -1: Participant number entry

%%% Enter participant number (taken from:
%%% http://www.academia.edu/2614964/Creating_experiments_using_Matlab_and_Psychtoolbox)
% fail1='Please enter a participant number.'; %error message
% prompt = {'Enter participant number:'};
% dlg_title ='New Participant';
% num_lines = 1;
% def = {'0'};
% answer = inputdlg(prompt,dlg_title,num_lines,def);%presents box to enterdata into
% switch isempty(answer)
%     case 1 %deals with both cancel and X presses 
%         error(fail1)
%     case 0
%         particNum=(answer{1});
% end

% HideCursor;

%% Screen 0: Instructions
% win = 10 %COMMENT AFTER DEBUGGING

% screenRect = [0 0 640 480] %COMMENT AFTER DEBUGGING
% [window, windowRect] = Screen('OpenWindow', 0, [255, 255, 255], [0 0 640 480]); %white background
% [win, screenRect] = Screen('OpenWindow', 0, [255, 255, 255]); %white background

%set colors 
% topColors = [0, 0, 0]; % black
p1Colors = [0, 0, 0.8039]; %MediumBlue
% uppColors = [0, 0, 0]; % black
p2Colors = [0.4314, 0.4824, 0.5451]; % LightSteelBlue4
black = [0, 0, 0]; % black
% winColors = [64, 64, 64]; %gray8
% winColors = [0.2510, 0.2510, 0.2510]; %gray8
winColors = [.1333, .5451, .1333]; %ForestGreen
% instructCola = [0, 104, 139]; %DeepSkyBlue4
instructCola = [0, 0.4078, 0.5451]; %DeepSkyBlue4
% instructColb = [205,149,12]; %DarkGoldenRod3
instructColb = [0.8039, 0.5843, 0.0471]; %DarkGoldenRod3

% Get the size of the on-screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Get the center coordinates of the window
[xCenter, yCenter] = RectCenter(windowRect);
screenCenter = [xCenter, yCenter]; % center coordinates

%Rectangle positions
topRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36 screenXpixels * 0.45];
numtopRect = length(topRectXpos); % Screen X positions of top five rectangles
uppRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36];
numuppRect = length(uppRectXpos); % Screen X positions of upper four rectangles
lowRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36 screenXpixels * 0.45 screenXpixels * 0.54 screenXpixels * 0.63 screenXpixels * 0.72 screenXpixels * 0.81 screenXpixels * 0.9];
numlowRect = length(lowRectXpos); % Screen X positions of lower ten rectangles
botRectXpos = [screenXpixels * 0.54 screenXpixels * 0.63 screenXpixels * 0.72 screenXpixels * 0.81 screenXpixels * 0.9];
numbotRect = length(botRectXpos); % Screen X positions of bottom five rectangles
topRectYpos = screenYpixels * 7/40; % Screen Y positions of top five rectangles (4/40)
uppRectYpos = screenYpixels * 16/40; % Screen Y positions of upper four rectangles (13/40)
sepLineYpos = screenYpixels * 39/80; % Screen Y position of separator line
lowRectYpos = screenYpixels * 27/40; % Screen Y positions of lower ten rectangles (24/40)
botRectYpos = screenYpixels * 34/40; % Screen Y positions of bottom five rectangles (31/40)

% Text positions
topTextYpos = screenYpixels * 2/40; % Screen Y positions of top text
uppTextYpos = screenYpixels * 11/40; % Screen Y positions of upper text
low1TextYpos = screenYpixels * 20/40; % Screen Y positions of lower text line 1
lowTextYpos = screenYpixels * 22/40; % Screen Y positions of lower text line2
botTextYpos = screenYpixels * 30/40; % Screen Y positions of bottom text 
textXpos = round(screenXpixels * 0.09 - screenXpixels * 2/56); % left position of text and separator line
lineEndXpos = round(screenXpixels * 0.91 + screenXpixels * 2/56); % right endpoint of separator line
% Instruct text positions
instruct1TextYpos = screenYpixels * 2/40; 
instruct2TextYpos = screenYpixels * 5/40; 
instruct3TextYpos = screenYpixels * 8/40; 
instruct4TextYpos = screenYpixels * 11/40; 
instruct5TextYpos = screenYpixels * 14/40; 
instruct6TextYpos = screenYpixels * 17/40; 
instruct7TextYpos = screenYpixels * 20/40; 
instruct8TextYpos = screenYpixels * 23/40; 
instruct9TextYpos = screenYpixels * 26/40; 
instruct10TextYpos = screenYpixels * 29/40; 
instructbotTextYpos = screenYpixels * 35/40; 

% Select specific text font, style and size:
fontSize = round(screenYpixels * 2/60);
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, black);
    
% Set standard line weight    
lineWidthPix = round(screenXpixels * 2 / 560);
   
instructText11 = ['You are competing against an opponent'];
instructText12 = ['to win a prize in each trial.'];
instructText13 = ['You can invest 0-' num2str(PLAYER1MAXBID) ' cards.'];
instructText14 = ['Your opponent can invest  0-' num2str(PLAYER2MAXBID) '.'];
instructText15 = ['The player who invests more wins 10.'];
instructText16 = ['If both invest the same amount,'];
instructText17 = ['neither player wins.'];
instructText18 = ['Whatever you don''t invest, you keep.'];
instructText19 = ['(For example, if you invest 3,'];
instructText20 = ['you keep 2, whether you win or lose.)'];
instructText0 = ['Hit the SPACE bar to continue.'];
instructText21 = ['Your endowment is renewed each round.'];
instructText22 = ['Your payment after the experiment will'];
instructText23 = ['be based on two random trials.'];
instructText24 = ['So every trial could matter.'];
instructText25 = ['A fixation cross appears between rounds.'];
% instructText22 = ['to select how many to invest.'];
instructText27 = ['Use the left/right arrow keys'];
instructText28 = ['to select how many cards to invest.'];
instructText29 = ['Then hit the SPACE bar to confirm your choice.'];

keyName=''; % empty initial value


while(~strcmp(keyName,'space')) % continues until current keyName is space
    
    DrawFormattedText(window, instructText11, 'center', instruct1TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText12, 'center', instruct2TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText13, 'center', instruct3TextYpos, instructColb); % Draw betting instructions
    DrawFormattedText(window, instructText14, 'center', instruct4TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText15, 'center', instruct5TextYpos, instructColb); % Draw betting instructions
    DrawFormattedText(window, instructText16, 'center', instruct6TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText17, 'center', instruct7TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText18, 'center', instruct8TextYpos, instructColb); % Draw betting instructions
    DrawFormattedText(window, instructText19, 'center', instruct9TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText20, 'center', instruct10TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText0, 'center', instructbotTextYpos, p1Colors); % Draw betting instructions
    Screen('Flip', window); % Flip to the screen

    [keyTime, keyCode]=KbWait([],2);
    keyName=KbName(keyCode);

end

keyName=''; %resets value to cue next screen
%      Screen('Flip', win); % Flip to the screen
WaitSecs(.25);

while(~strcmp(keyName,'space')) % continues until current keyName is space

    DrawFormattedText(window, instructText21, 'center', instruct1TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText22, 'center', instruct2TextYpos, instructColb); % Draw betting instructions
    DrawFormattedText(window, instructText23, 'center', instruct3TextYpos, instructColb); % Draw betting instructions
    DrawFormattedText(window, instructText24, 'center', instruct4TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText25, 'center', instruct5TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(win, instructText26, 'center', instruct6TextYpos, instructColb); % Draw betting instructions
    DrawFormattedText(window, instructText27, 'center', instruct7TextYpos, p1Colors); % Draw betting instructions
    DrawFormattedText(window, instructText28, 'center', instruct8TextYpos, p1Colors); % Draw betting instructions
    DrawFormattedText(window, instructText29, 'center', instruct9TextYpos, p1Colors); % Draw betting instructions
%     DrawFormattedText(win, instructText30, 'center', instruct10TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText0, 'center', instructbotTextYpos, p1Colors); % Draw betting instructions
    Screen('Flip', window); % Flip to the screen

    [keyTime, keyCode]=KbWait([],2);
    keyName=KbName(keyCode);

end


%% Screen 1: Presentation

% win = 10 %COMMENT AFTER DEBUGGING
% screenRect = [0 0 640 480] %COMMENT AFTER DEBUGGING
% [win, screenRect] = Screen('OpenWindow', 0, [255, 255 ,255], [0 0 640 480]); %white background

% Make a base Rect 4/56th of the screen width and 5/33rds of the height
rectWidth = screenXpixels * 4 / 56;
rectHeight = screenYpixels * 5 / 40;
baseRect = [0 0 rectWidth rectHeight];


% Rectangle coordinates
topRects = nan(4, numtopRect); % Make coordinates for top row of rectangles
for i = 1:numtopRect
    topRects(:, i) = CenterRectOnPointd(baseRect, topRectXpos(i), topRectYpos);
end

uppRects = nan(4, numuppRect); % Make coordinates for upper row of rectangles
for i = 1:numuppRect
    uppRects(:, i) = CenterRectOnPointd(baseRect, uppRectXpos(i), uppRectYpos);
end


lowRects = nan(4, numlowRect); % Make coordinates for bottom row of rectangles
for i = 1:numlowRect
    lowRects(:, i) = CenterRectOnPointd(baseRect, lowRectXpos(i), lowRectYpos);
end

botRects = nan(4, numbotRect); % Make coordinates for bottom row of rectangles
for i = 1:numbotRect
    botRects(:, i) = CenterRectOnPointd(baseRect, botRectXpos(i), botRectYpos);
end

% Instruction text strings
topInstructText = ['Select your investment (0 - ' num2str(PLAYER1MAXBID) ')'];
uppInstructText = ['Your opponent can invest up to ' num2str(PLAYER2MAXBID) '.'];
lowInstructText = 'You can win 10, plus';
botInstructText = 'the amount you don''t invest';

% Trials begin here
for i=1:NUMROUNDS

%% Screen 1a: Fixation cross
% DrawFormattedText(win, '+','center','center'); % Fixation cross as
% typeset character; commented out now that draw cross works

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
fixCrossDimPix = round(screenXpixels * 1 / 56); % Arm size
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0]; % horizontal line
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix]; % vertical line
allCoords = [xCoords; yCoords]; % both lines together

% Draw the fixation cross in black, set it to the center of our screen and set good quality antialiasing
Screen('DrawLines', window, allCoords, lineWidthPix, black, screenCenter);
Screen('Flip', window); % Flip to the screen

% Wait for 4-8 seconds
WaitSecs(fixationDelay(i));


%% Screen 1b: Presentation screen
DrawFormattedText(window, topInstructText, textXpos, topTextYpos); % Draw betting instructions
Screen('FrameRect', window, p1Colors, topRects); % Draw the top rects to the screen
DrawFormattedText(window, uppInstructText, textXpos, uppTextYpos); % Draw opponent explanation
Screen('FrameRect', window, p2Colors, uppRects); % Draw the upper rects to the screen

% % SANDBOXING THIS LINE DISPLAY
% [win, screenRect] = Screen('OpenWindow', 0, [255, 255, 255], [0 0 640 480]); %white background
% topColors = [0, 0, 0]; % black
% winColors = [64, 64, 64]; %gray8
% instructCola = [0, 104, 139]; %DeepSkyBlue4
% instructColb = [205,149,12]; %DarkGoldenRod3
% [screenXpixels, screenYpixels] = Screen('WindowSize', win);
% [xCenter, yCenter] = RectCenter(screenRect);
% 
% textXpos = 50; %increase does nothing
% sepLineYpos1 = 50; % increase shifts back left
% lineEndXpos = 300; %increase makes it gow longer down scren
% sepLineYpos2 = 50; % now moves it up and down relative to 25
% lineWidthPix = 25;
Screen('DrawLine', window, black, lineEndXpos, sepLineYpos, textXpos, sepLineYpos, lineWidthPix); % Make this a line separating the sections
% Scrn('DrawLine', win, [weight    ], lineEndXpo?, [verticlend], textXpo?, [vertclstrt]; % Make this a line separating the sections
% Screen('Flip', win); % Flip to the screen

DrawFormattedText(window, lowInstructText, textXpos, low1TextYpos); % Draw reward explanation
DrawFormattedText(window, botInstructText, textXpos, lowTextYpos); % Draw reward explanation
Screen('FrameRect', window, winColors, lowRects); % Draw the lower rects to the screen 
Screen('FrameRect', window, winColors, botRects); % Draw the bottom rects to the screen 
Screen('Flip', window); % Flip to the screen
        trialStartTime(i) = GetSecs;

currPlayerSelection=0;     % Set starting choice
keyName=''; % empty initial value

while(~strcmp(keyName,'space')) % continues until current keyName is space

[keyTime, keyCode]=KbWait([],2);
keyName=KbName(keyCode);

        switch keyName
            case 'LeftArrow' 
                currPlayerSelection = currPlayerSelection - 1;
                if currPlayerSelection < 0
                    currPlayerSelection = 0;
                end
            case 'RightArrow'
                currPlayerSelection = currPlayerSelection + 1;
                if currPlayerSelection > PLAYER1MAXBID
                    currPlayerSelection = PLAYER1MAXBID;
                end
        end
        % update selection to last button press

DrawFormattedText(window, topInstructText, textXpos, topTextYpos);
% Screen('FillRect', win, topColors, SelectedRects); % Draw the top rects to the screen
Screen('FrameRect', window, p1Colors, topRects);
DrawFormattedText(window, uppInstructText, textXpos, uppTextYpos); % Draw opponent explanation
Screen('FrameRect', window, p2Colors, uppRects); % Draw the upper rects to the screen
Screen('DrawLine', window, black, lineEndXpos, sepLineYpos, textXpos, sepLineYpos, lineWidthPix); % Make this a line separating the sections
DrawFormattedText(window, lowInstructText, textXpos, low1TextYpos); % Draw reward explanation
DrawFormattedText(window, botInstructText, textXpos, lowTextYpos); % Draw reward explanation
Screen('FrameRect', window, winColors, lowRects); % Draw the lower rects to the screen 
Screen('FrameRect', window, winColors, botRects); % Draw the bottom rects to the screen 


if currPlayerSelection ~= 0
    selectedRects = topRects(:,1:currPlayerSelection);    
    Screen('FillRect', window, p1Colors, selectedRects); % Draw the top rects to the screen
else
    selectedRects=0;
end

Screen('Flip', window); % Flip to the screen
            
end

trialEndTime(i) = GetSecs;
player1Choice(i) = currPlayerSelection; 

% Selection text strings
topSelectText = ['You invested ' num2str(player1Choice(i)) '.'];
uppSelectText = ['Your opponent can invest up to ' num2str(PLAYER2MAXBID) '.'];
botSelectText = botInstructText;
    
    player1ChoiceInd = player1Choice(i)+1;      %because choosing 0 is an option, there's a discrepancy between choices and index of options...
    
    player2Choice(i)=find(rand < cumsum(exp(player2Options.*TAU)/sum(exp(player2Options.*TAU))),1);  % uses softmax to make a choice (TAU -> 0 = more random)
    
    player1Earnings(i) = PLAYER1MAXBID + (PRIZE-player1Choice(i))*(player1ChoiceInd > player2Choice(i)) - player1Choice(i)*(player1ChoiceInd<=player2Choice(i)); %calculates how much the strong player wins
    player2Earnings(i) = PLAYER2MAXBID + (PRIZE-player2Choice(i))*(player2Choice(i) > player1ChoiceInd) - player2Choice(i)*(player2Choice(i)<=player1ChoiceInd); %calculates how much the weak player wins
    player2Options = player2Update(player2Options, player2Strategy, player2Choice(i), player2Earnings(i), player1ChoiceInd, PRIZE, PLAYER2MAXBID);  %calls the function that determines how player2 will update its values
    
%% Screen 2: Player's selection
playerSelection = player1Choice(i);
selectedRects = topRects(:,1:playerSelection);
unSelected = playerSelection + 1;
unselectedRects = topRects(:,unSelected:5);

% Win Result text strings
topWinText = topSelectText;
uppWinText = ['Your opponent invested ' num2str(player2Choice(i)-1) '.'];
botWinText = ['You earned ' num2str(player1Earnings(i)) ' in this round.']; 
lowWinText = ['Your opponent earned ' num2str(player2Earnings(i)) ' in this round.']; 

% Draw choice explanation
DrawFormattedText(window, topSelectText, textXpos, topTextYpos);
if currPlayerSelection ~= 0
    Screen('FillRect', window, p1Colors, selectedRects); % Draw the top rects to the screen
end
Screen('FrameRect', window, p1Colors, topRects);
DrawFormattedText(window, uppSelectText, textXpos, uppTextYpos); % Draw opponent explanation
Screen('FrameRect', window, p2Colors, uppRects); % Draw the upper rects to the screen
Screen('DrawLine', window, black, lineEndXpos, sepLineYpos, textXpos, sepLineYpos, lineWidthPix); % Make this a line separating the sections
DrawFormattedText(window, lowInstructText, textXpos, low1TextYpos); % Draw reward explanation
DrawFormattedText(window, botInstructText, textXpos, lowTextYpos); % Draw reward explanation
Screen('FrameRect', window, winColors, lowRects); % Draw the lower rects to the screen 
Screen('FrameRect', window, winColors, botRects); % Draw the bottom rects to the screen 
% Screen('FrameRect', win, botColors, unselectWinRects); % Draw the lower lost rects to the screen
% Screen('FillRect', win, botColors, selectedWinRects); % Draw the lower retained rects to the screen
% Screen('FrameillRect', win, topColors, selectedRects); % Draw the lower lost rects to the screen
% Screen('FillRect', win, topColors, unselectedRects);

% show filled rects if win / empty rects if lost
% if player1Choice(i) > player2Choice(i)
%     Screen('FillRect', win, botColors, rewardRects); % Draw the lower retained rects to the screen
%     Screen('FillRect', win, botColors, botRects); % Draw the bottom won rects to the screen
% else
%     Screen('FrameRect', win, botColors, rewardRects); % Draw the lower lost rects to the screen
%     Screen('FrameRect', win, botColors, botRects); % Draw the bottom lost rects to the screen
% end
Screen('Flip', window); % Flip to the screen

WaitSecs(feedbackDelay(i));

%% Screen 3: Result
weakSelection = player2Choice(i)-1;
if weakSelection ~= 0
    weakselRects = uppRects(:,1:weakSelection);
else
    weakselRects=0;
end
% weakunSelected = (str2num(weakSelection) + 1);
% weakunselRects = uppRects(:,weakunSelected:4);
if player1Choice(i) < PLAYER1MAXBID
    selectedWinRects = lowRects(:,player1Choice(i)+1:PLAYER1MAXBID);
else
    selectedWinRects=0;
end
% lostRects = playerSelection - 1;
% unselectWinRects = lowRects(:,1:currPlayerSelection);
rewardRects = lowRects(:,6:10);

% display('test')
Screen('FrameRect', window, p1Colors, topRects);
Screen('FrameRect', window, p2Colors, uppRects);
Screen('FrameRect', window, p2Colors, lowRects); 
Screen('FrameRect', window, p2Colors, botRects); 

%     Screen('TextStyle', win, 1); % change style to bold
Screen('DrawLine', window, black, lineEndXpos, sepLineYpos, textXpos, sepLineYpos, lineWidthPix); % Make this a line separating the sections
DrawFormattedText(window, topSelectText, textXpos, topTextYpos); % Draw strong outcome
DrawFormattedText(window, uppWinText, textXpos, uppTextYpos); % Draw weak outcome
% DrawFormattedText(win, lowInstructText, textXpos, low1TextYpos); % Draw reward explanation
% DrawFormattedText(win, botInstructText, textXpos, lowTextYpos); % Draw reward explanation

if selectedRects
    Screen('FillRect', window, p1Colors, selectedRects); % Draw the top rects to the screen
end
if weakselRects
    Screen('FillRect', window, p2Colors, weakselRects); % Draw the upper rects to the screen
end
if selectedWinRects
    Screen('FillRect', window, p1Colors, selectedWinRects); % Draw the lower retained rects to the screen
end

% show filled rects if win / empty rects if lost
if player1Choice(i) > weakSelection
    Screen('FillRect', window, winColors, rewardRects); % Draw the lower reward rects to the screen
    Screen('FillRect', window, winColors, botRects); % Draw the bottom won rects to the screen
% else
%     Screen('FrameRect', win, botColors, rewardRects); % Draw the lower lost rects to the screen
%     Screen('FrameRect', win, botColors, botRects); % Draw the bottom lost rects to the screen
end
% Screen('FrameRect', win, botColors, lowRects); % Draw the lower rects to the screen
% Screen('FillRect', win, botColors, botRects); % Draw the bottom rects to the screen
DrawFormattedText(window, botWinText, textXpos, lowTextYpos); % Draw reward explanation
Screen('Flip', window); % Flip to the screen

WaitSecs(5);

end

%% Screen 4: Earnings

% calculate total earnings this round for each player 
p1GameEarnings=sum(player1Earnings); 
p2GameEarnings=sum(player2Earnings);

% Earnings text
earningsText11 = ['Your earnings this game: ' num2str(p1GameEarnings)];
earningsText12 = ['Opponent''s earnings this game: ' num2str(p2GameEarnings)];

    DrawFormattedText(window, earningsText11, 'center', instruct1TextYpos); % Draw player earnings text
    DrawFormattedText(window, earningsText12, 'center', instruct3TextYpos); % Draw opponent earnings text
%     DrawFormattedText(win, instructText0, 'center', instructbotTextYpos); % Draw space bar instructions
    Screen('Flip', window); % Flip to the screen

WaitSecs(4);

function [player2Options] = player2Update(player2Options, player2Strategy, player2Choice, player2Earnings, player1Choice, PRIZE, PLAYER2MAXBID)
    alpha=0.5;  % learning rate for how quickly player2 adapts

    switch lower(player2Strategy)
        case 'rl'
            player2Options(player2Choice) = player2Options(player2Choice) + alpha*(player2Earnings-player2Options(player2Choice));      % Update value of chosen option based on earnings
        case 'fictive'
            player2FictEarn = PLAYER2MAXBID + (PRIZE-(0:PLAYER2MAXBID)).*((0:PLAYER2MAXBID) > player1Choice) - (0:PLAYER2MAXBID).*((0:PLAYER2MAXBID)<=player1Choice); %calculates the fictive earnings of each potential choice
            player2Options = player2Options + alpha*(player2FictEarn-player2Options);  %updates the value of each option based on the fictive earnings
        otherwise           % Default option is to not update the value of the options, making each choice random
            
    end
end


% sca;
RestrictKeysForKbCheck([]); % re-recognize all key presses


%% End-of-block calculations and create log file
for i=1:NUMROUNDS
        trialLength(i) = trialEndTime(i)-trialStartTime(i);
end

% save(['/Users/bentimberlake/Documents/MATLAB/patentTaskBTMP/logfiles/patent_race-subj_' num2str(particNum) '-' DateTime], 'player1Choice', 'player2Choice', 'player1Earnings', 'player2Earnings', 'trialLength');
save([num2str(particNum) '-' DateTime '_3patent_race-subj'], 'player1Choice', 'player2Choice', 'player1Earnings', 'player2Earnings', 'trialLength');

end




