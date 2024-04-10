function [population,bestFitness,avgFitness,bestIndividual,aed,fitness] = GA_HPO_AED(data, HPOsettingsAED)
% <keywords>
%
% Purpose : This function performs a hyperparameter optimization for
% architectures creted with the framework AutoencoderDeep for the 
% hyperparameters:
% 1)"number of epochs",
% 2)"number of neurons encoder",
% 3)"number of neurons decoder"
% 4)"learning rate"
% 5)"mini batch size"
% 6) "BetaKLDivergence" - if the specified autoencoder is a VAE
% The same ordering of hyperparameters is used as in the settings for the
% optimizable variables passed with the object
% HPOsettingsAED.optimizableVariables
%
% Syntax : [population,bestFitness,avgFitness,bestIndividual,aed,fitness] = GA_HPO_AED(data, HPOsettingsAED)
%
% Input Parameters :
% - data: data containting the data that should be used for the
% optimization
% HPOsettingsAED with the fields
% - settingsGA: settings regarding the genetic algorithm
% - settingsAED: settings regarding the autoencoder itself
% - optimizableVariables: containing the lower and upper bounds for the
% variables which can be optimized in the form [lowerBound, upperBound]
% if for a variable lowerBound==upperBound the variable is not optimized.
%
% Return Parameters :
% - population: all populations (formed by all individuals) sorted by
% generations
% - bestFitness: best fitness of the best individual of each generation
% - avgFitness: average fitness of each generation
% - bestIndividual: encoded best individual of each generation
% - encoder: all trained encoder models
% - decoder: all trained decoder models
% - fitness: all calculated fitness values of all the individuals in
% |population|
%
% Description :
% For the optimization a genetic algorithm 
% with a following properties are used:
% - selection scheme: rank based selection with elitism
% - crossover scheme: mean value crossover and random crossover
% - mutation scheme: random mutation
% - replacement strategy: replacement of the whole population
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{05-Nov-2021}{Original}
% \change{2.0}{22-Feb-2022}
%
%
%
% cite as:
%  @article{Terbuch2023Jan,
% 	author = {Terbuch, Anika and O{'}Leary, Paul and Khalili-Motlagh-Kasmaei, Negin and Auer, Peter and Z{\ifmmode\ddot{o}\else\"{o}\fi}hrer, Alexander and Winter, Vincent},
% 	title = {{Detecting Anomalous Multivariate Time-Series via Hybrid Machine Learning}},
% 	journal = {IEEE Transactions on Instrumentation and Measurement},
% 	volume = {72},
% 	pages = {1--11},
% 	year = {2023},
% 	month = jan,
% 	urldate = {2023-04-13},
% 	issn = {1557-9662},
% 	publisher = {IEEE},
% 	doi = {10.1109/TIM.2023.3236354}
%   }
% --------------------------------------------------
% (c) 2023, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% assert the data dimensions
% the data needs to be a column row array; each time-series is stored in
% one of the cells 
%% initialization:
population={};
bestFitness=[];
bestIndividual={};
aed={};
filenames={};
fitness={};
% stall generations: terminate GA, if no improvement in the best fitness of
% the last 4 generations
stallGen=false;
% convergence: generation consists of individuals which all hold the same genes 
checkConv=false;

%% check if the mini-batch size is in a valid range
% the mini-batch size can maximally be 2/3 of the data samples provided.
% This is the case because 3-fold cross validation is performed. Each
% autoencoder is trained on 2/3 of the provided data and 1/3 is used for
% the validation -> evaluation of the fitness of an individual
maxPermittedMiniBatch=round(size(data,1)*2/3)-1;

% get the range of the mini-batch-size
rangeMiniBatch=HPOsettingsAED.optimizableVariables.MiniBatchSize;

% check if the lower bound is smaller than the max. permitted set the range
% to the fixed value of the upper bound

if rangeMiniBatch(1) > maxPermittedMiniBatch
    strMsg=strcat('The selected Mini-Batch-Size is not in the permitted rage. Permittet range is [1,',string(maxPermittedMiniBatch),']');
    warning(strMsg)
    warning('The mini-batch size was set to the max. permitted value.')
    HPOsettingsAED.setRangesOptimization('MiniBatchSize',[maxPermittedMiniBatch,maxPermittedMiniBatch]);
end

% if only the upper bound is too high - set it to the max. allowed value
if((rangeMiniBatch(1) <= maxPermittedMiniBatch) &&  (rangeMiniBatch(2) > maxPermittedMiniBatch))
    strMsg=strcat('The selected upper bound of the  Mini-Batch-Size is not in the permitted rage. Permittet range is [1,',string(maxPermittedMiniBatch),']');
    warning(strMsg);
    warning('The upper bound of the Mini-Batch-Size was set to the max. permitted value')
    HPOsettingsAED.setRangesOptimization('MiniBatchSize',[rangeMiniBatch(1),maxPermittedMiniBatch])
end


%% set the re-scaled integer ranges for the genes
HPOsettingsAED.rangeScalingOptiVar();

%% generating the first population of the size |popSize|
population{1}=intPopulationGA(HPOsettingsAED);

% extract some of the variables from the structs for easier use
maxGeneration=HPOsettingsAED.settingsGA.MaxGenerations;
mutationProbability=HPOsettingsAED.settingsGA.MutationProbability;
ub(:)=HPOsettingsAED.geneRanges.UpperBounds;
lb(:)=HPOsettingsAED.geneRanges.LowerBounds;
randomProb=HPOsettingsAED.settingsGA.RandomProbability;
executionEnvironment=HPOsettingsAED.settingsAED.ExecutionEnvironment;
autoencoderType=HPOsettingsAED.settingsAED.AutoencoderType;
layersEncoder=HPOsettingsAED.settingsAED.LayersEncoder;
layersDecoder=HPOsettingsAED.settingsAED.LayersDecoder;
latentDimension=HPOsettingsAED.settingsAED.LatentDimension;


%% iterate over generations
% do as long as termination condition is not fullfilled
i=2;
fitnessFig=figure(1)
while(checkConv==0 && i <= maxGeneration && stallGen==false)
    % genetic operations: apply selection, crossover, mutation to the
    % population
    [population{i},bestFitness(i-1),avgFitness(i-1),bestIndividual{i-1}, aed{i-1},fitness{i-1}] = intGeneticOperatorsAED(population{i-1}, data, mutationProbability,ub,lb, randomProb,executionEnvironment,autoencoderType, layersEncoder, layersDecoder, latentDimension);
    % visualize the progress
    figure(1)
    plot(i-1,bestFitness(i-1),'go')
    hold on
    figure(1)
    plot(i-1,avgFitness(i-1),'co')
    hold on;
    legend('best fitness','average fitness')
    xlabel('generation')
    ylabel('fitness value')
    grid on
    drawnow();
    if i>5
        if max(avgFitness([i-5:i-2])) < avgFitness(i-1)
            stallGen=true;
        end
    end
    % counter for number of generations
    i=i+1;
end
% evaluate the fitness of the last generation

[aed{i-1},currentFitness] = intEvaluation3CVAED(data,population{i-1},executionEnvironment,autoencoderType, layersEncoder, layersDecoder, latentDimension);
fitness{i-1}=currentFitness;
[bestFitness(i-1), idxBest]=min(currentFitness);
avgFitness(i-1)=mean(fitness{i-1});
currentPopulation=population{i-1};
bestIndividual{i-1}=currentPopulation(idxBest);
% draw the results of the last generation
figure(1)
    plot(i-1,bestFitness(i-1),'go')
    hold on
    figure(1)
    plot(i-1,avgFitness(i-1),'co')
    hold on;
    legend('best fitness','average fitness')
    xlabel('generation')
    ylabel('fitness value')
    grid on
    drawnow();

hold off;

