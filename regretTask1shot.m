 % Clear the workspace and the screen
% sca;
% close all;
clearvars -except particNum DateTime screens screenNumber window windowRect prop* tex* arrow*;  

% load('regretTasktrialWheels1shot.mat')       % Load the preset wheel probabilites and values TABLE
load('regretTasktrialWheels1shotDataset.mat')       % Load the preset wheel probabilites and values DATASET
regretTasktrialWheels1shot = regretTasktrialWheels1shotDataset; % Needed to equate variable to different filename
% DateTime=datestr(now,'ddmm-HHMM');      % Get date and time for log file

%% Screen -1: Participant number entry [delete when combined with Patent Race]
% 
% %% Enter participant number (taken from:
% %% http://www.academia.edu/2614964/Creating_experiments_using_Matlab_and_Psychtoolbox)
% fail1='Please enter a participant number.'; %error  message
% prompt = {'Enter participant number:'};
% dlg_title ='New Participant';
% num_lines = 1;
% def = {'0'};
% answer = inputdlg(prompt,dlg_title,num_l ines,def);%presents box to enterdata into
% switch isempty(answer)
%     case 1 %deals with both cancel and X presses 
%         error(fail1)
%     case 0
%         particNum=(answer{1});
% end

% uncomment after debugging
% HideCursor;

%% Here we call some default settings for setting up Psychtoolbox
% PsychDefaultSetup(2);

% Screen('Preference', 'SkipSyncTests', 1);
% KbName('UnifyKeyNames');
% 
% % Get the screen numbers
% screens = Screen('Screens');
% 
% % Draw to the external screen if avaliable
% % screenNumber = max(screens);
% screenNumber = 0;

% Define black and white and other colors
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
BG=[1 1 1]; % set background color of PNG imports
% NOTE that colors now have to be in the set [0,1], so to get values, just 
% divide old RGB amounts by 255
winColors = [.1333, .5451, .1333]; %ForestGreen
loseColors = [.8039, .2157, 0]; %OrangeRed3
% winColors = black; %black
% loseColors = black; %black
chooseColors = [1, .84, 0]; %Gold

% Open an on screen window
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]);
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
screenCenter = [xCenter, yCenter]; % center coordinatesf


%% Set position info
wheelRadius = (screenXpixels*.13);

% Set positions of graphical elements
leftWheelpos = [screenXpixels*.25-wheelRadius screenYpixels*.5-wheelRadius screenXpixels*.25+wheelRadius screenYpixels*.5+wheelRadius];
rightWheelpos = [screenXpixels*.75-wheelRadius screenYpixels*.5-wheelRadius screenXpixels*.75+wheelRadius screenYpixels*.5+wheelRadius];
leftArrowpos = [screenXpixels*.25-wheelRadius*.25 screenYpixels*.5-wheelRadius*.75 screenXpixels*.25+wheelRadius*.25 screenYpixels*.5+wheelRadius*.75];
rightArrowpos = [screenXpixels*.75-wheelRadius*.25 screenYpixels*.5-wheelRadius*.75 screenXpixels*.75+wheelRadius*.25 screenYpixels*.5+wheelRadius*.75];

% Set positions of text elements
topTextYpos = screenYpixels * 2/40; % Screen Y positions of top/instruction text
botTextYpos = screenYpixels * 35/40; % Screen Y positions of bottom/result text
leftwheelLeftTextXpos = screenXpixels*.035;
leftwheelRightTextXpos = screenXpixels*.40;
rightwheelLeftTextXpos = screenXpixels*.52;
rightwheelRightTextXpos = screenXpixels*.91;
leftwheelLeftTextYpos = screenYpixels*.38;
leftwheelRightTextYpos = screenYpixels*.43;
rightwheelLeftTextYpos = screenYpixels*.38;
rightwheelRightTextYpos = screenYpixels*.43;

% Rect positions/dimensions based on wheel positions/dimensions
rectWidth = screenXpixels*.3; % based on wheelRadius = (screenXpixels*.13);
rectHeight = screenYpixels*.45;
baseRect = [0 0 rectWidth rectHeight];
rectYpos = screenYpixels*.5;
leftRectXpos = screenXpixels*.25;
rightRectXpos = screenXpixels*.75;
leftRect = CenterRectOnPointd(baseRect, leftRectXpos, rectYpos);
rightRect = CenterRectOnPointd(baseRect, rightRectXpos, rectYpos);
lineWeight = round(screenYpixels*.01);

