

function [choicesHPS] = HPSquestionnaire(cfg, particNum, DateTime, window, windowRect)

%% Developing/debugging material
addpath('REGRET_task', 'patentTaskBTMP', 'ratingslider', 'instructions', 'games', 'games/stimoli');

PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = 0;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]); % for one screen setup 
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); % for two-screen setup
[xCenter, yCenter] = RectCenter(windowRect);
 
particNum = '1212'; 
DateTime = '0101-1235'; 
enabledKeys = RestrictKeysForKbCheck([30, 44, 79, 80, 81,82]);
addpath('questionnaires');
load('citpromptARRAY.mat')       % Load CIT prompts and responses DATASET - PC Lab
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

cfg.screenSize.x = screenXpixels; 
cfg.screenSize.y = screenYpixels;
cfg.font = 'Courier New';
cfg.fontSize = round(screenYpixels * 2/40);
% Colors
cfg.textColor = [0, 0, 0]; % black
% cfg.bgColor = [255, 255, 255];
cfg.bgColor = [1 1 1]; % white
cfg.instColA = [0, 0.4078, 0.5451]; %DeepSkyBlue4
cfg.instColB = [0.8039, 0.5843, 0.0471]; %DarkGoldenRod3
cfg.p1Col = [0, 0, 0.8039]; %MediumBlue
cfg.p2Col = [0.4314, 0.4824, 0.5451]; % LightSteelBlue4
cfg.winCol = [.1333, .5451, .1333]; %ForestGreen
% Positions
cfg.screenCenter = [xCenter, yCenter]; % center coordinatesf
cfg.topTextYpos = screenYpixels * 2/40; % Screen Y positions of top/instruction text
cfg.uppTextYpos = screenYpixels * 6/40;
cfg.botTextYpos = screenYpixels * 35/40; % Screen Y positions of bottom/result text
cfg.waitTextYpos = screenYpixels * 38/40; % Y position of lowest "Please Wait" text
cfg.LeftTextXpos = screenXpixels*.035;

cfg.fontSizeSmall = round(cfg.fontSize/2);

    Screen('TextFont', window, cfg.font);
    Screen('TextSize', window, cfg.fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, cfg.textColor);
%     Screen('Preference', 'TextAlphaBlending', 1);
% 	oldTextBackgroundColor=Screen('TextBackgroundColor', window, [255 255 255]); 
    
% HPS
% SCREENS: 4
% QUESTIONS/SCREEN: 12
% CHOICES: 2
% PROMPTS: images
% RESPONSE: move rectangle, click 'space'
% output answers
% compare to answer file
% output assessment
% Do this just like the MPL, just over four or so pages

% screen 1: first instruction screen
% screen 2: real choices
  % - change instructs to say using l/r arrows, 
% - up/down arrows to change rows
% - space to confirm all choices
%  - change instructs to say choice becomes yellow
% screen 3: game gets played
% - random selection of game 1-10 (have it run through like in WoF?)
% - random choice 1-10 (0-first prob (70 = 1-7) gets top row prize. Second prob-1 (30 = 8-10) gets lower row prize) 
%         - have it run through like WoF?
% - show  result

addpath('questionnaires');
% load('citpromptARRAY.mat')       % Load CIT prompts and responses DATASET - PC Lab
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


end