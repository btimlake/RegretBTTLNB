function [sex, sexNum, age, eduLevel, field] = agesex(cfg, particNum, DateTime, window) 



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
% enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81, 82]);
% 
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
% cfg.screenSize.x = screenXpixels;
% cfg.screenSize.y = screenYpixels;
% cfg.font = 'Courier New';
% cfg.fontSize = round(cfg.screenSize.y * 2/40);
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
% cfg.topTextYpos = cfg.screenSize.y * 2/40; % Screen Y positions of top/instruction text
% cfg.uppTextYpos = cfg.screenSize.y * 6/40;
% cfg.botTextYpos = cfg.screenSize.y * 35/40; % Screen Y positions of bottom/result text
% cfg.waitTextYpos = cfg.screenSize.y * 38/40; % Y position of lowest "Please Wait" text

%% Variables
sexReq = 'Di che sesso sei? \n(Scegli e poi premi "spazio")';
% dobReq = 'Inserisci la data della tua nascit? (ddmmyyyy): ';
prompt = {'Inserisci la tua eta'' oggi e premi "invio": ', 'Quale l''anno di studio corrente?', 'Cosa studi?', 'Sei daltonico/a? (si'' o no)'};
sexResp = {'maschio', 'femmina'};

% Font
Screen('TextFont', window, cfg.font);
Screen('TextSize', window, cfg.fontSize);
Screen('TextColor', window, cfg.textColor);


%% dummy drawing of all text elements to get surrounding rect sizes and lengths
 
for k = 1:length(sexResp);
    
    [~, ~, rect]=DrawFormattedText(window, char(sexResp(k)), 0, 0, cfg.bgColor);
    spacer = (rect(4)-rect(2))/2; % sets the spacing for selection rectangles
    respLength(k) = rect(3)-rect(1); % finds length of each response
    storedRect(k,:) = rect;
    rectHeight(k) = rect(4)-rect(2);
    rectWidth(k) = rect(3)-rect(1);
    
    %         selRects(1:2,k) = rect(1:2)-spacer; % left and top sides of rect for answer (i, k)
    %         selRects(3:4,k) = rect(3:4)+spacer; % right and bottom sides of rect for answer (i, k)
    %         storedSizeRects(i,:,k) = [rect(1:2)-spacer/2 rect(3:4)+spacer/2]; % left and top, right and bottom sides of rect for answer (i, k)
    if k == 1;
        rectXCenter = cfg.screenCenter(1) - cfg.screenSize.x/4;
        xPos = rectXCenter - respLength(k)/2;
    elseif k == 2;
        rectXCenter = cfg.screenCenter(1) + cfg.screenSize.x/4;
        xPos = rectXCenter - respLength(k)/2;
    else
    end
    storedXRectCenter(k)=rectXCenter;
    storedXPos(k)=xPos;
    storedSelRects(:,k) = [rectXCenter-rectWidth(k)/2-spacer cfg.screenCenter(2)-spacer rectXCenter+rectWidth(k)/2+spacer cfg.screenCenter(2)+rectHeight(k)+spacer];
end

for k = 1:length(prompt);
    
    [~, ~, rect]=DrawFormattedText(window, char(prompt(k)), 0, 0, cfg.bgColor);
    promptLength(k) = rect(3)-rect(1); % finds length of each response
    storedRect(k,:) = rect;
    promptXPos = cfg.screenCenter(1) - promptLength(k)/2;
    storedPromptXPos(k)=promptXPos;

end


%% Intro screen
 
keyName = '';
while(~strcmp(keyName,'space')) % leaves questionnaire explanation up until 'space' is hit
    
    Screen('TextStyle', window, 1); % bold
    DrawFormattedText(window,'Questionario 6/6: demografia', 'center', cfg.topTextYpos, [255 0 0]);
    Screen('TextStyle', window,0); % back to plain
    DrawFormattedText(window,'Dopo ogni risposta, premi "invio".', 'center', cfg.uppTextYpos, 0, 50);
    DrawFormattedText(window, 'Premi "spazio" per continuare.', 'center', cfg.botTextYpos, cfg.p1Col, 70);
    Screen('Flip', window);
    
    [~, keyCode]=KbWait([],2);
    keyName=KbName(keyCode);
    
    
