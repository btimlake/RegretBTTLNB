% %% Screen 0: Instructions
% % win = 10 %COMMENT AFTER DEBUGGING
% 
% % screenRect = [0 0 640 480] %COMMENT AFTER DEBUGGING
% % [window, windowRect] = Screen('OpenWindow', 0, [255, 255, 255], [0 0 640 480]); %white background
% % [win, screenRect] = Screen('OpenWindow', 0, [255, 255, 255]); %white background
% 
% %set colors 
% % topColors = [0, 0, 0]; % black
% p1Colors = [0, 0, 0.8039]; %MediumBlue
% % uppColors = [0, 0, 0]; % black
% p2Colors = [0.4314, 0.4824, 0.5451]; % LightSteelBlue4
% black = [0, 0, 0]; % black
% % winColors = [64, 64, 64]; %gray8
% % winColors = [0.2510, 0.2510, 0.2510]; %gray8
% winColors = [.1333, .5451, .1333]; %ForestGreen
% % instructCola = [0, 104, 139]; %DeepSkyBlue4
% instructCola = [0, 0.4078, 0.5451]; %DeepSkyBlue4
% % instructColb = [205,149,12]; %DarkGoldenRod3
% instructColb = [0.8039, 0.5843, 0.0471]; %DarkGoldenRod3
% 
% % Get the size of the on-screen window
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
% % Get the center coordinates of the window
% [xCenter, yCenter] = RectCenter(windowRect);
% screenCenter = [xCenter, yCenter]; % center coordinates
% 
% %Rectangle positions
% topRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36 screenXpixels * 0.45];
% numtopRect = length(topRectXpos); % Screen X positions of top five rectangles
% uppRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36];
% numuppRect = length(uppRectXpos); % Screen X positions of upper four rectangles
% lowRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36 screenXpixels * 0.45 screenXpixels * 0.54 screenXpixels * 0.63 screenXpixels * 0.72 screenXpixels * 0.81 screenXpixels * 0.9];
% numlowRect = length(lowRectXpos); % Screen X positions of lower ten rectangles
% botRectXpos = [screenXpixels * 0.54 screenXpixels * 0.63 screenXpixels * 0.72 screenXpixels * 0.81 screenXpixels * 0.9];
% numbotRect = length(botRectXpos); % Screen X positions of bottom five rectangles
% topRectYpos = screenYpixels * 7/40; % Screen Y positions of top five rectangles (4/40)
% uppRectYpos = screenYpixels * 16/40; % Screen Y positions of upper four rectangles (13/40)
% sepLineYpos = screenYpixels * 39/80; % Screen Y position of separator line
% lowRectYpos = screenYpixels * 27/40; % Screen Y positions of lower ten rectangles (24/40)
% botRectYpos = screenYpixels * 34/40; % Screen Y positions of bottom five rectangles (31/40)
% 
% % Text positions
% topTextYpos = screenYpixels * 2/40; % Screen Y positions of top text
% uppTextYpos = screenYpixels * 11/40; % Screen Y positions of upper text
% low1TextYpos = screenYpixels * 20/40; % Screen Y positions of lower text line 1
% lowTextYpos = screenYpixels * 22/40; % Screen Y positions of lower text line2
% botTextYpos = screenYpixels * 30/40; % Screen Y positions of bottom text 
% textXpos = round(screenXpixels * 0.09 - screenXpixels * 2/56); % left position of text and separator line
% lineEndXpos = round(screenXpixels * 0.91 + screenXpixels * 2/56); % right endpoint of separator line
% % Instruct text positions
% instruct1TextYpos = screenYpixels * 2/40; 
% instruct2TextYpos = screenYpixels * 5/40; 
% instruct3TextYpos = screenYpixels * 8/40; 
% instruct4TextYpos = screenYpixels * 11/40; 
% instruct5TextYpos = screenYpixels * 14/40; 
% instruct6TextYpos = screenYpixels * 17/40; 
% instruct7TextYpos = screenYpixels * 20/40; 
% instruct8TextYpos = screenYpixels * 23/40; 
% instruct9TextYpos = screenYpixels * 26/40; 
% instruct10TextYpos = screenYpixels * 29/40; 
% instructbotTextYpos = screenYpixels * 35/40; 
% 
% % Select specific text font, style and size:
% fontSize = round(screenYpixels * 2/40);
%     Screen('TextFont', window, 'Courier New');
%     Screen('TextSize', window, fontSize);
%     Screen('TextStyle', window);
%     Screen('TextColor', window, black);
%     
% % Set standard line weight    
% lineWidthPix = round(screenXpixels * 2 / 560);
%    
% instructText11 = ['You are competing against an opponent'];
% instructText12 = ['to win a prize in each trial.'];
% instructText13 = ['You can invest 0-' num2str(PLAYER1MAXBID) ' cards.'];
% instructText14 = ['Your opponent can invest  0-' num2str(PLAYER2MAXBID) '.'];
% instructText15 = ['The player who invests more wins 10.'];
% instructText16 = ['If both invest the same amount,'];
% instructText17 = ['neither player wins.'];
% instructText18 = ['Whatever you don''t invest, you keep.'];
% instructText19 = ['(For example, if you invest 3,'];
% instructText20 = ['you keep 2, whether you win or lose.)'];
% instructText0 = ['Hit the SPACE bar to continue.'];
% instructText21 = ['Your endowment is renewed each round.'];
% instructText22 = ['Your payment after the experiment will'];
% instructText23 = ['be based on two random trials.'];
% instructText24 = ['So every trial could matter.'];
% instructText25 = ['A fixation cross appears between rounds.'];
% % instructText22 = ['to select how many to invest.'];
% instructText27 = ['Use the left/right arrow keys'];
% instructText28 = ['to select how many cards to invest.'];
% instructText29 = ['Then hit the SPACE bar to confirm your choice.'];
% 
% keyName=''; % empty initial value
% 
% %% Italian instructions
% % Select specific text font, style and size:
% fontSize = round(screenYpixels * 1/40);
%     Screen('TextFont', window, 'Courier New');
%     Screen('TextSize', window, fontSize);
%     Screen('TextStyle', window);
%     Screen('TextColor', window, black);
% 
% patentInstr1 = {'Stai per giocare contro un un algoritmo'; ...
%     'adattivo del computer per vincere quanto'; ...
%     'pi? denaro possibile. Il computer fa la'; ...
%     'sua scelta prima di tu.' ; ; ...
%     'Tu puoi investire da 0 a ',  num2str(PLAYER1MAXBID), ' carte;'}; ...
%     'il tuo avversario ne pu? investire da 0 a ', num2str(PLAYER2MAXBID), '.'; ; ...
%     'Il giocatore che investe pi? carte a ogni'; ...
%     'turno vince 10 carte per turno.'; ...
%     'Se entrambi investono lo stesso numero di carte,'; ...
%     'non vince nessun giocatore'; ; ...
%     'Manterrai il numero di carte che non investirai'; ...
%     '(e.g. se ne investi 3, le altre 2 rimarranno a te,'; ...
%     'sia che tu vinca sia che tu perda).'; ; ...
%     'Usa i tasti freccia per scegliere quante carte'; ...
%     'investire, poi clicca SPAZIO per confermare la'; ...
%     'tua scelta.';  ; ; 'Clicca SPAZIO per continuare.'};
% 
% for line_num = 1:length(patentInstr1)
% line_width = RectWidth(Screen('TextBounds',window,patentInstr1{line_num}));
% Screen('DrawText', window, patentInstr1{line_num}, screenCenter(1) - line_width/2, ...
% screenCenter(2) - fontSize * (2 + length(patentInstr1)-line_num+1), instructCola); 
% end
% 
% while(~strcmp(keyName,'space')) % continues until current keyName is space
%     
%     DrawFormattedText(window, instructText11, 'center', instruct1TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText12, 'center', instruct2TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText13, 'center', instruct3TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText14, 'center', instruct4TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText15, 'center', instruct5TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText16, 'center', instruct6TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText17, 'center', instruct7TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText18, 'center', instruct8TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText19, 'center', instruct9TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText20, 'center', instruct10TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText0, 'center', instructbotTextYpos, p1Colors); % Draw betting instructions
%     Screen('Flip', window); % Flip to the screen
% 
%     [keyTime, keyCode]=KbWait([],2);
%     keyName=KbName(keyCode);
% 
% end
% 
% keyName=''; %resets value to cue next screen
% %      Screen('Flip', win); % Flip to the screen
% WaitSecs(.25);
% 
% while(~strcmp(keyName,'space')) % continues until current keyName is space
% 
%     DrawFormattedText(window, instructText21, 'center', instruct1TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText22, 'center', instruct2TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText23, 'center', instruct3TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText24, 'center', instruct4TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText25, 'center', instruct5TextYpos, instructColb); % Draw betting instructions
% %     DrawFormattedText(win, instructText26, 'center', instruct6TextYpos, instructColb); % Draw betting instructions
%     DrawFormattedText(window, instructText27, 'center', instruct7TextYpos, p1Colors); % Draw betting instructions
%     DrawFormattedText(window, instructText28, 'center', instruct8TextYpos, p1Colors); % Draw betting instructions
%     DrawFormattedText(window, instructText29, 'center', instruct9TextYpos, p1Colors); % Draw betting instructions
% %     DrawFormattedText(win, instructText30, 'center', instruct10TextYpos, instructCola); % Draw betting instructions
%     DrawFormattedText(window, instructText0, 'center', instructbotTextYpos, p1Colors); % Draw betting instructions
%     Screen('Flip', window); % Flip to the screen
% 
%     [keyTime, keyCode]=KbWait([],2);
%     keyName=KbName(keyCode);
% 
% end
% 
