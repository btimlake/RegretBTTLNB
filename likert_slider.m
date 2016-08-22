function [currRatingSelection, ratingDuration] = likert_slider(window, windowRect, enabledKeys)
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
enabledKeys;

%set parameters 
scale_range = 1:1:13; %requires odd number of intervals
scale_middle = mean([1:length(scale_range)]); % gets half the scale range
% ENGLISH
% scale_question = {'Please rate how you feel';
% 'by tapping the arrow keys.'; 'Press ''SPACE'' to continue.'};
% scale_hi_label = 'positive';
% scale_middle_label = 'neutral';
% scale_low_label = 'negative';

% ITALIAN
scale_question = {'Si prega si valuta le tue emozione corrente';
'usando i tasti freccia.'; 'Clicca SPAZIO per confermare la tua scelta.'};
scale_hi_label = 'positive';
scale_middle_label = 'neutrale';
scale_low_label = 'negative';

% [window, windowRect] = Screen('OpenWindow', 0, [255, 255, 255], [0 0 640 480]); %white background
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
screenCenter = [xCenter, yCenter]; % center coordinates

% font info
fontSize = round(screenYpixels * 2/60);
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, [0, 0, 0]);hi_label_width = RectWidth(Screen('TextBounds',window,scale_hi_label));

low_label_width = RectWidth(Screen('TextBounds',window,scale_low_label));
middle_label_width = RectWidth(Screen('TextBounds',window,scale_middle_label));
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
for i=1:(scale_middle-1) % does it half as many times minus one as total length of scale (which accomodates later addition of center coordinate)
    allRatingRectXpos(i, :) = [xCenter-screenXpixels*i*.06 xCenter+screenXpixels*i*.06];
end
% Get the coordinates into one vector
lowRatingRectXpos = sort(allRatingRectXpos(:,1));
highRatingRectXpos = sort(allRatingRectXpos(:,2));
ratingRectXpos = [lowRatingRectXpos; xCenter; highRatingRectXpos]'; % adding in the center position

% Y position for circle
% ratingRectYpos = screenYpixels * 7/40; 

% Rectangle coordinates
lineRects = nan(4, length(ratingRectXpos)); % Make coordinates for top row of rectangles
for i = 1:length(ratingRectXpos) % ratingRectXpos accounts for all the rectangles, while scale_range would not
    lineRects(:, i) = CenterRectOnPointd(baseRatingRect, ratingRectXpos(i), yCenter);
end

%prepare scale question
for line_num = 1:length(scale_question)
line_width = RectWidth(Screen('TextBounds',window,scale_question{line_num}));
Screen('DrawText', window, scale_question{line_num}, screenCenter(1) - line_width/2, ...
screenCenter(2) - fontSize * (2 + length(scale_question)-line_num+1), ratingPenColor); 
end

