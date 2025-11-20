%% Physical Layer Security with Cooperative Jamming
% This script implements a relay-assisted secure communication system
% with cooperative jamming to confuse the eavesdropper
%
% System Model:
% - Source (Alice) transmits to Destination (Bob) with help of Relay
% - Relay can either forward signal or jam the eavesdropper
% - Eavesdropper (Eve) tries to intercept the communication

clear all;
close all;
clc;

%% System Parameters
N_monte = 1000;              % Number of Monte Carlo iterations
SNR_dB = 0:2:30;             % SNR range in dB
SNR_linear = 10.^(SNR_dB/10); % Convert to linear scale

% Distance parameters (normalized)
d_SR = 1;                    % Distance Source to Relay
d_RD = 1;                    % Distance Relay to Destination
d_SD = 1.8;                  % Distance Source to Destination (direct)
d_SE = 1.2;                  % Distance Source to Eavesdropper
d_RE = 0.8;                  % Distance Relay to Eavesdropper

% Path loss exponent
alpha = 2.5;

% Calculate path loss coefficients
PL_SR = d_SR^(-alpha);
PL_RD = d_RD^(-alpha);
PL_SD = d_SD^(-alpha);
PL_SE = d_SE^(-alpha);
PL_RE = d_RE^(-alpha);

% Power allocation factor for cooperative jamming (0 to 1)
% eta: fraction of power used for information transmission
% (1-eta): fraction used for jamming
eta = 0.7;

%% Initialize result arrays
secrecy_capacity_jamming = zeros(length(SNR_dB), 1);
secrecy_capacity_no_jamming = zeros(length(SNR_dB), 1);

%% Monte Carlo Simulation
fprintf('Starting Cooperative Jamming Simulation...\n');
fprintf('Number of iterations: %d\n', N_monte);
fprintf('Power allocation factor (eta): %.2f\n', eta);
fprintf('SNR range: %d to %d dB\n\n', SNR_dB(1), SNR_dB(end));

for snr_idx = 1:length(SNR_dB)
    fprintf('Processing SNR = %d dB... ', SNR_dB(snr_idx));
    
    secrecy_sum_jamming = 0;
    secrecy_sum_no_jamming = 0;
    
    for iter = 1:N_monte
        % Generate Rayleigh fading channel coefficients
        h_SR = sqrt(PL_SR/2) * (randn + 1j*randn);  % Source to Relay
        h_RD = sqrt(PL_RD/2) * (randn + 1j*randn);  % Relay to Destination
        h_SD = sqrt(PL_SD/2) * (randn + 1j*randn);  % Source to Destination
        h_SE = sqrt(PL_SE/2) * (randn + 1j*randn);  % Source to Eavesdropper
        h_RE = sqrt(PL_RE/2) * (randn + 1j*randn);  % Relay to Eavesdropper
        
        % Channel gains (squared magnitudes)
        g_SR = abs(h_SR)^2;
        g_RD = abs(h_RD)^2;
        g_SD = abs(h_SD)^2;
        g_SE = abs(h_SE)^2;
        g_RE = abs(h_RE)^2;
        
        % Current SNR (total power)
        P = SNR_linear(snr_idx);
        
        %% With Cooperative Jamming
        % Phase 1: Source transmits with power eta*P
        % Relay receives and destination receives
        
        % SINR at destination (with jamming from relay in phase 2)
        % Assuming MRC at destination
        P_info = eta * P;  % Power for information
        P_jam = (1 - eta) * P;  % Power for jamming
        
        % Destination combines direct and relay paths
        % Simplified model: coherent combination
        gamma_D = P_info * (g_SD + g_RD);
        
        % Eavesdropper suffers from jamming
        % SINR at eavesdropper
        gamma_E_jam = (P_info * g_SE) / (1 + P_jam * g_RE);
        
        % Secrecy capacity with jamming
        C_D_jam = log2(1 + gamma_D);
        C_E_jam = log2(1 + gamma_E_jam);
        secrecy_rate_jamming = max(C_D_jam - C_E_jam, 0);
        secrecy_sum_jamming = secrecy_sum_jamming + secrecy_rate_jamming;
        
        %% Without Cooperative Jamming (full power for information)
        % Both source and relay use full power for transmission
        gamma_D_no_jam = P * (g_SD + g_RD);
        gamma_E_no_jam = P * (g_SE + g_RE);
        
        % Secrecy capacity without jamming
        C_D_no_jam = log2(1 + gamma_D_no_jam);
        C_E_no_jam = log2(1 + gamma_E_no_jam);
        secrecy_rate_no_jamming = max(C_D_no_jam - C_E_no_jam, 0);
        secrecy_sum_no_jamming = secrecy_sum_no_jamming + secrecy_rate_no_jamming;
    end
    
    % Average results
    secrecy_capacity_jamming(snr_idx) = secrecy_sum_jamming / N_monte;
    secrecy_capacity_no_jamming(snr_idx) = secrecy_sum_no_jamming / N_monte;
    
    fprintf('Done.\n');
end

fprintf('\nSimulation completed successfully!\n\n');

%% Plot Results
figure('Position', [100, 100, 800, 500]);
plot(SNR_dB, secrecy_capacity_jamming, 'b-o', 'LineWidth', 2, 'MarkerSize', 6);
hold on;
plot(SNR_dB, secrecy_capacity_no_jamming, 'r--s', 'LineWidth', 2, 'MarkerSize', 6);
grid on;
xlabel('SNR (dB)', 'FontSize', 12);
ylabel('Secrecy Capacity (bits/s/Hz)', 'FontSize', 12);
title('Secrecy Capacity: Cooperative Jamming vs No Jamming', 'FontSize', 14);
legend('With Cooperative Jamming', 'Without Jamming', 'Location', 'northwest');
set(gca, 'FontSize', 11);

% Save figure
saveas(gcf, 'cooperative_jamming_results.png');
fprintf('Results saved to cooperative_jamming_results.png\n');

%% Display Summary Statistics
fprintf('\n=== SIMULATION SUMMARY ===\n');
fprintf('Power allocation factor (eta): %.2f\n', eta);
fprintf('Maximum Secrecy Capacity (With Jamming): %.3f bits/s/Hz at SNR = %d dB\n', ...
    max(secrecy_capacity_jamming), SNR_dB(find(secrecy_capacity_jamming == max(secrecy_capacity_jamming), 1)));
fprintf('Maximum Secrecy Capacity (Without Jamming): %.3f bits/s/Hz at SNR = %d dB\n', ...
    max(secrecy_capacity_no_jamming), SNR_dB(find(secrecy_capacity_no_jamming == max(secrecy_capacity_no_jamming), 1)));

% Find optimal eta
fprintf('\nNote: Current eta = %.2f. Try different values to find optimal power allocation.\n', eta);
fprintf('==========================\n');
