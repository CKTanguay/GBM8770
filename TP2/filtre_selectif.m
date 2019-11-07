function [image_filtree] = filtre_selectif(image, frequences_coupure, cx, cy)
    [m,n] = size(image);
    [x1,y1] = freqspace([m,n], 'meshgrid');
    u = x1/2;
    v = y1/2;
    
    dim = size(cx);
    masque = zeros();
    
    for i=1:dim
        gauss_pos = exp(sqrt((u-cx(i)).^2 + (v-cy(i)).^2)./(2*frequences_coupure(i).^2));
        gauss_neg = exp(sqrt((u+cx(i)).^2 + (v+cy(i)).^2)./(2*frequences_coupure(i).^2));
        masque = masque + (gauss_pos + gauss_neg);
    end
    masque = 1 - masque;
    
    
    spectre = fftshift(fft2(image));
    image_filtree = normalize(ifftshift(ifft2(masque.*spectre)));
end

