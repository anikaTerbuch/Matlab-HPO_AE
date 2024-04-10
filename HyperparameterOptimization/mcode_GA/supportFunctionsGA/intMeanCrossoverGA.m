function child = intMeanCrossoverGA(parentA, parentB)
% <keywords>
%
% Purpose : The purpose of this function is to perform a crossover where
% the mean of the alleles is taken as allele of the cild.
%
% Syntax :
%
% Input Parameters :
% - parentA - first parent that is used for the crossover
% - parentB - second parent for the crossover
%
% Return Parameters :
% - child: offspring of the crossover
%
% Description : for every component of the individual the mean value of the
% components of the parents is taken as value for the offspring.
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{04-Feb-2021}{Original}
% \change{2.0}{16-Feb-2022} adaption for AED
%
% --------------------------------------------------
% (c) 2021, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
numVar=length(parentA);
for i=1:numVar
    try
        % gene consits of one single entry
        child{i}=round((parentA{i}+parentB{i})./2);
    catch 
        % get the array which represents the gene
        genA=parentA{i};
        genB=parentB{i};
        % gene consists of more than one entry
        lenGen=length(parentA{i});

        for j=1:genA
            genEntry(j)=round((genA(j)+genB(j))./2);
        end
        child{i}=genEntry;
    end

end