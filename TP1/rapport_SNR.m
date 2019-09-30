function [snr] = rapport_SNR(yC1,yC2,xC1,xC2, yF1,yF2, xF1,xF2,matrix)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

Fcible = mean2(matrix(yC1:yC2, xC1:xC2));
Ffond = mean2(matrix(yF1:yF2, xF1:xF2));

fond = double(matrix(yF1:yF2, xF1:xF2));

aire = (yC2 - yC1)*(xC2 - xC1);
ecart_type_fond = std(fond(:));

snr = aire*abs(Fcible - Ffond)/ecart_type_fond;

end