% temporary; will be modified to make these vary depending on choice
% Not sure anymore that this is needed
locChoice = leftWheelpos;  
locNonChoice = rightWheelpos; 
arrowChoice = leftArrowpos;
arrowNonChoice = rightArrowpos;

% Display text
topInstructText = ['Choose which wheel to play.'];

% Select specific text font, style and size:
fontSize = round(screenYpixels * 2/60);
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, [0, 0, 0]);
    
% Set some variables
NUMROUNDS = 1;
lotteryOutcome1shot = [.70*regretTasktrialWheels1shot.wlp2 1.6*regretTasktrialWheels1shot.wrp2; 1.7*regretTasktrialWheels1shot.wlp2 0.8*regretTasktrialWheels1shot.wrp2]; % Creates array of outcomes for both wheels for either left choice (:,1) or right choice (:,2)

% outcome values from earlier iterations
% OUTCOME1 = 50;
% OUTCOME2 = -50;
% OUTCOME3 = 200;
% OUTCOME4 = -50;
% % outcome strings
% winL = num2str(OUTCOME1);
% loseL = num2str(OUTCOME2);
% winR = num2str(OUTCOME3);
% loseR = num2str(OUTCOME4);

%% back to original
% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% We will set the rotations angles to increase by 1 degree on every frame
degPerFrame = 10;

% We position the squares in the middle of the screen in Y, spaced equally
% scross the screen in X
% posXs = [screenXpixels * 0.25 screenXpixels * 0.5 screenXpixels * 0.75];
% posYs = ones(1, numRects) .* (screenYpixels / 2);

arrow=imread(fullfile('arrow.png'), 'BackgroundColor',BG); %load image of arrow
texArrow = Screen('MakeTexture', window, arrow); % Draw arrow to the offscreen window
prop25=imread(fullfile('propCircle25-75.png'), 'BackgroundColor',BG); %load image of circle
prop33=imread(fullfile('propCircle33-66.png'), 'BackgroundColor',BG ); %load image of circle
prop50=imread(fullfile('propCircle50-50.png'), 'BackgroundColor',BG); %load image of circle
prop66=imread(fullfile('propCircle66-33.png'), 'BackgroundColor',BG); %load image of circle
prop75=imread(fullfile('propCircle75-25.png'), 'BackgroundColor',BG); %load image of circle
texProb25 = Screen('MakeTexture', window, prop25); % Draw circle to the offscreen window
texProb33 = Screen('MakeTexture', window, prop33); % Draw circle to the offscreen window
texProb50 = Screen('MakeTexture', window, prop50); % Draw circle to the offscreen window
texProb66 = Screen('MakeTexture', window, prop66); % Draw circle to the offscreen window
texProb75 = Screen('MakeTexture', window, prop75); % Draw circle to the offscreen window

%     [...] = imread(...,'BackgroundColor',BG) composites any transparent 
%     pixels in the input image against the color specified in BG.  If BG is
%     'none', then no compositing is performed. Otherwise, if the input image
%     is indexed, BG should be an integer in the range [1,P] where P is the
%     colormap length. If the input image is grayscale, BG should be a value
%     in the range [0,1].  If the input image is RGB, BG should be a 
%     three-element vector whose values are in the range [0,1]. The string
%     'BackgroundColor' may be abbreviated. 
    
% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

%% Screen 0 - Instructions
% Instruct text positions
instruct1TextYpos = screenYpixels * 2/42; 
instruct2TextYpos = screenYpixels * 4/42; 
instruct3TextYpos = screenYpixels * 6/42; 
instruct4TextYpos = screenYpixels * 8/42; 
instruct5TextYpos = screenYpixels * 10/42; 
instruct6TextYpos = screenYpixels * 12/42; 
instruct7TextYpos = screenYpixels * 14/42; 
instruct8TextYpos = screenYpixels * 16/42; 
instruct9TextYpos = screenYpixels * 18/42; 
instruct10TextYpos = screenYpixels * 20/42; 
instruct11TextYpos = screenYpixels * 22/42; 
instruct12TextYpos = screenYpixels * 24/42; 
instruct13TextYpos = screenYpixels * 26/42; 
instruct14TextYpos = screenYpixels * 28/42; 
instruct15TextYpos = screenYpixels * 30/42; 
instruct16TextYpos = screenYpixels * 32/42; 
instruct17TextYpos = screenYpixels * 34/42; 
instruct18TextYpos = screenYpixels * 36/42; 
instruct19TextYpos = screenYpixels * 38/42; 
instructbotTextYpos = screenYpixels * 40/42; 

