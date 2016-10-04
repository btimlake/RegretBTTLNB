function [rating, ratingDuration, normalizedChoice, computerSide] = debrief_slider(particNum, DateTime, window, windowRect, enabledKeys)
% function [slider_position_now] = likert_slider(screenInfo, slider_position_old, move_slider)

% draw rating line
% sepLineYpos = screenYpixels * 39/80; % Screen Y position of separator line
% textXpos = round(screenXpixels * 0.09 - screenXpixels * 2/56); % left position of text and separator line
% lineEndXpos = round(screenXpixels * 0.91 + screenXpixels * 2/56); % right endpoint of separator line

% write instruction

% code mouse response
% or use arrows

% space bar to continue

% wdw_pointer = screenInfo.curwindow; % pointer to current window
% center = screenInfo.center; %physical center of scale
% if nargin < 2
% slider_position_old = 0;
% move_slider = 0;
% end
% if nargin < 3
% move_slider = 0;
% end

% slider_position_old = 0;
% move_slider = 1;
% RestrictKeysForKbCheck([37,39,32,49]); % limit recognized presses to left and right arrows PC
% may not be necessary with broader Restrict Keys in umbrella script
if ismac
    % Code to run on Mac plaform 
    disp('Mac');
    disabledKeys=[];
    skipSyncTest=[];
    screenRes=[];
    enabledKeys = RestrictKeysForKbCheck([30, 34, 44, 79, 80, 81,82]); % limit recognized presses to 1!, 5%, space, left, right, up, down arrows MAC
%     enabledKeys = RestrictKeysForKbCheck([]); % for debugging
elseif isunix
    % Code to run on Linux plaform
    disp('Unix');
elseif ispc
    % Code to run on Windows platform
    disp('PC');
    enabledKeys = RestrictKeysForKbCheck([49,53,32,37,38,39,40]); % limit recognized presses to 1!, 5%, space, left, right, up, down arrows PC

else
    disp('Platform not supported')
end

%set parameters
scale_range = 1:1:13; %requires odd number of intervals
scale_middle = mean([1:length(scale_range)]); % gets half the scale range
BG=[1 1 1]; % set background color of JPG imports

% left image position
% line start, 2/39th line length down, 1/13th line length around

