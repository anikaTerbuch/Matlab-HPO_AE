function rangeScalingOptiVar(obj)
% <keywords>
%
% Purpose : This function converts the ranges set by the user to integer
% ranges used in the genetic algorithm. This is done because the here
% implemented algorithm requires integer ranges for all the optimized
% variables. In this version, only the learning rate is a double in the
% range [10^-7, 1], so only this field needs to be scaled to the integer
% domain.
%
% Syntax :
%
% Input Parameters :
% - obj: object of the class HPOsettingsAED.
%
% Return Parameters :
%
% Description :
%
% Author :
%    Anika Terbuch
%
% History :
% \change{1.0}{23-Feb-2023}{Original}
%
% --------------------------------------------------
% (c) 2023, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Execute only if this function wasn't applied before on the object |obj|
% if not executed before -> no struct
if ~(isempty(fieldnames( obj.geneRanges)))
    warning('The ranges were already rescaled before.')
else
    %% Copy and scale
    scaledStruct=obj.optimizableVariables;
    scaledStruct.LearningRate=scaledStruct.LearningRate*10^7;

    %% assign the struct to the hidden variable of the object (internal use only)
    obj.geneRanges=scaledStruct;
end