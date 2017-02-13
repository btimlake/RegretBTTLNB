function [totalEarnings] = payouts(cfg, window, particNum, DateTime, varargin)
RestrictKeysForKbCheck(cfg.enabledExpandedKeys);
% jsut varargin
% 
% then can do sanity checks for str v num

% amount1, description1, amount2, description2, amount3, description3, amount4, description4, amount5, description5, ...
%     amount6, description6, amount7, description7, 

% Eliminate variables not input
% if nargin < 13
%     amount6 = [];
%     description6 = [];
%     amount7 = [];
%     description7 = [];
% end
% 
% if nargin < 15
%     amount7 = [];
%     description7 = [];
% end

% inputs = length(nargin);
% fields = (nargin-2)/2;

fields = length(varargin);
% fields = 12

% dummy struct
    earnings.amount = NaN(fields/2, 1);
    earnings.label = NaN(fields/2, 1);
%     earningsLabel = NaN(7,1)
    earnings.runtot = NaN(fields/2, 1); % dummy struct with starting value 0
%     earningsLabel = {'Show-up pagamento';  'Rows & Colums';  'Ruota della fortuna';  'Patent Race';  'Lista dei prezzi';  'Puzzles'};
% earningsLabel(1) = 'Show-up pagamento';  
% earningsLabel(2) = 'Rows & Colums';
% earnings.label(3) = 'Ruota della fortuna';
% earnings.label(4) = 'Patent Race';
% earnings.label(5) = 'Lista dei prezzi';
% earnings.label(6) = 'Puzzles';
% earnings.label(7) = 'Totale';

%     varargin = {10, 'Show-up pagamento', winnings2x2, 'Rows & Colums', total1shotEarnings, ...
%     'Ruota della fortuna', player1Earnings, 'Patent Race', winningsMPL, 'Lista dei prezzi', ...
%     ravenWinnings, 'Puzzles'}
% earnings.amount = {[10]  [9]  [-6]  [10]  [3.8500]  [6]}'
earnings.label = {'Gettone di participazione',  'Matrici',  'Ruota della fortuna',  'Gioco delle carte',  'Lotteria dei prezzi',  'Puzzles'}';


% earnings.amount = cell2struct(varargin)

% Make the earnings structure with amounts and labels
for i = 1:2:fields
earnings.amount(ceil(i/2), 1) = cell2mat(varargin(i));
% earnAmountsMatrix(ceil(i/2)) = varargin(i); %no longer needed
% runningTotal(i) = runningTotal(i-1) + earnings.amount(i); % creates a running total for each level
end

% Just use this for label names. Can't get the names into the structure unfortunately
for i = 2:2:fields
% earnings.label(ceil(i/2)) = char(varargin(i));
earningsLabel(ceil(i/2)) = varargin(i);
end

earningsLabel(end+1) = {'Totale'}; % make 'Total' the label for final element
earnings.label(end+1) = {'Totale'}; % make 'Total' the label for final element
earningsRunTot = cumsum(earnings.amount); % create running total matrix

% convert running total matrix to struct
for i = 1:length(earningsRunTot)
earnings.runtot(i) = earningsRunTot(i);
end

% for i = 1:length(earningsLabel)
% earnings.label(i) = char(earningsLabel(:,i))
% %     earnings.label(i,1) = cellstr(earningsLabel(1,i))
% end


% Add elements for total
earnings.amount(end+1) = earningsRunTot(end); % adds total to final field
% earnAmountsMatrix(end+1) = struct2mat(earnings.amount(end); % make
% cumulative sum (total) the last amount %no longer needed %no longer needed
totalEarnings = earnings.amount(end);

% for i=length(earnings.amount)
% earnings.amount(i) = earnAmountsMatrix(i);
% earnings.label(i) = earningsLabel(i);
% end
% earnings.label(ceil(i/2), 1) = varargin(i);
% earnings.label(ceil(i/2)+1, 1) = {'Totale'}; % make final element label 
% 
% earnAmountsMatrix = cell2mat(earnings.amount); % convert cells to matrix

% Sanity checks
for k = 1:length(earnings.amount)
numTrue(k) = isnumeric(earnings.amount(k));
end

% for k = 1:length(earningsLabel)
% charTrue(k) = ischar(earningsLabel{k});
% end
for k = 1:length(earnings.label)
charTrue(k) = ischar(earnings.label{k});
end

if unique(numTrue) ~= 1 
    disp('There is a problem with the input amounts.')
elseif find(unique(numTrue)) > 1
    disp('There is a problem with the input amounts.')
elseif unique(charTrue) ~= 1
    disp('There is a problem with the input labels.')    
elseif find(unique(charTrue)) > 1
    disp('There is a problem with the input labels.')
else
    disp('Everything''s cool, baby.')
end

% Bring in the screen elements
screenXpixels=cfg.screenSize.x;
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, cfg.fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, cfg.textColor);
    
    

