function setBoundsGenes(obj, lowerBounds, upperBounds)
% <keywords>
%
% Purpose : This function is used to save the bounds of the optimization
% variables in two fields of the struct geneRanges during the creation of
% the first generation.
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
% \change{1.0}{23-Feb-2023}{Original}
%
% --------------------------------------------------
% (c) 2023, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%

%% set the fields of the struct |geneRanges|
obj.geneRanges.LowerBounds=lowerBounds;
obj.geneRanges.UpperBounds=upperBounds;

end
