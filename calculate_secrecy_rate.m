function [secrecy_rate] = calculate_secrecy_rate(SNR, g_main, g_eve)
% CALCULATE_SECRECY_RATE Calculate the secrecy rate for a communication link
%
% Inputs:
%   SNR     - Signal-to-Noise Ratio (linear scale)
%   g_main  - Channel gain to legitimate receiver
%   g_eve   - Channel gain to eavesdropper
%
% Output:
%   secrecy_rate - Secrecy capacity in bits/s/Hz
%
% The secrecy rate is defined as:
%   C_s = max(C_main - C_eve, 0)
% where C_main and C_eve are the capacities of main and eavesdropper channels

    % Calculate capacity of main channel
    C_main = log2(1 + SNR * g_main);
    
    % Calculate capacity of eavesdropper channel
    C_eve = log2(1 + SNR * g_eve);
    
    % Secrecy rate (non-negative)
    secrecy_rate = max(C_main - C_eve, 0);
end
