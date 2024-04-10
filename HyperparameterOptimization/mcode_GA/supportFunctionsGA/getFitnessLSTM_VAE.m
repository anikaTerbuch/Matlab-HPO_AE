function [fitness, encoderNet, decoderNet]=getFitnessLSTM_VAE(hyperparam,XTrain, XTest, latentDim, executionEnvironment )

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
% - latentDim: dimension of the latent space of the LSTM-VAE
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
%
% --------------------------------------------------
% (c) 2021, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Train ML-Model with XTrain
[encoderNet, decoderNet]  = LSTM_VAE(hyperparam,XTrain, latentDim, executionEnvironment);
% get the reconstructed features
[reconstructedX, ~, ~] = encodingDecoding(encoderNet, decoderNet, XTest);

% calculate the reconstruction error of the prediction on the reduced test
% set
recFit=abs(reconstructedX-XTest);
% error per channel & per sample
recFit=squeeze(sum(recFit,3));
% convert array from gpu dlarray to normal array
recFit=gather(recFit);
recFit=extractdata(recFit);
% error per channel
recFit=squeeze(sum(recFit,1));
% error used for fitness
fitness=squeeze(sum(recFit));
