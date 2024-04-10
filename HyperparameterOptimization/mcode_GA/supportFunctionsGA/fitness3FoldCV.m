function [fitnessValidation, encoder, decoder, filenames] = fitness3FoldCV(XFold1, XFold2, XFold3, filenames, hyperparam,latentDim, executionEnvironment)
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
% - filenames: corresponding filenames of the raw data
% - hyperparam: hyperparameters
% - latentDim: latent dimension of the LSTM-VAE
% - executionEnvironment: execution environment ML-model is trained on
%   (code optimized for execution on 'GPU')

% Return Parameters :
% - fitnessValidation: set of three
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
%%

% 3-fold cross validation
for j=1:3

    % compute the fitness value for the first fold
    if j==1
        % devide the folds in data for training and data for testing
        % use only non-anomalous data for training
        XTrain=[XFold2,XFold3];
        XTest=XFold1;
        [fitnessValidation(j), encoder(j), decoder(j)]=getFitnessLSTM_VAE(hyperparam,XTrain, XTest, latentDim, executionEnvironment );
    end
    % compute the fitness value for the second fold
    if j==2
        XTrain=[XFold1,XFold3];
        XTest=XFold2;
        [fitnessValidation(j), encoder(j), decoder(j)]=getFitnessLSTM_VAE(hyperparam,XTrain, XTest, latentDim, executionEnvironment );
    end
    % compute the fitness value for the third fold

    if j==3
        XTrain=[XFold1,XFold2];
        XTest=XFold3;
        [fitnessValidation(j), encoder(j), decoder(j)]=getFitnessLSTM_VAE(hyperparam,XTrain, XTest, latentDim, executionEnvironment );
    end
    %to catch if the elboLoss returns NaN - repeat the evaluation for these
    %instances
    while isnan(fitnessValidation(j))
        [fitnessValidation(j), encoder(j), decoder(j)]=getFitnessLSTM_VAE(hyperparam,XTrain, XTest, latentDim, executionEnvironment );
    end
end
