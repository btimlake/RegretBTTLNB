function [crtResponse, crtPrevious] = CRTquestionnaire(cfg, particNum, DateTime, window, windowRect)

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
enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]);
addpath('questionnaires');
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

cfg.enabledSelectKeys = [44, 79, 80]; % limit recognized presses to space, left, right arrows MAC
cfg.enabledChoiceKeys = [44, 81, 82]; % space, up, down arrows MAC
cfg.limitedChoiceKeys = [81, 82]; % up, down arrows MAC
cfg.enabledExpandedKeys = [30, 34, 44, 79:82, 89, 93]; % limit recognized presses to 1!, 5%, space, left, right, up, down arrows, keypad1, keypad5 MAC
cfg.limitedKeys = [79, 80]; % limit recognized presses to left, right arrows MAC
cfg.enabledNumberKeys = [30:40, 55, 89:99,]; % limit recognized presses to 1-10, return, decimal, keypad 1-10 & decimal MAC

cfg.screenSize.x = screenXpixels;
cfg.screenSize.y = screenYpixels;
cfg.font = 'Courier New';
cfg.fontSize = round(screenYpixels * 2/80);
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
% Screen('TextSize', window, cfg.fontSize);
Screen('TextStyle', window, 0); % start out plaintext
Screen('TextColor', window, cfg.textColor);
%     Screen('Preference', 'TextAlphaBlending', 1);
oldTextBackgroundColor=Screen('TextBackgroundColor', window, [255 255 255]);
load('crtpromptsARRAY.mat')       % Load CRT prompts and responses DATASET - PC Lab
numChoice = length(crtprompts);


% CRT
% SCREENS: 4
% QUESTIONS/SCREEN: 1
% CHOICES: Typed response
% PROMPTS: GetEchoNumForm, GetEchoStringForm
% RESPONSE: GetEchoNumForm, GetEchoStringForm
% output answers
% compare to answer file
% output correct, score/winnings, free response

%% load data
addpath('questionnaires');

if ismac
    % Code to run on Mac plaform
    disp('Mac');
    disabledKeys=[];
    skipSyncTest=[];
    screenRes=[];
    %     load('crtpromptsTABLE.mat')       % Load CRT prompts and responses TABLE - when available - Mac
    %     numChoice = height(crtprompts);
    
elseif isunix
    % Code to run on Linux plaform
    disp('Unix');
elseif ispc
    % Code to run on Windows platform
    disp('PC');
    load('crtpromptsARRAY.mat')       % Load CRT prompts and responses DATASET - PC Lab
    numChoice = length(crtprompts);
    
else
    disp('Platform not supported')
end

RestrictKeysForKbCheck(cfg.enabledNumberKeys);
% ListenChar(2); %disable transmission of keypresses to Matlab command window; press CTRL+C to reenable


%% CONSTANTS

% Font
Screen('TextFont', window, cfg.font);
Screen('TextSize', window, cfg.fontSize);
Screen('TextColor', window, cfg.textColor);


%% BEGIN CRT

% Empty arrays to save time
% numIteration = height(crtprompts(:,1))-1;
% numPrompts = width(crtprompts(1,:));
[numIteration, numPrompts] = size(crtprompts);
crtResponse = nan(numIteration, 1);
numCrtPrevious = numIteration + 1;

% selRects = NaN(numIteration, numPrompts);
% respLength = NaN(numIteration, numPrompts);
% storedXPos = NaN(numIteration, numPrompts);
% % storedXPos(2:end ,3) = cfg.screenCenter(1)/2; % should fill in all second options at center, but if loop keeps overwriting
% storedRect = NaN(numIteration, numPrompts, 4);
% % storedSizeRects = NaN(numIteration, numPrompts, 4);
% storedXRectCenter = NaN(numIteration, numPrompts);
% rectHeight = NaN(numIteration, numPrompts);
% rectWidth = NaN(numIteration, numPrompts);
% storedSelRects = NaN(numIteration, numPrompts, 4);

