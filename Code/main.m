close all;clear all;clc;
%% Transformation d'histogramme
%q1
%image = imread("flower.png"); 
image = imread("pieces.png");
image = im2double(image); 

%q2
i_seg1 = k_means(image,2);
i_seg2 = k_means(image,2);
i_seg3 = k_means(image,2);

n=10;
i_seg4 = k_means(image,2);
for i=1:n;
i_seg4 = i_seg4 + k_means(image,2);
end
i_seg4=i_seg4/n;

figure(1)
subplot(221);
imshow(i_seg1);
title('n°1');

subplot(222);
imshow(i_seg2);
title('n°2');

subplot(223);
imshow(i_seg3);
title('n°3');

subplot(224);
imshow(i_seg4);
titre = sprintf('moyennée sur %d répétitions', n);
title(titre);

%q3
hist=imhist(image);
[h,w]=size(image);
hist_norm = hist/(h*w); % calcul de l'histogramme normalise


figure(2)
subplot(211);
bar(hist);
title('Histogramme non normalisé de pieces.png');

subplot(212);
bar(hist_norm);
title('Histogramme normalisé de pieces.png');


hist_cumul = hist_norm;
cumul = 0;
for i = 1:length(hist_norm)
    cumul = cumul + hist_norm(i);
    hist_cumul(i) = cumul;
end
figure(3)
hold on;
bar(hist_norm);
plot(hist_cumul);%affichage de l'histogramme cumulé
legend('Histogramme normalisé', 'Histogramme cumulé');
title('Histogramme normalisé de pieces.png échelle de 0 à 255.');

%q4
% solution 1
% [h,w]=size(image);
% max=255;
% min=79;
% i_eg1 = zeros(h,w);
%  for i=1:h*w;
%     i_eg1(i)=(max-min)/(h*w) * sum(hist(1:ceil(image(i)*255)))+ min;% g_k = (G-1)/N sum(i=1,i=k,H_i)
%  end
% i_eg1=i_eg1/255;

%solution2
[h,w]=size(image);
i_eg1 = zeros(h,w);
max=255/255;
min=0/255;
for i=1:(h*w)
    i_eg1(i)=((max-min)* hist_cumul(image(i)*255) + min);%image en flotant
end

hist_ceg1=imhist(i_eg1)/(h*w);
cumul = 0;
for i = 1:length(hist_ceg1)
    cumul = cumul + hist_ceg1(i);
    hist_ceg1(i) = cumul;
end

[i_eg2,hist_eg2]=histeq(image); %solution matlab 

%q5
figure(4)

subplot(221);
imshow(i_eg1);
title('Image égalisée');
subplot(222);
hold on;
title('Histogramme égalisé');
histogram(i_eg1,'Normalization','probability');
plot((0:255)/255,hist_ceg1);
legend('normalisé', 'cumulé');

subplot(223);
imshow(i_eg2);
title('Image égalisée matlab');

%donne une solution proche, cumulé programmé
hist_eg2=imhist(i_eg2)/(h*w);
cumul = 0;
for i = 1:length(hist_eg2)
    cumul = cumul + hist_eg2(i);
    hist_eg2(i) = cumul;
end

subplot(224);
hold on;
title('Histogramme égalisé matlab');
histogram(i_eg2,'Normalization','probability');
plot((0:255)/255,hist_eg2);
legend('normalisé', 'cumulé');

%q6
i_segeg1 = k_means(i_eg1,2);
i_segeg2 = k_means(i_eg1,2);
i_segeg3 = k_means(i_eg1,2);


n=10;
i_segeg4 = k_means(i_eg1,1);
for i=1:n;
i_segeg4 = i_segeg4 + k_means(i_eg1,2);
end
i_segeg4=i_segeg4/n;

figure(5)
subplot(221);
imshow(i_segeg1);
title('n°1');

subplot(222);
imshow(i_segeg2);
title('n°2');

subplot(223);
imshow(i_segeg3);
title('n°3');

subplot(224);
imshow(i_segeg4);
titre = sprintf('moyennée sur %d répétitions', n);
title(titre);


%%Granulométrie
%q1
figure();
i_g1 = im2bw(i_segeg4);%permet d'avoir une image binaire
disp("Avant traitement");
disp(bweuler(i_g1));
%i_g=masque(i_g1,'fermeture','rond');
%i_g=masque(i_g1,'fermeture','croix');%laisse passer des anomalies
%i_g2=masque(i_g1,'ouverture','carrée');%fermeture donne des résultats correctes
i_g2=masque(i_g1,'ouverture','d10'); %résultat meilleurs
disp("Apres traitement 1");
disp(bweuler(i_g2));%détection correcte mais taille fausse
%imshow(i_g2);

%q3
figure();
i_gsb1 = masque(i_g2,'reconstruction','bord');%détecte les bords;
i_gsb2 = im2bw(i_g2-i_gsb1);
%i_gsb1 = imclearborder(i_g2);%équivalent matlab
%imshow(i_gsb);
%q4
[centers, rayons, metric] = imfindcircles(i_gsb2,[5 200]);
nb_cercle = length(centers);
disp("Après traitement 2");
disp(nb_cercle);
%disp(bweuler(i_gsb2));
disp(metric);

figure(6)
subplot(221);
imshow(i_g1);
title('Image binaire');

subplot(222);
imshow(i_g2);
title('Traitement n°2');

subplot(223);
imshow(i_gsb1);
title('prétraitement n°3');

subplot(224);
imshow(i_gsb2);
title('Traitement n°3');


figure(7);%matlab solution
hold on
imshow(image);
viscircles(centers, rayons,'EdgeColor','b');
title('Traitement n°4');

%q5 perso
r=compteur(i_gsb2);
disp("Rayons associés aux figures")
disp(r);

%HS
% figure(7)
% subplot(221);
% hold on;
% imshow(image);
% [centers1, rayons1, metric1] = imfindcircles(image,[10 100]);
% viscircles(centers1, rayons1,'EdgeColor','b');
% title('Sans traitement');
% 
% subplot(222);
% hold on;
% imshow(image);
% [centers2, rayons2, metric2] = imfindcircles(i_g1,[10 100]);
% viscircles(centers2, rayons2,'EdgeColor','b');
% title('Traitement n°1');
% 
% subplot(223);
% hold on;
% imshow(image);
% [centers3, rayons3, metric3] = imfindcircles(i_g2,[10 100]);
% viscircles(centers3, rayons3,'EdgeColor','b');
% title('Traitement n°2');

%élément structurant à faire soi même