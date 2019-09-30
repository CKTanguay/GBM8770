function [C] = contraste(yC1,yC2,xC1,xC2, yF1,yF2, xF1,xF2,matrix)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Rcible = matrix(yC1:yC2, xC1:xC2);
Rfond = matrix(yF1:yF2, xF1:xF2);
Icible = mean2(Rcible);
Ifond = mean2(Rfond);
C=abs((Icible-Ifond)/Ifond);
end

