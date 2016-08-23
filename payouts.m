function payouts(winnings2x2, gamesdatafilename, total1shotEarnings, player1Earnings, winningsMPL, earningsRaven)

Var2Str(gamesdatafilename);

load('gamesdatafilename');

% randomly select opponent from attendees and deliver info to each computer
% Input the randomly chosen game 1-48 on every computer

% computer returns: player's corresponding play (I or II from corresponding
% game) and partner station number
    % need separate dataset/table for these correspondences

% Input partner's corresponding play

% Return player's reward based on own play and partner's play
winnings2x2

endowment = 10; 
winnings2x2
winnings1shot = total1shotEarnings;
winningsPatentRace = player1Earnings;
winningsMPL;
earningsRaven;

totalEarnings = endowment + winnings2x2 + winnings1shot + winningsPatentRace + winningsMPL + earningsRaven;

if totalEarnings <= 10
    disp('You earned ' num2str(totalEarnings)) '. 10 euro minimum awarded');
else
    disp('You earned ' num2str(totalEarnings)) '.')
    
end