for i=1:2
    
    % [window, windowRect] = Screen('OpenWindow', 0, [255, 255, 255], [0 0 640 480]); %white background
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    screenCenter = [xCenter, yCenter]; % center coordinates
    yUnits = screenYpixels/20;
    xUnits = screenXpixels/20;
    
    % font info
    fontSize = round(screenYpixels * 2/60);
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, [0, 0, 0]);
    
    spacing = 60; %physical spacing of scale intervals in pixel units
    ratingPenWidth = screenXpixels/200; % thickness of circle cursor that moves along the scale
    circlePenColor = [.1333, .5451, .1333]; %ForestGreen
    % ratingPenColor = [33.9915  139.0005   33.9915]; %ForestGreen
    ratingPenColor = [0 0 0]; %black
    ratingRectWidth = screenXpixels * 3 / 60;
    ratingRectHeight = screenYpixels * 6 / 60;
    baseRatingRect = [0 0 ratingRectWidth ratingRectHeight];
    
    
    % generate x coordinates for circle positions based on length of scale
    % (added two at a time on either side of center)
    for j=1:(scale_middle-1) % does it half as many times minus one as total length of scale (which accomodates later addition of center coordinate)
        allRatingRectXpos(j, :) = [xCenter-screenXpixels*j*.06 xCenter+screenXpixels*j*.06];
    end
    % Get the coordinates into one vector
    lowRatingRectXpos = sort(allRatingRectXpos(:,1));
    highRatingRectXpos = sort(allRatingRectXpos(:,2));
    ratingRectXpos = [lowRatingRectXpos; xCenter; highRatingRectXpos]'; % adding in the center position
    
    % Y position for circle
    % ratingRectYpos = screenYpixels * 7/40;
    
    % Rectangle coordinates
    lineRects = nan(4, length(ratingRectXpos)); % Make coordinates for top row of rectangles
    for j = 1:length(ratingRectXpos) % ratingRectXpos accounts for all the rectangles, while scale_range would not
        lineRects(:, j) = CenterRectOnPointd(baseRatingRect, ratingRectXpos(j), yCenter);
    end
    
    if i==1
        scale_question = {'ho avuto l''impressione di stare giocando con:' ;'Durante il gioco delle carte Patent Race,'}; % reverse order due to how y position is calculated away from center
        scale_instructions = {'Usa sempre i tasti freccia.'; 'Premi "spazio" per continuare.'};
        scale_middle_label = '?';
        scale_hi_label = ''; % leave the text label areas empty
        scale_low_label = '';
        %prepare scale images
        human=imread('human.jpg'); %load image of human
        computer=imread('computer.jpg'); %load image of computer
        
        computerSide = CoinFlip(1,.5); % alternate whether human/computer is on right/left
        if computerSide == 1 % Computer choice is 7-13
            scale_hi_image = computer;
            scale_low_image = human;
            
        else % Computer choice is 1-7
            scale_hi_image = human;
            scale_low_image = computer;
            
        end
        
    else
        scale_question = {'a seconda delle mie scelte:'; 'il mio avversario cambiava la sua strategia'; 'Durante il gioco delle carte Patent Race,'}; % reverse order due to how y position is calculated away from center
        scale_instructions = {'Usa sempre i tasti freccia.'; 'Premi "spazio" per continuare.'};
        scale_hi_label = 'molto';
        scale_middle_label = 'neutrale';
        scale_low_label = 'per niente';
        dummy=imread('dummy.jpg'); %load image of nothing
        scale_hi_image = dummy; % hopefully just shows no image
        scale_low_image = dummy;
        
        %         hi_label_width = RectWidth(Screen('TextBounds',window,scale_hi_label));
        %         low_label_width = RectWidth(Screen('TextBounds',window,scale_low_label));
        %         middle_label_width = RectWidth(Screen('TextBounds',window,scale_middle_label));
        
    end
    
    
    % scale_QxPos = screenCenter(1) - line_width/2;
    % scale_QyPos = yCenter - 2*(-line_num*yUnits
    % scale_InstxPos = screenCenter(1) - line_width/2;
    % scale_InstyPos = yCenter + 2*(line_num+2)*yUnits
    %prepare scale question
    for line_num = 1:length(scale_question)
        line_width = RectWidth(Screen('TextBounds',window,scale_question{line_num}));
        Screen('DrawText', window, scale_question{line_num}, screenCenter(1) - line_width/2, ...
            yCenter - 2*(line_num)*yUnits, ratingPenColor);
    end
    
    %prepare scale instructions
    Screen('TextStyle', window, 2);
    for line_num = 1:length(scale_instructions)
        line_width = RectWidth(Screen('TextBounds',window,scale_instructions{line_num}));
        Screen('DrawText', window, scale_instructions{line_num}, screenCenter(1) - line_width/2, ...
            yCenter + 2*(line_num+2)*yUnits, ratingPenColor);
    end
    Screen('TextStyle', window, 0);
    
    
    %prepare scale line
    firstPosCenter = lineRects(1,1)+ratingRectWidth/2; % Line starting point at leftmost slider position
    lastPosCenter = lineRects(3,length(lineRects))-ratingRectWidth/2; %Line end point at righttmost slider position
    scaleLineYpos = yCenter; % Y postion of line
    % scaleLineXposLeft = lineRects(1,1); % Line starting point on leftmost slider position
    % scaleLineXposRight = lineRects(1,length(lineRects)); %Line end point on righttmost slider position
    Screen('DrawLine', window, ratingPenColor, lastPosCenter, scaleLineYpos, firstPosCenter, scaleLineYpos, ratingPenWidth); % Make this a line separating the sections
    % Scrn('DrawLine', window, [weight    ], lineEndXpo?, [verticlend], textXpo?, [vertclstrt]; % Make this a line separating the sections
    
    
    %prepare scale image positions
    lineLength = lastPosCenter - firstPosCenter;
    imageYpos = scaleLineYpos + 2*yUnits;
    leftImageXpos = firstPosCenter - xUnits;
    rightImageXpos = lastPosCenter + xUnits;
    leftImageRect = [leftImageXpos-xUnits imageYpos-yUnits leftImageXpos+xUnits imageYpos+yUnits];
    rightImageRect = [rightImageXpos-xUnits imageYpos-yUnits rightImageXpos+xUnits imageYpos+yUnits];
    
    texLowLabelImage = Screen('MakeTexture', window, scale_low_image); % Draw image to the offscreen window
    texHiLabelImage = Screen('MakeTexture', window, scale_hi_image); % Draw image to the offscreen window
    Screen('DrawTexture', window, texLowLabelImage, [0 0 300 300], leftImageRect);
    Screen('DrawTexture', window, texHiLabelImage, [0 0 300 300], rightImageRect);
    
    %prepare scale labels
    Screen('DrawText', window, scale_low_label, ...
        firstPosCenter - length(scale_low_label)*fontSize/6, ...
        screenCenter(2) + fontSize*1.5, ratingPenColor);
    Screen('DrawText', window, scale_middle_label, ...
        screenCenter(1) - length(scale_middle_label)*fontSize/3.5, ...
        imageYpos, ratingPenColor);
    Screen('DrawText', window, scale_hi_label, ...
        lastPosCenter - length(scale_hi_label)*fontSize/2.2, ...
        screenCenter(2) + fontSize*1.5, ratingPenColor);
    
    % position circle slider to middle position
    currRatingSelection = mean([1:length(lineRects)]);
    selectedRect = lineRects(:,currRatingSelection); % get new coordinates of circle
    Screen('FrameArc', window, circlePenColor, selectedRect, 0, 360, ratingPenWidth); % Draw the circle to the screen
    
    
    %present drawindowg
    Screen('Flip', window); % Flip to the screen
    
    ratingStartTime = GetSecs;
    
    %% Screen 1b: Presentation screen
    
    keyName=''; % empty initial value
    
    while(~strcmp(keyName,'space')) % continues until current keyName is space
        
        [keyTime, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
        switch keyName
            case 'LeftArrow'
                currRatingSelection = currRatingSelection - 1;
                if currRatingSelection < 1
                    currRatingSelection = 1;
                end
            case 'RightArrow'
                currRatingSelection = currRatingSelection + 1;
                if currRatingSelection > length(scale_range)
                    currRatingSelection = max(scale_range);
                end
        end
        % update selection to last button press
        
        % latest position of circle slider
        selectedRect = lineRects(:,currRatingSelection); % get new coordinates of circle
        Screen('FrameArc', window, circlePenColor, selectedRect, 0, 360, ratingPenWidth); % Draw the circle to the screen
        
        % scale question
        for line_num = 1:length(scale_question)
            line_width = RectWidth(Screen('TextBounds',window,scale_question{line_num}));
            Screen('DrawText', window, scale_question{line_num}, screenCenter(1) - line_width/2, ...
                yCenter - 2*(line_num)*yUnits, ratingPenColor);
        end
        
        %prepare scale instructions
        Screen('TextStyle', window, 2);
        for line_num = 1:length(scale_instructions)
            line_width = RectWidth(Screen('TextBounds',window,scale_instructions{line_num}));
            Screen('DrawText', window, scale_instructions{line_num}, screenCenter(1) - line_width/2, ...
                yCenter + 2*(line_num+2)*yUnits, ratingPenColor);
        end
        Screen('TextStyle', window, 0);
        
        Screen('DrawLine', window, ratingPenColor, lastPosCenter, scaleLineYpos, firstPosCenter, scaleLineYpos, ratingPenWidth); % Make this a line separating the sections
        
        Screen('DrawTexture', window, texLowLabelImage, [0 0 300 300], leftImageRect);
        Screen('DrawTexture', window, texHiLabelImage, [0 0 300 300], rightImageRect);
        Screen('DrawText', window, scale_low_label, ...
            firstPosCenter - length(scale_low_label)*fontSize/6, ...
            screenCenter(2) + fontSize*1.5, ratingPenColor);
        Screen('DrawText', window, scale_middle_label, ...
            screenCenter(1) - length(scale_middle_label)*fontSize/3.5, ...
            imageYpos, ratingPenColor);
        Screen('DrawText', window, scale_hi_label, ...
            lastPosCenter - length(scale_hi_label)*fontSize/2.2, ...
            screenCenter(2) + fontSize*1.5, ratingPenColor);
        
        Screen('Flip', window); % Flip to the screen
        
    end % ends the while loop with space bar press
    
    ratingEndTime = GetSecs;
    keyName=[];
    
    %% normalize computerChoice
    if i==1 && computerSide == 1 % First question Computer choice is 7-13
        normalizedChoice = currRatingSelection;
    elseif i==1 && computerSide == 0
        normalizedChoice = 14 - currRatingSelection; % makes computer choice 7-13 instead of 1-7
    end
    
    
    
    %% outputs
    
    % for i=1:2
    rating(i) = currRatingSelection;
    ratingDuration(i) = ratingEndTime-ratingStartTime;
    normalized(i) = normalizedChoice;
    % end
end
%currRatingSelection(1:2)
%ratingDuration
%normalizedChoice
%computerSide (if computerSide == 1, Computer choice is 7-13; 0, computer is 1-7)


% Selection text strings

%     player1ChoiceInd = emotionalRating(i)+1;      %because choosing 0 is an option, there's a discrepancy between choices and index of options...
%
%     player2Choice(i)=find(rand < cumsum(exp(player2Options.*TAU)/sum(exp(player2Options.*TAU))),1);  % uses softmax to make a choice (TAU -> 0 = more random)
%
%     player1Earnings(i) = PLAYER1MAXBID + (PRIZE-emotionalRating(i))*(player1ChoiceInd > player2Choice(i)) - emotionalRating(i)*(player1ChoiceInd<=player2Choice(i)); %calculates how much the strong player windows
%     player2Earnings(i) = PLAYER2MAXBID + (PRIZE-player2Choice(i))*(player2Choice(i) > player1ChoiceInd) - player2Choice(i)*(player2Choice(i)<=player1ChoiceInd); %calculates how much the weak player windows
%     player2Options = player2Update(player2Options, player2Strategy, player2Choice(i), player2Earnings(i), player1ChoiceInd, PRIZE, PLAYER2MAXBID);  %calls the function that determines how player2 will update its values
%
% RestrictKeysForKbCheck([]); % re-recognize all key presses

save(['sub' num2str(particNum) '-' DateTime '_6debrief'], 'rating', 'normalizedChoice', 'ratingDuration', 'computerSide');



end