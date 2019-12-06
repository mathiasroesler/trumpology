function d = bhattacharyya(p_data, q_data)
%BHATTACHARYYA Calculates the Bhattacharyya distance between the data in
%p_data and q_data.
%   Input: -p_data, matrix PxN where P is the number of samples and N is 
%          the number of features.
%          -q_data, matrix QxN where Q is the number of samples and N is
%          the number of features.
%   Output: -d, vector 1xN, each component represent the Bhattacharyya
%           distance of the component.

p_mean = mean(p_data);  % Mean of p_data
p_var = var(p_data);    % Variance of p_data

q_mean = mean(q_data);  % Mean of q_data
q_var = var(q_data);    % Variance of p_data

d = 0.25*log(0.25*(p_var./(q_var+eps) + q_var./p_var + 2)) + 0.25*(((p_mean-q_mean).^2)./(p_var + q_var));
end

