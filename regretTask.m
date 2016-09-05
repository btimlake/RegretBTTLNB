function [totalEarnings] = regretTask(particNum, DateTime, window, windowRect, enabledKeys)% Clear the workspace and the screen

enabledKeys;

% load('regretTasktrialWheels.mat')       % Load the preset wheel probabilites and values TABLE
load('regretTasktrialWheelsDataset.mat')       % Load the preset wheel probabilites and values DATASET
regretTasktrialWheels = regretTasktrialWheelsDataset; % Needed to equate variable to different filename
% DateTime=datestr(now,'ddmm-HHMM');      % Get date and time for log file


%% Here we call some default settings for setting up Psychtoolbox
% PsychDefaultSetup(2);
% 
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
% white = WhiteIndex(screenNumber);
% black = BlackIndex(screenNumber);
BG=[1 1 1]; % set background color of PNG imports
% NOTE that colors now have to be in the set [0,1], so to get values, just 
% divide old RGB amounts by 255
winColors = [.1333, .5451, .1333]; %ForestGreen
loseColors = [.8039, .2157, 0]; %OrangeRed3
% winColors = black; %black
% loseColors = black; %black
chooseColors = [1, .84, 0]; %Gold

% % Open an on screen window
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

% Set emotional rating line position
rateLineYpos = screenYpixels * 39/80; % Screen Y position of separator line
rateLineXposLeft = round(screenXpixels * 0.09 - screenXpixels * 2/56); % left position of text and separator line
rateLineXposRight = round(screenXpixels * 0.91 + screenXpixels * 2/56); % right endpoint of separator line

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
% topInstructText = ['Choose which wheel to play.']; % ENGLISH
topInstructText = 'Scegli quale ruota girare.'; % Italian

% Select specific text font, style and size:
fontSize = round(screenYpixels * 2/60);
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, [0, 0, 0]);
    
% Set some variables
NUMROUNDS = 3;
lotteryOutcome = 0 + (1-0).*rand(NUMROUNDS,2); % Creates array of random outcome probabilities for both wheels in each round
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

    keyName=''; % empty initial value
    instructions = 1;
    instFilename = ['instructions/WoF_instructions' num2str(instructions) '.png'];
    imdata=imread(instFilename);    
    tex=Screen('MakeTexture', window, imdata);
    Screen('DrawTexture', window, tex);
    Screen('Flip', window);
    
while ~strcmp(keyName,'space')
    
