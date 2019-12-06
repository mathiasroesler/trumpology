function energy = extract_energy(x, loc)
%EXTRACT_ENERGY Extracts the energy of the signal for different location.
%   Input: -x, matrix NxC, audio signal of N samples with C channels
%          -loc, vector Mx1, location of segment ends to calculate the
%          energy
%   Output: -energy, vector Mx1, energy of the signal

energy = zeros(size(loc));

for j = 1:length(loc)-1
    % Calculate the root mean square for the samples between two locations
    energy(j) = rms(x(loc(j):loc(j+1)));
end

energy(end) = rms(x(loc(end):end));
end

