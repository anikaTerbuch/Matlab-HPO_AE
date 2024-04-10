function populationMutation = intMutationGA(population, mutationProb, upperBound, lowerBound)
% <keywords>
%
% Purpose : The purpose of this function is to apply mutation on the
% population "population"
%
% Syntax :
%
% Input Parameters :
% -population: population mutation is applied on
% -mutationProb: probability with which mutation is applied
% -upperBound: upper bound for every optimized hyperparameter
% -lowerBound: lower bound for every optimized hyperparameter
%
% Return Parameters :
% - populationMutation: population after applying mutation
%
% Description : An individual that is an instance of the population is
% mutated with the probability "mutationProb". A random number is
% generated, if it is <= the mutationProb, mutation is applied to one
% random variable of the individual.
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{30-Dec-2020}{Original}
% \change{2.0}{16-Feb-2021} adjustment for AED
%
% --------------------------------------------------
% (c) 2020, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
for i=1:length(population)
    randM=rand();
    if randM <= mutationProb
        % mutated individual
        mInd = population{i};
        % determine which entry of the individual is mutated
        randVar=randi([1,length(upperBound)]);

    
        % random entry for the variable randVar
        lowerBoundVar=lowerBound(randVar);

        %
        upperBoundVar=upperBound(randVar);
        val=randi([lowerBoundVar,upperBoundVar]);
        mInd{randVar}=val;

        
        % add the individual back to the population
        population{i}=mInd;
    end
end 
populationMutation=population;
end