% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%
%      Correction du saut lié au filtre sur les spectres mesurés
%
% -------------------------------------------------------------------------
%                       S. Kirchner, C. Pradère le 20 octobre 2016
%                               version 1.0

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%S,Cube des spectres mesurés avant correction du filtre
% Sr, Cube des spectres mesurés après correction du filtre

function [S,Filtre,r]=function_correction_spectre(S,pl,pc,c)

%reshape de la matrice
Sr=reshape(S,size(S,1)*size(S,2),size(S,3));
%Recherche du saut sur un pixel de référence
% [a,c]=min(diff(squeeze(S(pl,pc,:))))
% c=160;
tic;
for i=1:size(Sr,1)
    %Correction du saut du à la présence du filtre
    psautg=(Sr(i,c)-Sr(i,c-2))/2;
    r(i)=psautg;
    Filtre(i)=(Sr(i,c)+psautg)./Sr(i,c+1);
    %Correction des pixels où T=S
    Filtre(isinf(Filtre))=1;
    %Calcul du saut
    Sr(i,c+1:end)=Sr(i,c+1:end)*Filtre(i);
    %Mise à 1 des valeurs négatives ou qui tendent vers 0
    [a,d]=find(Sr(i,:)<=0.1);
    Sr(i,d)=1;
end
toc
S=reshape(Sr,size(S,1),size(S,2),size(S,3));

return




















