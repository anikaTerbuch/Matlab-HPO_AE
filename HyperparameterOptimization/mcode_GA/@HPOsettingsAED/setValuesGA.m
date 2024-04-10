function setValuesGA(obj,maxGen,populationSize,mutationProbability, randomProbability )
% AED, genetic algorithm, HPO
% Purpose : With this functions the settings of the genetic algorithm can
% be adjusted.
%
% Syntax : 
% - setValuesGA(maxGen,populationSize)
% - setValuesGA(maxGen,populationSize,mutationProbability)
% - setValuesGA(maxGen,populationSize,mutationProbability, randomProbability )
%
% Input Parameters :
% - obj: this function is called in an object oriented way, the first entry
% is the object it should be applied on - in this case an object of the
% class HPOsettingsAED
% - maxGen: max. number of generations the genetic algorithm is performed
% used in the termination condition.
% - sizePopulation: number of individuals per population
% - mutationProbability: mutation probability used in the genetic operator
% mutation
% - randomProbability: used in the step of building a mating pool and is
% the probability that an individual with not sufficiently good fitness is
% added to the mating pool
%
% Return Parameters :
%
% Description :
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{02-Feb-2023}{Original}
%
% --------------------------------------------------
% (c) 2023, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Check the input parameters
arguments
    obj (1,1) HPOsettingsAED
    maxGen (1,1) double
    populationSize (1,1) double 
    mutationProbability(1,1) double = 0.05
    randomProbability (1,1) double = 0.05
end


if mod(maxGen,1) ~= 0 || mod(populationSize,1) ~= 0
    error('maxGen and sizePopulation must be integers');
end

if populationSize < 2
    error('A population must consist of at least 2 individuals.')
end


if mutationProbability < 0 || mutationProbability > 1
    error('Mutation probability must be between 0 and 1.');
end

if randomProbability < 0 || randomProbability > 1
    error('Random Probability must be between 0 and 1.');
end

%% Assign the passed values

% maxGen and sizePop should be set
if nargin >= 3
    obj.settingsGA.MaxGenerations = maxGen;
    obj.settingsGA.PopulationSize = populationSize;
end

% additionaly set mutationProbability
if nargin >= 4
    obj.settingsGA.MutationProbability = mutationProbability;
end

% set all 4 values of the struct to new values
if nargin >= 5
    obj.settingsGA.RandomProbability = randomProbability;
end

if nargin > 5
    error("Too many inputs, expected at most 4 inputs.");
end






