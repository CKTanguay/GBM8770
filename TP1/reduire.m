function [I_reduite] = reduire(I_originale,f)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%dims = size(matrix);
width = size(I_originale,1);
height = size(I_originale,2);
I_reduite = zeros(floor(width/f), floor(height/f), 'uint8');
for i=1:floor(width/f)
    for j=1:floor(height/f)
        I_reduite(i,j) = I_originale(i*f,j*f);
    end    
end    
end