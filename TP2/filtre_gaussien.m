function [image_filtre] = filtre_gaussien(image,masque)
image_filtre = conv2(image,masque,'same');
end

