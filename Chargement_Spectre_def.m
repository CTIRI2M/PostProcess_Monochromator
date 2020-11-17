
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%
%       Chargement des films spectro à toutes les longueurs d'ondes
%
% -------------------------------------------------------------------------
%                       C. Pradère le 28 Janvier 2016
%                               version 1.0
%
%                       Modifs C.BOURGES Novembre 2020
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%Initialisation
clear all
close all
warning off

% Inputs
racine=pwd;  %extension du fichier
w=2000:25:6000;  %longueurs d'onde et pas


c=64;
%Pour calculer c:
%Lancer une première fois le code jusqu'à l'affichage de la figure du Signal
%transmis en fonction de la longueur d'onde
%Repérer la position du saut selon lambda (exemple 3600 nm)
%Soustraire lambda min : 3600 - 2000 = 1600 nm
%Divise par le pas : 1600 / 25 = 64
%Relancer le code avec la bonne valeur de c

%--------------------------------------------------------------------------
%               Ouverture du dossier à convertir
% -------------------------------------------------------------------------


chemin=uigetdir([racine,'\2.Mesure\CONDUC500_Spectro\LOF_postdoc\']);


% -------------------------------------------------------------------------
%                       Choix du pixel de référence
% -------------------------------------------------------------------------

nom=[chemin,'\test_',num2str(w(round(end/2))),'nm.ptw'];

[t,data, fileinfo] = GetPTWFrame (nom,1);
Nt=fileinfo.m_nframes;
som=0;

for i=1:Nt
    [t,data, fileinfo] = GetPTWFrame (nom,i);
    som=som+data;
end
figure;imagesc(som);title('Choisissez un pixel de référence puis double cliquer sur le point');
g = impoint(gca,[]);
position = wait(g);
% close(g);
close all;
pl=round(position(2));pc=round(position(1));



% -------------------------------------------------------------------------
%                       Chargement des données
% -------------------------------------------------------------------------

tic;
h = waitbar(0,['Chargement différentes longueurs d''ondes']);
for i=1:length(w)
       
    nom=[chemin,'\test_',num2str(w(i)),'nm.ptw'];

    [t,data1, fileinfo] = GetPTWFrame (nom,1);
    [t,data2, fileinfo] = GetPTWFrame (nom,2);
         
   if data1(pl,pc)<data2(pl,pc)
        S(:,:,i) = data2-data1;
        E(:,:,i) = data1;
    else
        S(:,:,i) = data1-data2 ;
        E(:,:,i) = data2;
    end

  
    waitbar(i/ length(w));
end
delete(h);



%----------------------------------------------------------------------
%                   Correction Saut du filtre des spectres
%----------------------------------------------------------------------



[Sc]=function_correction_spectre(S,pl,pc,c);


%Affichage des courbes S et SC (avec et sans correction)
A = zeros(1,length(w));
B = zeros(1,length(w));
for i=1:length(w)
    A(i) = mean(mean(Sc(180:240,270:320,i)));
    B(i) = mean(mean(S(180:240,270:320,i)));
end

figure(1)
plot(w,A);
hold on 
plot(w,B);
ylabel('Signal transmis DL')
xlabel('Wavelength (nm)')


% Sauvegarde du fichier
uisave({'w','E','Sc'});














