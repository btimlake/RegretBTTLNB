function [winnings2x2, chosenGame2x2, opponentChoice2x2] = games2x2winningsRemote(compNum, cfg, window)
% Accesses a dated file and produces a readout of individual results of  
% 2x2games, including selected game, image, adversary, player choice, 
% adversary choice and winnings.
% Written in December 2016 by Ben Timberlake, Learning and Decision Making 
% Group, University of Trento 
    
%% load data
time = str2double(datestr(now,'HHMM'));
if time < 1300
    gamesData = load(['games', datestr(now,'ddmm'), 'amA.mat']);
elseif time > 1300 && time < 1600 
    gamesData = load(['games', datestr(now,'ddmm'), 'pmB.mat']);
else
    gamesData = load(['games', datestr(now,'ddmm'), 'pmC.mat']);
end

% Find the row that corresponds to this user's information
% for 5-digit participant numbers
    %     tempString = num2str(particNum); 
    %     thisCompNum = str2num(tempString(5:6)); % Set computer name for easier matching
% for 7-digit, string-based participant number
    %     tempString = char(particNum);
    %     thisCompNum = str2num(tempString(7:8)); % Set computer name for easier matching 
% for 2-digit computer number
        datarow = find(str2num(compNum) == gamesData.global2x2.compNum); % finds which row this user's data is stored on

% Turn player choice into a number
    if gamesData.global2x2.numberChoice(datarow) == 1
        thisChoice = 'I';
    elseif gamesData.global2x2.numberChoice(datarow) == 2
        thisChoice = 'II';
    else
        disp('Something bad happened with chosenChoice')
    end

% Turn opponent choice into a number
    if gamesData.global2x2.opponentChoice(datarow) == 1
        oppChoice = 'i'; %
    elseif gamesData.global2x2.opponentChoice(datarow) == 2
        oppChoice = 'ii'; %
    else
        disp('Something bad happened with matchedChoice')
    end
    
% save opponent choice, winnings and chosen game as variables
    opponentChoice2x2 = gamesData.global2x2.opponentChoice(datarow);
    winnings2x2 = gamesData.global2x2.winnings2x2(datarow);
    chosenGame2x2 = gamesData.chosenGame;
    
% payout2x2.label = {'Gioco',  'Avversario',  'Scelta tua',  'Scelta sua',  'Guadagno'}';

% Prepare text lines for readout
text = {['Gioco: ', num2str(gamesData.chosenGame)] ...
    ['Avversario: ', num2str(gamesData.global2x2.opponent(datarow))] ...
    ['Hai scelto: ', thisChoice] ...
    ['L''avversario ha scelto: ', oppChoice] ...
    ['Hai guadagnato: ', num2str(gamesData.global2x2.winnings2x2(datarow))]};

% Get image of chosen game
trialfilename  = 'stimoli.txt';                            % Experimental list
[objnumber, objname, strategic, cooperative, competitive, naive] = textread(trialfilename,'%d %s %d %d %d %d');
stimfilename=strcat('stimoli/',char(objname(gamesData.chosenGame))); % assume stims are in subfolder "stimoli"
imdata=imread(char(stimfilename));
tex=Screen('MakeTexture', window, imdata);
imageRectPos = [cfg.screenCenter(1)-cfg.screenSize.x/5 cfg.topTextYpos+(2*cfg.fontSize) cfg.screenCenter(1)+cfg.screenSize.x/5 cfg.topTextYpos+(2*cfg.fontSize)+cfg.screenSize.y/2.5];
Screen('DrawTexture', window, tex, [], imageRectPos);

% Draw top line of text to screen
DrawFormattedText(window, char(text(1)), 'center', cfg.topTextYpos); % Result text
Screen('Flip', window)
WaitSecs(1.5);
    
% Make y positions for subsequent text lines
for i = 2:length(text)
    yPos(i) = cfg.midTextYpos + i*cfg.fontSize; % sets Y position of each line of text
end

% Add text lines one by one
for i = 2:length(text);
    Screen('DrawTexture', window, tex, [], imageRectPos);
    DrawFormattedText(window, char(text(i)), 'center', yPos(i)); % Result text
    
    for j = 2:i % redraws all previously displayed amounts
        DrawFormattedText(window, char(text(1)), 'center', cfg.topTextYpos); % Result text
        DrawFormattedText(window, char(text(j)), 'center', yPos(j));
    end
    
    Screen('Flip', window)
    WaitSecs(1.5);
end

DrawFormattedText(window, 'Si prega di attendere un attimo i prossimi resultati ... ', 'center', cfg.topTextYpos, cfg.instColA); % Result text
Screen('Flip', window, 0, 1)

% Let result sit for 5 seconds
WaitSecs(5);

end




