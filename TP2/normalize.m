function [image_norm] = normalize(image)
    max_image = max(image, [], 'all');
    min_image = min(image, [], 'all');
    [m,n] = size(image);
    image_norm = image;
    
    for i=1:m
        for j=1:n
            image_norm(i,j) = (image(i,j) - min_image) / (max_image - min_image);
        end
    end
end

