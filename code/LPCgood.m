close all, clear all, clc ;

%% Chargement des donnï¿½es :

%-----------------Train----------------------

path_Train = '/Users/jeremyjaspar/Desktop/M2_ISSI/Perception/Projet/trumpology/data/train';
dir_Train = dir(fullfile(path_Train));

Class_Train = cell(0,2);
Base_Train = cell(0,1);
for n = 3:length(dir_Train)
    Class_Train{end+1,1} = 5;
    Class_Train{end,2} = "trump";
    Base_Train{end+1,1} = audioread(strcat(dir_Train(n).folder,'/',dir_Train(n).name));
end
clear path_Train dir_Train n;

%-----------------Test----------------------
path_Test = '/Users/jeremyjaspar/Desktop/M2_ISSI/Perception/Projet/trumpology/data/test';
dir_Test = dir(fullfile(path_Test));

Class_Test = cell(0,3);
Base_Test = cell(0,1);

for n = 4:length(dir_Test)
    %on entre dans dossier french:
    dir_Test_class = dir(fullfile(strcat(path_Test,'/',dir_Test(n).name)));
    for p=4:length(dir_Test_class)
        %on entre des dossier chirac:
        dir_Test_class_ex = dir(fullfile(strcat(path_Test,'/',dir_Test(n).name,'/',dir_Test_class(p).name)));
        for q = 3:length(dir_Test_class_ex)
            Class_Test{end+1,1} = n-3;
            Class_Test{end,2} = dir_Test(n).name;
            Class_Test{end,3} = dir_Test_class(p).name;
            Base_Test{end+1,1} = audioread(strcat(dir_Test(n).folder,'/',dir_Test(n).name,'/',dir_Test_class(p).name,'/',dir_Test_class_ex(q).name));
        end
    end
end
clear path_Test dir_Test dir_Test_class dir_Test_class_ex n p q;

%% Convert to Mono:
Base_Train_Mono = cell(length(Base_Train),1);
Base_Test_Mono = cell(length(Base_Test),1);

for i =1:length(Base_Train)
    Base_Train_Mono{i} = Base_Train{i}(:,1) + Base_Train{i}(:,2);
    peakAmp = max(abs(Base_Train_Mono{i}));
    Base_Train_Mono{i} = Base_Train_Mono{i}/peakAmp;
    
    peakL = max(abs(Base_Train{i}(:,1)));
    peakR = max(abs(Base_Train{i}(:,2)));
    maxPeak = max([peakL peakR]);
    Base_Train_Mono{i} = Base_Train_Mono{i}*maxPeak;
end

for i = 1:length(Base_Test)
    Base_Test_Mono{i} = Base_Test{i}(:,1) + Base_Test{i}(:,2);
    peakAmp = max(abs(Base_Test_Mono{i}));
    Base_Test_Mono{i} = Base_Test_Mono{i}/peakAmp;
    
    peakL = max(abs(Base_Test{i}(:,1)));
    peakR = max(abs(Base_Test{i}(:,2)));
    maxPeak = max([peakL peakR]);
    Base_Test_Mono{i} = Base_Test_Mono{i}*maxPeak;
end

clear maxPeak peakL peakR peakAmp i Base_Train Base_Test;

%% Suppression des silences :
seuil = 0.01;

for i = 1:length(Base_Test_Mono)
    logical = (abs(Base_Test_Mono{i}) > seuil);
    ind = find(logical);
    Base_Test_Mono{i} = Base_Test_Mono{i}(ind,1);
end

for i = 1:length(Base_Train_Mono)
    logical = (abs(Base_Train_Mono{i}) > seuil);
    ind = find(logical);
    Base_Train_Mono{i} = Base_Train_Mono{i}(ind,1);
end

clear i ind logical seuil;
%% Segmentation & hamming & LPCp & FLPC:
%{
On segmente chaque signaux sur des périodes de 20ms avec 10ms d'overlapp
%}
t_15ms = 662;
t_10ms = 441;
w = hamming(t_15ms);
p=20;
LPC_Train = [];
LPC_Test = [];

