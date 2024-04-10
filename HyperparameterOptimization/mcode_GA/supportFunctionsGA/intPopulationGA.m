function population = intPopulationGA(HPOsettingsAED)
% <keywords>
%
% Purpose : The purpose of this function is to create a population that can
% be used for the genetic algorithm.
%
% Syntax :
%
% Input Parameters :
% - HPOsettingsAED: object of the class HPOsettingsAED containing the
% settings regarding the optimization of the architecture specified in the
% object itself.
%
% Return Parameters :
% - population: array that consists of "size" possible solutions
%
% Description : Number "size" individuals are created and stored in an
% array that represents the population. 
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{30-Dec-2020}{Original}
% \change{2.0}{23-Feb-2023}
%
% --------------------------------------------------
% (c) 2020, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Input checking
% check if the passed input is an object of the class |HPOsettingsAED|
%% Extract the variables needed from the object |HPOsettingsAED|
populationSize=HPOsettingsAED.settingsGA.PopulationSize;
% extract the ranges of the variables 
ranges=cell2mat( struct2cell( HPOsettingsAED.geneRanges ));
% extract the entries for the upper bound from the ranges of the genes
ub=int32(ranges(:,2));
% extract the entries for the lower bounds from the ranges of the genes
lb=int32(ranges(:,1));

%save the ranges into the hidden struct |geneRanges| for later use
HPOsettingsAED.setBoundsGenes(lb,ub);

population={};
for s=1:populationSize
    population{s}=intIndividualGA(ub, lb);
end