%     while ~strcmp(num2str(instructions), '5')
        
        [keyTime, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
        switch keyName
            case 'LeftArrow'
                instructions = instructions - 1;
                if instructions < 1
                    instructions = 1;
                end
            case 'RightArrow'
                instructions = instructions + 1;
                if instructions > 2
                    instructions = 2;
                end
        end
        % update selection to last button press
        
        instFilename = ['instructions/WoF_instructions' num2str(instructions) '.png'];
        imdata=imread(instFilename);
        
        tex=Screen('MakeTexture', window, imdata);
        
        % Draw texture image to backbuffer. It will be automatically
        % centered in the middle of the display if you don't specify a
        % different destination:
        Screen('DrawTexture', window, tex);
        
        Screen('Flip', window);
        
        
%     end
end


WaitSecs(.25);


%% Begin trial loop

for i=1:NUMROUNDS

%% Screen 1

keyName=[]; % empty initial value

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
winL = num2str(regretTasktrialWheels.wlv1(i), '%.2f');
loseL = num2str(regretTasktrialWheels.wlv2(i), '%.2f');
winR = num2str(regretTasktrialWheels.wrv1(i), '%.2f');
loseR = num2str(regretTasktrialWheels.wrv2(i), '%.2f');
% wheelL = ['texProb' num2str(regretTasktrialWheels.wlp1(i)*100)];
% wheelR = ['texProb' num2str(regretTasktrialWheels.wrp1(i)*100)];

wheelL = [];
wheelR = [];

probL = num2str(regretTasktrialWheels.wlp1(i));
probR = num2str(regretTasktrialWheels.wrp1(i));

switch probL
    case {'0.25'}
    wheelL=texProb25;
    case {'0.33'}
    wheelL=texProb33';
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
% wheelR = texProb66

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
% RestrictKeysForKbCheck([37,39,32]); % limit recognized presses to left and right arrows PC
[keyTime, keyCode]=KbWait([],2); % Wait for a key to be pushed and released
keyName=KbName(keyCode); % get the name of which key was pressed

    if strcmp(keyName,'LeftArrow') % If left arrow pressed, set the rectangle to the left side
        rectPos = leftRect;
        wofChoice(i,1) = 1;   % and note the choice for the log file
    elseif strcmp(keyName,'RightArrow')
        rectPos = rightRect;
        wofChoice(i,1) = 2;
    end
    
wofTrialEndTime(i) = GetSecs; % trial time end


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

% Set winning portions for each wheel type
arrowAngleL=360*lotteryOutcome(i,1); % reflects final position of arrow
arrowAngleR=360*lotteryOutcome(i,2);
% winResultText = ['You won ' num2str(winAmount(i)) '.'];
% lossResultText = ['You lost ' num2str(lossAmount(i)) '.'];
 
% Determine whether the selection resulted in win or loss
if wofChoice(i,1) == 1    % Participant chose wheel 1
    
    if arrowAngleL > 360*regretTasktrialWheels.wlp2(i);   % If endpoint of arrow is greater than loss zone, win
    winAmount(i) = regretTasktrialWheels.wlv1(i);
    wofEarnings(i,1) = winAmount(i);  % set earngings for log file
%     botResultText = ['You won ' num2str(winAmount(i)) '.'];  % Set feedback text to winning message ENGLISH
    botResultText = ['Hai vinto ' num2str(winAmount(i)) '.'];  % Set feedback text to winning message ITALIAN
    botTextColor = winColors;
    else   % If endpoint of arrow is less than loss zone, loss
    lossAmount(i) = regretTasktrialWheels.wlv2(i);
    wofEarnings(i,1) = lossAmount(i);  % set losses for log file
%     botResultText = ['You lost ' num2str(-lossAmount(i)) '.'];  % Set feedback text to losing message ENGLISH
    botResultText = ['Hai perso ' num2str(-lossAmount(i)) '.'];  % Set feedback text to losing message ITALIAN
    botTextColor = loseColors;
    end

elseif wofChoice(i,1) == 2    % Participant chose wheel 2
    
    if arrowAngleR > 360*regretTasktrialWheels.wrp2(i);   % If endpoint of arrow is greater than loss zone, win
    winAmount(i) = regretTasktrialWheels.wrv1(i);
    wofEarnings(i,1) = winAmount(i);  % set earngings for log file
%     botResultText = ['You won ' num2str(winAmount(i)) '.'];  % Set feedback text to winning message ENGLISH
    botResultText = ['Hai vinto ' num2str(winAmount(i)) '.'];  % Set feedback text to winning message ITALIAN
    botTextColor = winColors;
    else   % If endpoint of arrow is less than loss zone, loss
    lossAmount(i) = regretTasktrialWheels.wrv2(i);
    wofEarnings(i,1) = lossAmount(i);  % set losses for log file
%     botResultText = ['You lost ' num2str(-lossAmount(i)) '.'];  % Set feedback text to losing message ENGLISH
    botResultText = ['Hai perso ' num2str(-lossAmount(i)) '.'];  % Set feedback text to losing message ITALIAN
    botTextColor = loseColors;
    end

end
%% Screen 3 - Animation loop

%     lotteryOutcome = 0.33;      %%!! this is the outcome of the lottery's probability roll, a number between 0 and 1
    time.start = GetSecs;
    angChoice=0;
    angNonChoice=0;
%  && angNonChoice < (4*360 + 360*lotteryOutcome(i,2))
while( (angChoice < (4*360 + 360*lotteryOutcome(i,1))) || (angNonChoice < (4*360 + 360*lotteryOutcome(i,2))) ) %% 4*360 means the arrow will spin 4 full rounds before stopping at the outcome
    if(angChoice < (4*360 + 360*lotteryOutcome(i,1)))
        angChoice=angChoice+degPerFrame;
    end
    if(angNonChoice < (4*360 + 360*lotteryOutcome(i,2)))
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
    angLeftArrow=(4*360 + 360*lotteryOutcome(i,1)); % final left arrow position
    angRightArrow=(4*360 + 360*lotteryOutcome(i,2)); % final right arrow position
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

WaitSecs(2.5); 

%% Screen 5 - Emotional rating

currentRound = i;

[currRatingSelection(i), ratingDuration(i,1)] = likert_slider(window, windowRect, enabledKeys);
 
emotionalRating(i,1) = currRatingSelection(i);

end
%% End-of-block calculations and create log file
for i=1:NUMROUNDS
        wofChoiceDuration(i,1) = wofTrialEndTime(i)-wofTrialStartTime(i);
%         ratingDuration(i) = ratingEndTime(i)-ratingStartTime(i);
end

totalEarnings = sum(wofEarnings);

% wofTrialLength = wofTrialLength';

% Write logfile
save(['sub' num2str(particNum) '-' DateTime '_1wofPractice'], 'regretTasktrialWheelsDataset', 'wofChoice', 'lotteryOutcome', 'wofEarnings', 'wofChoiceDuration', 'emotionalRating', 'ratingDuration');

% RestrictKeysForKbCheck([]); % re-recognize all key presses

WaitSecs(2);
    
end