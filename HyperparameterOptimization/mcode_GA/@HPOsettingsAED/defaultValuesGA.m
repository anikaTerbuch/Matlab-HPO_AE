function defaultValuesGA(obj)
% AED, genetic algorithm, default
%
% Purpose : 
% This function is used to create a struct holding the default values of
% the genetic algorithm.
%
% Syntax : defaultValuesGA()
%
% Input Parameters :
%
% Return Parameters :
% -defaultStructGA: struct of default values for the GA
%
% Description : Before starting the genetic algorithm some parameters of
% the GA need to be set, e.g. population size, number of individuals,
% mutation probability, random probability. In this function the default
% values are defined and a call to this function is used in the constructor
% of the class HPOsettingsAED.
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
%% Create the default struct
defaultStructGA=struct();
%% Define the default values
% define the maximal number of generations the GA should be performed
defaultMaxGen=10;
% define the default size of a population
defaultPopSize=20;

% the following two probabilites help to perserve some genetic diversity in
% the mating pool and can help to escape local optima
% define the default probability mutation is performed
defaultMutationProb=0.05;
% define the default probability that an individual is added to the mating
% pool with a lower fitness than the minimum fitness to be added
defaultRandomProb=0.05;
%% Defining the struct
defaultStructGA=struct();
% adding the fields to the struct and assigning the default values

defaultStructGA.MaxGenerations=defaultMaxGen;
defaultStructGA.PopulationSize=defaultPopSize;
defaultStructGA.MutationProbability=defaultMutationProb;
defaultStructGA.RandomProbability=defaultRandomProb;


% assign the default struct to the object
obj.settingsGA=defaultStructGA;