% Instruction text
instructText0 = ['Please wait to be told to continue.'];

instructText11 = ['Now you will play the important'];
instructText12 = ['lottery wheel game.'];
instructText13 = ['You will spin one wheel, and the outcome'];
instructText14 = ['of this game alone can change your winnings.'];
% instructText15 = [''];
instructText16 = ['As before, choose which wheel to play'];
instructText17 = ['by pressing the left arrow key or the'];
instructText18 = ['right arrow key.'];
% instructText19 = [''];
% 
% instructText20 = ['You will also see the result of the'];
% instructText21 = ['wheel you did not choose, but it will'];
% instructText22 = ['not change your score.'];
% 
% instructText23 = ['You will practice 10 times, but these'];
% instructText24 = ['trials do not affect your payment.'];
% instructText25 = ['The final game is the only one that'];
% instructText26 = ['matters, and you will be told when'];
% instructText27 = ['that game is about to happen.'];
% instructText28 = ['In that game, you can either add to'];
% instructText29 = ['your 50 euros or lose from it.'];

% Instruction text colors
instructCola = [0, 0.4078, 0.5451]; %DeepSkyBlue4
instructColb = [0.8039, 0.5843, 0.0471]; %DarkGoldenRod3

keyName=''; % empty initial value

RestrictKeysForKbCheck([37,39,32,49]); % limit recognized presses to left and right arrows PC

while(~strcmp(keyName,'1!')) % continues until the 1 button is pressed
    
    DrawFormattedText(window, instructText11, 'center', instruct2TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText12, 'center', instruct3TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText13, 'center', instruct4TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText14, 'center', instruct5TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText15, 'center', instruct5TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText16, 'center', instruct8TextYpos, instructColb); % Draw betting instructions
    DrawFormattedText(window, instructText17, 'center', instruct9TextYpos, instructColb); % Draw betting instructions
    DrawFormattedText(window, instructText18, 'center', instruct10TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText19, 'center', instruct9TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText20, 'center', instruct10TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText21, 'center', instruct11TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText22, 'center', instruct12TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText23, 'center', instruct13TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText24, 'center', instruct14TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText25, 'center', instruct15TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText26, 'center', instruct16TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText27, 'center', instruct17TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText28, 'center', instruct18TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText29, 'center', instruct19TextYpos, instructCola); % Draw betting instructions
    DrawFormattedText(window, instructText0, 'center', instruct19TextYpos, black); % Draw betting instructions
    Screen('Flip', window); % Flip to the screen

    [keyTime, keyCode]=KbWait([],2);
    keyName=KbName(keyCode);

end

WaitSecs(.25);


%% Begin trial loop

for i=1:NUMROUNDS

%% Screen 1

keyName=''; % empty initial value

%     [keyTime, keyCode]=KbWait([],2);
%     keyName=KbName(keyCode);
% 
% while(strcmp(keyName,'')) % continues until any key pressed
    
%         switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = 0; % choice is left lottery
%             case 'RightArrow'
%                 currPlayerSelection = 1; % choice is right lottery
%         end

% Set win/lose values based on trial round
winL = num2str(regretTasktrialWheels1shot.wlv1(i));
loseL = num2str(regretTasktrialWheels1shot.wlv2(i));
winR = num2str(regretTasktrialWheels1shot.wrv1(i));
loseR = num2str(regretTasktrialWheels1shot.wrv2(i));
% wheelL = ['texProb' num2str(regretTasktrialWheels.wlp1(i)*100)];
% wheelR = ['texProb' num2str(regretTasktrialWheels.wrp1(i)*100)];

wheelL = [];
wheelR = [];

probL = num2str(regretTasktrialWheels1shot.wlp1(i));
probR = num2str(regretTasktrialWheels1shot.wrp1(i));

switch probL
    case {'0.25'}
    wheelL=texProb25;
    case {'0.33'}
    wheelL=texProb3';
    case {'0.5'}
    wheelL=texProb50;
    case {'0.66'}
    wheelL=texProb66;
    case {'0.75'}
    wheelL=texProb75;
