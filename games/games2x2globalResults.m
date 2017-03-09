function games2x2globalResults
% Accesses files in given directory, randomly chooses one game from among 48, 
% uses data to create matchups among all available files and outputs a dated 
% file for use by each user running Remote, which produces a readout of the 
% results, including game, image, adversary, player choice, adversary
% choice and winnings.
% Written in December 2016 by Ben Timberlake, Learning and Decision Making 
% Group, University of Trento

%% Files
% Set file location
% Make sure that only files from this session are in this directory
addpath('/Users/bentimberlake/Documents/MATLAB-Drive/RegretBTTLNB', '/Users/bentimberlake/Documents/MATLAB-Drive/RegretBTTLNB/games', '/Users/bentimberlake/Documents/MATLAB-Drive/RegretBTTLNB/games/stimoli', '/Users/bentimberlake/Documents/MATLAB-Drive/Subject data/24012017_pmB-games/');
subject_data_dir = dir('Subject data/24012017_pmB-games/');
subject_data = subject_data_dir(4:end); % gets all files and folders in the directory (after three invisible files)

% Determine which game will be played
chosenGame = randi(48,1,1);

% Get reference file for which row game matches with which column game
load('RegretBTTLNB/games/matching_responsesTABLE'); % becomes variable matchingresponses - MAC
% load('RegretBTTLNB/games/matching_responsesDATASET'); % becomes variable matchingresponses - PC
matchedGame = find(matchingresponses.column == chosenGame); % get the corresponding game from standard list

games2x2files = dir('/Users/bentimberlake/Documents/MATLAB-Drive/Subject data/24012017_pmB-games/*1games2x2.dat'); % get all the instances of games files

% Check that there are an even number of files for the matchups
if isempty(games2x2files)
  disp('PROBLEM: There are no files');    
elseif mod(length(games2x2files),2) == 0
  disp('There are an even number of files');
else
  disp('PROBLEM: There are an odd number of files');
end

% Get choice and match choice from each user
for i=1:length(games2x2files)
    gamesData = dataset('File', games2x2files(i).name, 'ReadVarNames', false, 'Delimiter', ' ');
    global2x2.chosenTrial(i,:) = find(gamesData.Var6 == chosenGame); % find the trial that contains the chosen game
    global2x2.matchedTrial(i,:) = find(gamesData.Var6 == matchedGame); % get the trial in which player did the matched game
    % get the choice from the chosen game
    chosenGameChoice = gamesData.Var5(global2x2.chosenTrial(i));
    matchedGameChoice = gamesData.Var5(global2x2.matchedTrial(i));
    % Convert to numbers the choice for player choice and matched choice
    % (matched choice will be provided to opponent)
    if strcmp(chosenGameChoice, 'UpArrow') == 1
        global2x2.numberChoice(i,:) = 1;
    elseif strcmp(chosenGameChoice, 'DownArrow') == 1
        global2x2.numberChoice(i,:) = 2;
    else
        disp('Something bad happened with global2x2.chosenTrial')
    end
    % These numbers are opposite for player choice because they are played 
    % as row games, but must be converted as if they were played as
    % columns.
    if strcmp(matchedGameChoice, 'UpArrow') == 1
        global2x2.numberMatch(i,:) = 2; 
    elseif strcmp(matchedGameChoice, 'DownArrow') == 1
        global2x2.numberMatch(i,:) = 1;
    else
        disp('Something bad happened with global2x2.chosenTrial')
    end

%   Set the computer number for each row, based on participant number
%   For previous, 5-digit participant numbers
%   tempString = gamesData.Var1(1); 
%   global2x2.compNum(i,:) = str2num(tempString(5:6)); % Set computer name for easier matching
%   For 7-character, string-based participant number
    tempString = char(gamesData.Var1(1));
    global2x2.compNum(i,:) = str2num(tempString(8:9)); % Set computer name for easier matching 

end

% Randomize computer numbers and put into two columns for matchups
matchPositions = global2x2.compNum(randperm(size(global2x2.compNum,1)),:);
matchPositions = [matchPositions flipud(matchPositions)];

for i = 1:length(games2x2files)
    % figure out which row belongs to the opponent, then what the opponents
    % match choice is; becomes a given player's opponent choice
    matchRow = find(matchPositions(:,1) == global2x2.compNum(i));
    global2x2.opponent(i,:) = matchPositions(matchRow,2);
    
    global2x2.opponentPosition(i,:) = find(matchPositions(:,1) == global2x2.opponent(i,:));

%     if global2x2.opponent(i,:) == 23
%         global2x2.opponentChoice(i,:) = global2x2.numberMatch(22);
%     else
    global2x2.opponentChoice(i,:) = global2x2.numberMatch(global2x2.opponentPosition(i,:));
%     end
    
    % for TABLE, winnings stored as matchingresponses.r_c(game, player choice, opponent choice)
    global2x2.winnings2x2(i,:) = matchingresponses.r_c(chosenGame, global2x2.numberChoice(i), global2x2.opponentChoice(i));
    % for DATASET winnings stored as matchingresponses{game,9}(:, player choice, opponent choice)
    % global2x2.winnings2x2(i,:) = matchingresponses{chosenGame,9}(:, global2x2.numberChoice(i), global2x2.opponentChoice(i));

end    

% Determines filename for results based on morning/afternoon session
time = str2double(datestr(now,'HHMM'));
if time < 1300
    save(['games', datestr(now,'ddmm'), 'amA.mat'], 'chosenGame', 'global2x2')
elseif time > 1300 && time < 1600 
    save(['games', datestr(now,'ddmm'), 'pmB.mat'], 'chosenGame', 'global2x2')
else
    save(['games', datestr(now,'ddmm'), 'pmC.mat'], 'chosenGame', 'global2x2')
end


end