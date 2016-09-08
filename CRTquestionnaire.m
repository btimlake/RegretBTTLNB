function [crt] = CRTquestionnaire(cfg, particNum, DateTime, window, windowRect, enabledKeys)

addpath('questionnaires');
load('crtpromptARRAY.mat')       % Load CRT prompts and responses DATASET - PC Lab
% load('crtpromptTABLE.mat')       % Load CRT prompts and responses TABLE - when available

% TURN THESE INTO STRINGS

% (row, col) row represents question; columns are 1=q, 2=a1, 3=a2, 4=a3

%% Developing/debugging material
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = 0;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]); % for one screen setup 
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); % for two-screen setup
[xCenter, yCenter] = RectCenter(windowRect);
 
particNum = '1212'; 
DateTime = '0101-1234'; 
enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]);

[screenXpixels, screenYpixels] = Screen('WindowSize', window);
cfg.screenSize.x = screenXpixels; 
cfg.screenSize.y = screenYpixels;
cfg.font = 'Courier New';
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


%% Overview

% CIT - done

% MPL
% SCREENS: 1
% QUESTIONS/SCREEN: 10
% CHOICES: 2
% PROMPTS: image
% RESPONSE: move rectangles, click 'space'
% Randomly select line
% Randomly select side
% output all selections, random selections, winnigs

% RAVEN
% SCREENS: 30
% QUESTIONS/SCREEN: 1
% CHOICES: 8/screen
% PROMPTS: images
% RESPONSE: move rectangle, click 'space'
% Make responses a separate image
%     - make consistent size; measure each as a proportion of size
%     - calculate rects and positions based on that proportion
% output answers
% compare to answer file
% output correct & score/winnings

% CRT
% SCREENS: 4
% QUESTIONS/SCREEN: 1
% CHOICES: Typed response
% PROMPTS: GetEchoNumForm, GetEchoStringForm
% RESPONSE: GetEchoNumForm, GetEchoStringForm
% output answers
% compare to answer file
% output correct, score/winnings, free response

% HPS
% SCREENS: 4
% QUESTIONS/SCREEN: 12
% CHOICES: 2
% PROMPTS: images
% RESPONSE: move rectangle, click 'space'
% output answers
% compare to answer file
% output assessment

%% CONSTANTS

% Font
Screen('TextFont', window, cfg.font);
Screen('TextSize', window, cfg.fontSize);
Screen('TextColor', window, cfg.textColor);


%% BEGIN CRT

% Empty arrays to save time
numIteration = length(crtprompt(:,1));
numPrompts = length(crtprompt(1,:));
% response = repmat({''},numIteration, numPrompts);
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

aOK=0; % initial value for aOK

while aOK ~= 1
 
    for i = 1:numIteration;
    response = GetEchoStringForm(window, crtprompt(i), 'center', 'center', cfg.textColor); % displays string in PTB; allows backspace
    
    % potential alternative
    % number = GetNumber([deviceIndex][, untilTime=inf][, optional KbCheck arguments...])
    % Should repeat as long as while condition satisfied
    
    % chosenGame = input('Enter the randomly selected game: ') % ENGLISH
    % chosenGame = input('Tasti il gioco scelto: ') % ITALIAN
    switch isempty(response)
        case 1 %deals with both cancel and X presses
            Screen('Flip', window)
            response = GetEchoStringForm(window, fail1, xPos1, yPos, cfg.textColor); % displays string in PTB; allows backspace
            aOK = 0;
        case 0
%             if response < 1 || response > 48
%                 Screen('Flip', window)
%                 response = str2double(GetEchoStringForm(window, fail1, xPos1, yPos, cfg.textColor)); % displays string in PTB; allows backspace
%                 aOK = 0;
%             elseif response == NaN
%                  Screen('Flip', window)
%                  response = str2double(GetEchoStringForm(window, fail1, xPos1, yPos, cfg.textColor)); % displays string in PTB; allows backspace
%                  aOK = 0;
%             else
                Screen('Flip', window)
                aOK = 1;
