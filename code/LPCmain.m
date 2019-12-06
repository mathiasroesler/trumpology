close all, clear all, clc ;

%% Chargement des donn�es :

%-----------------Train----------------------

path_Train = '/Users/jeremyjaspar/Desktop/M2_ISSI/Perception/Projet/trumpology/data/train';
dir_Train = dir(fullfile(path_Train));

Class_Train = cell(0,2);
Base_Train = cell(0,1);
for n = 3:length(dir_Train)
    Class_Train{end+1,1} = 1;
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

%% Extraction features LPC 16
p=16;
Features_Train = [];
Labels_Train = [];
Features_Test = [];
Labels_Test = [];

for n=1:length(Class_Train)
    [a,~] = lpc(Base_Train{n,1},p);
    Features_Train = [Features_Train; (a(1,2:end)-mean(a(1,2:end)))/var(a(1,2:end))];
    Labels_Train = [Labels_Train; Class_Train{n,1}];
end

for n=1:length(Class_Test)
    [a,~] = lpc(Base_Test{n,1},p);
    Features_Test = [Features_Test; (a(1,2:end)-mean(a(1,2:end)))/var(a(1,2:end))];
    Labels_Test = [Labels_Test; Class_Test{n,1}];
end
clear a n;

save Features_Train.dat Features_Train -ascii
save Features_Test.dat Features_Test -ascii
save Labels_Train.dat Labels_Train -ascii
save Labels_Test.dat Labels_Test -ascii

%% Distance Bhatta



