function [gamesdatafilename]=games(subNo, anni, w, wRect, NUMROUNDS, enabledKeys)
% games(participant number, date/time, window size, window rectangle size,
% number of rounds)

% Written by Luca Polonio & Joshua Zonca.
% Modified June 2016 by Ben Timberlake for use with Regret Priming
% experiment.

% Clear Matlab/Octave window:
% clc;

% check for Opengl compatibility, abort otherwise:
AssertOpenGL;

% Check if all needed parameters given:
if nargin < 5
    error('Must provide required input parameters subNo, anni, w, wRect and NUMROUNDS');
end

% Reseed the random-number generator for each expt.
rand('state',sum(100*clock));

% Make sure keyboard mapping is the same on all supported operating systems
% Apple MacOS/X, MS-Windows and GNU/Linux:
% KbName('UnifyKeyNames');
enabledKeys;
% <<<<<<< HEAD
% RestrictKeysForKbCheck([38, 40 ,32]); % limit recognized presses to up and down arrows PC
% RestrictKeysForKbCheck([81,82,44]); % limit recognized presses to space and up and down arrows MAC
% =======
% RestrictKeysForKbCheck([40,41,32]); % limit recognized presses to up and down arrows PC
% RestrictKeysForKbCheck([30,81,82,44]); % limit recognized presses to space and up and down arrows MAC
% >>>>>>> origin/master

riga_up=KbName('UpArrow'); 
riga_bottom=KbName('DownArrow'); 
%colonna_dx=KbName('3');
DateTime=anni;

%%%%%%%%%%%%%%%%%%%%%%
% file handling
%%%%%%%%%%%%%%%%%%%%%%
addpath(matlabroot,'games/instructions');

% Define filenames of input files and result file:
% datafilename = strcat('sub' num2str(subNo), '-', DateTime, '_4games2x2.dat'); % name of data file to write to
datafilename = ['sub' num2str(subNo), '-', num2str(DateTime), '_4games2x2.dat'];
% datafilename = ['sub' subNo, '-', DateTime, '_4games2x2.dat']; % name of data file to write to
%strcat corrisponde a concatena, infatti concatena le stringhe successive
gamesdatafilename=datafilename; %different variable for exporting to umbrella script

%provafilename = 'Blocco0_colonna_trial_prova.txt';                           % Training list
testfilename  = 'stimoli.txt';                            % Experimental list

% check for existing result file to prevent accidentally overwriting
% files from a previous subject/session (except for subject numbers > 99):
% if subNo<99 && fopen(datafilename, 'rt')~=-1
%     fclose('all');
%     error('Hai gi? un soggetto corrispondente con questo numero!');
% else
    datafilepointer = fopen(datafilename,'w+t'); % open ASCII file for writing ('w+t' used to be 'wt' here -- version? Needed for PC to write to text file)
% end

%%%%%%%%%%%%%%%%%%%%%%
% experiment
%%%%%%%%%%%%%%%%%%%%%%

try
    % Get screenNumber of stimulation display. We choose the display with
    % the maximum index, which is usually the right one, e.g., the external
    % display on a Laptop:
    screens=Screen('Screens');
    screenNumber=max(screens);

    % Hide the mouse cursor:
%     HideCursor;
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     fileEdf = ['fase_1',num2str(subNo),'e',num2str(anni),'.edf'];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Returns as default the mean gray value of screen:
    gray=GrayIndex(screenNumber); 
    black=BlackIndex(screenNumber);
    % Open a double buffered fullscreen window on the stimulation screen
    % 'screenNumber', 'w' is the handle
    % used to direct all drawing commands to that window - the "Name" of
    % the window. 'wRect' is a rectangle defining the size of the window.
    % See "help PsychRects" for help on such rectangles and useful helper
    % functions:
