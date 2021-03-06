function [p,q,D,Diff,WarpingPath] = DTWContXY(X1,X2)
% [p,q] = dp(M)
%    Use dynamic programming to find a min-cost path through matrix M.
%    Return state sequence in p,q
% 2003-03-15 dpwe@ee.columbia.edu

% Copyright (c) 2003 Dan Ellis <dpwe@ee.columbia.edu>
% released under GPL - see file COPYRIGHT
%Alighn X2 , Y2 to X1,Y1

% a = dlmread ('C:\OCRData\Features\ShapeContext\8.m');
% b = dlmread ('C:\OCRData\Features\ShapeContext\8A.m');
% [p,q,D,Diffs1,WarpingPath] = DTWContXY(a,b);

[L1,t] = size(X1);
[L2,t] = size(X2);

Mx = mean(X1);
MRep = repmat(Mx,L1,1);
X1= X1 - MRep ;

Mx = mean(X2);
MRep = repmat(Mx,L2,1);
X2= X2 - MRep ;

% costs
D = zeros(L1, L2);

WarpingPath = 0;
%    return DTW[n, m]
D(1,:) = NaN;
D(:,1) = NaN;
D(1,1) = 0;
%D(2:(r+1), 2:(c+1)) = M;
%D(2:(r+1), 1) = A1;
%D(1,2:(c+1)) = A2;
% traceback
phi = zeros(L1,L2);
k=0;

for i = 2:L1
    %  for j=max(2, i-w):min(L2, i+w)
    for j = 2:L2
        %      CS = (A1(i)-A2(j))^2*(L1(i)-L2(j))^2;
        %    CI = (A1(i)-A1(i-1))^2*(L1(i)-L1(i-1))^2;
        %   CD = (A2(j)-A2(j-1))^2*(L2(j)-L2(j-1))^2;
        %  Cost = sqrt((X2(j,2)-X1(i,2))^2 + (X2(j,1)-X1(i,1))^2);
        
        %Cost = dist(X2(j,:),X1(i,:)');
        Cost = ComputeDist(X2(j,:),X1(i,:));
        [dmax, tb] = min([D(i, j-1), D(i-1, j), D(i-1, j-1)]);
        D(i,j) = dmax+Cost;
        phi(i,j) = tb;
        k=k+1;
    end
end

% Traceback from top left
i = L1;
j = L2;
p = i;
q = j;
while i > 1 && j > 1
    tb = phi(i,j);
    WarpingPath = [tb,WarpingPath];
    if (tb == 3)
        i = i-1;
        j = j-1;
    elseif (tb == 2)
        i = i-1;
    elseif (tb == 1)
        j = j-1;
    else
        Diff=inf;
    end
    p = [i,p];
    q = [j,q];
end

% Strip off the edges of the D matrix before returning
%D = D(2:(r+1),2:(c+1));
Diff = D(L1,L2)/size(p,2) ; %abs(r+c);