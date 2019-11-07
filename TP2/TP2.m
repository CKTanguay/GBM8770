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
matrix = imread("fundus.png");

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

% % Q3
for i = 1:20
    elem_struct = strel('disk', i);
    fermeture = imerode(image_binarisee, elem_struct);
    subplot(5,4,i);
    imshow(fermeture, [])
    title(['Image �rod�e avec un rayon de ', num2str(i)]);
end


% Q4
% la meilleure approximation est avec un rayon de 11
elem_structurel = strel('disk', 11);
fermeture2 = imerode(image_binarisee, elem_structurel);
figure(), imshow(fermeture2, [])
title('Image �rod�e avec un rayon de 11');

[x1,y1] = ginput(1);
fprintf('Les coordonn�es du centre du disque optique sont %d et %d \n', x1, y1)

% Q5
% Le rayon du disque optique en d'environ 11,5 pixels. �tant donn� que nous
% consid�rons que le disque optique est approximativement un cercle, nous utilisons 
% un �l�ment structurant qui est �galement un disque. Lors de l'�rosion de
% l'image, on peut constater que le centre du disque optique disparait lorsque 
% le rayon de l'�l�ment structurant passe de 11 � 12 pixels. 


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
% �tant donn� que les barres sur lesquelles nous appliquons la fft et la
% normalisation peuvent �tre consid�r�es comme des rectangles, la r�ponse
% que nous devrions recevoir est un sinus cardinal. C'est ce que nous
% pouvons observer dans les 3 images g�n�r�es. Il est �galement possible de
% constater que les images r�sultantes ont toutes �t� tourn�es dans le sens
% inverse de la fft.


% Q4
% Comme mentionn� lors de la question pr�c�dente, le r�sultat de la fft 
% d'un signal d'entr�e repr�sentant un rectangle donne un sinus cardinal,
% ce qui explique la pr�sence de z�ros dans l'image finale.


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
sgtitle('Images cr��es sans FFT')


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
sgtitle('Modules de la FFT des images cr��es')

% Dans chaque image du module de la fft, on observe 4 points. Dans ces
% images, on peut observer que tous  les points qui sont align�s
% verticalement correspondent aux lignes horizontales de l'image originale.
% Il en est de m�me pour les points qui sont align�s horizontalement. Ces
% derniers repr�sentent les lignes verticales des images originales. Les
% points que nous pouvons observer sont en fait les maximums de la
% transform�e de Fourrier d'un sinus. De plus, si nous agrandissons les
% images, il est possible de voir des ondelettes autour de ces points. Cela
% s'explique par le fait qu'il s'agit d'une fonction de Dirac. La position
% des points est �galement li�e � la fr�quence du signal. De fait, les
% points seront �loign�s les uns des autres lorsque la fr�quence sera
% �lev�e, et ils seront rapproch�s dans le cas o� la fr�quence est basse.


%% Exercice 4

% Q1
type filtrage_frequentiel.m

% Q2
type filtrage_spatial.m

% Q3
matrix = imread("koala.png");
d0 = 0.0398;
image_filtree_freq = filtrage_frequentiel(matrix, d0);

sigma = 4;
image_filtree_spatial = filtrage_spatial(matrix, sigma);

figure(), subplot(1, 2, 1)
imshow(image_filtree_freq, [])
title('Image filtr�e dans le domaine fr�quentiel');
subplot(1, 2, 2)
imshow(image_filtree_spatial, [])
title('Image filtr�e dans le domaine spatial');

% Q4
% En observant les images r�sultantes du domaine fr�quentiel et du domaine
% spatial, ces derni�res semblent tout � fait identiques, mis � part les
% contours (cadre) de l'image du domaine spatial qui sont plus fonc�s. La 
% relation entre le domaine fr�quentiel et le domaine spatial se fonde sur
% le th�or�me de la convolution. Nous faisons une convolution pour le
% filtre spatial avec l'image et nous faisons une multiplication dans le
% domaine fr�quentiel du filtre avec l'image encore une fois. En mettant en
% relation les paramètres des exponentielles, il est possible de trouver
% l'égalité fc = 1/(2pi*sigma), où fc est la fréquence de coupure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Q5
% En analysant les images obtenues apr�s l'application du filtre id�al et
% butterworth, il est possible d'observer que l'image r�sultante du
% butterworth est plus d�finie que celle du filtre id�al. Bien que les deux
% soient tr�s floues, il est plus facile de discerner les formes et
% contours avec un butterworth. Cela s'explique par le fait que le filtre
% butterworth coupe de fa�on moins �s�che� les contours des images. 

im1 = imread("koala-E4-Q5-ideal.jpg");
im2 = imread("koala-E4-Q5-butterworth.jpg");

figure(), subplot(1, 2, 1)
imshow(im1, [])
title('Image de koala avec filtre id�al');
subplot(1, 2, 2)
imshow(im2, [])
title('Image de koala avec filtre butterworth');


%% Exercice 5

% Q1
matrix = imread("XrayBar.jpg");

spectre_normal = fftshift(abs(fft2(matrix)));
spectre_logarithmique = 1 + log(fftshift(abs(fft2(matrix))));

figure(), subplot(1, 2, 1)
imshow(spectre_normal, [])
title('Spectre normal de limage');
subplot(1, 2, 2)
imshow(spectre_logarithmique, [])
title('Spectre logarithmique de limage');

%  Dans le spectre normal de l'image, nous observons un point en forme de
%  croix. Ce point ne nous fourni pas d'autes informations sur l'image que
%  la plus grand intensit� du spectre, en g�n�ral. Dans le spectre
%  logarithmique, nous observons une image brouill�e o� aucunes formes ne
%  sont discernables, mais dans laquelle on peut voir plusieurs points
%  lumineux. Ces points repr�sentent les lignes diagonales de bruit qui
%  sont pr�sentes dans l'image originale.


% Q2
u = [1/8 1/4 3/8];
v = [1/8 1/4 3/8];
frequences_coupure = [0.03 0.02 0.01];

masque = filtre_selectif(matrix, frequences_coupure, u, v);

figure()
imshow(masque, [])
title('Masque du filtre s�lectif');
% 
% 
% spectre = fftshift(fft2(image));
% image_filtree = normalize(ishift(ifft2(masque.*spectre)));




















