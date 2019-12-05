function [diceIdx] = dice(targets,predictions)
%DICE Calcule l'indice S�rensen-Dice.
%       targets: Valeurs r�elles (label).
%       outputs: Valeurs pr�dites seuill�es.

intersection  = targets.*predictions;
diceIdx = 2*sum(intersection) / (sum(targets) + sum(predictions));
end

