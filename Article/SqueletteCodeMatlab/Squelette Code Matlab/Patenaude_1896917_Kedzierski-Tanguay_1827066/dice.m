function [diceIdx] = dice(targets,predictions)
%DICE Calcule l'indice Sørensen-Dice.
%       targets: Valeurs réelles (label).
%       outputs: Valeurs prédites seuillées.

intersection  = targets.*predictions;
diceIdx = 2*sum(intersection) / (sum(targets) + sum(predictions));
end

