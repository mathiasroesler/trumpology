function data = extract_data(folder_name, num_coeffs)
%EXTRACT_DATA Function that extracts the data from the files in folder_name
%The files must be audio and the nm_coeffs mfcc are extracted from each
%audio file. The data is then concatenated. The file audio files are stereo
%files. 
%   Input: -folder_name, string, name of the folder where the data is.
%          -num_coeffs, int, number of coefficiants to extract using the
%          mfcc.
%   Output: -data, matrix Lxnum_coeffs, contains L frames and num_coeffs
%           coefficients that are extracted using a mfcc. 

dir_contents = dir(folder_name); % Structure containing all the files in the folder
data = [];    % List to contain the features
local_features = []; % List to contain local features
step = 10;

for k = 3:size(dir_contents, 1)
    % For every file in the folder except . and ..
    [x, Fe] = audioread(strcat(dir_contents(k).folder, '/', dir_contents(k).name)); % Read audio file
    win_len = round(Fe*0.03);
    overlap = round(Fe*0.02);
    [mfcc_coeffs, ~, ~, loc] = mfcc(x(:, 1), Fe, 'NumCoeffs', num_coeffs, 'WindowLength', win_len, 'OverlapLength', overlap, 'LogEnergy', 'Ignore'); % Extract mel frequency cesptral coefficiants deltas for the first channel only
    en = extract_energy(x(:, 1), loc); % Extract energy of the signal for the first channel only
    f0 = pitch(x(:, 1), Fe, 'WindowLength', win_len, 'OverlapLength', overlap);  % Extract pitch of the signal for the first channel only
    
% % Extraction of global and local functionals    
%     global_features = extract_functionals(mfcc_deltas, f0, en); % Extract global features
%     
%     for j = 1:step:length(mfcc_deltas)
%         % Extract local features over step frames
%         if (j+step > length(mfcc_deltas))
%             local_features = [local_features; extract_functionals(mfcc_deltas(j:end, :), f0(j:end), en(j:end))];
%         
%         else
%             local_features = [local_features; extract_functionals(mfcc_deltas(j:(j-1)+step, :), f0(j:(j-1)+step), en(j:(j-1)+step))];
%         
%         end
%     end
%     
%     data = [data; global_features; local_features]; % Save features
    
    data = [data; mfcc_coeffs, f0, en];
end
end

