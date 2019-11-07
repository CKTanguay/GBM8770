function [image] = filtrage_spatial(image, sigma)
    hsize = 6 * sigma;
    mask = fspecial('gaussian', hsize, sigma);
    image = conv2(image, mask, 'same');
end

