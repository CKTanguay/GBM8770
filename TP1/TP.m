%% Exercice 1
% Q1
matrix=imread("fundus_image.png");
%imshow("fundus_image.png")

% Q2
f=2;
image_reduite = reduire(matrix, f);
imshow(image_reduite)

