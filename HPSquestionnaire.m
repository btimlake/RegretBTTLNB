

function [hpsResponsesIdx, hpsResponses] = HPSquestionnaire(cfg, particNum, DateTime, window, windowRect)

addpath('questionnaires');

if ismac
    % Code to run on Mac plaform
    disp('Mac');
    disabledKeys=[];
    skipSyncTest=[];
    screenRes=[];
    enabledKeys = [44, 79, 80]; % limit recognized presses to space, left, right arrows MAC
    limitedKeys = [79, 80]; % limit recognized presses to left, right arrows PC
    load('hps_italian_TABLE.mat')       % Load HPS prompts and responses TABLE - Mac
    numChoice = height(HPSItalian);
    
elseif isunix
    % Code to run on Linux plaform
    disp('Unix');
elseif ispc
    % Code to run on Windows platform
    disp('PC');
    enabledKeys = [32,37,39]; % limit recognized presses to space, left, right arrows PC
    limitedKeys = [37,39]; % limit recognized presses to left, right arrows PC
    load('hps_italian_ARRAY.mat')       % Load HPS prompts and responses DATASET - PC Lab
    numChoice = length(HPSItalian);

else
    disp('Platform not supported')
end

RestrictKeysForKbCheck(enabledKeys);

%% Developing/debugging material
addpath('REGRET_task', 'patentTaskBTMP', 'ratingslider', 'instructions', 'games', 'games/stimoli');

PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = 1;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]); % for one screen setup
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); % for two-screen setup
[xCenter, yCenter] = RectCenter(windowRect);

particNum = '1212';
DateTime = '0101-1235';
% enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]);
% addpath('questionnaires');
% load('citpromptARRAY.mat')       % Load CIT prompts and responses DATASET - PC Lab
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

cfg.screenSize.x = screenXpixels;
cfg.screenSize.y = screenYpixels;
cfg.font = 'Courier New';
cfg.fontSize = round(screenYpixels * 2/40);
cfg.fontSizeSmall = round(screenYpixels * 2/100);
% Colors
cfg.textColor = [0, 0, 0]; % black
% cfg.bgColor = [255, 255, 255];
cfg.bgColor = [1 1 1]; % white
cfg.instColA = [0, 0.4078, 0.5451]; %DeepSkyBlue4
cfg.instColB = [0.8039, 0.5843, 0.0471]; %DarkGoldenRod3
cfg.p1Col = [0, 0, 0.8039]; %MediumBlue
cfg.p2Col = [0.4314, 0.4824, 0.5451]; % LightSteelBlue4
cfg.winCol = [.1333, .5451, .1333]; %ForestGreen
% Positions
cfg.screenCenter = [xCenter, yCenter]; % center coordinatesf
cfg.topTextYpos = screenYpixels * 2/40; % Screen Y positions of top/instruction text
cfg.uppTextYpos = screenYpixels * 6/40;
cfg.midTextYpos = screenYpixels * 20/40;
cfg.botTextYpos = screenYpixels * 35/40; % Screen Y positions of bottom/result text
cfg.waitTextYpos = screenYpixels * 38/40; % Y position of lowest "Please Wait" text
cfg.LeftTextXpos = screenXpixels*.035;

cfg.fontSizeSmall = round(cfg.fontSize/2);

Screen('TextFont', window, cfg.font);
Screen('TextSize', window, cfg.fontSize);
Screen('TextStyle', window);
Screen('TextColor', window, cfg.textColor);
%     Screen('Preference', 'TextAlphaBlending', 1);
% 	oldTextBackgroundColor=Screen('TextBackgroundColor', window, [255 255 255]);

% HPS
% SCREENS: 4
% QUESTIONS/SCREEN: 12
% CHOICES: 2
% PROMPTS: images
% RESPONSE: move rectangle, click 'space'
% output answers
% compare to answer file
% output assessment
% Do this just like the MPL, just over four or so pages

% screen 1: first instruction screen
% screen 2: real choices
% - change instructs to say using l/r arrows,
% - up/down arrows to change rows
% - space to confirm all choices
%  - change instructs to say choice becomes yellow
% screen 3: game gets played
% - random selection of game 1-10 (have it run through like in WoF?)
% - random choice 1-10 (0-first prob (70 = 1-7) gets top row prize. Second prob-1 (30 = 8-10) gets lower row prize)
%         - have it run through like WoF?
% - show  result

% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
% [xCenter, yCenter] = RectCenter(windowRect);

%% Variables

hpsResp = {'vero', 'falso'};
instructionText = 'Scegli e poi premi "spazio"';
hpsResponsesIdx = zeros(numChoice, 1);
numChoice = height(HPSItalian);

%% dummy drawing of all text elements to get surrounding rect sizes and lengths

% This does both rectangles individually
% for k = 1:length(hpsResp);
%     
%     [~, ~, rect]=DrawFormattedText(window, char(hpsResp(k)), 0, 0, cfg.bgColor);
%     spacer = (rect(4)-rect(2))/2; % sets the spacing for selection rectangles
%     respLength(k) = rect(3)-rect(1); % finds length of each response
%     storedRect(k,:) = rect;
%     rectHeight(k) = rect(4)-rect(2);
%     rectWidth(k) = rect(3)-rect(1);
%     
%     %         selRects(1:2,k) = rect(1:2)-spacer; % left and top sides of rect for answer (i, k)
%     %         selRects(3:4,k) = rect(3:4)+spacer; % right and bottom sides of rect for answer (i, k)
%     %         storedSizeRects(i,:,k) = [rect(1:2)-spacer/2 rect(3:4)+spacer/2]; % left and top, right and bottom sides of rect for answer (i, k)
%     if k == 1;
%         rectXCenter = cfg.screenCenter(1) - rectWidth(1);
%         xPos = rectXCenter - respLength(k)/2;
%     elseif k == 2;
%         rectXCenter = cfg.screenCenter(1) + rectWidth(1);
%         xPos = rectXCenter - respLength(k)/2;
%     else
%     end
%     storedXRectCenter(k)=rectXCenter;
%     storedXPos(k)=xPos;
%     storedSelRects(:,k) = [rectXCenter-rectWidth(k)/2-spacer cfg.screenCenter(2)-spacer rectXCenter+rectWidth(k)/2+spacer cfg.screenCenter(2)+rectHeight(k)+spacer];
% end

