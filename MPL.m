function [choice, winningsMPL] = MPL(cfg, particNum, DateTime, window, windowRect, enabledKeys)
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
% addpath('questionnaires');
% load('citpromptARRAY.mat')       % Load CIT prompts and responses DATASET - PC Lab
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
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
% cfg.uppTextYpos = screenYpixels * 6/40;
% cfg.botTextYpos = screenYpixels * 35/40; % Screen Y positions of bottom/result text
% cfg.waitTextYpos = screenYpixels * 38/40; % Y position of lowest "Please Wait" text

%% Setup
% Font
Screen('TextFont', window, cfg.font);
Screen('TextSize', window, cfg.fontSize/2);
Screen('TextColor', window, cfg.textColor);

% BaseRect based on screen and text size
rectWidth = screenXpixels * 5 / 40;
rectHeight = screenYpixels * 0.125 / 56; % rectangles slimmer!
baseRect = [0 0 rectWidth rectHeight]; % like this (not numbers manually) because it *should* keeps the same proportions on all screensizes 

% Text
instructions = repmat({''},2, 2);
instructions(1,1) = {'Descrizione Generale dell''Esperimento'};
instructions(1,2) = {'Descrizione della Procedura di Scelta e di Pagamento'};
instructions(2,1) = {'In questa parte dell''esperimento ti verranno presentate 10 coppie di lotterie. Ogni lotteria ti garantisce di ottenere, con una certa probabilita'', una tra due possibili vincite. Per ogni coppia di lotterie, il tuo compito sara'' quello di scegliere la lotteria che preferisci giocare. \n\nDi seguito ti verra'' presentata una descrizione dettagliata del compito. \n\nClicca ''spazio'' per continuare.'};
instructions(2,2) = {'Nella parte destra dello schermo sono riportate le 10 coppie di lotterie. Ci sono 10 righe che corrispondono alle 10 scelte che dovrai effettuare. Ogni riga rappresenta una scelta tra due lotterie. \n\nPer effettuare le tue scelte in ogni riga, tasti le frecce sinistra o destra. Per cambiare la riga, usa le frecce su o giu''. Quando sei finito, premi ''spazio''. Una volta che avrai scelto una lotteria, essa diventera'' di colore verde. \n\nDopo che avrai effettuato le tue 10 scelte, il computer selezionera'' in modo casuale una delle 10 righe. Infine, la lotteria da te scelta verra'' giocata dal computer e tu riceverai la vincita corrispondente all''esito della lotteria. La tua vincita ti verra'' mostrata a schermo dopo che avrai completato e validato le tue scelte. \n\nRicorda, l''ammontare di denaro rappresentato nelle diverse lotterie e'' reale, percio'' sarai pagato/a in base alle scelte che effettuerai e secondo le regole appena descritte. \n\nSe hai qualche dubbio sulla procedura ed il metodo di pagamento sentiti libero/a di chiedere chiarimenti allo sperimentatore.'};

% Define values
prob(:,1) = (10:10:100)';
prob2values = (0:10:90)';
prob(:,2) = sort(prob2values,'descend');

% empty matrices to fill up
choice = NaN(10,1);
numChoice=length(choice);
leftChoice = repmat({''},10, 1);
rightChoice = repmat({''},10, 1);

euro = hex2dec('20ac');

for i = 1:numChoice
leftChoice(i,1) = cellstr([num2str(prob(i,1)), '% prob. vincere ', euro, '2 \n', num2str(prob(i,2)), '% prob. vincere ', euro, '1,60']);
rightChoice(i,1) = cellstr([num2str(prob(i,1)), '% prob. vincere ', euro, '3,85 \n', num2str(prob(i,2)), '% prob. vincere ', euro, '0,10']);
end


% currSelection = NaN(10,1);

%% EXPLANATION SCREEN

    Screen('TextStyle', window,1); % bold
    Screen('TextSize', window, cfg.fontSize);
    [~, ny1] = DrawFormattedText(window, char(instructions(1,1)), 'center', cfg.topTextYpos);

    Screen('TextStyle', window,0); % back to plain
    Screen('TextSize', window, cfg.fontSize/2); % smaller fontsize
    DrawFormattedText(window,char(instructions(2,1)), 'center', ny1*2, 0, 70);
    
    Screen('Flip', window);
    