%             end
    end
    respLog(i) = response
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

%% 

%%%%%%%%%
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
% DrawFormattedText(window, botInstructText, textXpos, lowTextYpos); % Draw reward explanation
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
%%%%%%%%%


% selectedRects = choiceRects(:,currPlayerSelection);    
    selectedRects = choiceRects;  
    Screen('FillRect', window, cfg.instColB, selectedRects); % Draw the top rects to the screen
    choiceRects = []
    
    % repeat text
    
    oldStyle = Screen(window,'TextStyle',4); 
    [nx, ny] = DrawFormattedText(window, ['Domanda ' num2str(i), '/' num2str(length(citprompt(:,1)))], 'center', ...
    cfg.topTextYpos, [255 0 0]);

    oldStyle = Screen(window,'TextStyle', 4); 
    DrawFormattedText(window, citprompt(i,1) , 'center', ny, [255 0 0]);

for k = 2:length(citprompt(1,:))
    if k = 1; 
    xPos = cfg.screenCenter(1)/2 - screenXpixels/3 - length(citprompt(i,k))/2
    elseif k = 2; 
    xPos = cfg.screenCenter(1)/2
    elseif k = 3; 
    xPos = cfg.screenCenter(1)/2 + screenXpixels/3 - length(citprompt(i,k))/2
    else
    end
    
    response = char(citprompt(i,k))
    length(response)
    
    oldStyle = Screen(window,'TextStyle', 0); 
    DrawFormattedText(window,citprompt(i,k), 'center', ...
    screenYpixels * 0.25, [0 0 0])

    oldStyle = Screen(window,'TextStyle', 2);
    DrawFormattedText(window,'\n\n\n\n\nChi ? la pi? arrabbiata della scelta del ristorante?','center',...
    screenYpixels * 0.53);

% this part produces rectangles around each response, based on the size of
% the text string
    Screen(window,'TextStyle',0); 
    [q1a1x, q1a1y, q1a1rect]=DrawFormattedText(window,'Sara',choiceRectXpos(1),...
    screenYpixels * 0.73);
	spacing = q1a1rect(4)-q1a1rect(2); % sets the spacing for all selection rectangles; don't have to repeat this for each question
    
   
    selRects(1:2,1) = q1a1rect(1:2)-spacing; % left and top sides of rect for answer 1
    selRects(3:4,1) = q1a1rect(3:4)+spacing; % right and bottom sides of rect for answer 1

    [q1a2x, q1a2y, q1a2rect] = DrawFormattedText(window,'Anna',choiceRectXpos(2),...
    screenYpixels * 0.73);
    selRects(1:2,2) = q1a2rect(1:2)-spacing; % left and top sides of rect for answer 1
    selRects(3:4,2) = q1a2rect(3:4)+spacing; % right and bottom sides of rect for answer 1

    [q1a3x, q1a3y, q1a3rect] = DrawFormattedText(window,'Lo stesso/Non saprei',choiceRectXpos(3),...
    screenYpixels * 0.73);
    selRects(1:2,3) = q1a3rect(1:2)-spacing; % left and top sides of rect for answer 1
    selRects(3:4,3) = q1a3rect(3:4)+spacing; % right and bottom sides of rect for answer 1

    Screen('FrameRect', window, rectCol, selRects); % Draw the top rects to the screen
 
    Screen(window,'flip');
    KbWait; 
    KbReleaseWait; 

end

%% QUESTION 1: 


% 1. Display

oldStyle= Screen(window,'TextStyle',4); 
DrawFormattedText(window,'Domanda 1' , 'center', ...
    screenYpixels * 0.15, [255 0 0]);

