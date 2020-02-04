function matrice=masque(image,mode,forme)
[h,w]=size(image);
%element structurant
se=[1];%par défaut
se_croix = [0,1,0;
            1,1,1;
            0,1,0];
se_car = [1,1,1;
          1,1,1;
          1,1,1];
se_rond = [0,0,1,0,0;
           0,1,1,1,0;
           1,1,1,1,1;
           0,1,1,1,0;
           0,0,1,0,0];
       
se_bord = zeros(h,w);
    se_bord(:,1)=1;
    se_bord(1,:)=1;
    se_bord(:,w)=1;
    se_bord(h,:)=1;
       
se_d10 = strel('disk', 10);
    
if strcmp(forme,'croix');
    se=se_croix;
end

if strcmp(forme,'carrée');
    se=se_car;
end

if strcmp(forme,'rond')
    se=se_rond;
end

if strcmp(forme,'d10')
    se=se_d10;
end

if strcmp(forme,'bord')
    se=se_bord;
end

[h,w]=size(image);
retour = zeros(h,w);

if strcmp(mode,'dilatation');
    retour = imdilate(image,se) ;
end
if strcmp(mode,'érosion');
    retour = imerode(image,se);
end

if strcmp(mode,'ouverture');
    retour = imerode(image,se);
    retour = imdilate(retour,se) ;
end

if strcmp(mode,'fermeture');
    retour = imdilate(image,se) ;
    retour = imerode(retour,se);
end

if strcmp(mode,'reconstruction');
    %figure(40);
    imshow(image);
    
    marker = im2bw(se);%même classe d'objet
    image=im2bw(image);
    
    retour = marker & image;
    for i = 1:100;
        retour_av=retour;
        retour = imdilate( retour & image, se_rond ) & image ;%peut être plus rapide si on choisit un autre masque
        %figure(100+i);
        %imshow(retour);
        %filename = ['f' num2str(i) '.png'];
        %saveas(gcf,filename);
        if retour==retour_av;%si les bords sont entièrements détectés
            break
        end
    end
    %retour = imreconstruct(marker, image);%équivalent
end
matrice = retour;
end