end

  
switch probR
    case {'0.25'}
    wheelR=texProb25;
    case {'0.33'}
    wheelR=texProb33;
    case {'0.5'}
    wheelR=texProb50;
    case {'0.66'}
    wheelR=texProb66;
    case {'0.75'}
    wheelR=texProb75;
end      
        
% wheelL = texProb66
% wheelR = texProb50 

    angChoice=0;
    angNonChoice=0;
    
    DrawFormattedText(window, topInstructText, 'center', topTextYpos, black); % Instruction text

    % Show lottery choices
    Screen('DrawTexture', window, wheelL, [0 0 550 550], locChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice, angChoice);
    DrawFormattedText(window, winL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount 
    DrawFormattedText(window, loseL, leftwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
    % non-choice wheel & arrow
     
    Screen('DrawTexture', window, wheelR, [0 0 550 550], locNonChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice, angNonChoice);
    DrawFormattedText(window, winR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    DrawFormattedText(window, loseR, rightwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
    Screen('Flip', window)
 
wofTrialStartTime(i) = GetSecs; % trial time start

% RestrictKeysForKbCheck([79, 80]); % limit recognized presses to left and right arrows MAC
RestrictKeysForKbCheck([37,39]); % limit recognized presses to left and right arrows PC
[keyTime, keyCode]=KbWait([],2); % Wait for a key to be pushed and released
keyName=KbName(keyCode); % get the name of which key was pressed

    if strcmp(keyName,'LeftArrow') % If left arrow pressed, set the rectangle to the left side
        rectPos = leftRect;
        wof1shotChoice(i) = 1;   % and note the choice for the log file
    elseif strcmp(keyName,'RightArrow')
        rectPos = rightRect;
        wof1shotChoice(i) = 2;
    end
    
wofTrialEndTime(i) = GetSecs; % trial time end

RestrictKeysForKbCheck([]); % re-recognize all key presses

%% show choice rect over wheels
    Screen('DrawTexture', window, wheelL, [0 0 550 550], locChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice, angChoice);
    DrawFormattedText(window, winL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount 
    DrawFormattedText(window, loseL, leftwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
    % non-choice wheel & arrow
    
    Screen('DrawTexture', window, wheelR, [0 0 550 550], locNonChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice, angNonChoice);
    DrawFormattedText(window, winR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    DrawFormattedText(window, loseR, rightwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
        Screen('FrameRect', window, chooseColors, rectPos, lineWeight); % Draw the choice rect to the screen
        Screen('Flip', window)
    
 WaitSecs(1);   

%             switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = currPlayerSelection - 1;
%                 if currPlayerSelection < 0
%                     currPlayerSelection = 0;
%                 end
%             case 'RightArrow'
%                 currPlayerSelection = currPlayerSelection + 1;
%                 if currPlayerSelection > PLAYER1MAXBID
%                     currPlayerSelection = PLAYER1MAXBID;
%                 end
%         end
%% Determine results and log

% arrowAngleL=360*lotteryOutcome1shot(j,1); % reflects final position of arrow
% arrowAngleR=360*lotteryOutcome1shot(j,2);
% winResultText = ['You won ' num2str(winAmount(i)) '.'];
% lossResultText = ['You lost ' num2str(lossAmount(i)) '.'];
 
% Determine whether the selection resulted in win or loss
if wof1shotChoice(i) == 1    % Participant chose wheel 1
    j=1;
% Set positions for each wheel type
arrowAngleL=360*lotteryOutcome1shot(j,1); % reflects final position of arrow
arrowAngleR=360*lotteryOutcome1shot(j,2);
    
    if arrowAngleL > 360*regretTasktrialWheels1shot.wlp2(i);   % If endpoint of arrow is greater than loss zone, win
    winAmount(i) = regretTasktrialWheels1shot.wlv1(i);
    wof1shotEarnings(i) = winAmount(i);  % set earngings for log file
    botResultText = ['You won ' num2str(winAmount(i)) '.'];  % Set feedback text to winning message
    botTextColor = winColors;
    else   % If endpoint of arrow is less than loss zone, loss
    lossAmount(i) = regretTasktrialWheels1shot.wlv2(i);
    wof1shotEarnings(i) = lossAmount(i);  % set losses for log file
    botResultText = ['You lost ' num2str(-lossAmount(i)) '.'];  % Set feedback text to losing message
    botTextColor = loseColors;
    end

elseif wof1shotChoice(i) == 2    % Participant chose wheel 2
    j=2;
% Set positions for each wheel type
arrowAngleL=360*lotteryOutcome1shot(j,1); % reflects final position of arrow
arrowAngleR=360*lotteryOutcome1shot(j,2);

    if arrowAngleR > 360*regretTasktrialWheels1shot.wrp2(i);   % If endpoint of arrow is greater than loss zone, win
    winAmount(i) = regretTasktrialWheels1shot.wrv1(i);
    wof1shotEarnings(i) = winAmount(i);  % set earngings for log file
    botResultText = ['You won ' num2str(winAmount(i)) '.'];  % Set feedback text to winning message
    botTextColor = winColors;
    else   % If endpoint of arrow is less than loss zone, loss
    lossAmount(i) = regretTasktrialWheels1shot.wrv2(i);
    wof1shotEarnings(i) = lossAmount(i);  % set losses for log file
    botResultText = ['You lost ' num2str(-lossAmount(i)) '.'];  % Set feedback text to losing message
    botTextColor = loseColors;
    end

end
%% Screen 3 - Animation loop

%     lotteryOutcome = 0.33;      %%!! this is the outcome of the lottery's probability roll, a number between 0 and 1
    time.start = GetSecs;
    angChoice=0;
    angNonChoice=0;
%  && angNonChoice < (4*360 + 360*lotteryOutcome(i,2))
while( (angChoice < (4*360 + 360*lotteryOutcome1shot(j,1))) || (angNonChoice < (4*360 + 360*lotteryOutcome1shot(j,2))) ) %% 4*360 means the arrow will spin 4 full rounds before stopping at the outcome
    if(angChoice < (4*360 + 360*lotteryOutcome1shot(j,1)))
        angChoice=angChoice+degPerFrame;
    end
    if(angNonChoice < (4*360 + 360*lotteryOutcome1shot(j,2)))
        angNonChoice=angNonChoice+degPerFrame;
    end
% Left wheel & arrow
    Screen('DrawTexture', window, wheelL, [0 0 550 550], locChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice, angChoice);
    DrawFormattedText(window, winL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount 
    DrawFormattedText(window, loseL, leftwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
% Right wheel & arrow    
    Screen('DrawTexture', window, wheelR, [0 0 550 550], locNonChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice, angNonChoice);
    DrawFormattedText(window, winR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    DrawFormattedText(window, loseR, rightwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
        Screen('FrameRect', window, chooseColors, rectPos, lineWeight); % Draw the choice rect to the screen
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
end

%% Screen 4 - Result

% Hold on last arrow position and give result text
    angLeftArrow=(4*360 + 360*lotteryOutcome1shot(j,1)); % final left arrow position
    angRightArrow=(4*360 + 360*lotteryOutcome1shot(j,2)); % final right arrow position
% Left wheel & arrow
    Screen('DrawTexture', window, wheelL, [0 0 550 550], locChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice, angLeftArrow);
    DrawFormattedText(window, winL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount 
    DrawFormattedText(window, loseL, leftwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
% Right wheel & arrow        
    Screen('DrawTexture', window, wheelR, [0 0 550 550], locNonChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice, angRightArrow);
    DrawFormattedText(window, winR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    DrawFormattedText(window, loseR, rightwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
        Screen('FrameRect', window, chooseColors, rectPos, lineWeight); % Draw the choice rect to the screen
        DrawFormattedText(window, botResultText, 'center', botTextYpos, botTextColor); % Result text
    Screen('Flip', window)

WaitSecs(5); 
%% Screen 5 - Emotional rating

currentRound = i;

[currRatingSelection, wof1shotRatingDuration] = likert_slider(window, windowRect);
 
wof1shotemotionalRating = currRatingSelection;

end
%% End-of-block calculations and create log file
for i=1:NUMROUNDS
        wof1shotChoiceDuration(i) = wofTrialEndTime(i)-wofTrialStartTime(i);
end

totalEarnings = sum(wof1shotEarnings);

% Write logfile
save([num2str(particNum) '-' DateTime '_2oneshot-subj'], 'regretTasktrialWheels1shotDataset', 'wof1shotChoice', 'wof1shotEarnings', 'wof1shotChoiceDuration', 'wof1shotemotionalRating', 'wof1shotRatingDuration');

    WaitSecs(2);

RestrictKeysForKbCheck([]); % re-recognize all key presses
    
% Clear the screen
% sca;