oldStyle= Screen(window,'TextStyle',0); 
DrawFormattedText(window,'\nAnna si sente male dopo aver mangiato in un ristorante\n\ndove mangia spesso.\n\n\nSara si sente male dopo aver mangiato in un ristorante\n\ndove non ha mai mangiato prima.','center', ...
    screenYpixels * 0.25, [0 0 0]);

oldStyle = Screen(window,'TextStyle',2);
DrawFormattedText(window,'\n\n\n\n\nChi ? la pi? arrabbiata della scelta del ristorante?','center',...
    screenYpixels * 0.53);

Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nSara',choiceRectXpos(1),... % position = no center, but words start from it!
    screenYpixels * 0.73);
    DrawFormattedText(window,'\nAnna',choiceRectXpos(2),...
    screenYpixels * 0.73);
    DrawFormattedText(window,'\nLo stesso/Non saprei',choiceRectXpos(3),...
    screenYpixels * 0.73);
 
Screen(window,'flip');
KbWait; 
KbReleaseWait; 


% 3. Selection

currSelection=1; % Set starting choice
keyName=''; % empty initial value

while(~strcmp(keyName,'space')) % continues until current keyName is space (>> add "then hit space" in instructions?)
   
[keyTime, keyCode]=KbWait([],2);
keyName=KbName(keyCode);

%          switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = currPlayerSelection - 1;
%                 if currPlayerSelection < 1
%                     currPlayerSelection = 3; % 4 clicks right: come back to first choice!
%                 end
%             case 'RightArrow'
%                 currPlayerSelection = currPlayerSelection + 1;
%                 if currPlayerSelection > 3
%                     currPlayerSelection = 1; % 1 click back: go to third choice!
%                 end
%         end
        % update selection to last button press

   
    % selectedRects = choiceRects(:,currPlayerSelection);    
    selectedRects = choiceRects;  
    Screen('FillRect', window, textColor, selectedRects); % Draw the top rects to the screen
    
    % repeat text
    oldStyle= Screen(window,'TextStyle',4); 
    DrawFormattedText(window,'Domanda 1' , 'center', ...
    screenYpixels * 0.15, [255 0 0]);

    oldStyle= Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nAnna si sente male dopo aver mangiato in un ristorante\n\ndove mangia spesso.\n\n\nSara si sente male dopo aver mangiato in un ristorante\n\ndove non ha mai mangiato prima.','center', ...
    screenYpixels * 0.25, [0 0 0]);

    oldStyle = Screen(window,'TextStyle',2);
    DrawFormattedText(window,'\n\n\n\n\nChi ? la pi? arrabbiata della scelta del ristorante?','center',...
    screenYpixels * 0.53);


    Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nSara',choiceRectXpos(1),...
    screenYpixels * 0.73);
    DrawFormattedText(window,'\nAnna',choiceRectXpos(2),...
    screenYpixels * 0.73);
    DrawFormattedText(window,'\nLo stesso/Non saprei',choiceRectXpos(3),...
    screenYpixels * 0.73);
    
    Screen(window,'flip');
    KbWait; 
    KbReleaseWait; 

end
end

%% QUESTION 2
 
% 1. Display

oldStyle= Screen(window,'TextStyle',4); 
DrawFormattedText(window,'Domanda 2' , 'center', ...
    screenYpixels * 0.15, [255 0 0]);

oldStyle= Screen(window,'TextStyle',0); 
DrawFormattedText(window,'\nGiulia ha perso il suo treno per 5 minuti.\n\n\nSusanna ha perso il suo treno per un'' ora.','center', ...
    screenYpixels * 0.30, [0 0 0])

oldStyle = Screen(window,'textStyle',2);
DrawFormattedText(window,'\n\n\n\n\nChi trascorrer? pi? tempo a pensare al treno che ha perso?','center',...
    screenYpixels * 0.53);

oldStyle= Screen(window,'TextStyle',0); 
DrawFormattedText(window,'\nSusanna         Giulia         Lo stesso/Non saprei','center',...
    screenYpixels * 0.73);

