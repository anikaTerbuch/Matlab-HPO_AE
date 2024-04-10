function setRangesOptimization(obj, varargin)
% <keywords>
%
% Purpose : With this function the ranges of the optimizable variables can
% be changed
%
% Syntax : setRangeOptimization(obj,fieldname1, [lowerBound1, upperBound1],
... fieldnameN,[lowerBoundN,upperBoundN]
    %
%
%
% Input Parameters :
%- obj: HPOsettingsAED
% name-value pairs of the fieldnames of the struct of
% optimizableVariables and the corresponding values.
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
%% Check if the number of passed arguments is even - name value pairs
nrInputs = numel( varargin );

if mod(nrInputs,2)==1
    error(['Unexpected number of inputs. ' ...
        'The inputs need to be a name-value pairs.'])
end

%% Define struct of valid values for input assertion
validVals.NumberEpochs="posInteger";
validVals.MiniBatchSize="posInteger";
validVals.BetaKLDivergence="posInteger";
validVals.LearningRate="posNumericMax1";
validVals.NeuronsEncoder="posIntegerArray";
validVals.NeuronsDecoder="posIntegerArray";

%% Get the struct of current values for the optimizableVariables

S=obj.optimizableVariables;

%% Devide into names and values
% odd entries are names, even entries are the corresponding values
names = varargin(1:2:nrInputs-1);
vals = varargin(2:2:nrInputs);

%% Validity checks

% iterate over the current name-value pairs
for v=1:length(names)
    %get the v-th name-value pair
    fieldname=names{v};
    fieldvalue=vals{v};
    % the fieldvalue needs to have the dimension (:,2)
    if(size(fieldvalue,2)~=2)
        error(strcat('Entered range for the optimizable variable '," ", fieldname, ...
            [' does not contain two entries as required for a range.']))
    end



    % check if the passed fieldname |fieldname| is a valid fieldname of the
    % hyperparameter struct
    
    % if the fieldname is starting with 'Neurons' indicating that it
    % referrs to the range of a layer in the encoder and decoder remove the
    % last character - the number - since the number of layers is variable.
    if(strcmp('Neurons',fieldname(1:7)))
        % cut off the digits in the end
        fieldname=fieldname(1:14);

    end
    if isfield(S,names{v})

        varType=validVals.(fieldname);

        % the second entry of the value needs to be greater or equal than the first
        % -> range!


        % switch on the type of variable
        switch varType

            case "posInteger"
                % In a range the frist entry needs to be smaller the frist entry. If
                % the frist entry has the same value as the second value this indicates
                % that the variable should not be optimized
                if (fieldvalue(1)> fieldvalue(2))
                    error(strcat(['The passed range of the optmimizable' ...
                        ' variable']," ",fieldname,[' ' ...
                        'is not a valid range. The frist entry (lower bound)' ...
                        ' has a higher value than the second entry' ...
                        ' (upper bound)']))
                end

                %% check if each of the entries is a positive integer
                assert( (abs(round(fieldvalue(1))) == fieldvalue (1)) ...
                    && (abs(round(fieldvalue(2))) == fieldvalue(2)), ...
                    strcat('The values of the variable ',fieldname, ...
                    ' need to be positive integers'))


            case "posNumericMax1"
                if (fieldvalue(1)> fieldvalue(2))
                    error(strcat(['The passed range of the optmimizable' ...
                        ' variable']," ",fieldname,[' ' ...
                        'is not a valid range. The frist entry (lower bound)' ...
                        ' has a higher value than the second entry' ...
                        ' (upper bound)']))
                end

                %% check if each of the entries is positive and smaller than 1
                assert(fieldvalue(1) == abs(fieldvalue(1))...
                    && fieldvalue(2) == abs(fieldvalue(2)) ...
                    && fieldvalue(1) <= 1 ...
                    && fieldvalue(2)  <= 1,  ...
                    strcat('The values of the variable ',fieldname, [' ' ...
                    ' need to be positive values smaller or equal to 1.']))

               %% the smallest permitted value: 10^-7
           assert(fieldvalue(1)>= 10^-7,['The smallest permitted learning rate ' ...
               'is 10^-7. Please enter a range between 10^-7 and 1.'])

            case "posIntegerArray"
                % check for each of teh entries if it is a positive integer
    
                
                numberEntries=size(fieldvalue,1);

                
                for n=1:numberEntries
                    nthRange=fieldvalue(n,:);


                    
                % In a range the frist entry needs to be smaller the frist entry. If
                % the frist entry has the same value as the second value this indicates
                % that the variable should not be optimized

                if (nthRange(1)> nthRange(2))
                    error(strcat(['Not all passed ranges of the optmimizable' ...
                        ' variable']," ",fieldname,[' ' ...
                        'are valid ranges. The frist entry of one of the ranges (lower bound)' ...
                        ' has a higher value than the second entry' ...
                        ' (upper bound)']))
                end

                %% check if each of the entries is a positive integer
                assert( (abs(round(nthRange(1))) == nthRange (1)) ...
                    && (abs(round(nthRange(2))) == nthRange(2)), ...
                    strcat('The values of the variable ',fieldname, ...
                    ' need to be positive integers'))
                    
                end

        end

    else
        % throw an error if the field entered is not a valid fieldname
        error(strcat('Entered fieldname '," ", fieldname, [' does' ...
            ' not match any optimizable variable.']))
        % end of valid fieldname check
    end

    
    % if all checks were successfull, set the fieldvalue to the new value.
    obj.optimizableVariables.(names{v})=fieldvalue;


    % end of for loop
end

% end of function
end