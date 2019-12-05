function [tpr,fpr,thresholds] = roc(targets,outputs)
%ROC Calcul la courbe ROC d'une classification binaire.
%   Cette fonction calcule le taux de Vrais Positifs (la sensitivité) et le
%   taux de Faux Positifs (1-spécificité) pour chaque seuil présent dans la
%   prédiction _outputs_ selon les valeurs réelles _targets_.
%
%       targets: Valeurs réelles (label).
%       outputs: Valeurs prédites non-seuillées.
%
%       tpr: Vecteur des Vrais Positifs.
%       fpr: Vecteur des Faux Positifs.
%       thresholds: Vecteur des seuils.

S = length(outputs);    % Nombre d'échantillon

% Tri les tableaux par les valeurs de prédiction décroissante
[outputs, sorted_index] = sort(outputs, 'descend');
targets = targets(sorted_index);

% Supprime les doublons dans outputs pour calculer le vecteur des seuils. 
% predP correspond à la fois aux indexes des seuils uniques (sans les 
% doublons), mais aussi pour chaque seuil, au nombre d'échantillon détecté
% positivement (dont la valeur prédite est supérieure au seuil).
predP = [find(diff(outputs)) S];
thresholds = outputs(predP);

% Calcule le nombre de Vrais Positifs associés à chaque seuil.
% (Le tableau des seuils étant trié par valeurs décroissantes, la somme
% cumulée de targets contient, pour chaque seuil,
% le nombre de valeurs réellement positives parmis celles dont la
% prédiction était supérieure au seuil.)
targets = cumsum(targets);
TP = targets(predP);

% Calcule le nombre de Faux Positifs. En calculant, pour chaque seuil,
% le nombre d'échantillons prédits positifs moins le nombre de vrais positifs.
FP = predP - TP;

% Calcule les taux de Vrais Positifs et de Faux Positifs
P = TP(end);    % Nombre d'échantillons positives, équivaut à sum(targets).
N = S-P;        % Nombre d'échantillons négatifs.

tpr = TP / P;
fpr = FP / N;
end