Screen(window,'flip');
KbWait; 
KbReleaseWait; 





% 3. Selection

currSelection=1; % Set starting choice
keyName=''; % empty initial value

while(~strcmp(keyName,'space')) % continues until current keyName is space (>> add "then hit space" in instructions?)
   
[keyTime, keyCode]=KbWait([],2);
keyName=KbName(keyCode);

%          switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = currPlayerSelection - 1;
%                 if currPlayerSelection < 1
%                     currPlayerSelection = 3; % 4 clicks right: come back to first choice!
%                 end
%             case 'RightArrow'
%                 currPlayerSelection = currPlayerSelection + 1;
%                 if currPlayerSelection > 3
%                     currPlayerSelection = 1; % 1 click back: go to third choice!
%                 end
%         end
        % update selection to last button press
    
          
    % selectedRects = choiceRects(:,currPlayerSelection);    
    selectedRects = choiceRects;  
    Screen('FillRect', window, textColor, selectedRects); % Draw the top rects to the screen
    
    % repeat text
    oldStyle= Screen(window,'TextStyle',4); 
    DrawFormattedText(window,'Domanda 2' , 'center', ...
    screenYpixels * 0.15, [255 0 0]);

    oldStyle= Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nGiulia ha perso il suo treno per 5 minuti.\n\n\nSusanna ha perso il suo treno per un'' ora.','center', ...
    screenYpixels * 0.30, [0 0 0])

    oldStyle = Screen(window,'textStyle',2);
    DrawFormattedText(window,'\n\n\n\n\nChi trascorrer? pi? tempo a pensare al treno che ha perso?','center',...
    screenYpixels * 0.53);

    oldStyle= Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nSusanna         Giulia         Lo stesso/Non saprei','center',...
    screenYpixels * 0.73);
        
    Screen(window,'flip');
    KbWait; 
    KbReleaseWait; 

end


%% QUESTION 3

% 1. Display

oldStyle= Screen(window,'TextStyle',4); 
DrawFormattedText(window,'Domanda 3' , 'center', ...
    screenYpixels * 0.15, [255 0 0]);

oldStyle= Screen(window,'TextStyle',0); 
DrawFormattedText(window,'\nGiovanni ha un incidente mentre percorre\n\nla solita strada per rientrare a casa.\n\n\nRoberto ha un incidente mentre percorre\n\nuna nuova strada per rientrare a casa.','center', ...
    screenYpixels * 0.23, [0 0 0])

oldStyle = Screen(window,'textStyle',2);
DrawFormattedText(window,'\n\n\n\n\nChi pensa di pi? alla possibilit? che\n\nl''incidente potesse essere evitato?','center',...
    screenYpixels * 0.48); 

oldStyle= Screen(window,'TextStyle',0); 
DrawFormattedText(window,'\nGiovanni         Roberto         Lo stesso/Non saprei','center',...
    screenYpixels * 0.73);

Screen(window,'flip');
KbWait; 
KbReleaseWait; 



% 3. Selection

currSelection=1; % Set starting choice
keyName=''; % empty initial value

while(~strcmp(keyName,'space')) % continues until current keyName is space (>> add "then hit space" in instructions?)
   
[keyTime, keyCode]=KbWait([],2);
keyName=KbName(keyCode);

