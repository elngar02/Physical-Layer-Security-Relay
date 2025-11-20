function [h] = generate_rayleigh_channel(path_loss)
% GENERATE_RAYLEIGH_CHANNEL Generate a Rayleigh fading channel coefficient
%
% Input:
%   path_loss - Path loss coefficient (distance^(-alpha))
%
% Output:
%   h - Complex channel coefficient following Rayleigh distribution
%
% The channel coefficient h is modeled as:
%   h = sqrt(path_loss/2) * (h_real + j*h_imag)
% where h_real and h_imag are i.i.d. Gaussian random variables

    % Generate real and imaginary parts (Gaussian distribution)
    h_real = randn;
    h_imag = randn;
    
    % Combine with path loss to get Rayleigh fading channel
    h = sqrt(path_loss/2) * (h_real + 1j*h_imag);
end
