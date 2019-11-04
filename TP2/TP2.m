%% Exercice 1
% Q1
matrix = imread("fundus.png");
figure(),imshow(matrix)
title('Disque optique dans une image fundus')
figure(),mesh(matrix)
title('Intensité')

% Q2
type filtre_gaussien.m

%Q3
masque1 = 1/16*[1 2 1; 2 4 2 ; 1 2 1];
masque2 = 1/100*[1 2 4 2 1 ; 2 4 8 4 2 ; 4 8 16 8 4 ; 2 4 8 4 2 ; 1 2 4 2 1];
masque3 = 1/484*[1 2 4 8 4 2 1 ; 2 4 8 16 8 4 2 ; 4 8 16 32 16 8 4 ; 8 16 32 64 32 16 8 ;
    4 8 16 32 16 8 4 ; 2 4 8 16 8 4 2 ; 1 2 4 8 4 2 1];

image_filtre1 = filtre_gaussien(matrix,masque1);
figure(), imshow(image_filtre1,[])
title('Image filtrée avec masque 3x3')
figure(), mesh(image_filtre1)
title('Intensité image filtrée masque 3x3')

image_filtre2 = filtre_gaussien(matrix,masque2);
figure(), imshow(image_filtre2,[])
title('Image filtrée avec masque 5x5')
figure(), mesh(image_filtre2)
title('Intensité image filtrée masque 5x5')

image_filtre3 = filtre_gaussien(matrix,masque3);
figure(), imshow(image_filtre3,[])
title('Image filtrée avec masque 7x7')
figure(), mesh(image_filtre3)
title('Intensité image filtrée masque 7x7')

% Q4
masque = [1 2 4 8 16 8 4 2 1 ; 
         2 4 8 16 32 16 8 4 2 ;
         4 8 16 32 64 32 16 8 4 ;
         8 16 32 64 128 64 32 16 8 ;
         16 32 64 128 256 128 64 32 16;
         8 16 32 64 128 64 32 16 8;
         4 8 16 32 64 32 16 8 4 ; 
         2 4 8 16 32 16 8 4 2 ; 
         1 2 4 8 16 8 4 2 1];
     
m4_coef = sum(masque, 'all');
masque4 = 1/m4_coef*masque;

image_filtre4 = filtre_gaussien(matrix, masque4);
figure(), imshow(image_filtre4,[])
title('Image filtrée avec masque 9x9')
figure(), mesh(image_filtre4)
title('Intensité image filtrée masque 9x9')

%L'augmentation de la valeur de l'écart-type de la gaussienne entraîne une
%une plus grande propagation du bruit dans l'image. 

% L'image originale est beaucoup plus claire que celle sur laquelle le
% masque a été appliqué. Les contours sont moins distincts et les détails
% moins visibles. Il est également possible de voir dans le graphe
% d'intensité du masque 9x9 qu'il y a moins de pics d'intensité, (les
% formes sont plus arrondies), ce qui signifie que l'image contient moins
% de détails.


% Q5
type filtre_laplacien.m

% Q6
type rehaussement_contour.m

% Q7
K = 1.5;
image_filtree5 = rehaussement_contour(matrix, masque2, K);
figure(), imshow(image_filtree5)
title('Image rehaussée');

image_gaussienne = conv2(matrix, masque2, 'same');
image_filtree_L = filtre_laplacien(image_gaussienne);
figure(), imshow(image_filtree_L, [])
title('Image filtre Laplacien');

% On peut voir dans l'image rehaussée que les contours sont moins définis
% que dans l'image originelle, bien que cela ne soit pas le résultat
% escompté. Cela s'explique par le fait que la taille du filtre gaussien
% serait trop grande, donc on enlève trop de détails en tentant de
% supprimer le bruit de l'image et le filtre Laplacien ne suffit pas pour
% afficher clairement les contours.

% Q8
for k = 0:10
    image_filtree_k = rehaussement_contour(matrix, masque2, k);
    figure(), imshow(image_filtree_k, [])
    title('Image rehaussée');
    pause(0.5)
end

% Le problème lorsque la valeur de K est trop élevée est que les détails de
% l'image deviennent de plus en plus "pixelisés". On perd une certain
% qualité de la résolution.

%% Exercice 2
matrix = imread("fundus.png");

% Q1
seuil = 150;
image_binarisee = binariser(matrix, seuil);
figure(), imshow(image_binarisee)
title('Image binarisée');

% Q2
rayon = 2;
elem_struct = strel('disk', rayon);
fermeture = imclose(image_binarisee, elem_struct);

figure(), imshow(fermeture)
title('Fermeture de limage binarisée');

