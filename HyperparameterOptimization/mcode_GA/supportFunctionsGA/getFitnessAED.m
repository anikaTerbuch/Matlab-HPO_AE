function [fitness, aed]=getFitnessAED(hyperparam,XTrain, XTest, executionEnvironment,autoencoderType, encoderLayers, decoderLayers, latentDimension)

% <keywords>
%
% Purpose : This function calculates the fitness of the LSTM_VAE for the
% hyperparameter configuration |hyperparam|
%
% Syntax :
%
% Input Parameters :
% - hyperparam: hyperparameters - evaluated configuration
% - XTrain: data set ML-model is trained on
% - XTest: data set ML-model is tested on (used for deriving fitness)
% - executionEnvironment: execution environment ML-model is trained on
% (code optimized for execution on 'GPU')
%
% Return Parameters :
% fitness: encoderNet, decoderNet evaluated on XTest 
% encoderNet, decoderNet: trained encoder and decoder trained with the hyperparameters|hyperparam|
% and the data |XTrain|
%
% Description :
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
%% Train ML-Model with XTrain
[aed]  = trainAED(hyperparam,XTrain, executionEnvironment,autoencoderType,encoderLayers, decoderLayers,latentDimension);
% convert XTest to a 
% get the reconstructed features
[~, reconstructedX] = aed.reconstructionAED(XTest);
% calculate the reconstruction error
[reconstructionError, ~, ~, ~, ~] = AutoencoderDeep.reconstructionErrorPerSampleAEDvariableLength(XTest,reconstructedX');
% sum up the reconstruction errors per sample to get the fitness
fitness=sum(reconstructionError);
end

