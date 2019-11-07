function [image_r] = rehaussement_contour(image,masque, K)
Ig = conv2(image, masque, 'same');
image_filtree = filtre_laplacien(Ig);
image_r = Ig + K*image_filtree;
end

