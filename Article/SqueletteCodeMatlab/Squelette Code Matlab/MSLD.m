classdef MSLD
   properties
       W               % Taille de la fen�tre
       L               % Vecteur contenant les longueurs des lignes � d�tecter
       n_orientation   % Nombre d'orientation des lignes � d�tecter
       
       line_detectors_masks 
       % Masques pour la d�tection des lignes pour chaque valeur de L et
       % chaque valeur de n_orientation.
       
       avg_mask % Masque moyenneur de taille WxW.
       
       threshold = 0.56;    % Seuil de segmentation (� apprendre)
   end
   methods
       function obj = MSLD(W, L, n_orientation)
       % Constructeur de la classe MSLD
       %    W: Taille de la fen�tre (tel que d�fini dans l'article)
       %    L: Un veteur contenant les valeurs des longueurs des lignes qui 
       %    seront d�tect�es par la MSLD.
       %    n_orientation: Nombre d'orientations des lignes � d�tecter
           
           obj.W = W;
           obj.L = L;
           obj.n_orientation = n_orientation;
           
           %%% TODO: I.Q1
           matrix_mask = ones(W);
           obj.avg_mask = 1/sum(matrix_mask,'all')*matrix_mask;
           
           
           %%% TODO: I.Q2
           %%% line_detectors_masks est un cell array contenant les masques
           %%% de d�tection de ligne pour toutes les �chelles contenues
           %%% dans le vecteur L et pour un nombre d'orientation �gal �
           %%% n_orientation. Ainsi pour toutes les valeurs de L:
           %%% obj.line_detectors_masks{L} est une matrice de la forme [L,L,n_orientation]
           
           angle = 180/n_orientation;
           for i = L
               obj.line_detectors_masks{i} = zeros(i,i,n_orientation);
               matrix = zeros(i);
               matrix(floor(i/2+1),:) = 1;
               for j = 0:(n_orientation-1)
                   temp = imrotate(matrix, angle*j, 'bilinear', 'crop');
                   obj.line_detectors_masks{i}(:,:,(j+1))= temp/sum(temp,'all');
               end
           end
          
           
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %                     MSLD Impl�mentation                          %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       function R = basicLineDetector(obj, grey_lvl, L)
       % Applique l'algorithme Basic Line Detector sur la carte 
       % d'intensit� grey_lvl avec des lignes de longueurs L.
       %    obj: Instance courante de la classe MSLD
       %    grey_lvl: Carte d'intensit� sur laquelle est appliqu� le BLD
       %    L: Longueur des lignes (on supposera que L est pr�sent dans obj.L
       %                   et donc que obj.line_detectors_masks{L} existe).
           
           %%% TODO: I.Q4
           %Padding sur grey level avant avec padarray (mettre 1 pour taille masque diviser par 2 +1)
           pad_size = floor((obj.W/2)+1);
           grey_lvl_pad = padarray(grey_lvl,[pad_size pad_size],1,'both');
           I_w_avg = conv2(grey_lvl_pad,obj.avg_mask, 'valid');
            
           pad_size_2 = floor((L/2)+1);
           grey_lvl_pad_L = padarray(grey_lvl, [pad_size_2 pad_size_2], 1, 'both');
           
           for i = 0:(obj.n_orientation-1)
               I_w_ligne(:,:,(i+1)) = conv2(grey_lvl_pad_L, obj.line_detectors_masks{L}(:,:,(i+1)), 'valid');
           end
           I_w_max = max(I_w_ligne,[],3);
           R =  I_w_max - I_w_avg;
           R = R/sum(R,'all');
       end
       
       function Rcombined = multiScaleLineDetector(obj, image)
       % Applique l'algorithme de Multi-Scale Line Detector et combine les
       % r�ponses des BLD pour obtenir la carte d'intensit� de l'�quation 4
       % de la section 3.3 Combination Method.
       %    obj: Instance courante de la classe MSLD
       %    image: Image aux intensit�es comprises entre 0 et 1 et aux 
       %           dimensions [hauteur, largeur, canal] (canal: R=1 G=2 B=3)

           
           %%% TODO: I.Q6
           pad_size = floor((obj.W/2)+1);
           image_pad = padarray(image,[pad_size pad_size],1,'both');
           I_w_avg = conv2(image_pad,obj.avg_mask, 'valid');
          
           
           for j = 1:obj.W
                pad_size_2 = floor((j/2)+1);
                image_pad_L = padarray(image, [pad_size_2 pad_size_2], 1, 'both');
                dims = size(image_pad_L);
                
                I_w_ligne_msld = zeros(dims(1), dims(2), obj.n_orientation);
                for i = 0:(obj.n_orientation-1)
                    I_w_ligne_msld(:,:,(i+1)) = conv2(image_pad_L, obj.line_detectors_masks{j}(:,:,(i+1)), 'valid');
                end
           
                I_w_max = max(I_w_ligne_msld,[],3);
                R =  I_w_max - I_w_avg;
                R = R/sum(R,'all');
                R_somme=+R;
           end
           Rcombined = 1/(obj.W+1)*(R_somme+image);
          
       end
       
       function [threshold, accuracy, obj] = learnThreshold(obj, dataset)
       % Apprend le seuil optimal pour obtenir la pr�cision la plus �lev�e
       % sur le dataset donn�.
       % Cette m�thode remplace la valeur de obj.threshold par le seuil
       % optimal puis renvoie ce seuil et la pr�cision obtenue. 
       % (Comme cette m�thode modifie obj.threshold, la variable obj doit
       %  �tre retourn�e. La m�thode s'utilise: 
       %  [threshold, accuracy, msld] = msld.learn_threshold(dataset);
       %
       %    obj:  Instance courante de la classe MSLD
       %    dataset: cell array contenant les colonnes: data, label, mask.
       %
       %    threshold: Seuille proposant la meilleure pr�cision
       %    accuracy: Valeur de la meilleure pr�cision
       %    obj: Instance courante de la classe MSLD avec le nouveau seuil
       
           [tpr, fpr, thresholds] = obj.roc(dataset);
           
           %%% TODO: I.Q10
           % ...
           % threshold = ... ;
           
           
           obj.threshold = threshold;
       end
       
       function [vessels] = segmentVessels(obj, image)
       % Segmente les vaisseaux sur une image en utilisant la MSLD.
       %    obj: Instance courante de la classe MSLD
       %    image: Image sur laquelle appliquer l'algorithme

           %%% TODO: I.Q13 
           %%% Utilisez obj.multiScaleLineDetector(image) et obj.threshold.
           
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %                     Visualisation                                %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       function showDiff(obj, sample)
       % Affiche la comparaison entre la pr�diction de l'algorithme et les
       % valeurs attendues (labels) selon le code couleur suivant:
       %    - Noir: le pixel est absent de la pr�diction et du label
       %    - Rouge: le pixel n'est pr�sent que dans la pr�diction
       %    - Bleu: le pixel n'est pr�sent que dans le label
       %    - Blanc: le pixel est pr�sent dans la pr�diction ET le label
       %
       %    obj: Instance courante de la classe MSLD
       %    sample: Un �chantillon provenant d'un dataset contenant les
       %            champs ['data', 'label', 'mask'].
       
            %%% TODO: I.Q16
            % ...
            % green = ... ;
            % red = ... ;
            % blue = ... ;
            
            
            imshow(cat(3, red,green,blue));
       end
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %                    SEGMENTATION METRICS                          %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       function [tpr, fpr, thresholds] = roc(obj, dataset)
       % Calcul la courbe ROC de l'algorithme MSLD sur un dataset donn� et
       % sur la r�gion d'int�r�t indiqu�e par le champs mask.
       %
       %    obj: Instance courante de la classe MSLD
       %    dataset: Base de donn�es sur laquelle calculer la courbe ROC
       %    
       %    tpr: Vecteur des Taux de vrais positifs
       %    fpr: Vecteur des Taux de faux positifs
       %    thresholds: Vecteur des seuils associ�s � ces taux.
       
           %%% TODO: I.Q9
           %%% Vous pouvez utiliser la fonction Matlab: roc().
           %%%
           %%% L'it�reration sur le dataset se fait par:
           %%% for d=dataset
           %%%     label = d.label;
           %%%     mask = d.mask;
           %%%     ...
           %%% end
           
       end
       
       function [accuracy, confusion_matrix] = naiveMetrics(obj, dataset)
       % �value la pr�cision et la matrice de confusion de l'algorithme sur 
       % un dataset donn� et sur la r�gion d'int�r�t indiqu�e par le 
       % champs mask. 
       %
       %    obj: Instance courante de la classe MSLD
       %    dataset: Base de donn�es sur laquelle calculer les m�triques
       %
       %    accuracy: Pr�cision 
       %    confusion_matrix: Matrices de confusions normalis�es par le
       %                      nombre de labels positifs et n�gatifs
       
           %%% TODO: II.Q1
           
       end
       
       function [diceIndex] = dice(obj, dataset)
       % �value l'indice dice de l'algorithme sur  un dataset donn� et sur 
       % la r�gion d'int�r�t indiqu�e par le champs mask. 
       %
       %    obj: Instance courante de la classe MSLD
       %    dataset: Base de donn�es sur laquelle calculer l'indice
       %
       %    diceIndex: Indice de S�rensen-Dice. 
       
           %%% TODO: II.Q6
           %%% Vous pouvez utiliser la function Matlab: dice().
           
       end
       
       function [aur] = plotROC(obj, dataset)
       % Affiche la courbe ROC et calcule l'AUR de l'algorithme pour un
       % dataset donn�e et sur la r�gion d'int�r�t indiqu�e par le champs
       % mask.
       %
       %    obj: Instance courante de la classe MSLD
       %    dataset: Base de donn�es sur laquelle calculer l'AUR
       %
       %    aur: Indice de S�rensen-Dice. 
       
           %%% TODO: II.Q8
           %%% Utilisez la m�thode obj.roc(dataset) d�j� impl�ment�e.
           
       end
   end
end