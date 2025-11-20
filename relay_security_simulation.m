%% Physical Layer Security with Relay - Main Simulation Script
% This script simulates a secure communication system with a relay node
% System Model: Source (Alice) -> Relay -> Destination (Bob)
% Eavesdropper (Eve) tries to intercept the communication
% 
% The simulation evaluates secrecy capacity under different SNR conditions

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
d_SD = 2;                    % Distance Source to Destination (direct)
d_SE = 1.5;                  % Distance Source to Eavesdropper
d_RE = 1.5;                  % Distance Relay to Eavesdropper

% Path loss exponent
alpha = 2;

% Calculate path loss coefficients
PL_SR = d_SR^(-alpha);
PL_RD = d_RD^(-alpha);
PL_SD = d_SD^(-alpha);
PL_SE = d_SE^(-alpha);
PL_RE = d_RE^(-alpha);

%% Initialize result arrays
secrecy_capacity_relay = zeros(length(SNR_dB), 1);
secrecy_capacity_direct = zeros(length(SNR_dB), 1);
outage_probability_relay = zeros(length(SNR_dB), 1);
outage_probability_direct = zeros(length(SNR_dB), 1);

target_secrecy_rate = 1;     % Target secrecy rate for outage calculation

%% Monte Carlo Simulation
fprintf('Starting Physical Layer Security Relay Simulation...\n');
fprintf('Number of iterations: %d\n', N_monte);
fprintf('SNR range: %d to %d dB\n\n', SNR_dB(1), SNR_dB(end));

for snr_idx = 1:length(SNR_dB)
    fprintf('Processing SNR = %d dB... ', SNR_dB(snr_idx));
    
    secrecy_sum_relay = 0;
    secrecy_sum_direct = 0;
    outage_count_relay = 0;
    outage_count_direct = 0;
    
    for iter = 1:N_monte
        % Generate Rayleigh fading channel coefficients
        h_SR = sqrt(PL_SR/2) * (randn + 1j*randn);  % Source to Relay
        h_RD = sqrt(PL_RD/2) * (randn + 1j*randn);  % Relay to Destination
        h_SD = sqrt(PL_SD/2) * (randn + 1j*randn);  % Source to Destination (direct)
        h_SE = sqrt(PL_SE/2) * (randn + 1j*randn);  % Source to Eavesdropper
        h_RE = sqrt(PL_RE/2) * (randn + 1j*randn);  % Relay to Eavesdropper
        
        % Channel gains (squared magnitudes)
        g_SR = abs(h_SR)^2;
        g_RD = abs(h_RD)^2;
        g_SD = abs(h_SD)^2;
        g_SE = abs(h_SE)^2;
        g_RE = abs(h_RE)^2;
        
        % Current SNR
        P = SNR_linear(snr_idx);
        
        %% Relay-based transmission (Decode-and-Forward)
        % Capacity at relay (Source -> Relay)
        C_SR = log2(1 + P * g_SR);
        
        % Capacity at destination via relay (Relay -> Destination)
        C_RD = log2(1 + P * g_RD);
        
        % End-to-end capacity (limited by weakest link)
        C_relay = min(C_SR, C_RD);
        
        % Eavesdropper capacity (best of two links)
        C_SE_relay = log2(1 + P * g_SE);
        C_RE_relay = log2(1 + P * g_RE);
        C_Eve_relay = max(C_SE_relay, C_RE_relay);
        
        % Secrecy capacity with relay
        secrecy_rate_relay = max(C_relay - C_Eve_relay, 0);
        secrecy_sum_relay = secrecy_sum_relay + secrecy_rate_relay;
        
        % Check outage
        if secrecy_rate_relay < target_secrecy_rate
            outage_count_relay = outage_count_relay + 1;
        end
        
        %% Direct transmission (without relay)
        % Capacity at destination (Source -> Destination)
        C_SD_direct = log2(1 + P * g_SD);
        
        % Eavesdropper capacity
        C_Eve_direct = log2(1 + P * g_SE);
        
        % Secrecy capacity without relay
        secrecy_rate_direct = max(C_SD_direct - C_Eve_direct, 0);
        secrecy_sum_direct = secrecy_sum_direct + secrecy_rate_direct;
        
        % Check outage
        if secrecy_rate_direct < target_secrecy_rate
            outage_count_direct = outage_count_direct + 1;
        end
    end
    
    % Average results
    secrecy_capacity_relay(snr_idx) = secrecy_sum_relay / N_monte;
    secrecy_capacity_direct(snr_idx) = secrecy_sum_direct / N_monte;
    outage_probability_relay(snr_idx) = outage_count_relay / N_monte;
    outage_probability_direct(snr_idx) = outage_count_direct / N_monte;
    
    fprintf('Done.\n');
end

fprintf('\nSimulation completed successfully!\n\n');

%% Plot Results
% Secrecy Capacity vs SNR
figure('Position', [100, 100, 800, 600]);
subplot(2,1,1);
plot(SNR_dB, secrecy_capacity_relay, 'b-o', 'LineWidth', 2, 'MarkerSize', 6);
hold on;
plot(SNR_dB, secrecy_capacity_direct, 'r--s', 'LineWidth', 2, 'MarkerSize', 6);
grid on;
xlabel('SNR (dB)', 'FontSize', 12);
ylabel('Secrecy Capacity (bits/s/Hz)', 'FontSize', 12);
title('Secrecy Capacity vs SNR', 'FontSize', 14);
legend('With Relay (DF)', 'Direct Transmission', 'Location', 'northwest');
set(gca, 'FontSize', 11);

% Outage Probability vs SNR
subplot(2,1,2);
semilogy(SNR_dB, outage_probability_relay, 'b-o', 'LineWidth', 2, 'MarkerSize', 6);
hold on;
semilogy(SNR_dB, outage_probability_direct, 'r--s', 'LineWidth', 2, 'MarkerSize', 6);
grid on;
xlabel('SNR (dB)', 'FontSize', 12);
ylabel('Outage Probability', 'FontSize', 12);
title(sprintf('Outage Probability vs SNR (Target Rate = %.1f bits/s/Hz)', target_secrecy_rate), 'FontSize', 14);
legend('With Relay (DF)', 'Direct Transmission', 'Location', 'northeast');
set(gca, 'FontSize', 11);

% Save figure
saveas(gcf, 'relay_security_results.png');
fprintf('Results saved to relay_security_results.png\n');

%% Display Summary Statistics
fprintf('\n=== SIMULATION SUMMARY ===\n');
fprintf('Maximum Secrecy Capacity (With Relay): %.3f bits/s/Hz at SNR = %d dB\n', ...
    max(secrecy_capacity_relay), SNR_dB(find(secrecy_capacity_relay == max(secrecy_capacity_relay), 1)));
fprintf('Maximum Secrecy Capacity (Direct): %.3f bits/s/Hz at SNR = %d dB\n', ...
    max(secrecy_capacity_direct), SNR_dB(find(secrecy_capacity_direct == max(secrecy_capacity_direct), 1)));
fprintf('\nImprovement with relay: %.2f%%\n', ...
    ((max(secrecy_capacity_relay) - max(secrecy_capacity_direct)) / max(secrecy_capacity_direct) * 100));
fprintf('==========================\n');
