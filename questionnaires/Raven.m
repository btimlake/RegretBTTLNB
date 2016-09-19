function [ravenChoice, ravenWinnings] = Raven(cfg, particNum, DateTime, window, windowRect)
% 
% RAVEN
% SCREENS: 30
% QUESTIONS/SCREEN: 1
% CHOICES: 8/screen
% PROMPTS: images
% RESPONSE: move rectangle, click 'space'
% Make responses a separate image
%     - make consistent size; measure each as a proportion of size
%     - calculate rects and positions based on that proportion
% output answers
% compare to answer file
% output correct & score/winnings

% screen 1: Questionnaire 3/5. You will see 30 pattern grids. For each one, you should choose the
% option that best completes the grid. 
% screen 2-31: pattern and getechostringform
% calculate results based on key
% return winnings for payout


addpath('questionnaires/ravenimages/');
% load('citpromptARRAY.mat')       % Load CIT prompts and responses DATASET - PC Lab
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
% [xCenter, yCenter] = RectCenter(windowRect);

%% Developing/debugging material
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = 0;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]); % for one screen setup 
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white); % for two-screen setup
[xCenter, yCenter] = RectCenter(windowRect);
 
particNum = '1212'; 
DateTime = '0101-1234'; 
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
cfg.bgColor = [1, 1, 1]; % white
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

%% Image source
% Specify the folder where the files live.
sourceFolder = 'questionnaires/ravenimages/';
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(sourceFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', sourceFolder);
  uiwait(warndlg(errorMessage));
  return;
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(sourceFolder, '*.jpeg'); % Change to whatever pattern you need.
ravenImages = dir(filePattern);

%% EXPLANATION SCREEN
keyName = ''; 

while ~strcmp(keyName,'space')
    
Screen('TextStyle', window,1); % bold
DrawFormattedText(window,'QUESTIONARIO 3/5', 'center', cfg.topTextYpos, cfg.textColor);

Screen('TextStyle', window,0); % back to plain
DrawFormattedText(window,'Ora vedrai 30 griglia dei simboli. Per ognuno, scegli l''alternativa che meglio completa la griglia. Guadagni 0.20 euro per ogni risposta giusta. Poi vincere 6 euro in totale.',...
    'center', cfg.uppTextYpos, cfg.textColor, 50);
 
Screen('Flip', window);

[~, keyCode]=KbWait([],2);
keyName=KbName(keyCode);

end


%% Set variables to fill in
NUMROUNDS = length(ravenImages); % unused for now; repalced by 
ravenChoice = NaN(NUMROUNDS, 1);

ravenInput = 'Inserisci il numero dell?alternativa che meglio completa la griglia e premi "spazio": ';





%% Loop of images
for k = 1 : NUMROUNDS
    baseFileName = ravenImages(k).name;
    fullFileName = fullfile(sourceFolder, baseFileName);
    %   fprintf(1, 'Now reading %s\n', fullFileName);
    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
    imageArray = imread(fullFileName);
    %   imshow(imageArray);  % Display image.
    %   drawnow; % Force display to update immediately.
    % make texture image out of image matrix 'imdata'
    tex=Screen('MakeTexture', window, imageArray);
    % Draw texture image to backbuffer. It will be automatically
    % centered in the middle of the display if you don't specify a
    % different destination:
    Screen('DrawTexture', window, tex);
    
    trialStartTime(k) = GetSecs; 
    ravenChoice(puzzle) = str2double(GetEchoString(window, ravenInput, 'center', cfg.botTextYpos, cfg.textColor)); % displays string in PTB; allows backspace
    trialEndTime(k) = GetSecs; % after choice
    Screen('Flip', window)
end
    
%               stimfilename=strcat('ravenimages/raven.',char(objname(trial, '%.3f'))); % assume stims are in subfolder "stimoli"
%              
%             imdata=imread(char(stimfilename));
%             
%             Screen('FillRect',w,silver,wRect);
%            
%            
% 
%             
%             
%             % Show stimulus on screen at next possible display refresh cycle,
%             % and record stimulus onset time in 'startrt':
%             
%              [VBLTimestamp startrt]=Screen('Flip', w,tfixation + 1.000);
% 

%% Compute results



%% Calculate trial length, save data
for i=1:NUMROUNDS
        trialLength(i) = trialEndTime(i)-trialStartTime(i);
end

save(['sub' num2str(particNum) '-' num2str(DateTime) '_q3Raven'], 'ravenChoice', 'ravenKey', 'ravenWinnings', 'trialLength');

end