function [train, test] = load_dataset()
    % Charge les images de l'ensemble d'entrainement et de test dans 2
    % objets struct. Pour chaque �chantillon, il faut cr�er une ligne dans
    % le dataset contenant les attributs ['line', 'data', 'label', 'mask'].
    % On pourra ainsi acc�der � la premi�re image du dataset d'entrainement
    % avec train(1).data.
    % La copie int�grale d'un dataset peut se faire avec la commande: 
    %       trainCopie = train(1,:);
    
    files_test = dir('DRIVE/data/test/*.png');
    files_train = dir('DRIVE/data/training/*.png');
    
    train = struct(['name' 'data' 'label' 'mask'], []);
    test = struct(['name' 'data' 'label' 'mask'], []);
    
    for i=1:length(files_train)
        name = files_train(i).name;
        train(i).name = name;
        %%% TODO I.Q3 Chargez les images data, label et mask:
        train(i).data = im2double(imread(['DRIVE/data/training/',name])); % Type: double, intensit� comprises entre 0 et 1);
        train(i).label = imread(['DRIVE/label/training/',name]); % Type: bool�en
        train(i).mask = imread(['DRIVE/mask/training/',name]);  % Type: bool�en
    end
   
    %%% TODO I.Q3 De la m�me mani�re, chargez les images de test.

    for i=1:length(files_test)
        name = files_test(i).name;
        test(i).name = name;
        test(i).data = im2double(imread(['DRIVE/data/test/',name])); % Type: double, intensit� comprises entre 0 et 1
        test(i).label = imread(['DRIVE/label/test/',name]); % Type: bool�en
        test(i).mask = imread(['DRIVE/mask/test/',name]);  % Type: bool�en
    end

end