for i=1:length(Base_Train_Mono)
    LPC = [];
    for j = 1:t_10ms:length(Base_Train_Mono{i})-t_15ms
        temp = w.*Base_Train_Mono{i}(1+(j-1): (j-1)+t_15ms);
        [a,~] = lpc(temp,p);
        LPC = [LPC ;(a(1,1:end)-mean(a(1,1:end)))/var(a(1,1:end))];
    end
    LPC_Train = [LPC_Train ; mean(LPC)];
end


for i=1:length(Base_Test_Mono)
    LPC = [];
    for j =1:t_10ms:length(Base_Test_Mono{i})-t_15ms
        temp = w.*Base_Test_Mono{i}(1+(j-1): (j-1)+t_15ms);
        [a,~] = lpc(temp,p);
        LPC = [LPC ;(a(1,1:end)-mean(a(1,1:end)))/var(a(1,1:end))];
    end
    LPC_Test = [LPC_Test ; mean(LPC)];
end

clear a i j LPC p t_10ms t_20ms temp w;

%% Apprentissage GMM :

% obj = gmdistribution.fit(LPC_Train, 3,'CovType','diagonal');
% gmm = gmdistribution(obj.mu,obj.Sigma);


%% Resultats Distance:
Resultat = cell(length(Base_Test_Mono),4);

for i = 1:length(Base_Test_Mono)
    Resultat{i,1} = Class_Test{i,2};
    Resultat{i,2} = Class_Test{i,3};
    dist=[];
    for z = 1:length(Base_Train_Mono)
        dist = [dist; sqrt(sum((LPC_Test(i,:)-LPC_Train(z,:)).^2))];
    end
    Resultat{i,3} = exp(-min(dist));
    %Resultat{i,4} = cdf(gmm,LPC_Test(i,:));
end

% [~, order] = sort(cell2mat(Resultat(:, 3)),'descend');
% Resultat = Resultat(order, :);

clear dist i z order;

%% Faire la moyenne sur les personnes  :

corpora = ["french"; "imitators"; "others"; "speeches"; "trump"; "women"];
people = ["chirac"; "baldwin"; "bush"; "trump"; "clinton";
    "hollande"; "di_domenico"; "meyers"; "obama"; "harris";
    "macron"; "fallon"; "supercarlin"; "sanders"; "pelosi";
    "sarkozy"; "noah"; "veitch"; "schiff"; "warren"];


Moy_people = cell(length(people),3);
for i = 1:length(people)
    logical = (Resultat(:,2) == people(i));
    ind = find(logical);
    Moy_people{i,1} = Resultat{ind(1),1};
    Moy_people{i,2} = people(i);
    Moy_people{i,3} = mean([Resultat{ind,3}]);
end

[~, order] = sort(cell2mat(Moy_people(:, 3)),'descend');
Moy_people = Moy_people(order, :);

% c = categorical(Moy_people(:,1));
% b1 = bar([Moy_people{:,2}]);
% legend

%% Save data for NN :
%{
On sépare les données en deux nouveaux groupes :
- Base_train :
    12xtrump de LPC_Train
    6xfrench
    9xothers
    6xspeech
    6xwomen
-Label_train:
    12x1
    27x0
-Base_test:
    3xtrump
    12ximmitators
    6xspeech
    6xfrench
    6xwomen

Base_train = [LPC_Train; LPC_Test(1:6,:); LPC_Test(25:33,:); LPC_Test(34:39,:); LPC_Test(49:54,:)];
Label_train = [ones(12,1); zeros(27,1)];
Base_test = [LPC_Test(46:48,:); LPC_Test(13:24,:); LPC_Test(40:45,:); LPC_Test(7:12,:); LPC_Test(55:60,:)];

save Base_train.dat Base_train -ascii
save Label_train.dat Label_train -ascii
save Base_test.dat Base_test -ascii

%}

