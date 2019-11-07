function [image_filtree] = filtrage_frequentiel(image, d0)
    [m,n] = size(image);
    [x1,y1] = freqspace([m,n], 'meshgrid');
    u = x1/2;
    v = y1/2;
    
    spectre = fftshift(fft2(image));
    H = exp((-u.^2-v.^2)./(2*d0^2));
    conv_image = spectre.*H;
    
    image_filtree = normalize(ifft2(ifftshift(conv_image)));
    
    
end

