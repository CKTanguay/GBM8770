function [I_reduite] = reduire(I_originale,f)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%dims = size(matrix);
width = size(I_originale,1);
height = size(I_originale,2);
I_reduite = zeros(width/f, height/f);

for i=1:width/f
    temp=zeros(1, height/f)
    for j=1:height/f
        temp(j) = I_originale(i*f,j*f);
               
    end
    I_reduite(i,:) = temp;
end    
end

