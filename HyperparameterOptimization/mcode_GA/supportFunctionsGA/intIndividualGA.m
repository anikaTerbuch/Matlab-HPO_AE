function individual = intIndividualGA (upperBound, lowerBound)
% <keywords>
%
% Purpose : The purpose of this function is to create a individual that
% contains the variables as integers for the GA
%
% Syntax :
%
% Input Parameters :
% - upperBound: vector that contains the upper bound for every
% hyperparameter that should be optimized
% - lowerBound: vector that contains the lower bound for every
% hyperparameter that should be optimized
%
% Return Parameters :
% - individual: vector that represents one valid solution for the problem
% Description :
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

numHyperparam = length(upperBound);

for i=1:numHyperparam
    try
    % hyperparameter consists of one entry
    individual{i}= randi([lowerBound(i), upperBound(i)]);
    catch
    % hyperparameter consists of several entries - for example: several
    % layers in the encoder with neurons
    lbEntry=lowerBound(i);
    ubEntry=upperBound(i);
    for j=1:length(lowerBound(i))
        arrayEntry(j)=randi([lbEntry(j),ubEntry(j)]);
    end
    individual{i}=arrayEntry;
    end
end