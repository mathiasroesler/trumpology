function functionals = extract_functionals(mfcc_deltas, pitch_coeffs, energy_coeffs)
%EXTRACT_FUNCTIONALS Extracts the features of a audio signal based on the MFCC
%the pitch and the energy of the signal.
%   Input: -mfcc_deltas, matrix NxMxC, MFCCs for N frames and M
%           coefficiants with C channels
%          -pitch_coeffs, vector NxC, pitch for N frames and C channels
%          -energy_coeffs, vector NxC, energy for N frames
%   Output: -functionals, vector Cx(M+7), extracted features from the inputs.

channels = size(pitch_coeffs, 2);
rate_features = zeros(channels, size(mfcc_deltas, 2)+1); % Feature representing the speech rate estimated with the MFCC
pitch_features = zeros(channels, 3); % Features representing the pitch esitmated with the pitch_coeffs
energy_features = zeros(channels, 3); % Features representing the intensity estimated with the energy

% Extract rate features
rate_features(:, 1:end-1) = squeeze(sum(abs(mfcc_deltas)))';
rate_features(:, end) = var(rate_features(:, 1:end-1), 0, 2);

% Extract pitch features
pitch_features(:, 1) = mean(pitch_coeffs);
pitch_features(:, 2) = var(pitch_coeffs);
pitch_features(:, 3) = max(pitch_coeffs);

% Extract energy features
energy_features(:, 1) = mean(energy_coeffs);
energy_features(:, 2) = var(energy_coeffs);
energy_features(:, 3) = max(energy_coeffs);

functionals = [rate_features pitch_features energy_features];
end

