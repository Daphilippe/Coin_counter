function [matrice,moyennes]=k_means(image,k)

%K-means
k=ceil(k);
retour=zeros(size(image));%image vide
%k nombre de zone
nn=0;
if k>1%avoir plus d'une zone
    A=sort(rand(k,1));
    epsi=1/255;% pixel près
    j=2;
    while j>epsi;
        nn=nn+1;
        Av=A;
        B=0*(1:k-1);
        for i=1:(k-1);%Moyenne des termes
            B(i)=(A(i)+A(i+1))/2;
        end
        %Valeurs extremums        
        %retour = retour + A(1)*(image<=B(1));
        A(1)=mean(mean(image(find(image<=B(1)))));
        %retour = retour + A(k)*(image>B(k-1));
        A(k)=mean(mean(image(find(image>B(k-1)))));
        for i=1:(k-2)
            %retour = retour + A(i+1)*(image > B(i) & image<B(i+1));
            A(i+1)=mean(mean(image(find((image > B(i) & image<B(i+1))))));
        end
        j=max(abs(Av-A));
    end
    retour = retour + A(1)*(image<=B(1));
    retour = retour + A(k)*(image>B(k-1));
    
    for i=1:(k-2)
        retour = retour + A(i+1)*(image > B(i) & image<B(i+1));
    end
end
disp(nn);
matrice=retour;
end