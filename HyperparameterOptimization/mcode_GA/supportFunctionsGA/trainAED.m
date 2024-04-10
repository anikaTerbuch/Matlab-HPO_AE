function [ae] = trainAED(hyperparam,XTrain, executionEnvironment,autoencoderType,encoderLayers, decoderLayers, latentDim)
% <keywords>
%
% Purpose : 
%
% Syntax :
%
% Input Parameters :
%
% Return Parameters :
%
% Description :
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{04-Feb-2022}{Original}
% \change{2.0}{05-Aug-2022}
% \change{3.0}{24-Feb-2023}
% --------------------------------------------------
% (c) 2022, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Instantiate an Autoencoder deep

% set the hyperparameters
% extract the hyperparameters from the evaluated individual of the current
% population of the genetic algorithm

% variable number of layers in the encoder and decoder
nrLayersEncoder=length(encoderLayers);
nrLayersDecoder=length(decoderLayers);

% instantiate the hyperparameter struct
hp=HyperparametersAED();

% counter 
idx=1;
% conditional parameter weighting function in the cost function of the
% variational autoencoder
if autoencoderType=="VAE"
    weigthingKL=hyperparam{idx};
    hp.setHyperparametersAED('WeightingKL',weigthingKL)
    idx=idx+1;
end

learningRate=hyperparam{idx}*10^-7;
idx=idx+1;

miniBatchSize=hyperparam{idx};
idx=idx+1;

idxD=idx+nrLayersDecoder-1;
neuronsDecoder(:)=cell2mat(hyperparam(idx:idxD));
idx=idx+nrLayersDecoder;

idxE=idx+nrLayersEncoder-1;
neuronsEncoder(:)=cell2mat(hyperparam(idx:idxE));
idx=idx+nrLayersEncoder;

numberEpochs=hyperparam{idx};



hp.setHyperparametersAED('NumberEpoch',numberEpochs, ...
    'NeuronsEncoder',neuronsEncoder, ...
    'NeuronsDecoder',neuronsDecoder, ...
    'LearningRate',learningRate, ...
    'MiniBatchSize',miniBatchSize, ...
    'ExecutionEnvironment',executionEnvironment, ...
    'LatentDim', latentDim,...
    'AutoencoderType',autoencoderType, ...
    'LayersEncoder', encoderLayers, ...
    'LayersDecoder',decoderLayers);
% train the AED with the data |XTrain|




ae=trainAutoencoderDeep(XTrain,hp);



end