crtRespChoice = {'SI', 'NO'};
% crtYesChoice = {'Si', 'No'};
instructionText = 'Inserisci la tua risposta e premi "invio".';
instructionTextChoice = 'Scegli usando i tasti freccia e poi premi "spazio"';


%% dummy drawing of yes/no to get surrounding rect sizes and lengths

% This makes both rects the same size
[~, ~, rect]=DrawFormattedText(window, char(crtRespChoice(2)), 0, 0, cfg.bgColor);
spacer = (rect(4)-rect(2))/2; % sets the spacing for selection rectangles
respLength = rect(3)-rect(1); % finds length of each response
storedRect = rect;
rectHeight = rect(4)-rect(2);
rectWidth = rect(3)-rect(1);
rectLineWeight = 4;

for k = 1:length(crtRespChoice);
    
    if k == 1;
        rectXCenter = cfg.screenCenter(1) - rectWidth;
    elseif k == 2;
        rectXCenter = cfg.screenCenter(1) + rectWidth;
    else
    end
    xPos = rectXCenter - respLength/2;
    storedXRectCenter(k)=rectXCenter;
    storedXPos(k)=xPos;
    storedSelRects(k,:) = [rectXCenter-rectWidth/2-spacer cfg.midTextYpos-spacer rectXCenter+rectWidth/2+spacer cfg.midTextYpos+rectHeight+spacer];
    % [left, top, right, bottom]
end

%% dummy drawing of yes explanations to get positions
storedYesRects = NaN(7, 4);
yPos = NaN(7,1);

for k = 2:8
    %     thisprompt = char(crtprompts(5,k));
    Screen('Flip', window)
    [~, ~, rect]=DrawFormattedText(window, char(crtprompts(5,k)), 0, 0, cfg.bgColor);
    
    rectWidth = rect(3)-rect(1);
    rectHeight = rect(4)-rect(2);
    spacer = (rect(4)-rect(2))/2; % sets the spacing for selection rectangles
    if k ==2
        yPos(k) = cfg.uppTextYpos + k*(rectHeight + spacer); % set y position for each row
    else
        yPos(k) = yPos(k-1) + (rectHeight + spacer); % set y position for each row
    end
    storedYesRects(k,:) = [(cfg.screenCenter(1)-(rectWidth/2)-spacer) (yPos(k)-spacer) (cfg.screenCenter(1)+(rectWidth/2)+spacer) (yPos(k)+rectHeight+spacer)];
    
end
%% dummy drawing of prompts to get positions
textXPos = NaN(3, 1);

for k = 1:3
    %     thisprompt = char(crtprompts(5,k));
    [~, ~, rect]=DrawFormattedText(window, char(crtprompts(k,2)), 0, 0, cfg.bgColor);
    
    Screen('Flip', window)
    textWidth = rect(3)-rect(1);
    textXPos(k) = cfg.screenCenter(1) - textWidth/2;

end
%% Number Qs
for i = 1:3;
    
    counter = ['Domanda ', num2str(i), '/4'];
    
    aOK=0; % initial value for aOK
    
    while aOK ~= 1
        
        Screen('TextSize', window, cfg.fontSizeSmall);
        DrawFormattedText(window, counter, 'center', cfg.topTextYpos, cfg.textColor) % question counter
        DrawFormattedText(window, instructionText, 'center', cfg.botTextYpos, cfg.textColor) % instructions
        Screen('TextSize', window, cfg.fontSize);
        %         DrawFormattedText(window, char(crtprompts.question(i)), 'center', cfg.topTextYpos, cfg.textColor) % displays question
        DrawFormattedText(window, char(crtprompts(i,1)), 'center', cfg.uppTextYpos, cfg.textColor) % displays question

%         Screen('TextSize', window, cfg.fontSizeSmall);
%         Screen('TextSize', window, cfg.fontSize);
        Screen('TextStyle', window,1); % bold question
        
        %         DrawFormattedText(window, crtInputHelp, 'center', cfg.waitTextYpos, cfg.p1Col);
        trialStartTime(i) = GetSecs;
        %         thisChoice = str2num(GetEchoString(window, char(crtprompts.Var2(i)), 10, cfg.midTextYpos, cfg.textColor)); % displays prompt string in PTB; allows backspace
        thisChoice = str2num(GetEchoStringForm(window, char(crtprompts(i,2)), textXPos(i), cfg.midTextYpos, cfg.textColor)); % displays prompt string in PTB; allows backspace ARRAY
        Screen('TextStyle', window,0); % bold question
        Screen('TextSize', window, cfg.fontSize);
        
        switch isempty(thisChoice)
            case 1 %deals with both cancel and X presses
