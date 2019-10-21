%% Exercice 1
% Q1
matrix = imread("fundus.png");
figure(),imshow(matrix)
title('Disque optique dans une image fundus')
figure(),mesh(matrix)
title('Intensit�')

% Q2
type filtre_gaussien.m

%Q3
masque1 = 1/16*[1 2 1; 2 4 2 ; 1 2 1];
masque2 = 1/100*[1 2 4 2 1 ; 2 4 8 4 2 ; 4 8 16 8 4 ; 2 4 8 4 2 ; 1 2 4 2 1];
masque3 = 1/484*[1 2 4 8 4 2 1 ; 2 4 8 16 8 4 2 ; 4 8 16 32 16 8 4 ; 8 16 32 64 32 16 8 ;
    4 8 16 32 16 8 4 ; 2 4 8 16 8 4 2 ; 1 2 4 8 4 2 1];

image_filtre1 = filtre_gaussien(matrix,masque1);
figure(), imshow(image_filtre1,[])
title('Image filtr�e avec masque 3x3')
figure(), mesh(image_filtre1)
title('Intensit� image filtr�e masque 3x3')

image_filtre2 = filtre_gaussien(matrix,masque2);
figure(), imshow(image_filtre2,[])
title('Image filtr�e avec masque 5x5')
figure(), mesh(image_filtre2)
title('Intensit� image filtr�e masque 5x5')

image_filtre3 = filtre_gaussien(matrix,masque3);
figure(), imshow(image_filtre3,[])
title('Image filtr�e avec masque 7x7')
figure(), mesh(image_filtre3)
title('Intensit� image filtr�e masque 7x7')

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
title('Image filtr�e avec masque 9x9')
figure(), mesh(image_filtre4)
title('Intensit� image filtr�e masque 9x9')

%L'augmentation de la valeur de l'�cart-type de la gaussienne entra�ne une
%une plus grande propagation du bruit dans l'image. 

% L'image originale est beaucoup plus claire que celle sur laquelle le
% masque a �t� appliqu�. Les contours sont moins distincts et les d�tails
% moins visibles. Il est �galement possible de voir dans le graphe
% d'intensit� du masque 9x9 qu'il y a moins de pics d'intensit�, (les
% formes sont plus arrondies), ce qui signifie que l'image contient moins
% de d�tails.


% Q5
type filtre_laplacien.m

% Q6
type rehaussement_contour.m

% Q7
K = 1.5;
image_filtree5 = rehaussement_contour(matrix, masque2, K);
figure(), imshow(image_filtree5)
title('Image rehauss�e');

image_gaussienne = conv2(matrix, masque2, 'same');
image_filtree_L = filtre_laplacien(image_gaussienne);
figure(), imshow(image_filtree_L, [])
title('Image filtre Laplacien');

% On peut voir dans l'image rehauss�e que les contours sont moins d�finis
% que dans l'image originelle, bien que cela ne soit pas le r�sultat
% escompt�. Cela s'explique par le fait que la taille du filtre gaussien
% serait trop grande, donc on enl�ve trop de d�tails en tentant de
% supprimer le bruit de l'image et le filtre Laplacien ne suffit pas pour
% afficher clairement les contours.

% Q8
for k = 0:10
    image_filtree_k = rehaussement_contour(matrix, masque2, k);
    figure(), imshow(image_filtree_k, [])
    title('Image rehauss�e');
    pause(0.5)
end

% Le probl�me lorsque la valeur de K est trop �lev�e est que les d�tails de
% l'image deviennent de plus en plus "pixelis�s". On perd une certain
% qualit� de la r�solution.

%% Exercice 2

% Q1
seuil = 150;
image_binarisee = binariser(matrix, seuil);
figure(), imshow(image_binarisee)
title('Image binaris�e');

% Q2
rayon = 2;
elem_struct = strel('disk', rayon);
fermeture = imclose(image_binarisee, elem_struct);

figure(), imshow(fermeture)
title('Fermeture de limage binaris�e');

% Q3
for i = 1:20
    elem_struct = strel('disk', i);
    fermeture = imerode(image_binarisee, elem_struct);
    subplot(5,4,i)
    imshow(fermeture, [])
    title(['Image �rod�e avec un rayon de ', num2str(i)]);
end
