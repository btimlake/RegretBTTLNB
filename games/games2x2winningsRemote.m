function [winnings2x2, chosenGame2x2, opponentChoice2x2] = games2x2winningsRemote(compNum, cfg, window)

% %% Developing/debugging material
% addpath('REGRET_task', 'patentTaskBTMP', 'ratingslider', 'instructions', 'games', 'games/stimoli');
% 
% PsychDefaultSetup(2);
% screens = Screen('Screens');
% screenNumber = 1;
% white = WhiteIndex(screenNumber);
% black = BlackIndex(screenNumber);
% % [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]); % for one screen setup 
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); % for two-screen setup
% [xCenter, yCenter] = RectCenter(windowRect);
%  
% particNum = '1212am02'; 
% DateTime = '0101-1235'; 
% enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]);
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
% 
%     cfg.enabledSelectKeys = [44, 79, 80]; % limit recognized presses to space, left, right arrows MAC
%     cfg.enabledExpandedKeys = [30, 34, 44, 79:82, 89, 93]; % limit recognized presses to 1!, 5%, space, left, right, up, down arrows, keypad1, keypad5 MAC
%     cfg.limitedKeys = [79, 80]; % limit recognized presses to left, right arrows MAC
%     cfg.enabledNumberKeys = [30:40, 55, 89:99,]; % limit recognized presses to 1-10, return, decimal, keypad 1-10 & decimal MAC
% 
% cfg.screenSize.x = screenXpixels; 
% cfg.screenSize.y = screenYpixels;
% cfg.font = 'Courier New';
% cfg.fontSize = round(screenYpixels * 2/40);
% % Colors
% cfg.textColor = [0, 0, 0]; % black
% % cfg.bgColor = [255, 255, 255];
% cfg.bgColor = [1 1 1]; % white
% cfg.instColA = [0, 0.4078, 0.5451]; %DeepSkyBlue4
% cfg.instColB = [0.8039, 0.5843, 0.0471]; %DarkGoldenRod3
% cfg.p1Col = [0, 0, 0.8039]; %MediumBlue
% cfg.p2Col = [0.4314, 0.4824, 0.5451]; % LightSteelBlue4
% cfg.winCol = [.1333, .5451, .1333]; %ForestGreen
% % Positions
% cfg.screenCenter = [xCenter, yCenter]; % center coordinatesf
% cfg.topTextYpos = screenYpixels * 2/40; % Screen Y positions of top/instruction text
% cfg.uppTextYpos = screenYpixels * 6/40;
% cfg.midTextYpos = screenYpixels * 20/40;
% cfg.botTextYpos = screenYpixels * 35/40; % Screen Y positions of bottom/result text
% cfg.waitTextYpos = screenYpixels * 38/40; % Y position of lowest "Please Wait" text
% cfg.LeftTextXpos = screenXpixels*.035;
% 
% cfg.fontSizeSmall = round(cfg.fontSize/2);
% 
%     Screen('TextFont', window, cfg.font);
%     Screen('TextSize', window, cfg.fontSizeSmall);
%     Screen('TextStyle', window);
%     Screen('TextColor', window, cfg.textColor);
% %     Screen('Preference', 'TextAlphaBlending', 1);
% 	oldTextBackgroundColor=Screen('TextBackgroundColor', window, [255 255 255]); 
    
%% load data
if str2num(datestr(now,'HHMM')) < 1200
    gamesData = load(['games', datestr(now,'ddmm'), 'am.mat']);
else
    gamesData = load(['games', datestr(now,'ddmm'), 'pm.mat']);
end

    % for 5-digit participant numbers
    %     tempString = num2str(particNum); 
    %     thisCompNum = str2num(tempString(5:6)); % Set computer name for easier matching
        % Turn this one on for new string-based participant number
%         tempString = char(particNum);
%         thisCompNum = str2num(tempString(7:8)); % Set computer name for easier matching 

        datarow = find(str2num(compNum) == gamesData.global2x2.compNum); % finds which row this user's data is stored on

% from games file, save a file with simplified name
% on the server, there has to be a script that collates all the submitters,
   % pull all the games files into one server
   % script that collates data into one six-column file; redistribute this
   % to the 2 or three servers
% randomizes them and then provides the information for this script
% maybe into one file that they all go looking for named for date and
% afternoon or morning session
% run that script as soon as they do the one-shot?

% use payouts script
% have it display the game image
% have it display the opponent's number
% have it display the player's choice
% have it dispaly the opponent's choice
% info on single row: computer number, game, player choice, opponent,
% opponent choice, winnings

    if gamesData.global2x2.numberChoice(datarow) == 1
        thisChoice = 'I';
    elseif gamesData.global2x2.numberChoice(datarow) == 2
        thisChoice = 'II';
    else
        disp('Something bad happened with chosenChoice')
    end
    
    if gamesData.global2x2.opponentChoice(datarow) == 1
        oppChoice = 'i'; %
    elseif gamesData.global2x2.opponentChoice(datarow) == 2
        oppChoice = 'ii'; %
    else
        disp('Something bad happened with matchedChoice')
    end
    
    opponentChoice2x2 = gamesData.global2x2.opponentChoice(datarow);
    winnings2x2 = gamesData.global2x2.winnings2x2(datarow);
    chosenGame2x2 = gamesData.chosenGame;
    
payout2x2.label = {'Gioco',  'Avversario',  'Scelta tua',  'Scelta sua',  'Guadagno'}';

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
% Screen('DrawTexture', window, tex, [], imageRectPos);
    Screen('DrawTexture', window, tex, [], imageRectPos);

DrawFormattedText(window, char(text(1)), 'center', cfg.topTextYpos); % Result text
Screen('Flip', window)
    WaitSecs(1.5);
    
for i = 2:length(text)
    yPos(i) = cfg.midTextYpos + i*cfg.fontSize; % sets Y position of each line of text
end
    
nyi = cfg.midTextYpos;
nyj = nyi+(cfg.fontSize);
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

WaitSecs(5);

end





