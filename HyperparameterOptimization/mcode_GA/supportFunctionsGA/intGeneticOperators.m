function[populationCrossoverMutation,bestFitness,avgFitness,bestIndividual, encoderP, decoderP, filenames,fitness] = intGeneticOperators(population, XData, filenames, mutationProbability,ub,lb, randomProb, latentDim, executionEnvironment)
% <keywords>
%
% Purpose : The purpose of this function is to select the individuals for
% the mating pool following a rank based selection with elitism followed by applying to
% that population crossover (mean crossover and random crossover) and as last step random mutation
%
% Syntax :
%
% Input Parameters :
% - population: contains the population the selection is applied on
% inputs for the LSTM_VAE:
% - XData: data for training the ML models 
% - filenames: corresponding filenames of the mat files the data was
%   extracted
% - mutationProbability: probability with which the mutation operator is
%   applied to the population
% - ub: upper bound of every gene - used for mutation
% - lb: lower bound of every gene - used for mutation
% - randomProb: probability that a individual that wouldn't be added
%   according to its fitness to the mating pool, is added.
% - latentDim: latent dimension of the LSTM-VAE
% - executionEnvironment: execution environment for training the ML-models
%                         code optimized for 'GPU'
%
% Return Parameters :
% - populationCrossoverMutation: population after crossover and mutation were applied
% - bestFitness: best fitness value of the population "population"
% - avgFitness: average fitness value of the population "population"
% - bestIndividual: index of the of the populations' individual with the highest
% fitness
% - encoderP - contains 3 trained networks with the same hyperparameter
% settings which were trained on different folds of the data
% - decoderP - contains 3 trained networks with the same hyperparameter
% settings which were trained on different folds of the data
% - elboLossP: corresponding elbo loss to the trained encoder-decoder
% structures on test data containing anomalous data
% - recErrorP: corresponding reconstruction error to the trained
% encoder-decoder structures on test data containing anomalous data
% - Filenames: filenames of the folds of the data after resampling
% - fintness: fitness of each individual of the population

% Description : The selection is done by selecting the individuals that
% have a fitness value that is lower than the value of the median
% of the fitness values of the population.
% To obtain the fintess value for each hyperparameter setting - the
% LSTM-VAE is trained with the values that are hold by the individuals of
% the population which should be evaluated.
% If the population contains the same hyperparameter setting more than once,
% the fitness value is calculated only once and the same fitness value is
% assigned to the individuals which have the same genes.
% The m fittest are added to the mating pool and randomly selected out of
% it to take part in the crossover.
% It is randomly selected which crossover function is chosen.
% The best three individuals of the current population are added to the
% next population (elitism).

% Fitness value: lower is better. 
%
% Author :
%    Anika Terbuch
%
% History :
% \change{1.0}{05.11.2021}
% --------------------------------------------------
% (c) 2020, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Evaluation

% evaluating the fitness value for every configuration using 3-fold cross
% validation
% figure to visualize the progress of the HPO
[encoderP, decoderP, fitness, filenames] = intEvaluation3CV(XData, filenames,population,latentDim,executionEnvironment);
[bestFitness, idxBest]=min(fitness);
avgFitness=mean(fitness);
bestIndividual=population(idxBest);

%% Selection 
% construct the mating pool
matingPool =constructMatingPool(fitness, population, randomProb);

%% Crossover with two crossover functions and elitism
% elitism
% add the k best individuals directly to the mating pool
k=3; 
populationCrossover=intCrossoverMeanRandomElitism(matingPool, population, k, fitness);

%% Mutation
% apply mutation to the population
populationCrossoverMutation = intMutationGA(populationCrossover,mutationProbability,ub,lb);
end