keyName='';        
while ~strcmp(keyName,'space')
    
    [~, keyCode]=KbWait([],2);
    keyName=KbName(keyCode);
   
    instructPage = 1;
    
    switch keyName
        case 'LeftArrow'
            instructPage = instructPage - 1;
            if instructPage < 1
                instructPage = 1;
            end
        case 'RightArrow'
            instructPage = instructPage + 1;
            if instructPage > 2
                instructPage = 2;
            end
    end
    
    Screen('TextStyle', window,1); % bold
    Screen('TextSize', window, cfg.fontSize);
    [~, ny(instructPage)] = DrawFormattedText(window,char(instructions(1,instructPage)), 'center', cfg.topTextYpos);
    
    Screen('TextStyle', window,0); % back to plain
    Screen('TextSize', window, cfg.fontSize/2); % smaller fontsize
    DrawFormattedText(window,char(instructions(2,instructPage)), 'center', ny(instructPage)*2, 0, 70);
    
    Screen('Flip', window);
        
end

%% Positioning and rectangles loops
Screen('TextSize', window, cfg.fontSize/2);

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
% for i = 1:length(choice)
%     
%     for k = 2:numPrompts
        
%         response(i,k) = char(citprompt(i,k))
%         response(i,k) = citprompt(i,k)
        %     length(response(i,k))
        
%         [xPos(i,k), yPos(i,k), rect(i,k)]=DrawFormattedText(window, 'Sara', 0, 0, cfg.bgColor);


[~, ~, rect]=DrawFormattedText(window, char(rightChoice(10,1)), 0, 0, cfg.bgColor);
    Screen('TextStyle', window,1); % bold
[~,~,joinerRect]=DrawFormattedText(window, 'OPPURE', 0, 0, cfg.bgColor);
    Screen('TextStyle', window,0); % plain
Screen('Flip', window)
rectHeight = cfg.screenSize.y/13; 
spacer = (rect(4)-rect(2))/2; % sets the spacing for all selection rectangles; don't have to repeat this for each question
% rectHeight = rect(4)-rect(2)+spacer; % different from spacer because k==4 is taller
rectWidth = rect(3)-rect(1)+spacer;
joinerWidth = joinerRect(3)-joinerRect(1);
selectingWidth = spacer/8; % pen width as choice is being made
selectedWidth = spacer/4; % pen width for rectangles that have been chosen

storedXPos(1) = cfg.screenCenter(1)-joinerWidth-rectWidth+spacer; %screen center, less half the joiner word, less a spacer
storedXPos(2) = cfg.screenCenter(1)-joinerWidth/2;
storedXPos(3) = cfg.screenCenter(1)+joinerWidth; %screen center, plus half the joiner word, plus a spacer
yPos = NaN(10,1);
storedSelRects = NaN(length(choice), 4, 2);


