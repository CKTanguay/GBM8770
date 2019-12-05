function [confmat] = confusionmat(targets, prediction)
%CONFUSIONMAT Calcul la matrice de confusion d'une classification binaire.
%   
%       targets: Valeurs r�elles (label).
%       outputs: Valeurs pr�dites seuill�es.
%
%       confmat: Matrice de Confusion
%                   [Vrais-N�gatifs    Faux-Positifs
%                    Faux-N�gatifs     Vrais-Positifs]

S = length(targets);            % Nombre d'�chantillon total
T = sum(targets==prediction);   % Nombre d'�chantillon classifi� correctement
P = sum(targets);               % Nombre d'�chantillon r�ellement positifs
N = S - P;                      % Nombre d'�chantillon r�ellement n�gatifs

TP = sum(targets.*prediction);   % Vrais Positifs
TN = T-TP;                      % Vrais N�gatifs
FN = P-TP;                      % Faux N�gatifs (miss)
FP = N-TN;                      % Faux Positifs (fausse-alarme)

confmat = [TN FP
           FN TP];
end