% This makes both rects the same size
    [~, ~, rect]=DrawFormattedText(window, char(hpsResp(2)), 0, 0, cfg.bgColor);
    spacer = (rect(4)-rect(2))/2; % sets the spacing for selection rectangles
    respLength = rect(3)-rect(1); % finds length of each response
    storedRect = rect;
    rectHeight = rect(4)-rect(2);
    rectWidth = rect(3)-rect(1);
    rectLineWeight = 4;
    
for k = 1:length(hpsResp);
        
    if k == 1;
        rectXCenter = cfg.screenCenter(1) - rectWidth;
    elseif k == 2;
        rectXCenter = cfg.screenCenter(1) + rectWidth;
    else
    end
    xPos = rectXCenter - respLength/2;
    storedXRectCenter(k)=rectXCenter;
    storedXPos(k)=xPos;
    storedSelRects(:,k) = [rectXCenter-rectWidth/2-spacer cfg.midTextYpos-spacer rectXCenter+rectWidth/2+spacer cfg.midTextYpos+rectHeight+spacer];
                            % [left, top, right, bottom]
end


% for k = 1:length(prompt);
%
%     [~, ~, rect]=DrawFormattedText(window, char(prompt(k)), 0, 0, cfg.bgColor);
%     promptLength(k) = rect(3)-rect(1); % finds length of each response
%     storedRect(k,:) = rect;
%     promptXPos = cfg.screenCenter(1) - promptLength(k)/2;
%     storedPromptXPos(k)=promptXPos;
%
% end
%% Show each prompt with true/false response buttons

for i = 1:numChoice
    
    % question number
    counter = ['Domanda ', num2str(i), '/48'];

    % question
    Screen('TextStyle', window,1); % bold question
    DrawFormattedText(window, char(HPSItalian.question(i)), 'center', cfg.uppTextYpos, cfg.textColor, 45)
    
    % responses
    for k = 1:length(hpsResp);
        Screen('TextStyle', window,0); %  plain text  resp onses
        DrawFormattedText(window, char(hpsResp(k)), storedXPos(k), cfg.midTextYpos, cfg.textColor);
        %         Screen('FrameRect', window, cfg.instColB, storedSelRects(:,currSelection)); % Draws a frame rectangle around current selection k
    end
    
    % counter & instructions
        Screen('TextSize', window, cfg.fontSizeSmall);
        DrawFormattedText(window, counter, 'center', cfg.topTextYpos) % question counter
        DrawFormattedText(window, instructionText, 'center', cfg.botTextYpos, cfg.textColor) % instructions
        Screen('TextSize', window, cfg.fontSize);

    Screen('Flip', window)
    
    currSelection = 1.5; % initial value - numbers reflect responses (since value 1 is associated with prompt)
    keyName='';
    
    while ~strcmp(keyName,'space')
        % while abs(char) ~= 10
        
        % Draw prompt and responses
        Screen('TextStyle', window,1); % bold question
        DrawFormattedText(window, char(HPSItalian.question(i)), 'center', cfg.uppTextYpos, cfg.textColor, 45)
        
        switch keyName
            case 'LeftArrow'
                currSelection = round(currSelection - .9);
                if currSelection < 1
                    currSelection = 2; % Loops around
                end
            case 'RightArrow'
                currSelection = round(currSelection + .9);
                if currSelection > 2
                    currSelection = 1; % Loops around
                end
        end
        %         update selection to last button press
        
        % responses
        for k = 1:length(hpsResp);
            Screen('TextStyle', window,0); %  plain text  resp onses
            DrawFormattedText(window, char(hpsResp(k)), storedXPos(k), cfg.midTextYpos, cfg.textColor);
            if currSelection == 1.5;
            	RestrictKeysForKbCheck(limitedKeys); % limit recognized presses to space, left, right arrows MAC
            else
                Screen('FrameRect', window, cfg.instColB, storedSelRects(:,currSelection), rectLineWeight); % Draws a frame rectangle around current selection k
                RestrictKeysForKbCheck(enabledKeys);    
            end
        end
        
    % counter & instructions
        Screen('TextSize', window, cfg.fontSizeSmall);
        DrawFormattedText(window, counter, 'center', cfg.topTextYpos) % question counter
        DrawFormattedText(window, instructionText, 'center', cfg.botTextYpos, cfg.textColor) % instructions
        Screen('TextSize', window, cfg.fontSize);

        Screen('Flip', window)
        
        [~, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
    end
    
    hpsResponsesIdx(i,:) = currSelection; % reflects numeric choice (1=true; 2=false)

    if currSelection == 1
        hpsResponses(i,:) = 't';
    elseif currSelection == 2
        hpsResponses(i,:) = 'f';
    else
        hpsResponses(i,:) = 'something went wrong';
    end
    
end

save(['sub' num2str(particNum) '-' num2str(DateTime) '_q6hps'], 'hpsResponsesIdx', 'hpsResponses');

end