%prepare scale line
firstPosCenter = lineRects(1,1)+ratingRectWidth/2; % Line starting point at leftmost slider position
lastPosCenter = lineRects(3,length(lineRects))-ratingRectWidth/2; %Line end point at righttmost slider position
scaleLineYpos = yCenter; % Y postion of line
% scaleLineXposLeft = lineRects(1,1); % Line starting point on leftmost slider position
% scaleLineXposRight = lineRects(1,length(lineRects)); %Line end point on righttmost slider position
Screen('DrawLine', window, ratingPenColor, lastPosCenter, scaleLineYpos, firstPosCenter, scaleLineYpos, ratingPenWidth); % Make this a line separating the sections
% Scrn('DrawLine', window, [weight    ], lineEndXpo?, [verticlend], textXpo?, [vertclstrt]; % Make this a line separating the sections

%prepare scale labels
Screen('DrawText', window, scale_low_label, ...
firstPosCenter - length(scale_low_label)*fontSize/6, ...
screenCenter(2) + fontSize*1.5, ratingPenColor);
Screen('DrawText', window, scale_middle_label, ...
screenCenter(1) - length(scale_middle_label)*fontSize/3.5, ...
screenCenter(2) + fontSize*1.5, ratingPenColor);
Screen('DrawText', window, scale_hi_label, ...
lastPosCenter - length(scale_hi_label)*fontSize/2.2, ...
screenCenter(2) + fontSize*1.5, ratingPenColor);

%prepare scale intervals
% txt_width = RectWidth(Screen('TextBounds',window,num2str(scale_range(1))));
% for i = 1:length(scale_range)
% Screen('DrawText', window, num2str(scale_range(i)), ...
% screenCenter(1) + spacing * (i - scale_middle) - txt_width/2, ...
% screenCenter(2) - fontSize/2, pencolor);
% end


%prepare rating slider 
% if abs(slider_position_old + move_slider) > (length(scale_range) - scale_middle);
% move_slider = 0; %to avoid ratings outside range of scale
% end
% slider_position_now = (slider_position_old + move_slider);
% slider_position_old = slider_position_now;

% position circle slider, but first
% change coordinates from center of circle to the corners of a box that
% would enclose the circle for use with Screen('FrameArc')
% circleRect = [screenCenter - spacing/2, screenCenter + spacing/2];
% 
% % now position circle slider
% circleRect(1:2:end) = circleRect(1:2:end) + slider_position_now * spacing;
% Screen('FrameArc', window, penColor, circleRect, 0, 360, penWidth);

% position circle slider to middle position
currRatingSelection = mean([1:length(lineRects)]);
selectedRect = lineRects(:,currRatingSelection); % get new coordinates of circle
Screen('FrameArc', window, circlePenColor, selectedRect, 0, 360, ratingPenWidth); % Draw the circle to the screen


%present drawindowg
Screen('Flip', window); % Flip to the screen
        
ratingStartTime = GetSecs;

%% Screen 1b: Presentation screen
% DrawFormattedText(window, topInstructText, textXpos, topTextYpos); % Draw betting instructions
% Screen('FrameRect', window, topColors, lineRects); % Draw the top rects to the screen
% DrawFormattedText(window, uppInstructText, textXpos, uppTextYpos); % Draw opponent explanation
% Screen('FrameRect', window, uppColors, uppRects); % Draw the upper rects to the screen

% % SANDBOXING THIS LINE DISPLAY
% [window, screenRect] = Screen('Openwindow', 0, [255, 255, 255], [0 0 640 480]); %white background
% topColors = [0, 0, 0]; % black
% windowColors = [64, 64, 64]; %gray8
% instructCola = [0, 104, 139]; %DeepSkyBlue4
% instructColb = [205,149,12]; %DarkGoldenRod3
% [screenXpixels, screenYpixels] = Screen('windowSize', window);
% [xCenter, yCenter] = RectCenter(screenRect);
% 

% DrawFormattedText(window, lowindowstructText, textXpos, low1TextYpos); % Draw reward explanation
% DrawFormattedText(window, botInstructText, textXpos, lowTextYpos); % Draw reward explanation
% Screen('FrameRect', window, botColors, lowRects); % Draw the lower rects to the screen 
% Screen('FrameRect', window, botColors, botRects); % Draw the bottom rects to the screen 
% Screen('Flip', window); % Flip to the screen


% currRatingSelection = mean([1:length(lineRects)]);
% selectedRect = lineRects(:,currRatingSelection); % get new coordinates of circle
% Screen('FrameArc', window, ratingPenColor, selectedRect, 0, 360, penWidth); % Draw the circle to the screen
% slider_position_now=7;     % Set starting choice

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

% DrawFormattedText(window, topInstructText, textXpos, topTextYpos);
% Screen('FillRect', window, topColors, SelectedRects); % Draw the top rects to the screen
% Screen('FrameRect', window, topColors, topRects);
% DrawFormattedText(window, uppInstructText, textXpos, uppTextYpos); % Draw opponent explanation
% Screen('FrameRect', window, uppColors, uppRects); % Draw the upper rects to the screen
% Screen('DrawLine', window, lineWidthPix, lineEndXpos, sepLineYpos, textXpos, sepLineYpos); % Make this a line separating the sections
% DrawFormattedText(window, lowindowstructText, textXpos, low1TextYpos); % Draw reward explanation
% DrawFormattedText(window, botInstructText, textXpos, lowTextYpos); % Draw reward explanation
% Screen('FrameRect', window, botColors, lowRects); % Draw the lower rects to the screen 
% Screen('FrameRect', window, botColors, botRects); % Draw the bottom rects to the screen 


% if currRatingSelection ~= 0
%     selectedRect = lineRects(:,currRatingSelection); % get new coordinates of circle
%     Screen('FrameArc', window, ratingPenColor, selectedRect, 0, 360, penWidth); % Draw the circle to the screen
% else
%     selectedRect=0;
% end
% 
% 
% currRatingSelection = 6;%TESTINGONLY

% latest position of circle slider
    selectedRect = lineRects(:,currRatingSelection); % get new coordinates of circle
    Screen('FrameArc', window, circlePenColor, selectedRect, 0, 360, ratingPenWidth); % Draw the circle to the screen

    for line_num = 1:length(scale_question)
        line_width = RectWidth(Screen('TextBounds',window,scale_question{line_num}));
        Screen('DrawText', window, scale_question{line_num}, screenCenter(1) - line_width/2, ...
            screenCenter(2) - fontSize * (2 + length(scale_question)-line_num+1), ratingPenColor);
    end
    Screen('DrawLine', window, ratingPenColor, lastPosCenter, scaleLineYpos, firstPosCenter, scaleLineYpos, ratingPenWidth); % Make this a line separating the sections
    Screen('DrawText', window, scale_low_label, firstPosCenter - length(scale_low_label)*fontSize/6, screenCenter(2) + fontSize*1.5, ratingPenColor);
    Screen('DrawText', window, scale_middle_label, screenCenter(1) - length(scale_middle_label)*fontSize/3.5, screenCenter(2) + fontSize*1.5, ratingPenColor);
    Screen('DrawText', window, scale_hi_label, lastPosCenter - length(scale_hi_label)*fontSize/2.2, screenCenter(2) + fontSize*1.5, ratingPenColor);

Screen('Flip', window); % Flip to the screen
              
end % ends the while loop with space bar press

ratingEndTime = GetSecs;
ratingDuration = ratingEndTime-ratingStartTime;
keyName=[];

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

end
