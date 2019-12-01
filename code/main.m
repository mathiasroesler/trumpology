% Main file for the trumpology project
clear all
close all

% Global variables
num_coeffs = 12; % Number of coefficiants for the mfcc
test_nb = 6; % Test number 1: Baldwin, 2: Di domenico, 3: Fallon, 4: Noah, 5: Obama, 6: Trump
valid_nb = 1; % Validation number 1: Trump, 2: Obama

% max_num_coeffs = 30;
% d = zeros(1, max_num_coeffs);
max_testers = 6;
d = zeros(1, max_testers);

% for num_coeffs = 2:max_num_coeffs+1
% Load the training set
train_data = extract_data('../data/trump/train', num_coeffs);

%     % Load validation set
%     switch valid_nb
%         case 1
%             % Trump
%             valid_data = extract_data('../data/trump/valid', num_coeffs);
%
%         case 2
%             % Obama
%             valid_data = extract_data('../data/obama/valid', num_coeffs);
%
%     end

for test_nb = 1:6
    % Load testing set depending on the imitator number
    switch test_nb
        case 1
            % Baldwin
            test_data = extract_data('../data/baldwin/test', num_coeffs);
            
        case 2
            % Di Domenico
            test_data = extract_data('../data/di_domenico/test', num_coeffs);
            
        case 3
            % Fallon
            test_data = extract_data('../data/fallon/test', num_coeffs);
            
        case 4
            % Noah
            test_data = extract_data('../data/noah/test', num_coeffs);
            
        case 5
            % Obama
            test_data = extract_data('../data/obama/test', num_coeffs);
        case 6
            % Trump
            test_data = extract_data('../data/trump/test', num_coeffs);
            
    end
    
    
    % % Distance calculation for the validation sets
    % d_valid = mean(bhattacharyya(train_data, valid_data));
    % d(num_coeffs-1) = d_valid;
    
    % Distance calculation for the testing sets
    d_test = mean(bhattacharyya(train_data, test_data));
    
    plot(test_nb, d_test, '.', 'MarkerSize', 22); hold on; grid on;
end

% % Plot for the validation sets
% plot(2:max_num_coeffs+1, d, 'b'); hold on; grid on;
% plot(2:max_num_coeffs+1, f.d, 'k');
% plot(12, d(11), 'b.', 'MarkerSize', 22);
% plot(12, f.d(11), 'k.', 'MarkerSize', 22);
% legend('Trump validation set', 'Obama validation set');
% xlabel('Nombre de coefficients'); ylabel('Distance de Bhattacharyya');

% Plot for the testing sets
xlabel('Personne'); ylabel('Distance de Bhattacharyya');
legend('Baldwin', 'Di Domenico', 'Fallon', 'Noah', 'Obama', 'Trump', 'Location', 'Best');

