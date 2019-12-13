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

clear maxPeak peakL peakR peakAmp i;

%% Hamming window :
w = hamming(3000);
for i=1:length(Base_Train)
    Base_Train{i,1}(:,1) = conv(Base_Train{i,1}(:,1),w,"same");
    Base_Train{i,1}(:,2) = conv(Base_Train{i,1}(:,2),w,"same");
    Base_Train_Mono{i} = conv(Base_Train_Mono{i},w,"same");
end

for i=1:length(Base_Test)
    Base_Test{i,1}(:,1) = conv(Base_Test{i,1}(:,1),w,"same");
    Base_Test{i,1}(:,2) = conv(Base_Test{i,1}(:,2),w,"same");
    Base_Test_Mono{i} = conv(Base_Test_Mono{i},w,"same");
end

%% LPC Training :
Fe = 44100;
p = 16;
TimeFrame = 900; %nb de points fenêtre pour lpc (20ms)
Overlapp = 450; %(10ms)
LPC_mean = [];

for t =1:length(Class_Train)
    Time = round(length(Base_Train_Mono{t})/2);
    LPC = [];
    %{
On part de la moitié du signal, sur 1s on prend 20 échantillons de 900pts
(=20ms) avec un overlapping de 10ms. Au total on aura échantilloné 400ms. Pour chacun de ses échantillon in calcul la LPC16
    %}
    for i = 1:20
        [a,~] = lpc(Base_Train_Mono{t}(Time+(i-1)*Overlapp:Time+TimeFrame+i*Overlapp),p);
        LPC = [LPC ;(a(1,1:end)-mean(a(1,1:end)))/var(a(1,1:end))];
    end
    LPC_mean = [LPC_mean ; mean(LPC)];
end

clear i t a LPC;

%% Reconnaissance :
LPC_Test = cell(length(Class_Test),4);

for t=1:length(Class_Test)
    Time = round(length(Base_Test_Mono{t})/3);
    LPC = [];
    for i = 1:20
        [a,~] = lpc(Base_Test_Mono{t}(Time+(i-1)*Overlapp:Time+TimeFrame+i*Overlapp),p);
        LPC = [LPC ;(a(1,1:end)-mean(a(1,1:end)))/var(a(1,1:end))];
    end
   LPC_Test{t,1} = mean(LPC);
   LPC_Test{t,2} = Class_Test{t,3};
   LPC_Test{t,3} = Class_Test{t,2};
   dist = 0;
   for z =1:length(Base_Train)
       dist = dist + sqrt(sum((LPC_Test{t,1}-LPC_mean(z,:)).^2));
   end
   LPC_Test{t,4} = dist;
end
 
%% Resultats :

[~, order] = sort(cell2mat(LPC_Test(:, 4)));
Results = LPC_Test(order, :);


