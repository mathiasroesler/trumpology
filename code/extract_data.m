function data = extract_data(folder_name, num_coeffs)
%EXTRACT_DATA Function that extracts the data from the files in folder_name
%The files must be audio and the nm_coeffs mfcc are extracted from each
%audio file. The data is then concatenated. The file audio files are stereo
%files. 
%   Input: -folder_name, string, name of the folder where the data is.
%          -num_coeffs, int, number of coefficiants to extract using the
%          mfcc.
%   Output: -data, matrix Lxnum_coeffs, contains L frames and num_coeffs
%   coefficients that are extracted using a mfcc. 

dir_contents = dir(folder_name); % Structure containing all the files in the folder
data = [];    % Training data

for k = 3:size(dir_contents, 1)
    % For every file in the folder except . and ..
    [x, Fe] = audioread(strcat(dir_contents(k).folder, '/', dir_contents(k).name)); % Read audio file
    coeffs = mfcc(x, Fe, 'NumCoeffs', num_coeffs); % Extract mel frequency cesptral coefficiants
    data = [data; coeffs(:, 2:end, 1); coeffs(:, 2:end, 2)]; % Add both channels to training set
end
end

