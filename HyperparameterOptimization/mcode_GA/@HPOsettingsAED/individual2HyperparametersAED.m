function hpObj=individual2HyperparametersAED(optiSettings,bestIndividual)
% <keywords>
%
% Purpose : This function creates from an indiviudal of the hyperparameter
% optimization the hyperparmater struct used to train an AutoencoderDeep
%
% Syntax : HyperparamterersAED=individual2HyperparametersAED(optiSettings,bestIndividual)
%
% Input Parameters :
%  - optiSettings: optimization settings which were used during the
%  hyperparamter optimization using the genetic algorithm
% - bestIndividual: best individual of the last generation for which the
% hyperparameter object should be created
%
% Return Parameters :
% - hpObj: object of the class HyperparametersAED containing the values for
% the hyperparameters represented by the best individual
%
% Description :
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{13-Apr-2023}{Original}
%
% --------------------------------------------------
% (c) 2023, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Check the passed input arguments
arguments
    optiSettings (1,1) HPOsettingsAED
    bestIndividual(1,:)
end

% create an object of the class HyperparametersAED()
hpObj=HyperparametersAED();

% get the fieldnames of the optimized variables
fieldnamesOpti=fieldnames(optiSettings.optimizableVariables);
assert(length(fieldnamesOpti)==length(bestIndividual),'The passed best individual does not match with the passed optimization settings.')

% set the first three values and the last value
hpObj.setHyperparametersAED('WeightingKL',bestIndividual{1}, ...
    'LearningRate',bestIndividual{2}*10^-7, ...
    'MiniBatchSize',bestIndividual{3}, ...
    'NumberEpoch',bestIndividual{length(bestIndividual)})

% determine the number of layers in the encoder and decoder
layersEncoder=length(optiSettings.settingsAED.LayersEncoder);
layersDecoder=length(optiSettings.settingsAED.LayersDecoder);

idxDecStart=3+1;
idxDecEnd=3+layersDecoder;
idxEncStart=idxDecEnd+1;
idxEncEnd=idxDecEnd+layersEncoder;


% get the entries for the encoder and decoder
arrDec=cell2mat(bestIndividual(idxDecStart:idxDecEnd));
arrEnc=cell2mat(bestIndividual(idxEncStart:idxEncEnd));


% assign the number of neurons to the hyperparamter settings
hpObj.setHyperparametersAED('NeuronsEncoder',arrEnc,'NeuronsDecoder',arrDec);


