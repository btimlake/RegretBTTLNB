function [cit] = CITquestionnaire(cfg, particNum, DateTime, window, windowRect, enabledKeys)
% CIT - done
% SCREENS: 4
% QUESTIONS/SCREEN: 1
% CHOICES: 3/screen
% PROMPTS: text
% RESPONSE: move rectangle, click 'space'
% output answers
% compare to answer file
% output correct & score

addpath('questionnaires');
load('citpromptARRAY.mat')       % Load CIT prompts and responses DATASET - PC Lab
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);

%% Developing/debugging material
% PsychDefaultSetup(2);
% screens = Screen('Screens');
% screenNumber = 0;
% white = WhiteIndex(screenNumber);
% black = BlackIndex(screenNumber);
% % [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]); % for one screen setup 
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); % for two-screen setup
% [xCenter, yCenter] = RectCenter(windowRect);
%  
% particNum = '1212'; 
% DateTime = '0101-1234'; 
% enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]);
% 
% cfg.screenSize.x = screenXpixels; 
% cfg.screenSize.y = screenYpixels;
% cfg.font = 'Courier New';
% cfg.fontSize = round(screenYpixels * 2/40);
% % Colors
% cfg.textColor = [0, 0, 0]; % black
% % cfg.bgColor = [255, 255, 255];
% cfg.bgColor = [1, 1, 1]; % white
% cfg.instColA = [0, 0.4078, 0.5451]; %DeepSkyBlue4
% cfg.instColB = [0.8039, 0.5843, 0.0471]; %DarkGoldenRod3
% cfg.p1Col = [0, 0, 0.8039]; %MediumBlue
% cfg.p2Col = [0.4314, 0.4824, 0.5451]; % LightSteelBlue4
% cfg.winCol = [.1333, .5451, .1333]; %ForestGreen
% % Positions
% cfg.screenCenter = [xCenter, yCenter]; % center coordinatesf
% cfg.topTextYpos = screenYpixels * 2/40; % Screen Y positions of top/instruction text
% cfg.botTextYpos = screenYpixels * 35/40; % Screen Y positions of bottom/result text
% cfg.waitTextYpos = screenYpixels * 38/40; % Y position of lowest "Please Wait" text

% Font
Screen('TextFont', window, cfg.font);
Screen('TextSize', window, cfg.fontSize);
Screen('TextColor', window, cfg.textColor);

%% EXPLANATION SCREEN

Screen('TextStyle', window,1); % bold

DrawFormattedText(window,'QUESTIONARIO', 'center', screenYpixels * 0.25, [255 0 0]);

DrawFormattedText(window,'\n\nLeggete i seguenti scenari e indicate la vostra risposta selezionando il riquadro corrispondente coi tasti freccia.\n\nNon ci sono risposte giuste o sbagliate:\n\nprovate a riportare la vostra prima impressione.',...
    'center', 'center', 0, 50);

Screen('Flip', window);
WaitSecs(4) 
Screen('TextStyle', window,0); % back to plain

%% Positioning and rectangles loops

% Empty arrays to save time
numIteration = length(citprompt(:,1));
numPrompts = length(citprompt(1,:));
% response = repmat({''},numIteration, numPrompts);
selRects = NaN(numIteration, numPrompts);
respLength = NaN(numIteration, numPrompts);
storedXPos = NaN(numIteration, numPrompts);
% storedXPos(2:end ,3) = cfg.screenCenter(1)/2; % should fill in all second options at center, but if loop keeps overwriting
storedRect = NaN(numIteration, numPrompts, 4);
% storedSizeRects = NaN(numIteration, numPrompts, 4);
storedXRectCenter = NaN(numIteration, numPrompts);
rectHeight = NaN(numIteration, numPrompts);
rectWidth = NaN(numIteration, numPrompts);
storedSelRects = NaN(numIteration, 4, numPrompts);

% dummy drawing of all text elements to get surrounding rect sizes and
% lengths
for i = 1:1:numIteration
    
    for k = 2:numPrompts
        
%         response(i,k) = char(citprompt(i,k))
%         response(i,k) = citprompt(i,k)
        %     length(response(i,k))
        
