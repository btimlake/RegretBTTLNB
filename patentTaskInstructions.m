function patentTaskInstructions(window, windowRect, enabledKeys, cfg, player1maxbid);

% enabledKeys;
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);

%% Screen 0: Instructions

% Select specific text font, style and size:
screenXpixels=cfg.screenSize.x;
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, cfg.fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, cfg.textColor);
    
    
%     if player1maxbid == 5;
% %         addpath(matlabroot,'instructions/strong');
% %         txtInstr = fileread('patentRace-strong.txt');
%         type = 'strong';
%     elseif player1maxbid == 4;
% %         addpath(matlabroot,'instructions/weak');
% %         txtInstr = fileread('patentRace-weak.txt');
%         type = 'weak';
%     else
%         disp('Player 1 max bid needs to be fixed')
%     end

%% Instruction screens
    keyName=''; % empty initial value
    instructions = 1;
    instFilename = ['instructions/patentRace_instructions' num2str(instructions) '.png'];
    imdata=imread(instFilename);    
    tex=Screen('MakeTexture', window, imdata);
    Screen('DrawTexture', window, tex);
    Screen('Flip', window);
    
% show first instruction page 
%     instFilename = ['instructions/patentRace_instructions' num2str(instructions) '-' type 'AI.png'];
%     imdata=imread(instFilename);    
%     tex=Screen('MakeTexture', window, imdata);    
%     % Draw texture image to backbuffer. It will be automatically
%     % centered in the middle of the display if you don't specify a
%     % different destination:
%     Screen('DrawTexture', window, tex);
%     
%     Screen('Flip', window);
    
    while ~strcmp(keyName,'space')
        
        %     while ~strcmp(num2str(instructions), '5')
        if instructions == 1;
            RestrictKeysForKbCheck(cfg.limitedKeys); % left, right arrows; doesn't allow "space" on first instruction screen 
        else
            RestrictKeysForKbCheck(cfg.enabledSelectKeys); % space, left, right arrows
        end

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
                if instructions > 2
                    instructions = 2;
                end
        end
        % update selection to last button press
        
        instFilename = ['instructions/patentRace_instructions' num2str(instructions) '.png'];
        imdata=imread(instFilename);
        
        tex=Screen('MakeTexture', window, imdata);
        
        % Draw texture image to backbuffer. It will be automatically
        % centered in the middle of the display if you don't specify a
        % different destination:
        Screen('DrawTexture', window, tex);
        
        Screen('Flip', window);
        
        
        %     end
    end
    
    keyName=[];
    
    
end
