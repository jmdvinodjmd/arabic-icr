function [RecognitionResults, SumDist] = RecognizeSequence (Sequence , Alg, Position, LettersDataStructure)
%RECOGNIZESEQUENCE return a list of the most similar letters with the
%distance from the given sequence.

C = RecognizeLetter( Sequence, LettersDataStructure, Position, Alg);
RecognitionResults = [];
for i=1:size(C,1)
    RecognitionResults = [RecognitionResults;{C(i,1),C{i,2}}];
end 
if (nargout==2)
    SumDist = NaN;
end