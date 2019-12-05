function [tpr,fpr,thresholds] = roc(targets,outputs)
%ROC Calcul la courbe ROC d'une classification binaire.
%   Cette fonction calcule le taux de Vrais Positifs (la sensitivit�) et le
%   taux de Faux Positifs (1-sp�cificit�) pour chaque seuil pr�sent dans la
%   pr�diction _outputs_ selon les valeurs r�elles _targets_.
%
%       targets: Valeurs r�elles (label).
%       outputs: Valeurs pr�dites non-seuill�es.
%
%       tpr: Vecteur des Vrais Positifs.
%       fpr: Vecteur des Faux Positifs.
%       thresholds: Vecteur des seuils.

S = length(outputs);    % Nombre d'�chantillon

% Tri les tableaux par les valeurs de pr�diction d�croissante
[outputs, sorted_index] = sort(outputs, 'descend');
targets = targets(sorted_index);

% Supprime les doublons dans outputs pour calculer le vecteur des seuils. 
% predP correspond � la fois aux indexes des seuils uniques (sans les 
% doublons), mais aussi pour chaque seuil, au nombre d'�chantillon d�tect�
% positivement (dont la valeur pr�dite est sup�rieure au seuil).
predP = [find(diff(outputs)) S];
thresholds = outputs(predP);

% Calcule le nombre de Vrais Positifs associ�s � chaque seuil.
% (Le tableau des seuils �tant tri� par valeurs d�croissantes, la somme
% cumul�e de targets contient, pour chaque seuil,
% le nombre de valeurs r�ellement positives parmis celles dont la
% pr�diction �tait sup�rieure au seuil.)
targets = cumsum(targets);
TP = targets(predP);

% Calcule le nombre de Faux Positifs. En calculant, pour chaque seuil,
% le nombre d'�chantillons pr�dits positifs moins le nombre de vrais positifs.
FP = predP - TP;

% Calcule les taux de Vrais Positifs et de Faux Positifs
P = TP(end);    % Nombre d'�chantillons positives, �quivaut � sum(targets).
N = S-P;        % Nombre d'�chantillons n�gatifs.

tpr = TP / P;
fpr = FP / N;
end