%                 Screen('TextSize', window, cfg.fontSizeSmall);
%                 DrawFormattedText(window, counter, 'center', cfg.topTextYpos) % question counter
%                 DrawFormattedText(window, instructionText, 'center', cfg.botTextYpos, cfg.textColor) % instructions
%                 Screen('TextSize', window, cfg.fontSize);
                Screen('Flip', window)
                continue
            case 0
                if isnan(thisChoice)
%                     Screen('TextSize', window, cfg.fontSizeSmall);
%                     DrawFormattedText(window, counter, 'center', cfg.topTextYpos) % question counter
%                     DrawFormattedText(window, instructionText, 'center', cfg.botTextYpos, cfg.textColor) % instructions
%                     Screen('TextSize', window, cfg.fontSize);
                    Screen('Flip', window)
                    continue
                else
%                     Screen('TextSize', window, cfg.fontSizeSmall);
%                     DrawFormattedText(window, counter, 'center', cfg.topTextYpos) % question counter
%                     DrawFormattedText(window, instructionText, 'center', cfg.botTextYpos, cfg.textColor) % instructions
%                     Screen('TextSize', window, cfg.fontSize);
                    
                    crtResponse(i) = thisChoice;
                    trialEndTime(i) = GetSecs; % after choice
                    aOK = 1;
                end
        end
        %         respLog(i) = response
    end
    Screen('TextSize', window, cfg.fontSizeSmall);
    DrawFormattedText(window, counter, 'center', cfg.topTextYpos) % question counter
    DrawFormattedText(window, instructionText, 'center', cfg.botTextYpos, cfg.textColor) % instructions
    Screen('TextSize', window, cfg.fontSize);
    
%     Screen('Flip', window)
end

%% Question 4: two choices

RestrictKeysForKbCheck(cfg.enabledSelectKeys)

% counter & instructions
counter = ['Domanda 4/4'];
currSelection = 1.5; % initial value - numbers reflect responses (since value 1 is associated with prompt)
keyName='';

while ~strcmp(keyName,'space')
    % while abs(char) ~= 10
    Screen('TextSize', window, cfg.fontSizeSmall);
    DrawFormattedText(window, counter, 'center', cfg.topTextYpos) % question counter
    DrawFormattedText(window, instructionTextChoice, 'center', cfg.botTextYpos, cfg.textColor) % instructions
    Screen('TextSize', window, cfg.fontSize);
    
    % Draw prompt and responses
    Screen('TextStyle', window,1); % bold question
    %         thisChoice = str2num(GetEchoString(window, char(crtprompts.question(4)), 10, cfg.topTextYpos, cfg.textColor)); % displays string in PTB; allows backspace
    %         DrawFormattedText(window, char(crtprompts.question(4)), 'center', cfg.midTextYpos, cfg.textColor) % displays question
    DrawFormattedText(window, char(crtprompts(4,1)), 'center', cfg.uppTextYpos, cfg.textColor) % displays question
    Screen('TextStyle', window,0); % back to plain
    
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
    for k = 1:length(crtRespChoice);
        %         DrawFormattedText(window, char(crtRespChoice(k)), storedXPos(k), cfg.midTextYpos, cfg.textColor, ~, ~, ~, ~, ~, storedSelRects(k,:));