%     [w, wRect]=Screen('OpenWindow',screenNumber, gray);
    
    [mx, my] = RectCenter(wRect);
    screenCenter = [mx, my]; % center coordinates
    [screenXpixels, screenYpixels] = Screen('WindowSize', w);

    % Set text size (Most Screen functions must be called after
    % opening an onscreen window, as they only take window handles 'w' as
    % input:
%     Screen('TextSize', w, 32);
    TextSize = round(screenYpixels * 2/40);
    lineWidthPix = round(screenXpixels * 2 / 560);
    silver=[192 192 192,(w)];
    %white=WhiteIndex(w);
    % Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure
    % they are loaded and ready when we need them - without delays
    % in the wrong moment:
    KbCheck;
    WaitSecs(0.1);
    GetSecs;
    
    % Set priority for script execution to realtime priority:
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    %% Instruction screens
    keyName=[];
    instructions = 1;
    
    while (~strcmp(instructions, '5') && ~strcmp(keyName,'space'))
        
        [keyTime, keyCode]=KbWait([],2);
        keyName=KbName(keyCode);
        
        switch keyName
            case 'LeftArrow'
                instructions = instructions - 1;
                if instructions < 1
                    instructions = 1;
                end
            case 'RightArrow'
                instructions = instructions + 1;
                if instructions > 4
                    instructions = 5;
                end
        end
        % update selection to last button press
        
        instFilename = ['instructions/games2x2_instructions' num2str(instructions) '.png'];
        imdata=imread(instFilename);
        
        tex=Screen('MakeTexture', w, imdata);
        
        % Draw texture image to backbuffer. It will be automatically
        % centered in the middle of the display if you don't specify a
        % different destination:
        Screen('DrawTexture', w, tex);
        
        Screen('Flip', w);
        
        
    end
    keyName=[];



% OLD PAGE MOVEMENT - DELETE WHEN ARROWS FUNCTION
%     for instructions=1:4;
%         while(~strcmp(keyName,'space')) % continues until current keyName is space
%             
%             %         scale_question = {'Please rate how you feel';
%             % 'by tapping the arrow keys.'; 'Press ''SPACE'' to continue.'};
%             % for line_num = 1:length(scale_question)
%             % line_width = RectWidth(Screen('TextBounds',window,scale_question{line_num}));
%             % Screen('DrawText', window, scale_question{line_num}, screenCenter(1) - line_width/2, ...
%             % screenCenter(2) - fontSize * (2 + length(scale_question)-line_num+1), ratingPenColor);
%             
%             instFilename = ['instructions/games2x2_instructions' num2str(instructions) '.png'];
%             imdata=imread(instFilename);
%             
%             tex=Screen('MakeTexture', w, imdata);
%             
%             % Draw texture image to backbuffer. It will be automatically
%             % centered in the middle of the display if you don't specify a
%             % different destination:
%             Screen('DrawTexture', w, tex);
%             
%             Screen('Flip', w);   
%             
%             [keyTime, keyCode]=KbWait([],2);
%             keyName=KbName(keyCode);
%             
%         end
%         keyName=[];
%     end

    
     %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %EYELINK
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     fprintf('EyelinkToolbox Example\n\n\t');
%     dummymode=0;       % set to 1 to initialize in dummymode (rather pointless for this example though)
    
    % STEP 1
    % Open a graphics window on the main screen
    % using the PsychToolbox's Screen function.
    %screenNumber=max(Screen('Screens'));
    %window=Screen('OpenWindow', screenNumber);
     
    % STEP 2
    % Provide Eyelink with details about the graphics environment
    % and perform some initializations. The information is returned
    % in a structure that also contains useful defaults
    % and control codes (e.g. tracker state bit and Eyelink key values).
%     el=EyelinkInitDefaults(w);
%     % Disable key output to Matlab window:
% %     ListenChar(2);
%     el.backgroundcolour = silver;
%     el.msgfontcolour    = BlackIndex(w);
%    
%     el.calibrationtargetcolour= BlackIndex(w);
%         el.calibrationtargetsize= 1;
%         el.calibrationtargetwidth=0.5;
%         el.displayCalResults = 1;
%         
%       EyelinkUpdateDefaults(el);   
%     % STEP 3
%     % Initialization of the connection with the Eyelink Gazetracker.
%     % exit program if this fails.
%     if ~EyelinkInit(dummymode, 1)
%             fprintf('Eyelink Init aborted.\n');
%             cleanup;  % cleanup function
%             return;
%         end
%         
%         [~, vs] = Eyelink('GetTrackerVersion');
%         fprintf('Running experiment on a ''%s'' tracker.\n', vs );
%         
%         % make sure that we get gaze data from the Eyelink
%         Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
%         
%         % open file to record data to
%         edfFile='demo.edf';
%         Eyelink('Openfile', edfFile);
%         
%         % STEP 4
%         % Calibrate the eye tracker
%         
%         
%         % do a final check of calibration using driftcorrection
%         %EyelinkDoDriftCorrection(el);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         %%%%%%%%%%
%         % STEP 5 %
%         %%%%%%%%%%
%         
%         % SET UP TRACKER CONFIGURATION
%         % Setting the proper recording resolution, proper calibration type,
%         % as well as the data file content;
%         
%         % it's location here is overridded by EyelinkDoTracker which resets it
%         % with display PC coordinates
%         Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, mx-1, my-1);
%         Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, mx-1, my-1);
%         %Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, 1587, 1285);
%         %Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, 1587, 1285);
%         % set calibration type.
% %          Eyelink('command', 'calibration_type = HV5');
%         % you must send this command with value NO for custom calibration
%         % you must also reset it to YES for subsequent experiments
%         Eyelink('command', 'generate_default_targets = NO');
%         
%         % STEP 5.1 modify calibration and validation target locations
%         Eyelink('command','calibration_samples = 13');
%         Eyelink('command','calibration_sequence = 0,1,2,3,4,5,6,7,8,9,10,11,12,13');
%         Eyelink('command','calibration_targets = %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d',...
%             560,405, 870,245, 1045,405, 1355,245, 560,840, 870,680, 1045,840, 1335,680, 390,540, 960,65, 1530,540, 960,1015, 960,540, 560,405);
%         %100,100,  500,100,  1000,100,  100,400,  500,400, 1000,400, 100,100, ...
%         %500,100,  1000,100,  100,400,  500,400, 1000,400);
%         
%         Eyelink('command','validation_samples = 13');
%         Eyelink('command','validation_sequence = 0,1,2,3,4,5,6,7,8,9,10,11,12,13');
%         Eyelink('command','validation_targets = %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d, %d %d',...
%             560,405, 870,245, 1045,405, 1355,245, 560,840, 870,680, 1045,840, 1335,680, 390,540, 960,65, 1530,540, 960,1015, 960,540, 560,405);
%         %1587*0.2,852*0.2,  1587/2,852*0.2,  1587*0.8,852*0.2, ...
%         %1587*0.2,852/2,    1587/2,852/2,    1587*0.8,852/2, ...
%         %1587*0.2,852*0.8,  1587/2,852*0.8,  1587*0.8,852*0.8);
%         
%         % set EDF file contents
%         % STEP 5.2 retrieve tracker version and tracker software version
%         [v,vs] = Eyelink('GetTrackerVersion');
%         fprintf('Running experiment on a ''%s'' tracker.\n', vs );
%         vsn = regexp(vs,'\d','match'); % wont work on EL
%         
%         if v == 3 && str2double(vsn{1}) == 4 % if EL 1000 and tracker version 4.xx
%             
%             % remote mode possible add HTARGET ( head target)
%             Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
%             Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT,HTARGET');
%             % set link data (used for gaze cursor)
%             Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,FIXUPDATE,INPUT');
%             Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT,HTARGET');
%         else
%             Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
%             Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
%             % set link data (used for gaze cursor)
%             Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,FIXUPDATE,INPUT');
%             Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
%         end
%         % allow to use the big button on the eyelink gamepad to accept the
%         % calibration/drift correction target
%         Eyelink('command', 'button_function 5 "accept_target_fixation"');
%         
%         EyelinkDoTrackerSetup(el);
% 
%     % do a final check of calibration using driftcorrection
    %EyelinkDoDriftCorrection(el);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % run through study and test phase
    for phase=1 % 1 fase di prova, 2 ?? la fase sperimentale
            
        % Setup experiment variables etc. depending on phase:
        if phase==1 % fase di prova
            
            % define variables for current phase
            %phaselabel='prova';
            %duration=60.000; % Duration of study image presentation in secs.
            %trialfilename=provafilename;
            
            %message = 'fase di prova \n \n premi il bottone del mouse per iniziare';
            %Screen('DrawText', w,'fase di prova' , 100, 10, 255);
            %Screen('DrawText', w,'studia le figure premi_n_ quando spariscono' , 100, 40, 255);
            %Screen('DrawText', w,'premi il bottone del mouse per iniziare ...' , 100, 70, 255);
            %else        % test phase
            
            % define variables
            phaselabel='test';
            duration=120.000;  %sec
            trialfilename=testfilename;
            
            % write message to subject
            str=sprintf('attendi il via dello sperimentatore',KbName(riga_up),KbName(riga_bottom));
            message = ['Inizio esperimento \n \n' str ];
            DrawFormattedText(w, message, 'center', 'center', BlackIndex(w));
            Screen('Flip', w);
            %message_two = ['aspetta la decisione del giocatore A \n \n' str];
            %message_three = ['fine seconda parte esperimento'];
            
            %Screen('DrawText', w, 'fase sperimentale', 10, 50, 255);
            %Screen('DrawText', w, str, 10, 100, 255);
            %Screen('DrawText', w, 'premi il bottone del mouse per iniziare', 10, 150,255);
        end
        
        % Write instruction message for subject, nicely centered in the
        % middle of the display, in white color. As usual, the special
        %         % character '\n' introduces a line-break:
        %         DrawFormattedText(w, message, 'center', 'center', BlackIndex(w));
        %
        %         Screen('FillRect',w,silver,wRect);
        %
        % Update the display to show the instruction text:
        
        
        % Wait for mouse click:
        %per sostituire il testo del mouse con un tasto normale prova
        %KbWait([], 3); (preso dall'"LayerIllusion"
        %         GetClicks(w);
        while(~strcmp(keyName,'space')) % continues until current keyName is space
            
            [keyTime, keyCode]=KbWait([],2);
            keyName=KbName(keyCode);
            
        end
        

        % Wait a second before starting trial
        WaitSecs(0.500);
      
    % read list of conditions/stimulus images -- textread() is a matlab function
        % objnumber  arbitrary number of stimulus
        % objname    stimulus filename
        % objtype    1=old stimulus, 2=new stimulus
        %            for study list, stimulus coded as "old"
        [ objnumber, objname, strategic, cooperative, competitive, naive] = textread(trialfilename,'%d %s %d %d %d %d');
%         [ objnumber, objname, strategic, cooperative, competitive, naive] = textread('stimoli.txt','%d %s %d %d %d %d'); %changed trialfilename to 'stimoli.txt' because program wasn't recognizing        %Nei file txt contenenti le liste degli stimoli, gli stimoli sono
        %definiti rispettivamente ordinando il numero dello stimolo, il
        %nome del file .jpg e la categoria
        
        % Randomize order of list
        ntrials=length(objnumber);         % get number of trials
        randomorder=randperm(ntrials);     % randperm() is a matlab function
        objnumber=objnumber(randomorder);  % need to randomize each list!
        objname=objname(randomorder);      %
        strategic=strategic(randomorder);
        cooperative=cooperative(randomorder);
        competitive=competitive(randomorder);
        naive=naive(randomorder);
        
%         FixCr=ones(20,20)*192;
%         FixCr(10:11,:)=0;
%         FixCr(:,10:11)=0;  %try imagesc(FixCr) to display the result in Matlab
%         fixcross = Screen('MakeTexture',w,FixCr);
         
        Screen('FillRect',w,silver,wRect);
        Screen('Flip', w);
        % loop through trials
        %for trial=1:ntrials
         cont_pausa=0;  
         
        for trial =1:NUMROUNDS %ntrials
       
        %startbreak
%              if cont_pausa==24
%              WaitSecs(0.500)  
%              Screen('FillRect',w,silver,wRect);
%              Screen('Flip', w); 
%              str=sprintf('il compito riprender?? tra 2 minuti');
%              message = ['fine prima parte \n \n' str];
%              DrawFormattedText(w, message, 'center', 'center', BlackIndex(w)); 
%              Screen('Flip', w);
%              
%              WaitSecs(120.000);
%              errore = EyelinkDoTrackerSetup(el, 'c');
%              WaitSecs(0.500);
%              
%              
%              Screen('FillRect',w,silver,wRect);
%              Screen('Flip', w);
%              str=sprintf('attendi il via dello sperimentatore');
%              message = ['inizio seconda parte \n \n' str];
%              DrawFormattedText(w, message, 'center', 'center', BlackIndex(w)); 
%              Screen('Flip', w);
%              GetClicks(w)
% %              cont_pausa=cont_pausa+1;
%              WaitSecs(0.500)
%              end

        %end break
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             EyeLinkDoDriftCorrect(el, wRect(3)/2, 850, 1, 1);
%             EyeLinkDoDriftCorrect(el, 150, 850, 1, 1);
%             EyeLinkDoDriftCorrect(el, 150, 50, 1, 1);
%             EyeLinkDoDriftCorrect(el, 1250, 50, 1, 1);
%             EyeLinkDoDriftCorrect(el, 1250, 850, 1, 1);
%             EyeLinkDoDriftCorrect(el, wRect(3)/2, 850, 1, 1);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %EyeLinkDoDriftCorrect(el, 134, 900, 1, 1);
            %EyeLinkDoDriftCorrect(el, 1140, 190, 1, 1);
            %EyeLinkDoDriftCorrect(el, wRect(3)/2, 50, 1, 1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
                   
            % initialize KbCheck and variables to make sure they're
            % properly initialized/allocted by Matlab - this to avoid time
            % delays in the critical reaction time measurement part of the
            % script:
            [KeyIsDown, endrt, KeyCode]=KbCheck;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            DrawFormattedText(w, 'inizio trial', 'center', 'center', BlackIndex(w));
            % Update the display to show the instruction text:
            Screen('Flip', w);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            WaitSecs(1.500);
            
            drift=randi(4);
            
           
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              if drift==1 
%                  EyeLinkDoDriftCorrect(el, 390, 540, 1, 1);
%              else if drift==2
%              
%              EyeLinkDoDriftCorrect(el, 960, 65, 1, 1);
%                  else if drift==3
%              
%              EyeLinkDoDriftCorrect(el, 1530, 540, 1, 1);
%                      else if drift==4
%              
%              EyeLinkDoDriftCorrect(el, 960, 1015, 1, 1);
%                          end
%                      end
%                  end
%              end
%              
%             if drift==1
%             Screen('DrawTexture', w, fixcross,[],[mx-580,my-10,mx-560,my+10]);
%             else if drift==2
%             Screen('DrawTexture', w, fixcross,[],[mx-10,my-485,mx+10,my-465]);
%                else if drift==3
%             Screen('DrawTexture', w, fixcross,[],[mx+560,my-10,mx+580,my+10]);
%                  else if drift==4
%             Screen('DrawTexture', w, fixcross,[],[mx-10,my+465,mx+10,my+485]);
%                       end
%                    end
%                 end
%             end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
%             Screen('FillRect',w,silver,wRect);
%             Screen('Flip', w);
%             
%             WaitSecs(1.000);
% 
%              if EYELINK('CheckRecording');
%                 EYELINK('StartRecording');
%                 end
%              %%%%%%
%              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              EYELINK('message',['TRIALID ',num2str(trial),num2str(char(objname(trial))),'_startTrial']);   
%              
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            %Screen('DrawTexture', w, fixcross,[],[mx-10,my-334,mx+10,my-314]);
            %Screen('DrawTexture', w, fixcross,[],[mx-10,my-10,mx+10,my+10]);
            fixCrossDimPix = round(screenXpixels * 1 / 56); % Arm size
            xCoords = [-fixCrossDimPix fixCrossDimPix 0 0]; % horizontal line
            yCoords = [0 0 -fixCrossDimPix fixCrossDimPix]; % vertical line
            allCoords = [xCoords; yCoords]; % both lines together
%             Screen('DrawTexture', w, fixcross,[],[mx-10,my-10,mx+10,my+10], [], [],[], black);
            Screen('DrawLines', w, allCoords, lineWidthPix, black, screenCenter);

           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            EYELINK('message',['TRIALID ',num2str(trial),'_fixation']);
%            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            tfixation = Screen('Flip', w);   
            
            % read stimulus image into matlab matrix 'imdata':
            stimfilename=strcat('stimoli/',char(objname(trial))); % assume stims are in subfolder "stimoli"
             
            imdata=imread(char(stimfilename));
            
            Screen('FillRect',w,silver,wRect);
           
           
            % make texture image out of image matrix 'imdata'
            tex=Screen('MakeTexture', w, imdata);
            
            % Draw texture image to backbuffer. It will be automatically
            % centered in the middle of the display if you don't specify a
            % different destination:
            Screen('DrawTexture', w, tex);
            
            % Show stimulus on screen at next possible display refresh cycle,
            % and record stimulus onset time in 'startrt':
            
             [VBLTimestamp startrt]=Screen('Flip', w,tfixation + 1.000);
            
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            EYELINK('message',['TRIALID ',num2str(trial),num2str(char(objname(trial))),'_trialPicture']);
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % while loop to show stimulus until subjects response or until
            % "duration" seconds elapsed.
                while (GetSecs - startrt)<=duration
                    % poll for a resp
                    % during test phase, subjects can response
                    % before stimulus terminates
                    if ( phase==1 ) % se fase di prova
                        %if ( KeyCode(colonna_sx)==1 | KeyCode(colonna_dx)==1 )
                        %    break;
                        %end
                        %[KeyIsDown, endrt, KeyCode]=KbCheck;
                    %end
                    %if ( phase==2 ) % se fase sperimentale
                        if ( KeyCode(riga_up)==1 || KeyCode(riga_bottom)==1)
                            break;
                        end
                        [endrt, KeyCode]= KbWait([], 3);
                    end

                    % Wait 1 ms before checking the keyboard again to prevent
                    % overload of the machine at elevated Priority():
                    WaitSecs(0.001);
                end
            
%                EYELINK('message',['TRIALID ',num2str(trial),'_endTrial']);
               % Clear screen to background color after fixed 'duration'
               % or after subjects response (on test phase)
               Screen('Flip', w);
            
              
               WaitSecs(0.1);
              
% %                EYELINK('message',['TRIALID ',num2str(trial),'_endRecording']);
%                WaitSecs(0.2);
%                EYELINK('stoprecording');
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
                % loop until valid key is pressed
                % if a response is made already, then this loop will be skipped
                if ( phase==1 ) % fase di prova
                    %while ( KeyCode(colonna_sx)==0 & KeyCode(colonna_dx)==0 )
                    %    [KeyIsDown, endrt, KeyCode]=KbCheck;
                    %    WaitSecs(0.001);
                    %end
                %end
             
                %if ( phase==2 ) % fase sperimentale
                    while ( KeyCode(riga_up)==0 && KeyCode(riga_bottom)==0)
                        [endrt, KeyCode]= KbWait([], 3);
                        WaitSecs(0.001);
                    end
                end
            
            
            
                % compute response time
                rt=round(1000*(endrt-startrt));
                %sar?? necessario inserire al posto di 1000 il tempo relativo
                %alla presentazione del punto di fissazione oppure nulla
            
                if ( (KeyCode(riga_up)==1 && strategic(trial)==1) || (KeyCode(riga_bottom)==1 && strategic(trial)==2))
                        ac_strategic=1;
                    else ac_strategic=0;
                end
                
                if ( (KeyCode(riga_up)==1 && cooperative(trial)==1) || (KeyCode(riga_bottom)==1 && cooperative(trial)==2))
                        ac_cooperative=1;
                    else ac_cooperative=0;
                end
                
                if ( (KeyCode(riga_up)==1 && competitive(trial)==1) || (KeyCode(riga_bottom)==1 && competitive(trial)==2))
                        ac_competitive=1;
                    else ac_competitive=0;
                end
                
                if ( (KeyCode(riga_up)==1 && naive(trial)==1) || (KeyCode(riga_bottom)==1 && naive(trial)==2))
                        ac_naive=1;
                    else ac_naive=0;
                end
            
                resp=KbName(KeyCode); % get key pressed by subject
            
            % Write trial result to file:
% <<<<<<< HEAD
%             fprintf(datafilepointer,'%i %s %s %i %s %i %s %i %i %i %i %i %i %i %i %i\n', ...
%                 str2num(subNo), ...
            fprintf(datafilepointer,'%s %s %s %i %s %i %s %i %i %i %i %i %i %i %i %i\n', ...
                subNo, ...
                anni, ...
                phaselabel, ...
                trial, ...
                resp, ...
                objnumber(trial), ...
                char(objname(trial)), ...
                strategic(trial), ...
                cooperative(trial), ...
                competitive(trial), ...
                naive(trial), ...
                ac_strategic, ...
                ac_cooperative, ...
                ac_competitive, ...
                ac_naive, ...
                rt);

%             save(['sub' num2str(particNum) '-' DateTime '_2x2data'], subNo, ...
%                 anni, ...
%                 phaselabel, ...
%                 trial, ...
%                 resp, ...
%                 objnumber(trial), ...
%                 char(objname(trial)), ...
%                 strategic(trial), ...
%                 cooperative(trial), ...
%                 competitive(trial), ...
%                 naive(trial), ...
%                 ac_strategic, ...
%                 ac_cooperative, ...
%                 ac_competitive, ...
%                 ac_naive, ...
%                 rt);
                
%                 % Save variables (probably in an inefficient way)
%                 phaselabel(trial)=phaselabel;
%                 trial(trial)=trial;
%                 resp(trial)=resp;
%                 objnumber(trial)=objnumber;
%                 stim(trial)=char(objname(trial));
%                 strategic(trial)=strategic;
%                 cooperative(trial)=cooperative;
%                 competitive(trial)=competitive;
%                 naive(trial)=naive;
%                 ac_strategic(trial)=ac_strategic;
%                 ac_cooperative(trial)=ac_cooperative;
%                 ac_competitive(trial)=ac_competitive;
%                 ac_naive(trial)=ac_naive;
%                 rt(trial)=rt;

            

            
%           cont_pausa=cont_pausa+1;   
            
        end % for trial loop
        
 %% create log file


% save(['/Users/bentimberlake/Documents/MATLAB/patentTaskBTMP/logfiles/patent_race-subj_' num2str(particNum) '-' DateTime], 'player1Choice', 'player2Choice', 'player1Earnings', 'player2Earnings', 'trialLength');
% save(datafilepointer, ...
%                 subNo, ...
%                 anni, ...
%                 phaselabel, ...
%                 trial, ...
%                 resp, ...
%                 objnumber, ...
%                 stim, ...
%                 strategic, ...
%                 cooperative, ...
%                 competitive, ...
%                 naive, ...
%                 ac_strategic, ...
%                 ac_cooperative, ...
%                 ac_competitive, ...
%                 ac_naive, ...
%                 rt);
            
    end % phase loop
    fclose(datafilepointer);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %EYELINK
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      EYELINK('CloseFile');
%      WaitSecs(1);
%      status = eyelink('receivefile','',fileEdf);
%      EYELINK('shutdown');
%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    % Cleanup at end of experiment - Close window, show mouse cursor, close
    % result file, switch Matlab/Octave back to priority 0 -- normal
    % priority:
%     Screen('CloseAll');
%     ShowCursor;
%     fclose('all');
%     Priority(0);
    
    % End of experiment:
    return;
catch
    % catch error: This is executed in case something goes wrong in the
    % 'try' part due to programming error etc.:
    
    % Do same cleanup as at the end of a regular session...
%     Screen('CloseAll');
%     ShowCursor;
%     fclose('all');
%     Priority(0);
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);
end % try ... catch %

% RestrictKeysForKbCheck([]); % re-recognize all key presses