% earnings.a7 = 'Totale: '; % ITALIAN
% pre-allocations
textWidth = NaN(length(earnings.label), 1);
xPosField = NaN(length(earnings.label), 1);
% Get layout positions for each text field
for i=1:length(earnings.label)
    
    % % % % % % % % % %         Undefined function or variable 'earnings'.
    % % % % % % % % % %
    % % % % % % % % % % Error in payouts (line 42)
    % % % % % % % % % %     for i=1:length(fieldnames(earnings))
    if i == 1
        [nx, ny(i), textRect] = DrawFormattedText(window, earnings.label{i}, 0, 0, cfg.bgColor); % draws a dummy version of text just to get measurements
        textHeight = textRect(4)-textRect(2); % for positioning top text (based on first string)
        lineSize = 1.5*textHeight; % sets baseline shift to half the height of text (based on first string)
    else
        [nx, ny(i), textRect] = DrawFormattedText(window, earnings.label{i}, 0, ny(i-1), cfg.bgColor); % draws a dummy version of text just to get measurements
    end
        Screen('Flip', window)
        textWidth(i) = textRect(3) - textRect(1); % gets width of each label title
        xPosField(i) = cfg.screenCenter(1) - textWidth(i); % sets the position so text ends at the center of the screen
        yPos(i) = cfg.screenCenter(2) - (cfg.screenSize.y/2) + 3*lineSize + i*lineSize; % sets Y position of each line of text

    
    
end
    xPosAmounts = cfg.screenCenter(1) + textHeight; % sets starting point for numbers with arbitrary tab
    
%     for i=1:length(fieldnames(earnings))
%         runningTotal(i) = runningTotal(i-1) + earnings.amount(i);
%     end
    
    
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
% ravenWinnings;  % Puzzles

% runningTotal = runningTotal + 
% totalEarnings = sum(earnings.amount);

roundTotalEarnings = ceil(totalEarnings*10)/10;

if totalEarnings <= earnings.amount(1) % should be show-up amount
%     disp('You earned ', num2str(totalEarnings) '. 10 euro minimum awarded');
    paymentNotice = ['Hai guadagnato ', num2str(roundTotalEarnings, '%0.2f'), '\n Pagamento minimo: ' num2str(earnings.amount(1), '%0.2f') ' euros'];

else
%     disp('You earned ', num2str(totalEarnings), '.')
    paymentNotice = strcat('Pagamento: ', ' ', num2str(roundTotalEarnings, '%0.2f'), ' euros');
end

for i=1:length(earnings.label)
    DrawFormattedText(window, earnings.label{i}, xPosField(i), yPos(i), cfg.textColor); % draws all the labels with empty amounts    
end
    Screen('Flip', window)

for j=1:length(earnings.amount) % draws amount text one by one
    DrawFormattedText(window, num2str(earnings.amount(j), '%0.2f'), xPosAmounts, yPos(j), cfg.textColor); % draws newest amount text 
    if j < length(earnings.amount)
        WaitSecs(.75);
    else
        WaitSecs(1.5);
    end
    if j > 1
        for k = 1:j % redraws all previously displayed amounts
            DrawFormattedText(window, num2str(earnings.amount(k), '%0.2f'), xPosAmounts, yPos(k), cfg.textColor);
        end
    end
    for i=1:length(earnings.label)
        DrawFormattedText(window, earnings.label{i}, xPosField(i), yPos(i), cfg.textColor); % keeps all labels visible
    end
    Screen('Flip', window)
    
end
WaitSecs(1);

keyName=''; % empty initial value

while(~strcmp(keyName,'5%')) % leaves last screen up until typing 5


    for j=1:length(earnings.amount)
        DrawFormattedText(window, num2str(earnings.amount(j), '%0.2f'), xPosAmounts, yPos(j), cfg.textColor);
    end
    for i=1:length(earnings.label)
        DrawFormattedText(window, earnings.label{i}, xPosField(i), yPos(i), cfg.textColor); % keeps all labels visible
    end
    DrawFormattedText(window, paymentNotice, 'center', cfg.botTextYpos, cfg.winCol);
    
    Screen('Flip', window)
%     WaitSecs(10)
    
[~, keyCode]=KbWait([],2);
keyName=KbName(keyCode);

end

end



% Display one after the other with running total
% waitsec of about .25 secs with .5 secs for total
% Do it like a table