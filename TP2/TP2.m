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

% Q3
for i = 1:20
    elem_struct = strel('disk', i);
    fermeture = imerode(image_binarisee, elem_struct);
    subplot(5,4,i)
    imshow(fermeture, [])
    title(['Image érodée avec un rayon de ', num2str(i)]);
end
