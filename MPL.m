function [winningsMPL] = MPL(cfg, particNum, DateTime, window, windowRect, enabledKeys)
% MPL
% SCREENS: 3
% QUESTIONS/SCREEN: 10
% CHOICES: 2
% PROMPTS: image
% RESPONSE: move rectangles, click 'space'
% Randomly select line
% Randomly select side
% output all selections, random selections, winnigs

% screen 1: first instruction screen
% screen 2: real choices
% - change instructs to say using l/r arrows, 
% - up/down arrows to change rows
% - space to confirm all choices
% - change instructs to say choice becomes yellow
% screen 3: game gets played
% - random selection of game 1-10 (have it run through like in WoF?)
% - random choice 1-10 (0-first prob (70 = 1-7) gets top row prize. Second prob-1 (30 = 8-10) gets lower row prize) 
%        - have it run through like WoF?
% - show result

addpath('questionnaires');
load('citpromptARRAY.mat')       % Load CIT prompts and responses DATASET - PC Lab
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);

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

%% Setup
% Font
Screen('TextFont', window, cfg.font);
Screen('TextSize', window, cfg.fontSize);
Screen('TextColor', window, cfg.textColor);

% BaseRect based on screen and text size
rectWidth = screenXpixels * 5 / 40;
rectHeight = screenYpixels * 0.125 / 56; % rectangles slimmer!
baseRect = [0 0 rectWidth rectHeight]; % like this (not numbers manually) because it *should* keeps the same proportions on all screensizes 

% Text
instructions = repmat({''},2, 2);
instructions(1,1) = 'Descrizione Generale dell?Esperimento';
instructions(1,2) = 'Descrizione della Procedura di Scelta e di Pagamento';
instructions(2,1) = 'In questa parte dell?esperimento ti verranno presentate 10 coppie di lotterie. Ogni lotteria ti garantisce di ottenere, con una certa probabilita?, una tra due possibili vincite. Per ogni coppia di lotterie, il tuo compito sar? quello di scegliere la lotteria che preferisci giocare. \nDi seguito ti verra? presentata una descrizione dettagliata del compito. \nClicca ''spazio'' per continuare.';
instructions(2,2) = 'Nella parte destra dello schermo sono riportate le 10 coppie di lotterie. Ci sono 10 righe che corrispondono alle 10 scelte che dovrai effettuare. Ogni riga rappresenta una scelta tra due lotterie. \nPer effettuare le tue scelte in ogni riga, tasti le frecce sinistra o destra. Per cambiare la riga, usa le frecce su o giu?. Quando sei finito, premi ?spazio?. Una volta che avrai scelto una lotteria, essa diventera? di colore giallo. \nDopo che avrai effettuato le tue 10 scelte, il computer selezionera? in modo casuale una delle 10 righe. Infine, la lotteria da te scelta verra? giocata dal computer e tu riceverai la vincita corrispondente all?esito della lotteria. La tua vincita ti verra? mostrata a schermo dopo che avrai completato e validato le tue scelte. \nRicorda, l?ammontare di denaro rappresentato nelle diverse lotterie e? reale, percio? sarai pagato/a in base alle scelte che effettuerai e secondo le regole appena descritte. \nSe hai qualche dubbio sulla procedura ed il metodo di pagamento sentiti libero/a di chiedere chiarimenti allo sperimentatore.';

% Define values
prob(:,1) = (10:10:100)'
prob2values = (0:10:90)'
prob(:,2) = sort(prob2values,'descend'))

euro = hex2dec('20ac');
leftChoice = [num2str(prob(i,1)), '% prob. vincere ', euro, '2 \n' num2str(prob(i,2)), '% prob. vincere ', euro, '1,60'];
rightChoice = [num2str(prob(i,1)), '% prob. vincere ', euro, '3,85 \n' num2str(prob(i,2)), '% prob. vincere ', euro, '0,10'];



%% EXPLANATION SCREEN

for i = 1:2
    
keyName=[];    

while ~strcmp(keyName,'space')
        
        [~, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
 
Screen('TextStyle', window,1); % bold
[~, ny] = DrawFormattedText(window,instructions(:,1), 'center', cfg.topText);

Screen('TextStyle', window,0); % back to plain
Screen('TextSize', window, cfg.fontSize/2); % smaller fontsize
DrawFormattedText(window,instructions(:,2), 'center', ny, 0, 50);

Screen('Flip', window);

Screen('TextSize', window, cfg.fontSize); % back to original



end
end

    keyName=''; % empty initial value
    instructions = 1;
    instFilename = ['instructions/MPL_instructions' num2str(instructions) '-' type 'AI.png'];
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
        
        instFilename = ['instructions/MPL_instructions' num2str(instructions) '-' type 'AI.png'];
        imdata=imread(instFilename);
        
        tex=Screen('MakeTexture', window, imdata);
        
        % Draw texture image to backbuffer. It will be automatically
        % centered in the middle of the display if you don't specify a
        % different destination:
        Screen('DrawTexture', window, tex);
        
        Screen('Flip', window);
        
        
%     end
end

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
storedSelRects = NaN(numIteration, numPrompts, 4);

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
