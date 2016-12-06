function games2x2globalResults

% Make sure that only files from this session are in this directory
addpath('RegretBTTLNB', 'RegretBTTLNB/games', 'RegretBTTLNB/games/stimoli', 'Subject data/02122016pm-games/');


subject_data_dir = dir('Subject data/02122016pm-games/');
subject_data = subject_data_dir(4:end); % gets all files and folders in the directory (after three invisible files)
priming_effect_table = [];


% Determine which game will be played
chosenGame = randi(48,1,1);
% chosenGame = 45;

load('RegretBTTLNB/games/matching_responsesTABLE'); % becomes variable matchingresponses - MAC
% load('RegretBTTLNB/games/matching_responsesDATASET'); % becomes variable matchingresponses - PC
matchedGame = find(matchingresponses.column == chosenGame); % get the corresponding game from standard list

games2x2files = dir('Subject data/02122016pm-games/*1games2x2.dat'); % get all the instances of 9all saved files

% Check that there are an even number of files for the matchups
if mod(length(games2x2files),2) == 0
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
    if strcmp(chosenGameChoice, 'UpArrow') == 1
        global2x2.numberChoice(i,:) = 1;
    elseif strcmp(chosenGameChoice, 'DownArrow') == 1
        global2x2.numberChoice(i,:) = 2;
    else
        disp('Something bad happened with global2x2.chosenTrial')
    end
    
    if strcmp(matchedGameChoice, 'UpArrow') == 1
        global2x2.numberMatch(i,:) = 2; %
    elseif strcmp(matchedGameChoice, 'DownArrow') == 1
        global2x2.numberMatch(i,:) = 1;
    else
        disp('Something bad happened with global2x2.chosenTrial')
    end
    
%     tempString = gamesData.Var1(1); 
%     global2x2.compNum(i,:) = str2num(tempString(5:6)); % Set computer name for easier matching
        % Turn this one on for new string-based participant number
        tempString = char(gamesData.Var1(1));
        global2x2.compNum(i,:) = str2num(tempString(7:8)); % Set computer name for easier matching 

end

% Randomize computer numbers and put into two columns for matchups
matchPositions = global2x2.compNum(randperm(size(global2x2.compNum,1)),:);
matchPositions = [matchPositions flipud(matchPositions)];

% global2x2.opponent = global2x2.matchPositions(:,2); % sort of an extra step to simplify for loop

for i = 1:length(games2x2files)

%     global2x2.opponentPos = find(global2x2.opponent(i) == global2x2.compNum);
%     global2x2.opponentChoice(i) = global2x2.numberMatch(global2x2.opponent(i) == global2x2.compNum);
%     global2x2.opponentChoice(i) = global2x2.numberMatch(global2x2.opponent(i));

    matchRow = find(matchPositions(:,1) == i);
    global2x2.opponent(i,:) = matchPositions(matchRow,2);
    global2x2.opponentChoice(i,:) = global2x2.numberMatch(global2x2.opponent(i,:));

    switch global2x2.numberChoice(i)
        case 1
%             disp('case1')
            if global2x2.opponentChoice(i) == 1
                global2x2.winnings2x2(i,:) = matchingresponses.r_c11(chosenGame);
%                 disp('r_c11')
            else
                global2x2.winnings2x2(i,:) = matchingresponses.r_c12(chosenGame);
%                 disp('r_c12')
            end
        case 2
%             disp('case2')
            if global2x2.opponentChoice(i) == 1
                global2x2.winnings2x2(i,:) = matchingresponses.r_c21(chosenGame);
%                 disp('r_c21')
            else
                global2x2.winnings2x2(i,:) = matchingresponses.r_c22(chosenGame);
%                 disp('r_c22')
            end
    end

end    
%     type           row    column    r_c22    r_c21    r_c11    r_c12    row_column
%     'DSS_1'         2     10        7        5        4        6        ''        
%     
%     chosenGame = 2; 
%     global2x2.numberChoice = 2;
%     global2x2.opponentChoice = 1;
%     switch global2x2.numberChoice
%         case 1
%             if global2x2.opponentChoice == 1
%                 global2x2.winnings2x2 = matchingresponsesDATASET.r_c11(chosenGame);
%             else
%                 global2x2.winnings2x2 = matchingresponsesDATASET.r_c12(chosenGame);
%             end
%         case 2
%             if global2x2.opponentChoice == 1
%                 global2x2.winnings2x2 = matchingresponsesDATASET.r_c21(chosenGame);
%             else
%                 global2x2.winnings2x2 = matchingresponsesDATASET.r_c22(chosenGame);
%             end
%     end    
%     global2x2.winnings2x2
%     
    % Needed for PC?
%     switch global2x2.numberChoice
%         case 1
%             if global2x2.opponentChoice == 1
%                 global2x2.winnings2x2 = matchingresponses.r_c11(chosenGame);
%             else
%                 global2x2.winnings2x2 = matchingresponses.r_c12(chosenGame);
%             end
%         case 2
%             if global2x2.opponentChoice == 1
%                 global2x2.winnings2x2 = matchingresponses.r_c21(chosenGame);
%             else
%                 global2x2.winnings2x2 = matchingresponses.r_c22(chosenGame);
%             end
%     end


if str2num(datestr(now,'HHMM')) < 1400
    save(['games', datestr(now,'ddmm'), 'am.mat'], 'chosenGame', 'global2x2')
else
    save(['games', datestr(now,'ddmm'), 'pm.mat'], 'chosenGame', 'global2x2')
end

end