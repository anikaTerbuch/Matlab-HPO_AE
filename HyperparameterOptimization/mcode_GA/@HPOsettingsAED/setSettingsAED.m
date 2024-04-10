function setSettingsAED(obj, varargin)
% AED, inputChecking, GA
%
% Purpose : With this function the settings of autoencoder deep -
% architecture that is optimized with the genetic algorithm is specified.
% The settings are stored in the struct |settingsAED| and can be customized
% with this function.
%
% Syntax : setSettingsAED(obj, varargin)
%
% Input Parameters :
% - obj: HPOsettingsAED
% - vargin: name-value pairs of the fieldnames of the struct of
% settingsAED and the corresponding values.

% Return Parameters: This function performs input checking based on a
% pre-defined set of possible input values (data type or categorical value)
% and assigns the hypeprarameter to the new value when the checks were
% sucessfull.
%
% Description :
%
% Author :
%    Anika Terbuch
%
% History :
% \change{1.0}{22-Feb-2023}{Original}
%
% --------------------------------------------------
% (c) 2023, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Check if the number of passed arguments is even - name value pairs
nrInputs = numel( varargin );

if mod(nrInputs,2)==1
    error(['Unexpected number of inputs. ' ...
        'The inputs need to be a name-value pairs.'])
end

%% Define struct of valid values for input assertion
%Define the valid values for each of the fields of the struct settingsAED
validVals=struct;
% numeric input
validVals.LatentDimension='posInteger';
% one of the following categorical values
validVals.ExecutionEnvironment={'cpu','gpu','auto'};
validVals.AutoencoderType={'VAE','AE'};
% array of categorical values - define two 'valid Vals' - one for datatye
% one for categorical values
validVals.LayersEncoder='categoricalArray';
validVals.LayersDecoder='categoricalArray';
%
validVals.LayersEncoderTypes={'FC','LSTM','Bi-LSTM'};
validVals.LayersDecoderTypes={'FC','LSTM','Bi-LSTM'};


%% Devide passed inputs intp names and values
% odd entries are names, even entries are the corresponding values
names = varargin(1:2:nrInputs-1);
vals = varargin(2:2:nrInputs);


%% Assertion of the AED settings which should be changed

% get the struct of settingsAED
S=obj.settingsAED;

% check if the passed values have valid values for the variables. The
% possible inputs (types or categorical values) are defined in the
% struct |validVals|

% iterate over the passed name-value pairs
for v=1:length(names)

    % get the current name-value pair
    fieldname=names{v};
    fieldvalue=vals{v};

    % check if the passed fieldname |fieldname| is a valid fieldname of the
    % struct |settingsAED|
    if isfield(S,fieldname)
        if iscell(validVals.(fieldname))
            % checks if the return array of valid strings is not empty
            % checks if the passed value matches one of the specified
            % values
            if ~any(validatestring(fieldvalue,validVals.(fieldname)))
                error(fieldvalue)
            end

        else
            % all other cases -> switch on varType

            % pull out the value specified in the struct of valid
            % variables -> indicates of which type the variable should
            % be
            varType=validVals.(fieldname);

            switch varType

                case "posInteger"
                    % check if the entry is numeric
                    assert(isnumeric(fieldvalue),['The latent dimension needs to ' ...
                        'be a positive integer.'])
                    % check if the passed fieldvalue is an integer
                    if ~(fieldvalue == floor(fieldvalue)) || fieldvalue < 0
                        error(strcat('The settingAED '," ", fieldname, ...
                            ['  can only take ' ...
                            'positive integer values.']))
                    end

                case "categoricalArray"
                    if ~iscell(fieldvalue)
                        errorMsg=strcat(fieldname,': This settingAED can only take cell-arrays as its values');
                        error(errorMsg)
                    end
                    categoricalVals=char(strcat(fieldname,'Types'));
                    % iterate over the length of the passed array - check
                    % for each entry if passed entry is a valid categorical
                    % value
                    for i=1:length(fieldvalue)
                        % checks if the return array of valid strings is not empty
                        % checks if the passed value matches one of the specified
                        % values
                        ithfieldvalue=string(fieldvalue{i});
                        if ~any(validatestring(ithfieldvalue,validVals.(categoricalVals)))
                            error(ithfieldvalue)
                        end
                    end

                    % end of switch
            end


        end


    else
        % throw an error if the field entered is not a valid fieldname
        error(strcat('Entered fieldname '," ", fieldname, [' does' ...
            ' not match any autoencoder setting specified in the struct ' ...
            'settingsAED.']))
        % end of if - isfield
    end

    %% Assigning
    % set the parameter (fieldname) to the new value fieldvalue
    S.(fieldname)=fieldvalue;

    % end of for
end

% re-assigning the struct of settingsAED to the object

%% Consistency adjustments
% the settings in the struct settingsAED have imidiate impact on the
% optimization variables.
% To ensure consistency, the following changes need to be performed:

% the KL-divergence is only part of the cost function if the
% Autoencoder-Type is chosen to be "VAE"
if S.AutoencoderType=="AE" && isfield(obj.optimizableVariables,"BetaKLDivergence")
    obj.optimizableVariables=rmfield(obj.optimizableVariables,"BetaKLDivergence");
end

% check if the number of layers of the encoder was changed
encOld=length(obj.settingsAED.LayersEncoder);
encNew=length(S.LayersEncoder);

diffEnc=encOld-encNew;

optiNew=obj.optimizableVariables;


% the number of layers in the encoder was reduced
if diffEnc > 0
    for e=encNew+1:encOld
        % construct fieldname of the e-th encoder layer in the struct
        % optimizableVariabels
        ethEnc=strcat('NeuronsEncoderLayer',string(e));
        % remove the field with the fieldname |ethEnc|
        optiNew=rmfield(optiNew,(ethEnc));
    end

    % the number of layers in the encoder was increased
elseif (diffEnc < 0)
    for e=encOld+1:encNew
        % construct the fieldname of the e-th encoder layer in the struct
        % optimizableVariables
        ethEnc=strcat('NeuronsEncoderLayer',string(e));
        % add this field to the struct and initialize it with default
        % values
        optiNew.(ethEnc)=[1,20];

    end
end

% check if the number of layers of the decoder was changed
decOld=length(obj.settingsAED.LayersDecoder);
decNew=length(S.LayersDecoder);

diffDec=decOld-decNew;
if diffDec > 0
    for e=decNew+1:decOld
        % construct fieldname of the e-th decoder layer in the struct
        % optimizableVariabels
        ethDec=strcat('NeuronsDecoderLayer',string(e));
        % remove the field with the fieldname |ethEnc|
        optiNew=rmfield(optiNew,(ethDec));
    end

    % the number of layers in the encoder was increased
elseif diffDec < 0
    for e=decOld+1:decNew
        % construct the fieldname of the e-th decoder layer in the struct
        % optimizableVariables
        ethDec=strcat('NeuronsDecoderLayer',string(e));
        % add this field to the struct and initialize it with default
        % values
        optiNew.(ethDec)=[1,20];

    end
end


optiNew=orderfields(optiNew);

%re-assign the structs to the object after modification
obj.optimizableVariables=optiNew;
obj.settingsAED=S;


% end of function
end