%         DrawFormattedText(window, char(crtRespChoice(k)), storedXPos(k), cfg.midTextYpos, cfg.textColor, [], [], [], [], [], storedSelRects(k,:));
        DrawFormattedText(window, char(crtRespChoice(k)), storedXPos(k), cfg.midTextYpos, cfg.textColor);
        if currSelection == 1.5;
            RestrictKeysForKbCheck(cfg.limitedKeys); % limit recognized presses to space, left, right arrows MAC
        else
            Screen('FrameRect', window, cfg.instColB, storedSelRects(currSelection, :), rectLineWeight); % Draws a frame rectangle around current selection k
            RestrictKeysForKbCheck(cfg.enabledSelectKeys);
        end
    end
    
    trialStartTime(4) = GetSecs;
    Screen('Flip', window)
    
    [~, keyCode]=KbWait([],2);
    keyName=KbName(keyCode);
    
end
trialEndTime(4) = GetSecs; % after choice
crtResponse(4) = currSelection; % 1=yes; 2=no


Screen('Flip', window)

if crtResponse(4) == 1;
    %% Question 4a: 7 choices
    counter = ['Domanda 4a/4'];
    RestrictKeysForKbCheck(cfg.enabledChoiceKeys)
    currSelection = 1.9;
    keyName = '';
    
    while ~strcmp(keyName,'space')
        % while abs(char) ~= 10
    Screen('TextSize', window, cfg.fontSizeSmall);
    DrawFormattedText(window, counter, 'center', cfg.topTextYpos) % question counter
    DrawFormattedText(window, instructionTextChoice, 'center', cfg.botTextYpos, cfg.textColor) % instructions
    Screen('TextSize', window, cfg.fontSize);
        
        % Draw prompt and responses
        Screen('TextStyle', window,1); % bold question
        %         thisChoice = str2num(GetEchoString(window, char(crtprompts.question(4)), 10, cfg.topTextYpos, cfg.textColor)); % displays string in PTB; allows backspace
        %         DrawFormattedText(window, char(crtprompts.question(4)), 'center', cfg.midTextYpos, cfg.textColor) % displays question
        DrawFormattedText(window, char(crtprompts(5,1)), 'center', cfg.uppTextYpos, cfg.textColor) % displays question
        Screen('TextStyle', window,0); % back to plain
        
        switch keyName
            case 'UpArrow'
                currSelection = round(currSelection - .9);
                if currSelection < 1.5
                    currSelection = 8; % Loops around
                end
            case 'DownArrow'
                currSelection = round(currSelection + .9);
                if currSelection > 8
                    currSelection = 2; % Loops around
                end
        end
        %         update selection to last button press
        
        % responses
        for k = 2:8;
            %         DrawFormattedText(window, char(crtRespChoice(k)), storedXPos(k), cfg.midTextYpos, cfg.textColor, ~, ~, ~, ~, ~, storedSelRects(k,:));
%             DrawFormattedText(window, char(crtprompts(5,k)), 'center', yPos(k), cfg.textColor, [], [], [], [], [], storedYesRects(k,:));
            DrawFormattedText(window, char(crtprompts(5,k)), 'center', yPos(k), cfg.textColor);
            if currSelection == 1.9;
                RestrictKeysForKbCheck(cfg.limitedChoiceKeys); % limit recognized presses to space, left, right arrows MAC
            else
                Screen('FrameRect', window, cfg.instColB, storedYesRects(currSelection, :), rectLineWeight); % Draws a frame rectangle around current selection k
                RestrictKeysForKbCheck(cfg.enabledChoiceKeys);
            end
        end
        
        
        trialStartTime(5) = GetSecs;
        Screen('Flip', window)
        
        [~, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
    end
    trialEndTime(5) = GetSecs; % after choice
    crtResponse(5) = currSelection; % 2=Q1,3=Q2,4=Q3,5=Q1&2,6=Q1&3,7=Q2&3,8=Q1&2&3
    
    Screen('Flip', window)
    
else
    crtResponse(5) = [];
end

for i=1:numIteration
    trialLength(i) = trialEndTime(i)-trialStartTime(i);
end

save(['sub' num2str(particNum) '-' num2str(DateTime) '_q4CRT'], 'crtResponse', 'trialStartTime', 'trialEndTime', 'trialLength');

% Block this after debugging
% ListenChar(0); %re-enable transmission of keypresses to Matlab command window; press CTRL+C to reenable

end





