function[aedP, fitness] = intEvaluation3CVAED(data,population, executionEnvironment,autoencoderType, encoderLayers,decoderLayers, latentDimension)

% <keywords>
%
% Purpose : This function evaluates the fitness the individuals that form the poulation
% using XData
%
% Syntax :
%
% Input Parameters :
% - dataPath: path the site folder which contains the MAT files used for
%   the HPO
% - population: population which should be evaluated
% - executionEnvironment: execution environment for training the ML-models
%                         code optimized for 'GPU'
%
% Return Parameters :
% - aedP: all trained AutoencoderDeep
% - fitness: fitness of each individual
%
% Description :
% To get a better estimate of the performance 3-fold cross-validation is
% used.
%
% Author :
%    Anika Terbuch
%
% History :
% \change{1.0}{05-Nov-2021}{Original}
% \change{2.0}{05-Aug-2022}- added LatentDim as HP
%
% --------------------------------------------------
% (c) 2021, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Resampling of the input data
[XFold1, XFold2, XFold3] = resamplingCV(data);
% assign it the fitness value
% 3-fold cross validation

% store all allready calculated hyperparameter configurations in a matrix
calculatedParam=zeros(length(population),length(cell2mat(population{1})));
% initialize array to store the fitness value of each individual
fitness=NaN(1,length(population));
for i=1:length(population)
    % initialize / reset fitness validation array
    fitnessValidation=[];

    % get the i-th individual of the population
    hyperparam=population{i};
    % compute fitness value of the hyperparameter setting only if that
    % configuration wasn't calculated before -> if it was calcluated in
    % earlier in that generation assign it the fintess value of the earlier
    % computation

    %member contains 1 if the hyperparam is allredy a member of
    %"calculatedParam" - location gives the index of the parameter
    [mem,loc]=ismember(cell2mat(hyperparam),calculatedParam,'rows');

    % calulate fintess values only if the fintess value for the
    % same configuration wasn't calculated before
    if mem==0
        % assign it the fitness value
        [fitnessValidation, aed] = fitness3FoldCVAED(XFold1, XFold2, XFold3, hyperparam, executionEnvironment,autoencoderType, encoderLayers, decoderLayers, latentDimension);
    else
        % no new autoencoderDeep was trained
        aedP{i}=[];
        % parameters where allredy calculated earlier
        fitness(i)=fitness(loc);
    end

    % convert the dlarray to an normal array
    if isa(fitnessValidation,'dlarray')
        fitnessValidation=extractdata(fitnessValidation);
    end
    % add the current configuration to the set of calculated parameters
    calculatedParam(i,:)=cell2mat(hyperparam);
    % calculate the fitness of the i-th individual as the mean values of
    % the 3 values obtained in cross validation
    % if fitness value wasn't calculated again, no values in the
    % fitnessValidation vector
    if isnan(fitness(i))
        %use average of the three runs as fitness
        fitness(i)=mean(fitnessValidation);
        %  fitness(i)=mean(fitnessValidation)
        % store all the ML-models that where trained to evaluate the current
        % configuration, for each configuration 3 LSTM-VAEs where trained because
        % 3-fold cross validation was performed
        aedP{i}=aed;
    end

    % end of loop over all individuals
end