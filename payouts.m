function payouts(cfg, window, amount1, description1, amount2, description2, amount3, description3, amount4, description4, amount5, description5, ...
    amount6, description6, amount7, description7, varargin)

% Eliminate variables not input
if nargin < 13
    amount6 = [];
    description6 = [];
    amount7 = [];
    description7 = [];
end

if nargin < 15
    amount7 = [];
    description7 = [];
end

inputs = length(nargin);
fields = inputs/2 - 2;

% Bring in the screen elements
screenXpixels=cfg.screenSize.x;
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, cfg.fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, cfg.textColor);
    
% Make the earnings structure
    for i = 1:fields
        earnings.amount(i) = amount(i)
        earnings.label(i) = description(i); 
    end
    
% earnings.a1 = 'Show-up pagamento: '; % ITALIAN
% earnings.a2 = 'Rows & Colums: '; % ITALIAN
% earnings.a3 = 'Ruota della fortuna: '; % ITALIAN
% earnings.a4 = 'Patent Race: '; % ITALIAN
% earnings.a5 = 'Lista dei prezzi: '; % ITALIAN
% earnings.a6 = 'Puzzles: '; % ITALIAN
% earnings.a7 = 'Totale: '; % ITALIAN

% Get layout positions for each text field
    for i=1:length(fieldnames(earnings))
        
% % % % % % % % % %         Undefined function or variable 'earnings'.
% % % % % % % % % % 
% % % % % % % % % % Error in payouts (line 42)
% % % % % % % % % %     for i=1:length(fieldnames(earnings))
        [nx, ny(i), textRect] = DrawFormattedText(window, earnings.label(i), 0, ny(i)-1, cfg.bgColor); % draws a dummy version of text just to get measurements
        Screen('Flip', window)
        textWidth(i) = textRec(3) - textRect(1); % gets width of each label title
        xPosField(i) = cfg.screenCenter(1) - textWidth; % sets the position so text ends at the center of the screen
        textHeight = textRect(4)-textRect(2); % for positioning top text
        lineSize = 1.5*textHeight % sets baseline shift to half the height of text
        yPos(i) = cfg.screenCenter(2) - (cfg.screenSize.y/2) + 3*lineSize + i*lineSize; % sets Y position of each line of text

        runningTotal(i) = runningTotal(i-1) + earnings.amount(i); % creates a running total for each level
    end
    
    xPosAmounts = cfg.screenCenter(1) + textHeight;
    
    for i=1:length(fieldnames(earnings))
        runningTotal(i) = runningTotal(i-1) + earnings.amount(i);
    end
    
    
%     [nx, ny1, textRect1]=DrawFormattedText(window, earnings1, 0, 0, cfg.bgColor); % draws a dummy version of text just to get measurements
%     [nx, ny2, textRect2]=DrawFormattedText(window, earnings2, 0, ny1, cfg.bgColor); % draws a dummy version of text just to get measurements
%     [nx, ny3, textRect3]=DrawFormattedText(window, earnings3, 0, ny2, cfg.bgColor); % draws a dummy version of text just to get measurements
%     [nx, ny4, textRect4]=DrawFormattedText(window, earnings4, 0, ny3, cfg.bgColor); % draws a dummy version of text just to get measurements
%     [nx, ny5, textRect5]=DrawFormattedText(window, earnings5, 0, ny4, cfg.bgColor); % draws a dummy version of text just to get measurements
%     [nx, ny6, textRect6]=DrawFormattedText(window, earnings6, 0, ny5, cfg.bgColor); % draws a dummy version of text just to get measurements
%     [nx, ny7, textRect7]=DrawFormattedText(window, earnings7, 0, ny6, cfg.bgColor); % draws a dummy version of text just to get measurements
% 
%     textWidth1 = textRect1(3)-textRect1(1); % figures width of bounding rectangle of text
% 	textWidth2 = textRect2(3)-textRect2(1); % figures width of bounding rectangle of text
% 	textWidth3 = textRect3(3)-textRect3(1); % figures width of bounding rectangle of text
% 	textWidth4 = textRect4(3)-textRect4(1); % figures width of bounding rectangle of text
% 	textWidth5 = textRect5(3)-textRect5(1); % figures width of bounding rectangle of text
% 	textWidth6 = textRect6(3)-textRect6(1); % figures width of bounding rectangle of text
% 	textWidth7 = textRect7(3)-textRect7(1); % figures width of bounding rectangle of text
%     xPos1 = cfg.screenCenter(1) - textWidth1; % sets x position to full text length back from center 
%     xPos2 = cfg.screenCenter(1) - textWidth2; % sets x position to full text length back from center 
%     xPos3 = cfg.screenCenter(1) - textWidth3; % sets x position to full text length back from center 
%     xPos4 = cfg.screenCenter(1) - textWidth4; % sets x position to full text length back from center 
%     xPos2 = cfg.screenCenter(1) - textWidth5; % sets x position to full text length back from center 
%     xPos6 = cfg.screenCenter(1) - textWidth6; % sets x position to full text length back from center 
%     xPos7 = cfg.screenCenter(1) - textWidth7; % sets x position to full text length back from center 
%     yPos = cfg.screenCenter(2);
%     yPos2 = yPos + ny1; 
% 
% 
% for i=1:(length(nargin)-2)
%     
% 
% endowment = 10; % Show-up fee
% winnings2x2;    % Rows & Colums
% winnings1shot = total1shotEarnings; % Ruota della fortuna
% winningsPatentRace = player1Earnings; % Patent Race
% winningsMPL;    % Lista dei prezzi
% earningsRaven;  % Puzzles

% runningTotal = runningTotal + 

totalEarnings = sum(earnings.amount);

if totalEarnings <= 10
    disp('You earned ', num2str(totalEarnings), '. 10 euro minimum awarded');
    DrawFormattedText(window, 'Minimum award: ')
    
else
    disp('You earned ', num2str(totalEarnings), '.')
    
end


for i=1:length(fieldnames(earnings))
    DrawFormattedText(window, earnings.label(i), xPosField(i), yPos(i), cfg.textColor); % draws field name text    
end
    Screen('Flip', window)

for j=1:length(fieldnames(earnings))
    DrawFormattedText(window, earnings.amount(j), xPosAmounts, yPos(j), cfg.textColor); % draws field name text
    for i=1:length(fieldnames(earnings))
        DrawFormattedText(window, earnings.label(i), xPosField(i), yPos(i), cfg.textColor); % draws field name text
    end
    Screen('Flip', window)
    if i < length(fieldnames(earnings))
        waitSecs(.25)
    else
        waitSecs(.5)
    end
    
end
    
end



% Display one after the other with running total
% waitsec of about .25 secs with .5 secs for total
% Do it like a table