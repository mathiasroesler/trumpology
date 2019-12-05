% Main file for the trumpology project
clear all
% close all

% Global variables
nb_coeffs = 12; % Number of coefficiants for the mfcc 
set_choice = 1; % Set choice 0: validation sets, 1: testing sets
corpora = ["french", "imitators", "others", "speeches", "trump", "women"];
people = ["chirac", "baldwin", "colbert", "bush", "", "clinton";
          "hollande", "di_domenico", "meyers", "obama", "", "harris";
          "macron", "fallon", "supercarlin", "sanders", "", "pelosi";
          "sarkozy", "noah", "veitch", "schiff", "", "warren"];
      
corpus_nb = 5; % Choice of corpus
person_nb = 1; % Choice of person

% Load the training set
train_data = extract_data('../data/train', nb_coeffs);

for corpus_nb = 1:6
    for person_nb = 1:4
        switch set_choice
            case 0
                % Load validation sets
                set = 'valid';
                corpus = corpora(corpus_nb);
                
                valid_data = extract_data(strcat('../data/', set, '/', corpus), nb_coeffs);
                
            case 1
                % Load testing sets
                set = 'test';
                corpus = corpora(corpus_nb);
                person = people(person_nb, corpus_nb);
                
                test_data = extract_data(strcat('../data/', set, '/', corpus, '/', person), nb_coeffs);
                
        end
        %     % Distance calculation for the validation sets
        %     d_valid = mean(bhattacharyya(train_data, valid_data));
        %
        %     % Plot for the  validation sets
        %     plot(corpus_nb, d_valid, '.', 'MarkerSize', 30); hold on; grid on;
        % Distance calculation for the testing sets
        d_test = mean(bhattacharyya(train_data, test_data));
        
        
        % Plot for the testing sets
        plot(person_nb, d_test, '.', 'MarkerSize', 30); hold on; grid on;
        
    end
%     legend(people(:, corpus_nb));
%     figure;
    
end

% % Legend and labels for the validation sets
% xlabel('Corpus'); ylabel('Distance de Bhattacharyya');
% legend(corpora);

% Legend and labels for one testing set
xlabel('Personne'); ylabel('Distance de Bhattacharyya');
% legend(people(:, corpus_nb));



