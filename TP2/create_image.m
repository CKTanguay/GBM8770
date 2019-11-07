function [image] = create_image(s1, s2)
    image = zeros(256);
    
    for i=1:256
        for j=1:256
            if i<128
                image(i,j) = sin(2*pi*s1*j/256);
            else
                image(i,j) = sin(2*pi*s2*i/256);
            end
        end
    end
end

