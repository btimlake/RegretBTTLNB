clear

% win = 10 %COMMENT AFTER DEBUGGING
% screenRect = [0 0 640 480] %COMMENT AFTER DEBUGGING
[win, screenRect] = Screen('OpenWindow', 0, [0 0 0], [0 0 640 480]);

% Make a base Rect of 30 by 40 pixels
baseRect = [0 0 30 40];

% Get the size of the on-screen window
% screenXpixels=640 %COMMENT AFTER DEBUGGING
% screenYpixels=480 %COMMENT AFTER DEBUGGING
[screenXpixels, screenYpixels] = Screen('WindowSize', win);
% RESTORE AFTER DEBUGGING
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(screenRect);

% Screen X positions of top five rectangles
topRectXpos = round([screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36 screenXpixels * 0.45]);
numtopRect = length(topRectXpos);
% Screen X positions of upper four rectangles
uppRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36];
numuppRect = length(uppRectXpos);
% Screen X positions of bottom ten rectangles
botRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36 screenXpixels * 0.45 screenXpixels * 0.54 screenXpixels * 0.63 screenXpixels * 0.72 screenXpixels * 0.81 screenXpixels * 0.9];
numbotRect = length(botRectXpos);

% Screen Y positions of top five rectangles
topRectYpos = screenYpixels * 0.2;
% Screen Y positions of upper four rectangles
uppRectYpos = screenYpixels * 0.4;
% Screen Y positions of bottom ten rectangles
botRectYpos = screenYpixels * 0.8;

% Make coordinates for top row of rectangles
topRects = nan(4, 3);
for i = 1:numtopRect
    topRects(:, i) = CenterRectOnPointd(baseRect, topRectXpos(i), topRectYpos);
end

% Make coordinates for upper row of rectangles
uppRects = nan(4, 3);
for i = 1:numuppRect
    uppRects(:, i) = CenterRectOnPointd(baseRect, uppRectXpos(i), uppRectYpos);
end

% Make coordinates for bottom row of rectangles
botRects = nan(4, 3);
for i = 1:numbotRect
    botRects(:, i) = CenterRectOnPointd(baseRect, botRectXpos(i), botRectYpos);
end

%set colors to blue, yellow, green
topColors = [0, 0, 255];
uppColors = [255, 200, 0];
botColors = [40, 155, 40];

% Screen Y positions of top text
topTextYpos = screenYpixels * 0.1;
% Screen Y positions of upper text
uppTextYpos = screenYpixels * 0.3;
% Screen Y positions of bottom text
botTextYpos = screenYpixels * 0.7;

% Select specific text font, style and size:
    Screen('TextFont', win, 'Courier New');
    Screen('TextSize', win, 24);
    Screen('TextStyle', win);

% Instruction text strings
topInstructText = 'Select your investment (up to 5)';
uppInstructText = 'Your opponent can invest up to 4';
botInstructText = 'You can win 10';

% Draw betting instructions
DrawFormattedText(win, topInstructText, topRectXpos(1), topTextYpos)
% Draw the top rects to the screen
Screen('FrameRect', win, topColors, topRects);

% Draw opponent explanation
DrawFormattedText(win, uppInstructText, uppRectXpos(1), uppTextYpos)
% Draw the upper rects to the screen
Screen('FrameRect', win, uppColors, uppRects);

% Draw reward explanation
DrawFormattedText(win, botInstructText, botRectXpos(1), botTextYpos)
% Draw the bottom rects to the screen
Screen('FrameRect', win, botColors, botRects);

% Flip to the screen
Screen('Flip', win);

noClickYet=true;
buttons(1)=0;

while ~any(buttons) % wait for release
    [mouseX,mouseY,buttons] = GetMouse;
%     if buttons(1)
    if(any(buttons))
        if((mouseY >= topRectYpos-(baseRect(4)/2)) && (mouseY <= topRectYpos+(baseRect(4)/2)))
            if((mouseX >= topRectXpos(1)-(baseRect(3)/2)) && (mouseX <= topRectXpos(1)+(baseRect(3)/2)))
                selection=1;
            elseif((mouseX >= topRectXpos(2)-(baseRect(3)/2)) && (mouseX <= topRectXpos(2)+(baseRect(3)/2)))
                selection=2;         
            elseif((mouseX >= topRectXpos(3)-(baseRect(3)/2)) && (mouseX <= topRectXpos(3)+(baseRect(3)/2)))
                selection=3;
            elseif((mouseX >= topRectXpos(4)-(baseRect(3)/2)) && (mouseX <= topRectXpos(4)+(baseRect(3)/2)))
                selection=4;
            elseif((mouseX >= topRectXpos(5)-(baseRect(3)/2)) && (mouseX <= topRectXpos(5)+(baseRect(3)/2)))
                selection=5;
            else
                buttons(1)=0;
            end
        else
            buttons(1)=0;
        end
    end
