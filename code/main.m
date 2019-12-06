% Main file for the trumpology project
clear all
close all

% Global variables
set_choice = 1; % Set choice 0: validation sets, 1: testing sets
coeffs_nb = 7; % Number of coefficiants for the mfcc
max_coeffs_nb = 4; % Maximum number of coefficants for the mfcc (Cannot be greater than 40)
plot_nb = 1; % Plot number

dir = '../data';
corpora = ["french", "imitators", "others", "speeches", "trump", "women"];
people = ["chirac", "baldwin", "colbert", "bush", "", "clinton";
    "hollande", "di_domenico", "meyers", "obama", "", "harris";
    "macron", "fallon", "supercarlin", "sanders", "", "pelosi";
    "sarkozy", "noah", "veitch", "schiff", "", "warren"];
d_coeffs = zeros(length(corpora), max_coeffs_nb-1);

% for coeffs_nb = 2:max_coeffs_nb
%     % Testing for different number of MFCC coefficants on the validation set
%     d_coeffs(:, coeffs_nb-1) = evaluate_distance(dir, corpora, coeffs_nb, 0);
% end

% % Plot, legend and labels for different number of coefficiants
% plot(2:max_coeffs_nb, d_coeffs, '*--');
% xlabel('Nombre de coefficients'); ylabel('Distance de Bhattacharyya');
% legend(corpora, 'Location', 'Best');


% Evaluation and plotting
if (set_choice == 0)
    % For validation sets
    distance = evaluate_distance(dir, corpora, coeffs_nb, set_choice);
    
    for j = 1:length(distance)
        plot(j, distance(j), '.', 'MarkerSize', 30); hold on; grid on;
    end
    
    xlabel('Corpus'); ylabel('Distance de Bhattacharyya');
    legend(corpora, 'Location', 'Best');
    
elseif (set_choice == 1)
    % For testing sets
    distance = evaluate_distance(dir, corpora, coeffs_nb, set_choice, people);
    
    plot(1:size(people, 1), distance, '.', 'MarkerSize', 30); grid on;
    xlabel('Personnes'); ylabel('Distance de Bhattacharyya');
    legend(corpora, 'Location', 'Best');
end
    


