% Main file for the trumpology project
clear all
close all

% Global variables
num_coeffs = 13; % Number of coefficiants for the mfcc
imitator = 1; % Imitator number 1: Baldwin, 2: Di domenico, 3: Fallon, 4: Noah

% Load the training set
train_data = extract_data('../data/trump/train', num_coeffs);

% Load validation set
valid_data = extract_data('../data/trump/valid', num_coeffs); 

% Load testing set depending on the imitator number
switch imitator
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
        
end