end

%% Choose sex response

currSelection = 1; % initial value - numbers reflect responses (since value 1 is associated with prompt)
keyName='';

Screen('TextStyle', window,1); % bold question
DrawFormattedText(window, sexReq, 'center', cfg.uppTextYpos, cfg.textColor); % Sex prompt

for i = 1:length(sexResp);
    Screen('TextStyle', window,0); %  plain text  resp onses
    DrawFormattedText(window, char(sexResp(i)), storedXPos(i), cfg.screenCenter(2), cfg.textColor);
    Screen('FrameRect', window, cfg.instColB, storedSelRects(:,currSelection)); % Draws a frame rectangle around current selection k
end

Screen('Flip', window)
    

while ~strcmp(keyName,'space')
% while abs(char) ~= 10

    % Draw prompt and responses
    Screen('TextStyle', window,1); % bold question
    DrawFormattedText(window, sexReq, 'center', cfg.uppTextYpos, cfg.textColor); % Sex prompt
    
    switch keyName
        case 'LeftArrow'
            currSelection = currSelection - 1;
            if currSelection < 1
                currSelection = 2; % Loops around
            end
        case 'RightArrow'
            currSelection = currSelection + 1;
            if currSelection > 2
                currSelection = 1; % Loops around
            end
    end
    %         update selection to last button press
    
    for i = 1:length(sexResp);
        Screen('TextStyle', window,0); %  plain text  resp onses
        DrawFormattedText(window, char(sexResp(i)), storedXPos(i), cfg.screenCenter(2), cfg.textColor);
        Screen('FrameRect', window, cfg.instColB, storedSelRects(:,currSelection)); % Draws a frame rectangle around current selection k
    end
        
    Screen('Flip', window)
    
    [~, keyCode]=KbWait([],2);
    keyName=KbName(keyCode);
    
end 
       
sexNum = currSelection; % reflects numeric choice (1=male; 2=female)

if currSelection == 1
    sex = 'm'; 
elseif currSelection == 2
    sex = 'f'; 
else
    sex = 'something went wrong';
end


%% Typed response prompts

% Age prompt
aOK=0; % initial value for aOK

while aOK ~= 1

    age = str2num(GetEchoStringForm(window, char(prompt(1)), storedPromptXPos(1), cfg.uppTextYpos, cfg.textColor)); % displays string in PTB; allows backspace

    switch isempty(age)
        case 1 %deals with both cancel and X presses
            Screen('Flip', window)
            continue            
        case 0
            if length(num2str(age)) ~= 2 
                Screen('Flip', window)
                continue                                
            elseif age < 18 % ensures they are older than 18, less than 100
                Screen('Flip', window)
                continue                
            else
                aOK = 1;
                Screen('Flip', window)               
            end
    end    
end

% Field and level prompts
aOK=0; % initial value for aOK

for i = 2:length(prompt);
    
    while aOK ~= 1
        
        response = GetEchoStringForm(window, char(prompt(i)), storedPromptXPos(i), cfg.uppTextYpos, cfg.textColor); % displays string in PTB; allows backspace
        
        switch isempty(response)
            case 1 %deals with both cancel and X presses
                Screen('Flip', window)
                continue
            case 0
                aOK = 1;
                Screen('Flip', window)
                if i == 2;
                    eduLevel = response;
                elseif i == 3;
                    field = response; 
                end
        end
    end    
    aOK=0; % reset aOK

end

save(['sub' num2str(particNum) '-' num2str(DateTime) '_q6demographics'], 'sex', 'sexNum', 'age', 'eduLevel', 'field');

end
