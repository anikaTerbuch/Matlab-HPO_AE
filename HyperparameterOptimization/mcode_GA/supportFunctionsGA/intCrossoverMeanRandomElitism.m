function  populationCrossover=intCrossoverMeanRandomElitism(matingPool, population, k, fitness)
% <keywords>
%
% Purpose : This function performs the crossover. The parents are chosen
% out of the matingPool. The best k individuals of the last population are
% allways added to the newly generated population without undergoing
% crossover (elitism)
%
% Syntax :
%
% Input Parameters :
% - mating pool: mating pool the parents should be selected from
% - population: current population (used for elitism)
% - k: k best individuals of the population |population| that should be
% transferred to next population
% - fitness of all individuals in |population|
%
% Return Parameters :
% - population after crossover
%
% Description :
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
%% Elitism
% add the k best individuals directly to the mating pool
[bestFitness, indexBest]=mink(fitness,k);

bestIndividuals=population(indexBest);

[bestFitness,bestIndividual]=min(fitness);
bestIndividual=population(bestIndividual);
populationCrossover={};
populationCrossover=bestIndividuals;
% counter to ensure a constant population size
cCrossover=k;

% perform the crossover operation as long as the new population has the
% same number of individuals as the prior population
while length(populationCrossover) < length(population)
    % select randomly two individuals for the crossover from the mating
    % pool
    
    indexA=randi([1,length(matingPool)]);
    indexB=randi([1,length(matingPool)]);
    %
    parentA=matingPool{indexA};
    parentB=matingPool{indexB};
    %perform crossover, with 50% probability mean crossover and with 50%
    %probability random crossover
    cR=rand();
    if cR < 0.5
    child=intMeanCrossoverGA(parentA,parentB);
    else
    child=intRandomCrossoverGA(parentA,parentB);
    end
    %couunter how often crossover was performed
    cCrossover=cCrossover+1;
    %add new inidividual obtained by crossover to the population
    populationCrossover{cCrossover}=child;
end
