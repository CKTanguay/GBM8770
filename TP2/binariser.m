function [image_binarisee] = binariser(image, seuil)
    image(image>=seuil)=255;
    image(image<seuil)=0;
    image_binarisee = image;
end

