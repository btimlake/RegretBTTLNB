% % Script to gather all user data into one Table file
% Start in folder that contains subject folders
% now eliminated subject folders, so have to ID by file name

% % Save needed data for this part
%                 var.particNum
%                 var.sex
%                 var.age
%                 var.1shotChoice
%                 var.1shotEarnings
%                 var.forgoneEarnings
%                 var.weak-strong_order
%                 var.p1Choice1
%                 var.p2Choice1
%                 var.p1Choice2
%                 var.p2Choice2

% Set any input variables
NUMBLOCKS = 2;

priming_effect_table.Properties.VariableNames = {'subject' 'sex' 'age' ...
    'WoFChoice' 'WoFearnings' 'WoFforegone' 'PRorder' ...
    'block' 'role' 'trial' 'SubjectPR' 'ComputerPR'};

priming_effect_table.Properties.VariableDescriptions = {'' '1=f;2=m' '' ...
    '' '' '' '54=s/w; 45=w/s' ...
    '' '' '' '' ''};

subject_data_dir = dir;
subject_data = subject_data_dir(4:end); % gets all files and folders in the directory (after three invisible files)
priming_effect_table = [];

all9all = dir('*9all.mat'); % get all the instances of 9all saved files
% create a structure with PR data filenames
pr=[];
pr.(['maxbid' num2str(4)]) = dir('*3patent_race4.mat');
pr.(['maxbid' num2str(5)]) = dir('*3patent_race5.mat');

%%%%%%DELETE
% struct(1,2,3,{dir('*3patent_race4.mat')},{dir('*3patent_race5.mat')})
% pr(4,:) = dir('*3patent_race4.mat'); % get all the instances of PR weak saved files
% pr5 = dir('*3patent_race5.mat'); % get all the instances of PR strong saved files
%%%%%%

% Make sure positions match
pr_filenames = [pr.maxbid4.name; pr.maxbid5.name];
for i = 1:length(pr.maxbid4)
check = strcmp(pr.maxbid4(i).name(1:14), pr.maxbid5(i).name(1:14));
if check == 1
else
    disp('There''s a problem with files for ')
    disp(pr.maxbid4(i).name(1:14))
end
end
% make sure there's an even number of matching files
if istrue(length(pr.maxbid4) == length(pr.maxbid5))
    disp('There''s a strong and weak file for each subject')
else 
    disp('You may be missing a strong or weak file for one or more subjects.')
end




for i=1:length(all9all)
    clearvars -except i all9all pr pr_filenames priming_effect_table subject_folder_dir subject_folder NUMBLOCKS
    
%%%%%%DELETE
%     all9all(i).name;
%     particID = subject_folder(i).name; 
%     filePattern = fullfile(all9all(i).name); % Change to whatever pattern you need.
%     allData = dir(all9all(i).name);
%                 baseFileName = allData.name;
%                 fullFileName = fullfile(subject_folder(i).name, baseFileName);
%%%%%%DELETE

    subData = load(all9all(i).name);    
                
    p1Choice = [subData.player1Choice1; subData.player1Choice2];
    p2Choice = [subData.player2Choice1; subData.player2Choice2];
    
    if subData.sex == 'f'
        sex = 1;
    else
        sex = 2;
    end
    
    
    for k=1:NUMBLOCKS % go through all blocks
        maxbid_round(k) = subData.playOrder(k); % which role did player play first (4 or 5) - corresponds to filename
        pr_datafile = eval(['pr.maxbid', num2str(maxbid_round(k)), '(', num2str(i), ').name']); % construct the filename and make it a variable
        prData(k) = load(pr_datafile); % load that file        
    end
    
    
%%%%%%DELETE
%     maxbid1 = subData.playOrder(1); % which role did player play first (4 or 5) - corresponds to filename
%     pr_data1 = eval(['pr.maxbid', num2str(maxbid1), '(', num2str(i), ').name']); % construct the filename and make it a variable
%     prData1 = load(pr_data1); % load that file
%     
%     maxbid2 = subData.playOrder(2); % which role did player play first (4 or 5) - corresponds to filename
%     pr_data2 = eval(['pr.maxbid', num2str(maxbid2), '(', num2str(i), ').name']); % construct the filename and make it a variable
%     prData2 = load(pr_data2); % load that file
%%%%%%DELETE

% load(pr_data1(i).name); 
% pr_data2 = load(fullfile('pr', num2str(subData.playOrder(2)))(i).name); 

% prData1 = load(pr_data1)
% load(strcat('pr.maxbid', num2str(subData.playOrder(1)), '(', num2str(i), ').name'));
% prData1 = load([['pr', num2str(subData.playOrder(1))], '(i)', '.name']);
% 
% filePattern = fullfile(subject_folder(i).name, strcat('*3patent_race', num2str(subData.playOrder(1)), '.mat')); % Change to whatever pattern you need.
% 
% filePattern = fullfile(subject_folder(i).name, '*3patent_race5.mat'); % Change to whatever pattern you need.



for m = 1:NUMBLOCKS
    for n = 1:length(prData(m).trialnum)
        if prData(m).player1Choice(n) > prData(m).player2Choice(n)
            prData(m).outcome(n, :) = 1; % win
        elseif prData(m).player1Choice(n) < prData(m).player2Choice(n)
            prData(m).outcome(n, :) = 2; % loss
        else
            prData(m).outcome(n, :) = 3; % tie
        end
    end
end

%%%%%%HAVE TO TEST THIS
%%%%%%***Check to see if adding priming condition variable works

