function games(subNo,anni, w, wRect)

%%
% Here is the script, I guess you need also a couple of practice trials.
% I do not have the practice trials (relative to this specific experiment) 
% in this computer, I need to go to  Fedrigotti. Later I will send you the rest of the material.
%
% I sent you a pure version, but probably Nadege want to add a feedback 
% with the action selected by the player at the end of each trial and maybe 
% some breaks (in total there are 48 trials), anyway it should be easy to add these things.
%
% to run the script just write: games(01, 01)
% The first number is the number of the participant, the second is a 
% variable that you can change as you want.
% The output file already include whether for a specific trial the player 
% choose in accordance with a level-2, level-1, cooperative or competitive strategy.
%
% I'm leaving tomorrow but ask Joshua if you need some clarification about 
% the script. We also need to change the script a little bit so I may 
% suggest Ben and Joshua to work together if you also want to change something.
%
% Luca


%% Clear Matlab/Octave window:
% clc;

% check for Opengl compatibility, abort otherwise:
AssertOpenGL;

% Check if all needed parameters given:
if nargin < 2
    error('Must provide required input parameters "subNo" and "DateTime"!');
end

% Reseed the random-number generator for each expt.
rand('state',sum(100*clock));

% Make sure keyboard mapping is the same on all supported operating systems
% Apple MacOS/X, MS-Windows and GNU/Linux:
KbName('UnifyKeyNames');

riga_up=KbName('UpArrow'); 
riga_bottom=KbName('DownArrow'); 
%colonna_dx=KbName('3');


%%%%%%%%%%%%%%%%%%%%%%
% file handling
%%%%%%%%%%%%%%%%%%%%%%

% Define filenames of input files and result file:
datafilename = strcat('risultati_games_sogg_',subNo, '_',anni,'.dat'); % name of data file to write to
%strcat corrisponde a concatena, infatti concatena le stringhe successive

%provafilename = 'Blocco0_colonna_trial_prova.txt';                           % Training list
testfilename  = 'stimoli.txt';                            % Experimental list

% check for existing result file to prevent accidentally overwriting
% files from a previous subject/session (except for subject numbers > 99):
% if subNo<99 && fopen(datafilename, 'rt')~=-1
%     fclose('all');
%     error('Hai gi? un soggetto corrispondente con questo numero!');
% else
    datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing
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
%     
%     % Hide the mouse cursor:
%     HideCursor;
%    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     fileEdf = ['fase_1',num2str(subNo),'e',num2str(anni),'.edf'];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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
%     
    [mx, my] = RectCenter(wRect);
    screenCenter = [mx, my]; % center coordinates

%     
%     % Set text size (Most Screen functions must be called after
%     % opening an onscreen window, as they only take window handles 'w' as
%     % input:
%     Screen('TextSize', w, 32);
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
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %EYELINK
%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     fprintf('EyelinkToolbox Example\n\n\t');
%     dummymode=0;       % set to 1 to initialize in dummymode (rather pointless for this example though)
%     
%     % STEP 1
%     % Open a graphics window on the main screen
%     % using the PsychToolbox's Screen function.
%     %screenNumber=max(Screen('Screens'));
%     %window=Screen('OpenWindow', screenNumber);
%      
%     % STEP 2
%     % Provide Eyelink with details about the graphics environment
%     % and perform some initializations. The information is returned
%     % in a structure that also contains useful defaults
%     % and control codes (e.g. tracker state bit and Eyelink key values).
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
%         fprintf('Eyelink Init aborted.\n');
%         cleanup;  % cleanup function
%         return;
%     end
%     
%     [v vs]=Eyelink('GetTrackerVersion');
%     fprintf('Running experiment on a ''%s'' tracker.\n', vs );
%     
%     % make sure that we get gaze data from the Eyelink
%     Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
%     
%     % open file to record data to
%     edfFile='demo.edf';
%     Eyelink('Openfile', edfFile);
%     
%     % STEP 4
%     % Calibrate the eye tracker
%     EyelinkDoTrackerSetup(el);

    % do a final check of calibration using driftcorrection
    %EyelinkDoDriftCorrection(el);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % run through study and test phase
    for phase=1 % 1 fase di prova, 2 ? la fase sperimentale                

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
        GetClicks(w);
        
        % Wait a second before starting trial
        WaitSecs(0.500);
      
    % read list of conditions/stimulus images -- textread() is a matlab function
        % objnumber  arbitrary number of stimulus
        % objname    stimulus filename
        % objtype    1=old stimulus, 2=new stimulus
        %            for study list, stimulus coded as "old"
        [ objnumber, objname, strategic, cooperative, competitive, naive] = textread(trialfilename,'%d %s %d %d %d %d');
        %Nei file txt contenenti le liste degli stimoli, gli stimoli sono
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
        
        FixCr=ones(20,20)*192;
        FixCr(10:11,:)=0;
        FixCr(:,10:11)=0;  %try imagesc(FixCr) to display the result in Matlab
        fixcross = Screen('MakeTexture',w,FixCr);
         
        Screen('FillRect',w,silver,wRect);
        Screen('Flip', w);
        % loop through trials
        %for trial=1:ntrials
        for trial =1:48  
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
            
%              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              if EYELINK('CheckRecording');
%                 EYELINK('StartRecording');
%              end
%              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            Screen('FillRect',w,silver,wRect);
            Screen('Flip', w);
            
            WaitSecs(1.000);
            
%              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              EYELINK('message',['TRIALID ',num2str(trial),num2str(char(objname(trial))),'_startTrial']);
%              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   
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
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            %Screen('DrawTexture', w, fixcross,[],[mx-10,my-334,mx+10,my-314]);
            %Screen('DrawTexture', w, fixcross,[],[mx-10,my-10,mx+10,my+10]);
            Screen('DrawTexture', w, fixcross,[],[mx-10,my-10,mx+10,my+10]);
            
%            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
            
%            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            EYELINK('message',['TRIALID ',num2str(trial),num2str(char(objname(trial))),'_trialPicture']);
%            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
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
                        [endrt, KeyCode]=KbWait([], 3);
                    end

                    % Wait 1 ms before checking the keyboard again to prevent
                    % overload of the machine at elevated Priority():
                    WaitSecs(0.001);
                end
            
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               EYELINK('message',['TRIALID ',num2str(trial),'_endTrial']);
               % Clear screen to background color after fixed 'duration'
               % or after subjects response (on test phase)
               Screen('Flip', w);
            
               WaitSecs(0.100);
             
%                EYELINK('message',['TRIALID ',num2str(trial),'_endRecording']);
%                WaitSecs(0.2);
%                EYELINK('stoprecording');
%                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
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
                        [endrt, KeyCode]=KbWait([], 3);
                        WaitSecs(0.001);
                    end
                end
            
            
            
                % compute response time
                rt=round(1000*(endrt-startrt));
                %sar? necessario inserire al posto di 1000 il tempo relativo
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
            fprintf(datafilepointer,'%i %i %s %i %s %i %s %i %i %i %i %i %i %i %i %i\n', ...
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
            
           
            
        end % for trial loop
    end % phase loop
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


