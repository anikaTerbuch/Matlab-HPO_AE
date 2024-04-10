function defaultOptimVar(obj)
% AED, genetic algorithm, default
%
% Purpose : 
% This function is used to create a struct with the default values with the
% optimizable variables of the AED.
%
% Syntax : defaultOptimVar
%
% Input Parameters :
%
% Return Parameters :
%
% Description : Before running the hyperparameter optimization, the ranges
% of the variables which should be optimized need to be set. That function
% pre-initializes the values with default values which can be changed by
% the user.
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{06-Feb-2023}{Original}
%
% --------------------------------------------------
% (c) 2023, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%% Create a default struct
defaultStructOptimVal=struct();

defaultStructOptimVal.NumberEpochs=[1,200];
defaultStructOptimVal.NeuronsEncoderLayer1=[1,20];
defaultStructOptimVal.NeuronsEncoderLayer2=[1,10];
defaultStructOptimVal.NeuronsDecoderLayer1=[1,30];
defaultStructOptimVal.LearningRate=[0.00001, 0.001];
% the max. value for the batch size is adjusted after the optimization data
% is specified. It can at most be 2/3 * numberExamplesForOptimization
defaultStructOptimVal.MiniBatchSize=[2,100];
% this variable can only be optimized when the autoencoder type is "VAE".
% This is the weighting factor of the second term of the cost function of
% the VAE.
defaultStructOptimVal.BetaKLDivergence=[0,100];

defaultStructOptimVal = orderfields(defaultStructOptimVal);

% assign the default struct to the AED stored in the variable obj
obj.optimizableVariables=defaultStructOptimVal;