%         [xPos(i,k), yPos(i,k), rect(i,k)]=DrawFormattedText(window, 'Sara', 0, 0, cfg.bgColor);
        [~, ~, rect]=DrawFormattedText(window, char(citprompt(i,k)), 0, 0, cfg.bgColor);
        if i == 1 && k == 2 % does spacer calculation just once
            spacer = rect(4)-rect(2); % sets the spacing for all selection rectangles; don't have to repeat this for each question
                % Get y positions here because need spacer calculation
            yPos(2:3) = yCenter; % set yPos of answers 1 and 2
            yPos(4) = yCenter-spacer/2; % set yPos of answer 3 because it is 2 lines
        else
        end
        respLength(i,k) = rect(3)-rect(1); % finds length of each response
        storedRect(i,:,k) = rect;
        rectHeight(i,k) = rect(4)-rect(2); % different from spacer because k==4 is taller
        rectWidth(i,k) = rect(3)-rect(1);

%         selRects(1:2,k) = rect(1:2)-spacer; % left and top sides of rect for answer (i, k)
%         selRects(3:4,k) = rect(3:4)+spacer; % right and bottom sides of rect for answer (i, k)
%         storedSizeRects(i,:,k) = [rect(1:2)-spacer/2 rect(3:4)+spacer/2]; % left and top, right and bottom sides of rect for answer (i, k)
        if k == 2;
            rectXCenter = cfg.screenCenter(1) - screenXpixels/3;
            xPos = rectXCenter - respLength(i,k)/2;
        elseif k == 3;
            rectXCenter = cfg.screenCenter(1);
            xPos = cfg.screenCenter(1)-(respLength(i,k)/2);
        elseif k == 4;
            rectXCenter = cfg.screenCenter(1) + screenXpixels/3;
            xPos = rectXCenter - respLength(i,k)/2;
        else
        end
         storedXRectCenter(i,k)=rectXCenter;
         storedXPos(i,k)=xPos;
        storedSelRects(i,:,k) = [rectXCenter-rectWidth(i,k)/2-spacer yPos(k)-spacer rectXCenter+rectWidth(i,k)/2+spacer yPos(k)+rectHeight(i,k)+spacer];
    end
end



Screen('Flip', window)
%% Question loop
  
for i = 1:length(citprompt(:,1))
    
    currSelection = 2; % initial value - numbers reflect responses (since value 1 is associated with prompt)
    keyName='';
    %     instructions = 1;
    %     instFilename = ['instructions/games2x2_instructions' num2str(instructions) '.png'];
    %     imdata=imread(instFilename);
    %     tex=Screen('MakeTexture', w, imdata);
    %     Screen('DrawTexture', w, tex);
    %     Screen('Flip', w);
    for k = 1:numPrompts
        if k == 1 % different for prompt
            Screen('TextStyle', window,1); % bold question
            DrawFormattedText(window, char(citprompt(i,k)), 'center', cfg.topTextYpos, cfg.textColor, 50); % wrap at 50 characters
        else
            Screen('TextStyle', window,0); %  plain text  resp onses
            DrawFormattedText(window, char(citprompt(i,k)), storedXPos(i,k), yPos(k), cfg.textColor);
        end
    end
    Screen('FrameRect', window, cfg.instColB, storedSelRects(i,:,currSelection)); % Draws a frame rectangle around current selection k
    Screen('Flip', window)
    
    while ~strcmp(keyName,'space')
        
        [~, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
        % Draw prompt and responses
        
        switch keyName
            case 'LeftArrow'
                currSelection = currSelection - 1;
                if currSelection < 2
                    currSelection = 4; % Loops around
                end
            case 'RightArrow'
                currSelection = currSelection + 1;
                if currSelection > 4
                    currSelection = 2; % Loops around
                end
        end
        %         update selection to last button press
        
        Screen('FrameRect', window, cfg.instColB, storedSelRects(i,:,currSelection)); % Draws a frame rectangle around current selection k
        
        for k = 1:numPrompts
            if k == 1 % different for prompt
                Screen('TextStyle', window,1); % bold question
                DrawFormattedText(window, char(citprompt(i,k)), 'center', cfg.topTextYpos, cfg.textColor, 50); % wrap at 50 characters
            else
                Screen('TextStyle', window,0); % plaintext responses
                DrawFormattedText(window, char(citprompt(i,k)), storedXPos(i,k), yPos(k), cfg.textColor);
            end
        end
        

        Screen('Flip', window)
        
    end
        cit.resp(i) = currSelection-1; % reflects response 1, 2, or 3
        cit.respInd(i) = currSelection; % reflects position of response: 2, 3, 4

end

end