% % Q3
for i = 1:20
    elem_struct = strel('disk', i);
    fermeture = imerode(image_binarisee, elem_struct);
    subplot(5,4,i);
    imshow(fermeture, [])
    title(['Image érodée avec un rayon de ', num2str(i)]);
end


% Q4
% la meilleure approximation est avec un rayon de 11
elem_structurel = strel('disk', 11);
fermeture2 = imerode(image_binarisee, elem_structurel);
figure(), imshow(fermeture2, [])
title('Image érodée avec un rayon de 11');

[x1,y1] = ginput(1);
fprintf('Les coordonnées du centre du disque optique sont %d et %d \n', x1, y1)

% Q5
% Le rayon du disque optique en d'environ 11,5 pixels. Étant donné que nous
% considérons que le disque optique est approximativement un cercle, nous utilisons 
% un élément structurant qui est également un disque. Lors de l'érosion de
% l'image, on peut constater que le centre du disque optique disparait lorsque 
% le rayon de l'élément structurant passe de 11 à 12 pixels. 


%% Exercice 3

% Q1
load mat_barre.mat;
figure(), subplot(1, 3, 1);
imshow(mat_barre_diag, [])
subplot(1, 3, 2)
imshow(mat_barre_x, [])
subplot(1, 3, 3)
imshow(mat_barre_y, [])
sgtitle('Barres diagonale, horizontale et verticale')

% Q2
fft_diag = fft2(mat_barre_diag);
fft_diag = fftshift(fft_diag);
fft_diag_norm = normalize(abs(fft_diag));

fft_hor = fft2(mat_barre_x);
fft_hor = fftshift(fft_hor);
fft_hor_norm = normalize(abs(fft_hor));

fft_ver = fft2(mat_barre_y);
fft_ver = fftshift(fft_ver);
fft_ver_norm = normalize(abs(fft_ver));

figure(), subplot(1, 3, 1)
imshow(fft_diag_norm, [])
subplot(1, 3, 2)
imshow(fft_hor_norm, [])
subplot(1, 3, 3)
imshow(fft_ver_norm, [])
sgtitle('Modules de la FFT de la barre diagonale, horizontale et verticale')

% Q3
% Étant donné que les barres sur lesquelles nous appliquons la fft et la
% normalisation peuvent être considérées comme des rectangles, la réponse
% que nous devrions recevoir est un sinus cardinal. C'est ce que nous
% pouvons observer dans les 3 images générées. Il est également possible de
% constater que les images résultantes ont toutes été tournées dans le sens
% inverse de la fft.


% Q4
% Comme mentionné lors de la question précédente, le résultat de la fft 
% d'un signal d'entrée représentant un rectangle donne un sinus cardinal,
% ce qui explique la présence de zéros dans l'image finale.


% Q5
image1 = create_image(12, 80);
image2 = create_image(12, 12);
image3 = create_image(80, 12);

figure(), subplot(2, 3, 1)
imshow(image1, [])
title('Image 1');
subplot(2, 3, 2)
imshow(image2, [])
title('Image 2');
subplot(2, 3, 3)
imshow(image3, [])
title('Image 3');
sgtitle('Images créées sans FFT')


fft_image1 = fft2(image1);
fft_image1 = fftshift(fft_image1);
fft_image1_norm = normalize(abs(fft_image1));

fft_image2 = fft2(image2);
fft_image2 = fftshift(fft_image2);
fft_image2_norm = normalize(abs(fft_image2));

fft_image3 = fft2(image3);
fft_image3 = fftshift(fft_image3);
fft_image3_norm = normalize(abs(fft_image3));

subplot(2, 3, 4)
imshow(fft_image1_norm, [])
subplot(2, 3, 5)
imshow(fft_image2_norm, [])
subplot(2, 3, 6)
imshow(fft_image3_norm, [])
sgtitle('Modules de la FFT des images créées')

% Dans chaque image du module de la fft, on observe 4 points. Dans ces
% images, on peut observer que tous  les points qui sont alignés
% verticalement correspondent aux lignes horizontales de l'image originale.
% Il en est de même pour les points qui sont alignés horizontalement. Ces
% derniers représentent les lignes verticales des images originales. Les
% points que nous pouvons observer sont en fait les maximums de la
% transformée de Fourrier d'un sinus. De plus, si nous agrandissons les
% images, il est possible de voir des ondelettes autour de ces points. Cela
% s'explique par le fait qu'il s'agit d'une fonction de Dirac. La position
% des points est également liée à la fréquence du signal. De fait, les
% points seront éloignés les uns des autres lorsque la fréquence sera
% élevée, et ils seront rapprochés dans le cas où la fréquence est basse.


%%


