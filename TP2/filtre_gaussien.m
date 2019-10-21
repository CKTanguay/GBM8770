function [image_filtre] = filtre_gaussien(image,masque)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
image_filtre = conv2(image,masque,'same');
end

