% % Start in folder that contains subject folders

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

priming_effect_table.Properties.VariableNames = {'subject' 'sex' 'age' ...
    'WoFChoice' 'WoFearnings' 'WoFforegone' 'PRorder' ...
    'block' 'role' 'trial' 'SubjectPR' 'ComputerPR'};

priming_effect_table.Properties.VariableDescriptions = {'' '1=f;2=m' '' ...
    '' '' '' '54=s/w; 45=w/s' ...
    '' '' '' '' ''};

subject_folder_dir = dir;
subject_folder = subject_folder_dir(4:end);
priming_effect_table = [];

for i=1:length(subject_folder)
    clearvars -except i priming_effect_table subject_folder_dir subject_folder
subject_folder(i).name;
particID = subject_folder(i).name; 
filePattern = fullfile(subject_folder(i).name, '*9all.mat'); % Change to whatever pattern you need.
allData = dir(filePattern);
                baseFileName = allData.name;
                fullFileName = fullfile(subject_folder(i).name, baseFileName);
                subData = load(fullFileName);
                
p1Choice = [subData.player1Choice1; subData.player1Choice2];
p2Choice = [subData.player2Choice1; subData.player2Choice2];

if subData.sex == 'f'
    sex = 1;
else 
    sex = 2; 
end

                % comment out when PARTICNUM, FOREGONE, ROLE, ORDER, TRIAL, BLOCK added to variable list
                subData.particNum = str2num([particID(1:4) particID(6:7)]); % how to get the number to display as simple in the table?
%                 subData.particNum = fprintf(str2num([particID(1:4) particID(6:7)]), '%6.0f');
                if subData.total1shotEarnings == 18;
                    subData.forgone1shotEarnings = -16;
                elseif subData.total1shotEarnings == 8;
                    subData.forgone1shotEarnings = -6;
                elseif subData.total1shotEarnings == -16;
                    subData.forgone1shotEarnings = 18;
                elseif subData.total1shotEarnings == -6;
                    subData.forgone1shotEarnings = 8;
                else
                end
                ws = [01, 05, 06, 09, 13, 17, 21, 02, 10, 14, 18];
                particNumeral = str2num(particID(6:7));                    
                if ismember(particNumeral, ws) == 1
                    subData.weak_strong_order = 45; 
                    role1 = 4;
                    role2 = 5;
                else
                    subData.weak_strong_order = 54;
                    role1 = 5;
                    role2 = 4;
                end
                
                for k=1:100
                    trial(k,:) = k;
                end
                block(1:50,:) = 1;
                block(51:100,:) = 2; 
                role(1:50,:) = role1;
                role(51:100,:) = role2; 
                
%  priming_effect = table(subData.particNum, sex, subData.age), ...
%     subData.wof1shotChoice, subData.total1shotEarnings, subData.forgone1shotEarnings, subData.weak_strong_order, ...
%     block, role, trial, p1Choice, p2Choice);
               
priming_effect = table(subData.particNum.*ones(100,1), sex.*ones(100,1), subData.age.*ones(100,1), ...
    subData.wof1shotChoice.*ones(100,1), subData.total1shotEarnings.*ones(100,1), subData.forgone1shotEarnings.*ones(100,1), subData.weak_strong_order.*ones(100,1), ...
    block, role, trial, p1Choice, p2Choice);
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
        