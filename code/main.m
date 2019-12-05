% Main file for the trumpology project
clear all
% close all

% Global variables
set_choice = 1; % Set choice 0: validation sets, 1: testing sets
coeffs_nb = 7; % Number of coefficiants for the mfcc
corpus_nb = 5; % Choice of corpus
person_nb = 1; % Choice of person
max_coeffs_nb = 30; % Maximum number of coefficants for the mfcc
plot_nb = 1; % Plot number


corpora = ["french", "imitators", "others", "speeches", "trump", "women"];
people = ["chirac", "baldwin", "colbert", "bush", "", "clinton";
    "hollande", "di_domenico", "meyers", "obama", "", "harris";
    "macron", "fallon", "supercarlin", "sanders", "", "pelosi";
    "sarkozy", "noah", "veitch", "schiff", "", "warren"];
colors = ["k"; "r"; "b"; "y"; "g"; "c"]; % Colors for plots for all training sets
plots = zeros(1, numel(people));    % Plot objects for every person
d_coeffs = zeros(length(corpora), max_coeffs_nb);


% for coeffs_nb = 2:max_coeffs_nb+1
% Load the training set
train_data = extract_data('../data/train', coeffs_nb);

for corpus_nb = 1:6
    for person_nb = 1:4
        switch set_choice
            case 0
                % Load validation sets
                set = 'valid';
                corpus = corpora(corpus_nb);
                
                valid_data = extract_data(strcat('../data/', set, '/', corpus), coeffs_nb);
                
            case 1
                % Load testing sets
                set = 'test';
                corpus = corpora(corpus_nb);
                person = people(person_nb, corpus_nb);
                
                test_data = extract_data(strcat('../data/', set, '/', corpus, '/', person), coeffs_nb);
                
        end
        
        %     % Distance calculation for different number of coefficiants
        %     d_coeffs(corpus_nb, coeffs_nb-1) = mean(bhattacharyya(train_data, valid_data));
        
        %     % Distance calculation for the validation sets
        %     d_valid = mean(bhattacharyya(train_data, valid_data));
        %
        %     % Plot for the validation sets
        %     plot(corpus_nb, d_valid, '.', 'MarkerSize', 30); hold on; grid on;
        
        % Distance calculation for the testing sets
        d_test = mean(bhattacharyya(train_data, test_data));
        
        % Plot for all the testing sets
        plots(plot_nb) = plot(person_nb, d_test, strcat('.', colors(corpus_nb)), 'MarkerSize', 30); hold on; grid on;
        plot_nb = plot_nb+1;
        
    end
    
end
% end

% % Plot, legend and labels for different number of coefficiants
% plot(2:max_coeffs_nb+1, d_coeffs, '*--');
% xlabel('Nombre de coefficients'); ylabel('Distance de Bhattacharyya');
% legend(corpora, 'Location', 'Best');

% % Legend and labels for the validation sets
% xlabel('Corpus'); ylabel('Distance de Bhattacharyya');
% legend(corpora);

% % Legend and labels for one testing set
% xlabel('Personnes'); ylabel('Distance de Bhattacharyya');
% legend(people(:, corpus_nb));

% Legend and labels for all of the testing sets
xlabel('Personnes'); ylabel('Distance de Bhattacharyya');
legend(plots(1:size(people, 1):numel(people)), corpora);

