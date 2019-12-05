classdef MSLD
   properties
       W               % Taille de la fenêtre
       L               % Vecteur contenant les longueurs des lignes à détecter
       n_orientation   % Nombre d'orientation des lignes à détecter
       
       line_detectors_masks 
       % Masques pour la détection des lignes pour chaque valeur de L et
       % chaque valeur de n_orientation.
       
       avg_mask % Masque moyenneur de taille WxW.
       
       threshold = 0.56;    % Seuil de segmentation (à apprendre)
   end
   methods
       function obj = MSLD(W, L, n_orientation)
       % Constructeur de la classe MSLD
       %    W: Taille de la fenêtre (tel que défini dans l'article)
       %    L: Un veteur contenant les valeurs des longueurs des lignes qui 
       %    seront détectées par la MSLD.
       %    n_orientation: Nombre d'orientations des lignes à détecter
           
           obj.W = W;
           obj.L = L;
           obj.n_orientation = n_orientation;
           
           %%% TODO: I.Q1
           matrix_mask = ones(W);
           obj.avg_mask = 1/sum(matrix_mask,'all')*matrix_mask;
           
           
           %%% TODO: I.Q2
           %%% line_detectors_masks est un cell array contenant les masques
           %%% de détection de ligne pour toutes les échelles contenues
           %%% dans le vecteur L et pour un nombre d'orientation égal à
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
       %                     MSLD Implémentation                          %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       function R = basicLineDetector(obj, grey_lvl, L)
       % Applique l'algorithme Basic Line Detector sur la carte 
       % d'intensité grey_lvl avec des lignes de longueurs L.
       %    obj: Instance courante de la classe MSLD
       %    grey_lvl: Carte d'intensité sur laquelle est appliqué le BLD
       %    L: Longueur des lignes (on supposera que L est présent dans obj.L
       %                   et donc que obj.line_detectors_masks{L} existe).
           
           %%% TODO: I.Q4
         
           pad_size = floor((obj.W/2));
           grey_lvl_pad = padarray(grey_lvl,[pad_size pad_size],1,'both');
           I_w_avg = conv2(grey_lvl_pad,obj.avg_mask, 'valid');
            
           pad_size_2 = floor((L/2));
           grey_lvl_pad_L = padarray(grey_lvl, [pad_size_2 pad_size_2], 1, 'both');
           
           for i = 0:(obj.n_orientation-1)
               I_w_ligne(:,:,(i+1)) = conv2(grey_lvl_pad_L, obj.line_detectors_masks{L}(:,:,(i+1)), 'valid');
           end
           I_w_max = max(I_w_ligne,[],3);
           R =  I_w_max - I_w_avg;
           R = (R-mean(R,'all'))./std(R,0,'all');
          
       end
       
       function Rcombined = multiScaleLineDetector(obj, image)
       % Applique l'algorithme de Multi-Scale Line Detector et combine les
       % réponses des BLD pour obtenir la carte d'intensité de l'Équation 4
       % de la section 3.3 Combination Method.
       %    obj: Instance courante de la classe MSLD
       %    image: Image aux intensitées comprises entre 0 et 1 et aux 
       %           dimensions [hauteur, largeur, canal] (canal: R=1 G=2 B=3)
           
           %%% TODO: I.Q6
           grey_lvl = 1-image.data(:,:,2);
           R_somme = 0;
           for j = 1:2:obj.W
                R = obj.basicLineDetector(grey_lvl, j);
                R_somme=R_somme+R;
           end
          Rcombined = (1/(8+1))*(R_somme+double(grey_lvl)); %gros hardcode de la valeur 8 car 8 valeurs impaires de 1 a 15
          
       end
       
       function [threshold, accuracy, obj] = learnThreshold(obj, dataset)
       % Apprend le seuil optimal pour obtenir la précision la plus élevée
       % sur le dataset donné.
       % Cette méthode remplace la valeur de obj.threshold par le seuil
       % optimal puis renvoie ce seuil et la précision obtenue. 
       % (Comme cette méthode modifie obj.threshold, la variable obj doit
       %  être retournée. La méthode s'utilise: 
       %  [threshold, accuracy, msld] = msld.learn_threshold(dataset);
       %
       %    obj:  Instance courante de la classe MSLD
       %    dataset: cell array contenant les colonnes: data, label, mask.
       %
       %    threshold: Seuil proposant la meilleure précision
       %    accuracy: Valeur de la meilleure précision
       %    obj: Instance courante de la classe MSLD avec le nouveau seuil
       
           [tpr, fpr, thresholds] = obj.rocknroll(dataset);
           label_final=0;
           for i = 1:length(dataset)
                label_temp = dataset(i).label(dataset(i).mask);
                label_final = cat(1, label_final, label_temp);
           end
           
           p = sum(label_final(:) == 1);
           n = sum(label_final(:) == 0);
           
           %%% TODO: I.Q10
           % ...

           [accuracy,y] = max((p*tpr + n*(1-fpr))/(p+n));
           threshold = thresholds(y);
           obj.threshold = threshold;
       end
       
       function vessels = segmentVessels(obj, image)
       % Segmente les vaisseaux sur une image en utilisant la MSLD.
       %    obj: Instance courante de la classe MSLD
       %    image: Image sur laquelle appliquer l'algorithme

           %%% TODO: I.Q13 
           %%% Utilisez obj.multiScaleLineDetector(image) et obj.threshold.
           vessels = obj.multiScaleLineDetector(image);
           vessels = vessels>=obj.threshold;           
       end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %                     Visualisation                                %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       function showDiff(obj, sample)
       % Affiche la comparaison entre la prédiction de l'algorithme et les
       % valeurs attendues (labels) selon le code couleur suivant:
       %    - Noir: le pixel est absent de la prédiction et du label
       %    - Rouge: le pixel n'est présent que dans la prédiction
       %    - Bleu: le pixel n'est présent que dans le label
       %    - Blanc: le pixel est présent dans la prédiction ET le label
       %
       %    obj: Instance courante de la classe MSLD
       %    sample: Un échantillon provenant d'un dataset contenant les
       %            champs ['data', 'label', 'mask'].
       
            %%% TODO: I.Q16
            % ...
            vessels = obj.segmentVessels(sample);
            
            vrai_positif = sample.label==1;
            vrai_negatif = sample.label==0;
          
            vessels_positif = vessels==1;
            vessels_negatif = vessels==0;
            
            red = (vessels_positif-vrai_positif).*sample.mask+vrai_positif.*sample.mask;
            blue =  (vessels_negatif-vrai_negatif).*sample.mask+vrai_positif.*sample.mask;
            green = vrai_positif.*sample.mask;
            
            
            imshow(cat(3, red,green,blue));
       end
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %                    SEGMENTATION METRICS                          %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       function [tpr, fpr, thresholds] = rocknroll(obj, dataset)
       % Calcul la courbe ROC de l'algorithme MSLD sur un dataset donné et
       % sur la région d'intérêt indiquée par le champs mask.
       %
       %    obj: Instance courante de la classe MSLD
       %    dataset: Base de données sur laquelle calculer la courbe ROC
       %    
       %    tpr: Vecteur des Taux de vrais positifs
       %    fpr: Vecteur des Taux de faux positifs
       %    thresholds: Vecteur des seuils associés à ces taux.
       
           %%% TODO: I.Q9
           %%% Vous pouvez utiliser la fonction Matlab: roc().
           %%%
           %%% L'itéreration sur le dataset se fait par:
           label_final = [];
           image_finale = [];
           d=dataset;
           for i=1:length(dataset)
               label = d(i).label;
               mask = d(i).mask;
               
               label_temp = label(mask);
               label_final = cat(1, label_final, label_temp);
               
               image_temp = obj.multiScaleLineDetector(d(i));
               image_finale = cat(1, image_finale, image_temp(mask));
           end
           [tpr, fpr, thresholds] = roc(label_final', image_finale');
           
       end
       
       function [accuracy, confusion_matrix] = naiveMetrics(obj, dataset)
       % Évalue la précision et la matrice de confusion de l'algorithme sur 
       % un dataset donné et sur la région d'intérêt indiquée par le 
       % champs mask. 
       %
       %    obj: Instance courante de la classe MSLD
       %    dataset: Base de données sur laquelle calculer les métriques
       %
       %    accuracy: Précision 
       %    confusion_matrix: Matrices de confusions normalisées par le
       %                      nombre de labels positifs et négatifs
       
           %%% TODO: II.Q1
           label_final = [];
           image_finale = [];
          
           for i = 1:length(dataset)
               label = dataset(i).label;
               mask = dataset(i).mask;
               
               label_temp = label(mask);
               label_final = cat(1, label_final, label_temp);
               
               image_temp = obj.segmentVessels(dataset(i));
               image_finale = cat(1, image_finale, image_temp(mask)); 
              
           end
           
           p = sum(label_final(:) == 1);
           n = sum(label_final(:) == 0);
           
           confusion_matrix = confusionmat(label_final',image_finale');
           accuracy = (confusion_matrix(1,1)+confusion_matrix(2,2))/(p+n);
       end
       
       function [diceIndex] = dice(obj, dataset)
       % Évalue l'indice dice de l'algorithme sur  un dataset donné et sur 
       % la région d'intérêt indiquée par le champs mask. 
       %
       %    obj: Instance courante de la classe MSLD
       %    dataset: Base de données sur laquelle calculer l'indice
       %
       %    diceIndex: Indice de Sørensen-Dice. 
       
           %%% TODO: II.Q6
           %%% Vous pouvez utiliser la function Matlab: dice().
           label_final = [];
           image_finale = [];
          
           for i = 1:length(dataset)
               label = dataset(i).label;
               mask = dataset(i).mask;
               
               label_temp = label(mask);
               label_final = cat(1, label_final, label_temp);
               
               image_temp = obj.segmentVessels(dataset(i));
               image_finale = cat(1, image_finale, image_temp(mask)); 
              
           end
           [diceIndex] = dice(label_final',image_finale');
       end
       
       function [aur] = plotROC(obj, dataset)
       % Affiche la courbe ROC et calcule l'AUR de l'algorithme pour un
       % dataset donnée et sur la région d'intérêt indiquée par le champs
       % mask.
       %
       %    obj: Instance courante de la classe MSLD
       %    dataset: Base de données sur laquelle calculer l'AUR
       %
       %    aur: Indice de Sørensen-Dice. 
       
           %%% TODO: II.Q8
           %%% Utilisez la méthode obj.roc(dataset) déjà implémentée.
           [TPR, FPR, ~] = obj.rocknroll(dataset);
           plot(FPR, TPR)
           xlabel('FPR')
           ylabel('TPR')
           aur = trapz(FPR, TPR);
       end
   end
end