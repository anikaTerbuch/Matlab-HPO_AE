function [fitnessValidation, aed] = fitness3FoldCVAED(XFold1, XFold2, XFold3, hyperparam, executionEnvironment,autoencoderType, encoderLayers, decoderLayers, latentDimension)
% <keywords>
%
% Purpose : This function trains three machine learning models with the
% same hyperparameters to get a better estimate of the performance of a
% hyperparameter setting hold by the individual which fitness is evaluated.
%
% Syntax :
%
% Input Parameters :
% - XFold1, XFold2, XFold3: data the ML-model is trained and tested on,
%   in the computation of each ML-model, 2 folds used for training, one for
%   testing
% - hyperparam: hyperparameters
% - executionEnvironment: execution environment ML-model is trained on
%   (code optimized for execution on 'GPU')
% - autoencoderType e.g. 'AE' or 'VAE'
% - encoderLayers e.g. 'LSTM' 'Bi-LSTM'
% - decoderLayers e.g. 'LSTM' 'Bi-LSTM'

% Return Parameters :
% -fitnessValidation: fitness on the validation set
% -aed: AutoencoderDeep
% -filenames: filenames the |aed|'s were trained on
% 
% Description :
%
% Author :
%    Anika Terbuch
%
% History :
% \change{1.0}{05-Nov-2021}{Original}
% \change{2.0}{16-Feb-2022} adjustments for the use on AED
% \change{3.0}{05-Aug-2022}- added LatentDim as HP
% --------------------------------------------------
% (c) 2021, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%


% 3-fold cross validation
for j=1:3

    % compute the fitness value for the first fold
    if j==1
        % devide the folds in data for training and data for testing
        % use only non-anomalous data for training
        XTrain= [XFold2{1};XFold3{1}];
        XTest=XFold1{1};
       % varLenTrain=[varyingLength{2};varyingLength{3}];
        [fitnessValidation(j), aed(j)]=getFitnessAED(hyperparam,XTrain, XTest, executionEnvironment,autoencoderType, encoderLayers, decoderLayers, latentDimension);
    end
    % compute the fitness value for the second fold
    if j==2
        XTrain= [XFold1{1};XFold3{1}];
        XTest=XFold2{1};
      %  varLenTrain=[varyingLength{1};varyingLength{3}];
        [fitnessValidation(j), aed(j)]=getFitnessAED(hyperparam,XTrain, XTest, executionEnvironment,autoencoderType, encoderLayers, decoderLayers,latentDimension);
    end
    % compute the fitness value for the third fold

    if j==3
        XTrain= [XFold1{1};XFold2{1}];
        XTest=XFold3{1};
      %  varLenTrain=[varyingLength{1};varyingLength{2}];
        [fitnessValidation(j), aed(j)]=getFitnessAED(hyperparam,XTrain, XTest, executionEnvironment,autoencoderType, encoderLayers, decoderLayers,latentDimension);
    end
    %to catch if the elboLoss returns NaN - repeat the evaluation for these
    %instances
    while isnan(fitnessValidation(j))
        [fitnessValidation(j), aed(j)]=getFitnessAED(hyperparam,XTrain, XTest, executionEnvironment,autoencoderType, encoderLayers, decoderLayers,latentDimension);
    end
end
