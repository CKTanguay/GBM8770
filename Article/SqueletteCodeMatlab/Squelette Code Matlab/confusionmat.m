function [confmat] = confusionmat(targets, prediction)
%CONFUSIONMAT Calcul la matrice de confusion d'une classification binaire.
%   
%       targets: Valeurs réelles (label).
%       outputs: Valeurs prédites seuillées.
%
%       confmat: Matrice de Confusion
%                   [Vrais-Négatifs    Faux-Positifs
%                    Faux-Négatifs     Vrais-Positifs]

S = length(targets);            % Nombre d'échantillon total
T = sum(targets==prediction);   % Nombre d'échantillon classifié correctement
P = sum(targets);               % Nombre d'échantillon réellement positifs
N = S - P;                      % Nombre d'échantillon réellement négatifs

TP = sum(targets.*prediction);   % Vrais Positifs
TN = T-TP;                      % Vrais Négatifs
FN = P-TP;                      % Faux Négatifs (miss)
FP = N-TN;                      % Faux Positifs (fausse-alarme)

confmat = [TN FP
           FN TP];
end

