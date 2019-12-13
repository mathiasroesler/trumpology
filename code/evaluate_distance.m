function distance = evaluate_distance(dir, corpora, coeffs_nb, set_choice, people)
%EVALUATE_DISTANCE Evaluates the distance between the train data and the validation
%data or the training data, depending on the value of set_choice. 
%   Input: -dir, str, location of the different sets.
%          -corpora, str vector 1xC, names of the different corpora.
%          -coeffs_nb, int, number of coefficiants for the MFCC.
%          -set_choice, 0 or 1, 0: validation set, 1: training set.
%          -people, str matrix CxN (only if set_choice is 1), matrix
%          containing the names of the people in each corpus. 
%   Output: -distance, matrix CxN, if people is not specified then N=1,
%   each element is the Bhattacharyya distance of a person or corpus
%   depending on the value of set_choice.

if (nargin == 4 && set_choice == 0)
    % The evaluation is done for one or several validation sets
    distance = zeros(size(corpora));

elseif (nargin == 5 && set_choice == 1)
    % The evaluation is done for one or several training sets
    distance = zeros(length(corpora), size(people, 1));
    
else
    % Error in the arguments
    error('Error with input arguments');
end   

% Load the training set
train_data = extract_data(strcat(dir, '/train'), coeffs_nb);

for corpus_nb = 1:length(corpora)
        switch set_choice
            case 0
                % Load validation set and extract features
                set = 'valid';
                corpus = corpora(corpus_nb);
                
                valid_data = extract_data(strcat(dir, '/', set, '/', corpus), coeffs_nb);
                
                distance(corpus_nb) = mean(bhattacharyya(train_data, valid_data)); %sqrt(sum((mean(train_data) - mean(valid_data)).^2));
                
            case 1
                for person_nb = 1:size(people, 1)
                    % Load testing set and extract features
                    set = 'test';
                    corpus = corpora(corpus_nb);
                    person = people(person_nb, corpus_nb);
                
                    test_data = extract_data(strcat(dir, '/', set, '/', corpus, '/', person), coeffs_nb);
                                    
                    distance(corpus_nb, person_nb) = mean(bhattacharyya(train_data, test_data));
                    
                end
                
        end
end
