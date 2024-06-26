function defaultSettingsAED(obj)
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
% \change{1.0}{06-Feb-2023}{Original}
%
% --------------------------------------------------
% (c) 2023, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Creates a default struct for the settings needed to initialize an
%% AutoencoderDeep
defaultStructAED.LatentDimension=2;
defaultStructAED.ExecutionEnvironment='auto';
defaultStructAED.AutoencoderType='VAE';
defaultStructAED.LayersEncoder={'FC','LSTM'};
defaultStructAED.LayersDecoder={'Bi-LSTM'};

obj.settingsAED=defaultStructAED;
