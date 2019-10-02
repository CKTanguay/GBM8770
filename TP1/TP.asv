%% Exercice 1
% Q1
matrix=imread("fundus_image.png");
imshow("fundus_image.png")

% Q2
f=80;
image_reduite = reduire(matrix, f);
imshow(image_reduite)

% Q3
f = [2 4 8 16 32 64 150];
for i = 1:7
    image_reduite = reduire(matrix,f(i));
    figure,imshow(image_reduite,'InitialMagnification', 'fit')
    title(['Image reduite facteur ', num2str(f(i))])
end

%% Q4
% L'image est de plus en plus pixelisée et il y a une perte de résolution. 
% La segmentation du disque sera difficile à réaliser à partir du facteur
% 32 et celle des vaisseaux à partir d'un facteur de 16.

%% Exercice 2
% Q1
matrix1=imread("crane1.png");
figure,imshow("crane1.png")
title('Crane 1')
[x1,y1]=ginput(2);
%
matrix2=imread("crane2.png");
figure,imshow("crane2.png")
title('Crane 2')
[x2,y2]=ginput(2);

%
matrix3=imread("crane3.png");
figure,imshow("crane3.png")
title('Crane 3')
[x3,y3]=ginput(2);

%% Q2
[p1] = improfile(matrix1,x1,y1);
[p2] = improfile(matrix2,x2,y2);
[p3] = improfile(matrix3,x3,y3);
plot(p1, 'r')
hold on
plot(p2, 'g')
hold on
plot(p3, 'b')
title('Profil des images')
hold off

%Q3
yC1 = 120;
yC2 = 150;
xC1 = 114;
xC2 = 144;

yF1 = 155;
yF2 = 185;
xF1 = 59;
xF2 = 89;

% Q4
imshow("crane1.png")
hold on
rectangle('Position',[114,144,120,150],'EdgeColor', 'r')
rectangle('Position',[59,89,155,185],'EdgeColor', 'g')
hold off

% Q5
contraste1 = contraste(yC1, yC2, xC1, xC2, yF1, yF2, xF1, xF2, matrix1);
contraste2 = contraste(yC1, yC2, xC1, xC2, yF1, yF2, xF1, xF2, matrix2);
contraste3 = contraste(yC1, yC2, xC1, xC2, yF1, yF2, xF1, xF2, matrix3);

% Q6
% Plus le contraste est élevé, plus il est difficile de bien analyser les
% radiographies et d'ensuite poser un diagnostic. »Il ne faut tout de même
% pas que le contraste soit trop faible.

%% Exercice III

matrix1=imread("crane1.png");

% Q1
% --

% Q2
yC1 = 120;
yC2 = 150;
xC1 = 114;
xC2 = 144;

yF1 = 155;
yF2 = 185;
xF1 = 59;
xF2 = 89;

snr = rapport_SNR(yC1, yC2, xC1, xC2, yF1, yF2, xF1, xF2, matrix1);

% Q3
noisy_matrix = imnoise(matrix1, 'gaussian', 0, 0.005);
imshow(noisy_matrix)
title('Image bruitée');

% Q4
noisy_snr = rapport_SNR(yC1, yC2, xC1, xC2, yF1, yF2, xF1, xF2, noisy_matrix);

% Q5
% Variance de 0.2
noisy_matrix_2 = imnoise(matrix1, 'gaussian', 0, 0.2);
figure, imshow(noisy_matrix_2)
title('Image bruitée de variance 0.2');

% Variance de 0.5
noisy_matrix_3 = imnoise(matrix1, 'gaussian', 0, 0.5);
figure, imshow(noisy_matrix_3)
title('Image bruitée de variance 0.5');

% Variance de 1
noisy_matrix_4 = imnoise(matrix1, 'gaussian', 0, 1);
figure, imshow(noisy_matrix_4)
title('Image bruitée de variance 1');

% Q6
% Plus le bruit augmente, moins l'image devient visible et déchiffrable.


%% Exercice IV

% Q1
signal_src = load("signal_diaph.mat");
x_axis = linspace(0, 2, 1000);
plot(x_axis, signal_src.newsignal)
title('Activite electrique du diaphragme')
grid('on')
legend('signal', 'Location', 'best')
xlabel('Time (s)')
ylabel('Frequence (Hz)')

% Q2
tfd = fft(signal_src.newsignal);
magnitude = abs(tfd);
plot(x_axis, signal_src.newsignal, 'r')
hold on
phase = angle(tfd);
plot(x_axis, phase, 'g')
hold off

% Q3
order = 400;
fc = 4;
fe = 500;
wc = 2*(fc/fe);
rif = fir1(order, wc, 'high');

impz(rif)
freqz(rif)

%filtered_signal = filter(rif, signal_src.newsignal);


% Q5
order_PB = 35;
fc_PB = 50;
wc_PB = 2*(fc_PB/fe);
rif_PB = fir1(order_PB, wc_PB, 'low');

impz(rif_PB)
freqz(rif_PB)


%filter signal with PB
% final_filtered_signal
%x_axis = linspace(0, 2, 1000);
%plot(x_axis, final_filtered_signal)
%title('Signal filtre final')
%grid('on')
%legend('Signal', 'Location', 'best')
%xlabel('Time (s)')
%ylabel('Frequence (Hz)')


%% Exercice V

% Q1


