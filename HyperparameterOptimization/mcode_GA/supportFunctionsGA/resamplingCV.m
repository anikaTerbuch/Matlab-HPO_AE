function[XFold1, XFold2, XFold3] = resamplingCV (XData)
% <keywords>
%
% Purpose : the purpose of this function is to split the samples in "XData"
% in three folds which can be used for
% 3-fold-cross-validation.
%
% Syntax :
%
% Input Parameters :
% -XData: containing the samples - cell array
% -filenames: corresponding filenames to "XData" - array
%
% Return Parameters :
% XFold1, XFold2, XFold3: Folds of data for performing CV
% filenames: filenames of the data

% Description : Before assigning the data to the folds, a random
% permutation is done. After that the data is splitted in three (allmost)
% same sized folds.
%
% Author : 
%    Anika Terbuch
%
% History :
% \change{1.0}{26-Jan-2021}{Original}
% \change{2.0}{27-Feb-2021}
% \change{3.0}{16-Feb-2022} adjusted for AED with varying length inputs
% --------------------------------------------------
% (c) 2021, Anika Terbuch
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Permutation
% permutate the data before assigning it to folds for cross-validation
sizeSample=size(XData,1);
idxP=randperm(sizeSample);
% adjust the file names to the permutation
%filenames=filenames(idxP);
% calculate the indices for the folds
% split the data in 3 nearly equal large portions
%% Assigning data to the folds
% calculating the indices
sf1=floor(sizeSample/3);
sf2=round((sizeSample-sf1)/2);
sf3=sizeSample-sf2-sf1;
% %
indices1=idxP(1:sf1);
i2=round(sf1+sf2);
indices2=idxP(sf2+1:i2);
i3=sf1+sf3+sf3;
indices3=idxP(i2+1:i3);
% 1st fold
XFold1{:}=XData(indices1);
% 2nd fold
XFold2{:}=XData(indices2);
% 3rd fold
XFold3{:}=XData(indices3);

% nameFirst=filenames(indices1);
% nameSecond=filenames(indices2);
% nameThird=filenames(indices3);

% obsolete since v200
%lengthFirst=varyingLength(indices1);
%lengthSecond=varyingLength(indices2);
%lengthThird=varyingLength(indices3);
% clear filenames
%clear varyingLength
% 
% filenames{1}=nameFirst;
% filenames{2}=nameSecond;
% filenames{3}=nameThird;

% obsolete since V200
%varyingLength{1}=lengthFirst;
%varyingLength{2}=lengthSecond;
%varyingLength{3}=lengthThird;

end
