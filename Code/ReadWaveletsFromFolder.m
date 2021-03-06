function [WaveletMatrix,WPmap] = ReadWaveletsFromFolder( WaveletsFolder )
%READWAVELETSFROMFOLDER Summary of this function goes here
%   Detailed explanation goes here

dirlist = dir(WaveletsFolder);
Num=0;
h = waitbar(0,('Reading Wavelet Data... Please Wait...'));
DirListLength = length(dirlist);

WPmap = cell(DirListLength-2,1);
[M,N] = GetVectorDimensionFromFolder( WaveletsFolder );
WaveletMatrix= zeros(DirListLength-2,M);

for j = 3:DirListLength
    current_object = dirlist(j);
    FileName = current_object.name;
    WPTWavelet = dlmread([WaveletsFolder,'\',FileName]);
    FileNameCell = {FileName};
    WPmap(j-2) = FileNameCell;
    WaveletMatrix(j-2,:) = WPTWavelet';
    prog = j/DirListLength;
    waitbar(prog,h);
    Num=Num+1;
end
close (h);
end