%          switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = currPlayerSelection - 1;
%                 if currPlayerSelection < 1
%                     currPlayerSelection = 3; % 4 clicks right: come back to first choice!
%                 end
%             case 'RightArrow'
%                 currPlayerSelection = currPlayerSelection + 1;
%                 if currPlayerSelection > 3
%                     currPlayerSelection = 1; % 1 click back: go to third choice!
%                 end
%         end
        % update selection to last button press
        
    % selectedRects = choiceRects(:,currPlayerSelection);    
    selectedRects = choiceRects;  
    Screen('FillRect', window, textColor, selectedRects); % Draw the top rects to the screen
    
    % repeat text
    oldStyle= Screen(window,'TextStyle',4); 
    DrawFormattedText(window,'Domanda 3' , 'center', ...
    screenYpixels * 0.15, [255 0 0]);

    oldStyle= Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nGiovanni ha un incidente mentre percorre\n\nla solita strada per rientrare a casa.\n\n\nRoberto ha un incidente mentre percorre\n\nuna nuova strada per rientrare a casa.','center', ...
    screenYpixels * 0.23, [0 0 0])

    oldStyle = Screen(window,'textStyle',2);
    DrawFormattedText(window,'\n\n\n\n\nChi pensa di pi? alla possibilit? che\n\nl''incidente potesse essere evitato?','center',...
    screenYpixels * 0.48);

    oldStyle= Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nGiovanni         Roberto         Lo stesso/Non saprei','center',...
    screenYpixels * 0.73);
        
    Screen(window,'flip');
    KbWait; 
    KbReleaseWait; 

end


%% QUESTION 4   

% 1. Display

oldStyle= Screen(window,'TextStyle',4); 
DrawFormattedText(window,'Domanda 4' , 'center', ...
    screenYpixels * 0.15, [255 0 0]);

oldStyle= Screen(window,'TextStyle',0); 
DrawFormattedText(window,'\nEdoardo subisce una rapina a soli 10 metri da casa.\n\n\nGiacomo subisce una rapina un chilometro da casa.','center', ...
    screenYpixels * 0.30, [0 0 0])

oldStyle = Screen(window,'textStyle',2);
DrawFormattedText(window,'\n\n\n\n\nChi ? pi? arrabbiato riguardo la rapina?','center',...
    screenYpixels * 0.53);

oldStyle= Screen(window,'TextStyle',0); 
DrawFormattedText(window,'\nEdoardo         Giacomo         Lo stesso/Non saprei','center',...
    screenYpixels * 0.73);

Screen(window,'flip');
KbWait; 
KbReleaseWait; 


% 3. Selection

currSelection=1; % Set starting choice
keyName=''; % empty initial value

while(~strcmp(keyName,'space')) % continues until current keyName is space (>> add "then hit space" in instructions?)
   
[keyTime, keyCode]=KbWait([],2);
keyName=KbName(keyCode);

%          switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = currPlayerSelection - 1;
%                 if currPlayerSelection < 1
%                     currPlayerSelection = 3; % 4 clicks right: come back to first choice!
%                 end
%             case 'RightArrow'
%                 currPlayerSelection = currPlayerSelection + 1;
%                 if currPlayerSelection > 3
%                     currPlayerSelection = 1; % 1 click back: go to third choice!
%                 end
%         end
        % update selection to last button press
        
    % selectedRects = choiceRects(:,currPlayerSelection);    
    selectedRects = choiceRects;  
    Screen('FillRect', window, textColor, selectedRects); % Draw the top rects to the screen
    
    % repeat text
    oldStyle= Screen(window,'TextStyle',4); 
    DrawFormattedText(window,'Domanda 4' , 'center', ...
    screenYpixels * 0.15, [255 0 0]);

    oldStyle= Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nEdoardo subisce una rapina a soli 10 metri da casa.\n\n\nGiacomo subisce una rapina un chilometro da casa.','center', ...
    screenYpixels * 0.30, [0 0 0])

    oldStyle = Screen(window,'textStyle',2);
    DrawFormattedText(window,'\n\n\n\n\nChi ? pi? arrabbiato riguardo la rapina?','center',...
    screenYpixels * 0.53);

    oldStyle= Screen(window,'TextStyle',0); 
    DrawFormattedText(window,'\nEdoardo         Giacomo         Lo stesso/Non saprei','center',...
    screenYpixels * 0.73);
    
    Screen(window,'flip');
    KbWait; 
    KbReleaseWait; 

end

% LOG FILE: player responses, winnings
     
sca;

end
