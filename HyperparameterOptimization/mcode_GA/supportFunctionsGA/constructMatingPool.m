function matingPool =constructMatingPool(fitness, population, randomProb)
% <keywords>
%
% Purpose : Constructs a mating pool for the genetic algorithm.
%
% Syntax :
%
% Input Parameters :
% - fitness: fitness of each individual of the population
% - population: current population
% - randP: probability that an individual which fitness is not 'good'
% enough is added to the mating pool
%
% Return Parameters :
% - matingPool
%
% Description : All individuals with a fitness <= median(fitness) are added
% to the mating pool.
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{05-Nov-2021}{Original}
%
% --------------------------------------------------
% (c) 2021, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
% convert fitness from gpu array into array
fitness=gather(fitness);
medianFit=median(fitness);

% initializations
cSelection=0;
matingPool={};

for i=1:length(fitness)
    if fitness(i) <= medianFit
        cSelection=cSelection+1;
        matingPool{cSelection}=population{i};
    else
        randP=rand();
        % add other individuals with probability randomProb to mating pool
        if(randP <= randomProb)
            cSelection=cSelection+1;
            matingPool{cSelection}=population{i}
        end
    end
    
end