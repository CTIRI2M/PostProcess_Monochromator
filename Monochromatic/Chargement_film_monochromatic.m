%TEST chargement
clear all
close all

path = 'D:\201116_Thermotransmittance_Silicium\T120\';

nomfich=[path,'test_1.ptw'];

y = 40:380;
x = 200:500;
pix_ref = 150;

%Fonction Stéphane
[t,image3D,fileinfo] = chargement_ptw_sans_interface(nomfich,x,y);



%Affichage
figure()
plot(squeeze(image3D(150,150,:)))

figure()
imagesc(image3D(:,:,1))

%Récupération Emission propre et Signal Transmis

Nt = size(image3D,3);
S = zeros(size(image3D,1),size(image3D,2),Nt/2);
E = zeros(size(image3D,1),size(image3D,2),Nt/2);

for j=1:2:Nt-1
       
    data1 = image3D(:,:,j);
    data2 = image3D(:,:,j+1);
         

   if data1(pix_ref,pix_ref)<data2(pix_ref,pix_ref)
        S(:,:,round((j+1)/2))=data2-data1;
        E(:,:,round((j+1)/2))=data1;
%         T(:,:,round((j+1)/2))=data2;

    else
        S(:,:,round((j+1)/2))=data1-data2 ;
        E(:,:,round((j+1)/2))=data2;
%         T(:,:,round((j+1)/2))=data1;

    end

  
    waitbar(j/ Nt);
end

clear('image3D')

% figure()
% hold on
% plot(squeeze(S(1,1,:)))
% plot(squeeze(E(1,1,:)))
% plot(squeeze(image3D(1,1,:)))
% plot(squeeze(S(1,1,:))+squeeze(E(1,1,:)))


uisave({'S','E'});