% add in variable for priming condition (1-regret, 2-relief, 3-disappointment, 4-satisfaction)
switch subData.1shotEarnings
    case < 0
        if subData.forgoneEarnings < 0
            disp('Something is not right with ')
            disp(subData(i).name(1:14))
        end
    case > 0
        if subData.forgoneEarnings > 0
            disp('Something is not right with ')
            disp(subData(i).name(1:14))
        end
end

if subData.1shotEarnings < subData.forgoneEarnings
    priming = 1; %regret
elseif subData.1shotEarnings > subData.forgoneEarnings
    priming = 2; %relief
end


%%%%%%DELETE
% comment out when PARTICNUM, FOREGONE, ROLE, ORDER, TRIAL, BLOCK added to variable list
%                 subData.particNum = str2num([particID(1:4) particID(6:7)]); % how to get the number to display as simple in the table?
%                 subData.particNum = fprintf(str2num([particID(1:4) particID(6:7)]), '%6.0f');
%                 if subData.total1shotEarnings == 18;
%                     subData.forgone1shotEarnings = -16;
%                 elseif subData.total1shotEarnings == 8;
%                     subData.forgone1shotEarnings = -6;
%                 elseif subData.total1shotEarnings == -16;
%                     subData.forgone1shotEarnings = 18;
%                 elseif subData.total1shotEarnings == -6;
%                     subData.forgone1shotEarnings = 8;
%                 else
%                 end
%                 ws = [01, 05, 06, 09, 13, 17, 21, 02, 10, 14, 18];
%                 particNumeral = str2num(particID(6:7));                    
%                 if ismember(particNumeral, ws) == 1
%                     subData.weak_strong_order = 45; 
%                     role1 = 4;
%                     role2 = 5;
%                 else
%                     subData.weak_strong_order = 54;
%                     role1 = 5;

% find('3patent_race4.mat') % get all the instances of 3patent_race4 saved files
% find('3patent_race5.mat') % get all the instances of 3patent_race5 saved files
% 
% organize them by block
%%%%%%DELETE


%%%%%%DELETE
% for i=1:length(subject_folder)
% %     clearvars -except i priming_effect_table subject_folder_dir subject_folder
% subject_folder(i).name;
% particID = subject_folder(i).name; 
% filePattern = fullfile(subject_folder(i).name, '*3patent_race*.mat'); % Change to whatever pattern you need.
% prData = dir(filePattern);
%                 baseFileName = prData.name;
%                 fullFileName = fullfile(subject_folder(i).name, baseFileName);
%                 subData = load(fullFileName);
%%%%%%DELETE


playOrder = repmat(subData.playOrder, 100, 1);
block = [prData(1).block.*ones(50,1); prData(2).block.*ones(50,1)];
role = [prData(1).player1maxbid.*ones(50,1); prData(2).player1maxbid.*ones(50,1)];
trial = [prData(1).trialnum; prData(2).trialnum];
p1Choice = [subData.player1Choice1; subData.player1Choice2];
p2Choice = [subData.player2Choice1; subData.player2Choice2];
outcome = [prData(1).outcome; prData(2).outcome];
particNum = eval(subData.particNum);

%%%%%%DELETE
% if subData.block == 1
%     role(1:50,:)
%     block(1:50,:)
%     trial(1:50,:)
% else 
%     role(51:100,:)
%     block(51:100,:)
%     trial(51:100,:)
% end
%                     role2 = 4;
%                 end
%                 
%                 for k=1:100
%                     trial(k,:) = k;
%                 end
%                 block(1:50,:) = 1;
%                 block(51:100,:) = 2; 
%                 role(1:50,:) = role1;
%                 role(51:100,:) = role2; 
%                 
%  priming_effect = table(subData.particNum, sex, subData.age), ...
%     subData.wof1shotChoice, subData.total1shotEarnings, subData.forgone1shotEarnings, subData.weak_strong_order, ...
%     block, role, trial, p1Choice, p2Choice);
%%%%%%DELETE

priming_effect = table(particNum.*ones(100,1), sex.*ones(100,1), subData.age.*ones(100,1), ...
    priming.*ones(100,1), subData.wof1shotChoice.*ones(100,1), subData.total1shotEarnings.*ones(100,1), subData.wof1shotForegoneAmount.*ones(100,1), subData.wof1shotReError.*ones(100,1), ...
    playOrder, block, role, trial, p1Choice, p2Choice, outcome, ...
    'VariableNames', {'subNum', 'sex', 'age', ...
    'primingCondition', 'wof1shotChoice', 'wof1shotEarn', 'wof1shotForegone', 'wof1shotReError', ...
    'playOrder', 'block', 'role', 'trial', 'p1Choice', 'p2Choice', 'outcome'});
% priming_effect.Properties.VariableUnits =  {'' '' 'Yrs'  ''  'euros'  'euros' '' 'cards' 'cards'};

priming_effect_table = [priming_effect_table; priming_effect];

end




%%%%SPECIAL SUBJECT EXCEPTION
% Subject 3009-06 has weak/strong roles reversed, due to computer location
% switching after number assignment but before playing WoF and PR. WoF
% condition remains the same as if at position 6.


% % Select the rows for patients who smoke, and a subset of the variables.
%        subject6 = priming_effect_table(priming_effect_table.subject == 300906, {'block' 'trial' 'role' 'PRorder' 'SubjectPR'})
%        
%         % Pick out two specific patients by the LastName variable.
%        priming_effect_table(ismember(num2str(priming_effect_table.subject),{'300904' '300905'}), :)
%        
%               % Make a scatter plot of two of the table's variables.
%        plot(priming_effect_table.SubjectPR,priming_effect_table.ComputerPR,'o')
        