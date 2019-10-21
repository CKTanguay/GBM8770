function [image_filtre] = filtre_laplacien(image)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
masque = [-1 -1 -1 ; -1 8 -1 ; -1 -1 -1];
image_filtre = conv2(image, masque, 'same');
end