end

while any(buttons) % wait for press
     [x,y,buttons] = GetMouse;
end

% while noClickYet % as long as this is true
%     [mouseX, mouseY, buttons] = GetMouse(win); % record mouse click
%     %change the value of noClickYet (and break the loop) only if the click
%     %is inside my oneRect
%     if buttons(1)
%         noClickYet=false;
%         mouseX
%         mouseY
%         %         for k = 1:totalNumberRect %for each rect, this loop check if the button was within the coordinates.
%         %             thisRect= myTrials(k).rect;
%         %             if mouseX>thisRect(1) & ...
%         %                     mouseX<thisRect(3) & ...
%         %                     mouseY>thisRect(2) & ...
%         %                     mouseY<thisRect(4)
%         %                 myTrials(k)=[];
%         %                 break
%         %             end
%         %         end
%     end
% end

%% Screen 2: Player's selection
buttons(1) = 0;

playerSelection = selection;
selectedRects = topRects(:,1:playerSelection);
unSelected = playerSelection + 1;
unselectedRects = topRects(:,unSelected:5);

% Instruction text strings
topSelectText = ['You invested ' num2str(playerSelection) '.']
uppSelectText = 'Your opponent can invest up to 4';
botSelectText = 'You can win 10';

% Draw betting instructions
DrawFormattedText(win, topSelectText, topRectXpos(1), topTextYpos)
% Draw the top rects to the screen
Screen('FillRect', win, topColors, selectedRects);
Screen('FrameRect', win, topColors, unselectedRects);

% Draw opponent explanation
DrawFormattedText(win, uppSelectText, uppRectXpos(1), uppTextYpos)
% Draw the upper rects to the screen
Screen('FrameRect', win, uppColors, uppRects);

% Draw reward explanation
DrawFormattedText(win, botSelectText, botRectXpos(1), botTextYpos)
% Draw the bottom rects to the screen
Screen('FrameRect', win, botColors, botRects);

% Flip to the screen
Screen('Flip', win);

noClickYet=true;

while noClickYet % as long as this is true
    [mouseX, mouseY, buttons] = GetMouse(win); % record mouse click
    %change the value of noClickYet (and break the loop) only if the click
    %is inside my oneRect
    if buttons(1)
        buttons
        noClickYet=false
        %         for k = 1:totalNumberRect %for each rect, this loop check if the button was within the coordinates.
        %             thisRect= myTrials(k).rect;
        %             if mouseX>thisRect(1) & ...
        %                     mouseX<thisRect(3) & ...
        %                     mouseY>thisRect(2) & ...
        %                     mouseY<thisRect(4)
        %                 myTrials(k)=[];
        %                 break
        %             end
        %         end
    end
end


%% Screen 3: Result

buttons(1) = 0;

weakSelection = 3;
weakselRects = uppRects(:,1:weakSelection);
weakunSelected = weakSelection + 1;
weakunselRects = uppRects(:,weakunSelected:4);

% Instruction text strings
% topResultText = ['You invested ' num2str(playerSelection) '.']
uppResultText = ['Your opponent invested ' num2str(weakSelection) '.'];
botResultText = 'You won 10.';

% Draw strong outcome
DrawFormattedText(win, topSelectText, topRectXpos(1), topTextYpos)
% Draw the top rects to the screen
Screen('FillRect', win, topColors, selectedRects);
Screen('FrameRect', win, topColors, unselectedRects);

% Draw weak outcome
DrawFormattedText(win, uppResultText, uppRectXpos(1), uppTextYpos)
% Draw the upper rects to the screen
Screen('FillRect', win, uppColors, weakselRects);
Screen('FrameRect', win, uppColors, weakunselRects);

% Draw reward explanation
    Screen('TextStyle', win, 1); % change style to bold
DrawFormattedText(win, botResultText, botRectXpos(1), botTextYpos, botColors)
% Draw the bottom rects to the screen
Screen('FillRect', win, botColors, botRects);

% Flip to the screen
Screen('Flip', win);

noClickYet=true;

while noClickYet % as long as this is true
    [mouseX, mouseY, buttons] = GetMouse(win); % record mouse click
    %change the value of noClickYet (and break the loop) only if the click
    %is inside my oneRect
    if buttons(1) == 0
        noClickYet=false;
        %         for k = 1:totalNumberRect %for each rect, this loop check if the button was within the coordinates.
        %             thisRect= myTrials(k).rect;
        %             if mouseX>thisRect(1) & ...
        %                     mouseX<thisRect(3) & ...
        %                     mouseY>thisRect(2) & ...
        %                     mouseY<thisRect(4)
        %                 myTrials(k)=[];
        %                 break
        %             end
        %         end
    end
end

sca

        

