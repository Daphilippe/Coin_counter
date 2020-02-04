function [rayon]=compteur(image);
nb_f=20;
sav=im2bw(image);
retour=im2bw(image);

r=[,];

[h,w]=size(image);
vide=im2bw(zeros(h,w));
%disp(size(image));
%disp(size(vide));
%imshow(vide);

while 1==1;
    disp('Traitement en cours');
    image_r=im2bw(sav);

    for i=1:100;
    se = strel('disk',i);
    image_rav=image_r;
    image_r=imerode(sav,se);
        if image_r==image_rav;
            disp('Dimension trouvée');
            r=[r,i];
            break
        end
%    end

    %matrice=retour;
    retour=imdilate(image_rav,strel('disk',i+3));
    end
    sav=im2bw(sav)-im2bw(retour);
    if sav==vide;
        break;
    end
    nb_f=nb_f+1;
    figure(nb_f);
    imshow(retour);
    filename = ['f' num2str(i) '.png'];
    saveas(gcf,filename);
    %figure(nb_f+1);%affiche étape où on soustrait
    %imshow(sav);
end
disp('Fin');
%disp(r);
%matrice = sav-im2bw(retour);
%imshow(matrice);
rayon = r;
end