for i = 1:length(choice)
    yPos(i) = rectHeight*i + spacer; % set y position for each row
    for k = 1:2:3 % store rects (just 1 and 3 since don't need rects around middle position)
        storedSelRects(i,:,k) = [storedXPos(k)-spacer yPos(i)-spacer/2 storedXPos(k)+rectWidth yPos(i)+rectHeight-spacer];
    end
end
gameXPos = storedSelRects(1,3,3)+spacer; % after right edge of rectangle, plus spacer

% left rects




%         if i == 1 && k == 2 % does spacer calculation just once
 
%         rectWidth(i,k) = rect(3)-rect(1); % finds length of each response
%         storedRect(i,:,k) = rect;

%         selRects(1:2,k) = rect(1:2)-spacer; % left and top sides of rect for answer (i, k)
%         selRects(3:4,k) = rect(3:4)+spacer; % right and bottom sides of rect for answer (i, k)
%         storedSizeRects(i,:,k) = [rect(1:2)-spacer/2 rect(3:4)+spacer/2]; % left and top, right and bottom sides of rect for answer (i, k)
%         if k == 2;
%             rectXCenter = cfg.screenCenter(1) - screenXpixels/3;
%             xPos = rectXCenter - respLength(i,k)/2;
%         elseif k == 3;
%             rectXCenter = cfg.screenCenter(1);
%             xPos = cfg.screenCenter(1)-(respLength(i,k)/2);
%         elseif k == 4;
%             rectXCenter = cfg.screenCenter(1) + screenXpixels/3;
%             xPos = rectXCenter - respLength(i,k)/2;
%         else
%         end
%          storedXRectCenter(i,k)=rectXCenter;
%          storedXPos(i,k)=xPos;
%         storedSelRects(i,:,k) = [rectXCenter-rectWidth(i,k)/2-spacer yPos(k)-spacer rectXCenter+rectWidth(i,k)/2+spacer yPos(k)+rectHeight(i,k)+spacer];




%% Price list
  
% Draw all choices
for i = 1:length(choice)
    if mod(i,2) == 0
        rowColor = cfg.p1Col; % medium blue for even rows
    else
        rowColor = cfg.p2Col; % light blue for odd rows
    end
    DrawFormattedText(window, char(leftChoice(i,1)), storedXPos(1), yPos(i), rowColor);
    %     DrawFormattedText(window, 'OPPURE', 'center', yPos(i), cfg.textColor);
    Screen('TextStyle', window,1); % bold
    DrawFormattedText(window, 'OPPURE',  storedXPos(2), yPos(i)+spacer/2, rowColor); % should do the same thing as 'center'
    Screen('TextStyle', window,0); % plaintext
    DrawFormattedText(window, char(rightChoice(i,1)), storedXPos(3), yPos(i), rowColor);
    for k=1:2:3
        Screen('FrameRect', window, cfg.textColor, storedSelRects(i,:,k)); % Draws a frame rectangle around current selection k
    end
    
end
Screen('Flip', window)
WaitSecs(.25)
    
    currRow = 1;
    currSelection = 1; % initial value - numbers reflect responses (since value 1 is associated with prompt)
    keyName='';
    while ~strcmp(keyName,'space')
        
        [~, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
        % First two move selection up and down; second two move selector
        % left and right
        
        switch keyName
            case 'UpArrow'
                currRow = currRow - 1;
                if currRow < 1
                    currRow = 1; % does not loop around
                end
            case 'DownArrow'
                choice(currRow) = currSelection;
                currRow = currRow + 1;
                if currRow > 10
                    currRow = 10; % does not loop around
                end
                
            case 'LeftArrow'
                currSelection = currSelection - 2;
                if currSelection < 1
                    currSelection = 3; % Loops around
                end
            case 'RightArrow'
                currSelection = currSelection + 2;
                if currSelection > 3
                    currSelection = 1; % Loops around
                end
        end
        %         update selection to last button press
        
        % redraw all choices
        for i = 1:length(choice)
            if mod(i,2) == 0
                rowColor = cfg.p1Col; % medium blue for even rows
            else
                rowColor = cfg.p2Col; % light blue for odd rows
            end
            DrawFormattedText(window, char(leftChoice(i,1)), storedXPos(1), yPos(i), rowColor);
            %     DrawFormattedText(window, 'OPPURE', 'center', yPos(i), cfg.textColor);
            Screen('TextStyle', window,1); % bold
            DrawFormattedText(window, 'OPPURE',  storedXPos(2), yPos(i)+spacer/2, rowColor); % should do the same thing as 'center'
            Screen('TextStyle', window,0); % plaintext
            DrawFormattedText(window, char(rightChoice(i,1)), storedXPos(3), yPos(i), rowColor);
            for k=1:2:3
                Screen('FrameRect', window, cfg.textColor, storedSelRects(i,:,k)); % Draws a frame rectangle around all choices
            end
            
        end
        % draw all previously selected frames
        for i = 1:length(choice)
            if ~isnan(choice(i))
                Screen('FrameRect', window, cfg.winCol, storedSelRects(i,:,choice(i)), selectedWidth); % Draws a frame rectangle around current selection k
            else
            end
        end
        % draw currently selecting frame
        Screen('FrameRect', window, cfg.instColB, storedSelRects(currRow,:,currSelection), selectingWidth); % Draws a frame rectangle around current selection k

        Screen('Flip', window)
        
    end
%         choice(:,1) = currSelection(:,1); 
%         cit.resp(i) = currSelection-1; % reflects response 1, 2, or 3
%         cit.respInd(i) = currSelection; % reflects position of response: 2, 3, 4
%% Random selection of which row to play

game = randi(10); 
loop = 0; 
        % redraw all choices and chosen rectangles
while loop <= 30+game;
    for l = 1:length(choice)
        for i = 1:length(choice)
            if mod(i,2) == 0
                rowColor = cfg.p1Col; % medium blue for even rows
            else
                rowColor = cfg.p2Col; % light blue for odd rows
            end
            DrawFormattedText(window, char(leftChoice(i,1)), storedXPos(1), yPos(i), rowColor);
            %     DrawFormattedText(window, 'OPPURE', 'center', yPos(i), cfg.textColor);
            Screen('TextStyle', window,1); % bold
            DrawFormattedText(window, 'OPPURE',  storedXPos(2), yPos(i)+spacer/2, rowColor); % should do the same thing as 'center'
            Screen('TextStyle', window,0); % plaintext
            DrawFormattedText(window, char(rightChoice(i,1)), storedXPos(3), yPos(i), rowColor);
            for k=1:2:3
                Screen('FrameRect', window, cfg.textColor, storedSelRects(i,:,k)); % Draws a frame rectangle around all choices
            end
            % draw green rects on all chosen
            Screen('FrameRect', window, cfg.winCol, storedSelRects(i,:,choice(i)), selectedWidth); % Draws a frame rectangle around current selection k
            
        end
        Screen('FrameRect', window, cfg.instColB, storedSelRects(l,:,choice(l)), selectedWidth); % Draws a frame rectangle around current selection k
        Screen('Flip', window)
        WaitSecs(.1)
        loop = loop+1;
        if loop == 30+game
            WaitSecs(2)            
            return
        end
    end
end

%% Roll the dice for the number
dice = randi(10);

% redraw only chosen row
i = game;
if mod(i,2) == 0
    rowColor = cfg.p1Col; % medium blue for even rows
else
    rowColor = cfg.p2Col; % light blue for odd rows
end
DrawFormattedText(window, char(leftChoice(i,1)), storedXPos(1), yPos(i), rowColor);
%     DrawFormattedText(window, 'OPPURE', 'center', yPos(i), cfg.textColor);
Screen('TextStyle', window,1); % bold
DrawFormattedText(window, 'OPPURE',  storedXPos(2), yPos(i)+spacer/2, rowColor); % should do the same thing as 'center'
Screen('TextStyle', window,0); % plaintext
DrawFormattedText(window, char(rightChoice(i,1)), storedXPos(3), yPos(i), rowColor);
for k=1:2:3
    Screen('FrameRect', window, cfg.textColor, storedSelRects(i,:,k)); % Draws a frame rectangle around all choices
end
% draw green rects on all chosen
Screen('FrameRect', window, cfg.instColB, storedSelRects(i,:,choice(i)), selectedWidth); % Draws a frame rectangle around chosen choice
Screen('Flip', window)

% Display possible results, depending on game choice and stored
% probabilities and determine winnings
if i == 10 % game 10 has 100 percent certain result
    if choice(i) == 1
        gameText = ['Hai vinto ', euro, '2.'];
        winningsMPL = 2;
    elseif choice(i) == 3
        gameText = ['Hai vinto ', euro, '3,85.'];
        winningsMPL = 3.85;
    end
    return
    
else
    if choice(i) == 1
        gameText = ['Se appara 1-', num2str(prob(i,1)/10), ', vinci ', euro, '2.\nSe invece appara ', num2str(prob(i,2)/10), '-10, vinci ', euro, '1,60.'];
        if dice <= prob(i,1)/10
            winningsMPL = 2;
        elseif dice > prob(i,1)/10
            winningsMPL = 1.6;
        else
            disp = 'Something went wrong with the dice roll'
        end
    elseif choice(i) == 3
        gameText = ['Se appara 1-', num2str(prob(i,1)/10), ', vinci ', euro, '3,85.\nSe invece appara ', num2str(prob(i,2)/10), '-10, vinci ', euro, '0,10.'];
        if dice <= prob(i,1)/10
            winningsMPL = 3.85;
        elseif dice > prob(i,1)/10
            winningsMPL = .1;
        else
            disp = 'Something went wrong with the dice roll'
        end
    end
end

% 
if dice <= prob(i,1)/10
    winningsMPL = 2;
elseif dice > prob(i,1)/10
    winningsMPL = 1.6;    
else
    disp = 'Something went wrong with the dice roll'
end

winText = ['Hai vinto ', euro, num2str(winningsMPL)];

% Determine which part of screen game will be played on
if game <= 5;    
    gameYPos = yPos(7);
    numYPos = yPos(9);
else
    gameYPos = yPos(3);
    numYPos = yPos(5);
end

WaitSecs(1);
% redraw chosen row
i = game;
if mod(i,2) == 0
    rowColor = cfg.p1Col; % medium blue for even rows
else
    rowColor = cfg.p2Col; % light blue for odd rows
end
DrawFormattedText(window, char(leftChoice(i,1)), storedXPos(1), yPos(i), rowColor);
%     DrawFormattedText(window, 'OPPURE', 'center', yPos(i), cfg.textColor);
Screen('TextStyle', window,1); % bold
DrawFormattedText(window, 'OPPURE',  storedXPos(2), yPos(i)+spacer/2, rowColor); % should do the same thing as 'center'
Screen('TextStyle', window,0); % plaintext
DrawFormattedText(window, char(rightChoice(i,1)), storedXPos(3), yPos(i), rowColor);
for k=1:2:3
    Screen('FrameRect', window, cfg.textColor, storedSelRects(i,:,k)); % Draws a frame rectangle around all choices
end
% draw green rects on chosen
Screen('FrameRect', window, cfg.instColB, storedSelRects(i,:,choice(i)), selectedWidth); % Draws a frame rectangle around chosen choice
% draw game explanation
Screen('TextSize', window, cfg.fontSize); % back to original
DrawFormattedText(window, gameText, 'center', gameYPos, cfg.instColB);
Screen('Flip', window)
Screen('TextSize', window, cfg.fontSize/2); % back to small

WaitSecs(1);

%% Show the dice roll
loop = 0; 
        % redraw all choices and chosen rectangles
        while loop <= 30+dice;
            for d = 1:10
                % redraw chosen row
                i = game;
                if mod(i,2) == 0
                    rowColor = cfg.p1Col; % medium blue for even rows
                else
                    rowColor = cfg.p2Col; % light blue for odd rows
                end
                DrawFormattedText(window, char(leftChoice(i,1)), storedXPos(1), yPos(i), rowColor);
                %     DrawFormattedText(window, 'OPPURE', 'center', yPos(i), cfg.textColor);
                Screen('TextStyle', window,1); % bold
                DrawFormattedText(window, 'OPPURE',  storedXPos(2), yPos(i)+spacer/2, rowColor); % should do the same thing as 'center'
                Screen('TextStyle', window,0); % plaintext
                DrawFormattedText(window, char(rightChoice(i,1)), storedXPos(3), yPos(i), rowColor);
                for k=1:2:3
                    Screen('FrameRect', window, cfg.textColor, storedSelRects(i,:,k)); % Draws a frame rectangle around all choices
                end
                % draw green rects on chosen
                Screen('FrameRect', window, cfg.instColB, storedSelRects(i,:,choice(i)), selectedWidth); % Draws a frame rectangle around chosen choice
                % draw game explanation
                Screen('TextSize', window, cfg.fontSize); % back to original
                DrawFormattedText(window, gameText, 'center', gameYPos, cfg.instColB);
                % Display dice number
                DrawFormattedText(window, num2str(d), 'center', numYPos, cfg.instColB);
                Screen('Flip', window)
                WaitSecs(.1)
                Screen('TextSize', window, cfg.fontSize/2); % back to small
                loop = loop+1;
                if loop == 30+dice
                    WaitSecs(2)
                    return
                end
            end
        end

%% show prize
        % redraw chosen row
        i = game;
        if mod(i,2) == 0
            rowColor = cfg.p1Col; % medium blue for even rows
        else
            rowColor = cfg.p2Col; % light blue for odd rows
        end
        DrawFormattedText(window, char(leftChoice(i,1)), storedXPos(1), yPos(i), rowColor);
        %     DrawFormattedText(window, 'OPPURE', 'center', yPos(i), cfg.textColor);
        Screen('TextStyle', window,1); % bold
        DrawFormattedText(window, 'OPPURE',  storedXPos(2), yPos(i)+spacer/2, rowColor); % should do the same thing as 'center'
        Screen('TextStyle', window,0); % plaintext
        DrawFormattedText(window, char(rightChoice(i,1)), storedXPos(3), yPos(i), rowColor);
        for k=1:2:3
            Screen('FrameRect', window, cfg.textColor, storedSelRects(i,:,k)); % Draws a frame rectangle around all choices
        end
        % draw green rects on chosen
        Screen('FrameRect', window, cfg.instColB, storedSelRects(i,:,choice(i)), selectedWidth); % Draws a frame rectangle around chosen choice
        % draw game explanation
        Screen('TextSize', window, cfg.fontSize); % back to original
        DrawFormattedText(window, winText, 'center', gameYPos, cfg.instColB);
        % Display dice number
        DrawFormattedText(window, num2str(d), 'center', numYPos, cfg.instColB);
        Screen('Flip', window)
        WaitSecs(5)
        Screen('TextSize', window, cfg.fontSize); % back to original
end

 