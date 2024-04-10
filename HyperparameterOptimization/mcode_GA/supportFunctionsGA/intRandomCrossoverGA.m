function child = intRandomCrossoverGA(parentA,parentB)
% <keywords>
%
% Purpose : The purpose of this function is to perform a random crossover
% between parentA and parentB
%
% Syntax :
%
% Input Parameters :
% - parentA - first parent that is used for the crossover
% - parentB - second parent for the crossover
%
% Return Parameters :
% - child - offspring of the crossover
%
% Description : for every component of the individual it is randomly chosen
% if the component is taken from parent A or parent B. 
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{30-Dec-2020}{Original}
%
% --------------------------------------------------
% (c) 2020, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%

% number of variables
numVar = length(parentA);

for i=1:numVar
    % random number [0,1] if <= 0.5 component from first parent, otherwise
    % from second
    randNr=rand();
    
    if(randNr <= 0.5)
        child{i}=parentA{i};
    else
        child{i}=parentB{i};
    end
    
end

end
