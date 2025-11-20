%% Physical Layer Security with Optimal Relay Selection
% This script simulates a secure communication system with multiple relays
% The best relay is selected based on instantaneous channel conditions
%
% System Model:
% - Source (Alice) can use one of N relays to communicate with Destination (Bob)
% - Relay selection based on maximizing secrecy capacity
% - Eavesdropper (Eve) tries to intercept the communication

clear all;
close all;
clc;

%% System Parameters
N_monte = 1000;              % Number of Monte Carlo iterations
SNR_dB = 0:2:30;             % SNR range in dB
SNR_linear = 10.^(SNR_dB/10); % Convert to linear scale
N_relays = 4;                % Number of available relays

% Distance parameters (normalized)
d_SD = 2.0;                  % Distance Source to Destination (direct)
d_SE = 1.3;                  % Distance Source to Eavesdropper

% Relay positions (randomly placed between source and destination)
d_SR = 0.8 + 0.4*rand(N_relays, 1);  % Distance Source to Relays
d_RD = 0.8 + 0.4*rand(N_relays, 1);  % Distance Relay to Destination
d_RE = 0.7 + 0.8*rand(N_relays, 1);  % Distance Relay to Eavesdropper

% Path loss exponent
alpha = 2.5;

% Calculate path loss coefficients
PL_SD = calculate_path_loss(d_SD, alpha);
PL_SE = calculate_path_loss(d_SE, alpha);
PL_SR = zeros(N_relays, 1);
PL_RD = zeros(N_relays, 1);
PL_RE = zeros(N_relays, 1);

for i = 1:N_relays
    PL_SR(i) = calculate_path_loss(d_SR(i), alpha);
    PL_RD(i) = calculate_path_loss(d_RD(i), alpha);
    PL_RE(i) = calculate_path_loss(d_RE(i), alpha);
end

%% Initialize result arrays
secrecy_capacity_best_relay = zeros(length(SNR_dB), 1);
secrecy_capacity_random_relay = zeros(length(SNR_dB), 1);
secrecy_capacity_direct = zeros(length(SNR_dB), 1);

relay_selection_count = zeros(N_relays, 1);

%% Monte Carlo Simulation
fprintf('Starting Multi-Relay Selection Simulation...\n');
fprintf('Number of relays: %d\n', N_relays);
fprintf('Number of iterations: %d\n', N_monte);
fprintf('SNR range: %d to %d dB\n\n', SNR_dB(1), SNR_dB(end));

for snr_idx = 1:length(SNR_dB)
    fprintf('Processing SNR = %d dB... ', SNR_dB(snr_idx));
    
    secrecy_sum_best = 0;
    secrecy_sum_random = 0;
    secrecy_sum_direct = 0;
    
    for iter = 1:N_monte
        % Generate channel coefficients for direct links
        h_SD = generate_rayleigh_channel(PL_SD);
        h_SE = generate_rayleigh_channel(PL_SE);
        
        g_SD = abs(h_SD)^2;
        g_SE = abs(h_SE)^2;
        
        % Generate channel coefficients for all relays
        g_SR = zeros(N_relays, 1);
        g_RD = zeros(N_relays, 1);
        g_RE = zeros(N_relays, 1);
        secrecy_rate_per_relay = zeros(N_relays, 1);
        
        for relay_idx = 1:N_relays
            h_SR = generate_rayleigh_channel(PL_SR(relay_idx));
            h_RD = generate_rayleigh_channel(PL_RD(relay_idx));
            h_RE = generate_rayleigh_channel(PL_RE(relay_idx));
            
            g_SR(relay_idx) = abs(h_SR)^2;
            g_RD(relay_idx) = abs(h_RD)^2;
            g_RE(relay_idx) = abs(h_RE)^2;
            
            % Calculate secrecy rate for this relay (DF protocol)
            P = SNR_linear(snr_idx);
            
            % End-to-end capacity via this relay
            C_SR = log2(1 + P * g_SR(relay_idx));
            C_RD = log2(1 + P * g_RD(relay_idx));
            C_relay = min(C_SR, C_RD);
            
            % Eavesdropper capacity (best of direct and relay path)
            C_SE = log2(1 + P * g_SE);
            C_RE = log2(1 + P * g_RE(relay_idx));
            C_Eve = max(C_SE, C_RE);
            
            % Secrecy rate via this relay
            secrecy_rate_per_relay(relay_idx) = max(C_relay - C_Eve, 0);
        end
        
        %% Best Relay Selection (optimal)
        [max_secrecy, best_relay_idx] = max(secrecy_rate_per_relay);
        secrecy_sum_best = secrecy_sum_best + max_secrecy;
        relay_selection_count(best_relay_idx) = relay_selection_count(best_relay_idx) + 1;
        
        %% Random Relay Selection
        random_relay_idx = randi(N_relays);
        secrecy_sum_random = secrecy_sum_random + secrecy_rate_per_relay(random_relay_idx);
        
        %% Direct Transmission (no relay)
        P = SNR_linear(snr_idx);
        C_SD_direct = log2(1 + P * g_SD);
        C_Eve_direct = log2(1 + P * g_SE);
        secrecy_rate_direct = max(C_SD_direct - C_Eve_direct, 0);
        secrecy_sum_direct = secrecy_sum_direct + secrecy_rate_direct;
    end
    
    % Average results
    secrecy_capacity_best_relay(snr_idx) = secrecy_sum_best / N_monte;
    secrecy_capacity_random_relay(snr_idx) = secrecy_sum_random / N_monte;
    secrecy_capacity_direct(snr_idx) = secrecy_sum_direct / N_monte;
    
    fprintf('Done.\n');
end

fprintf('\nSimulation completed successfully!\n\n');

%% Plot Results
figure('Position', [100, 100, 1000, 500]);

% Subplot 1: Secrecy Capacity
subplot(1,2,1);
plot(SNR_dB, secrecy_capacity_best_relay, 'b-o', 'LineWidth', 2, 'MarkerSize', 6);
hold on;
plot(SNR_dB, secrecy_capacity_random_relay, 'g--d', 'LineWidth', 2, 'MarkerSize', 6);
plot(SNR_dB, secrecy_capacity_direct, 'r--s', 'LineWidth', 2, 'MarkerSize', 6);
grid on;
xlabel('SNR (dB)', 'FontSize', 12);
ylabel('Secrecy Capacity (bits/s/Hz)', 'FontSize', 12);
title('Secrecy Capacity: Relay Selection Strategies', 'FontSize', 14);
legend('Best Relay Selection', 'Random Relay Selection', 'Direct (No Relay)', ...
    'Location', 'northwest');
set(gca, 'FontSize', 11);

% Subplot 2: Relay Selection Distribution
subplot(1,2,2);
bar(1:N_relays, relay_selection_count / sum(relay_selection_count));
grid on;
xlabel('Relay Index', 'FontSize', 12);
ylabel('Selection Probability', 'FontSize', 12);
title('Relay Selection Distribution', 'FontSize', 14);
set(gca, 'FontSize', 11);
xlim([0.5, N_relays+0.5]);

% Save figure
saveas(gcf, 'relay_selection_results.png');
fprintf('Results saved to relay_selection_results.png\n');

%% Display Summary Statistics
fprintf('\n=== SIMULATION SUMMARY ===\n');
fprintf('Number of relays: %d\n', N_relays);
fprintf('\nMaximum Secrecy Capacity (Best Relay): %.3f bits/s/Hz at SNR = %d dB\n', ...
    max(secrecy_capacity_best_relay), SNR_dB(find(secrecy_capacity_best_relay == max(secrecy_capacity_best_relay), 1)));
fprintf('Maximum Secrecy Capacity (Random Relay): %.3f bits/s/Hz at SNR = %d dB\n', ...
    max(secrecy_capacity_random_relay), SNR_dB(find(secrecy_capacity_random_relay == max(secrecy_capacity_random_relay), 1)));
fprintf('Maximum Secrecy Capacity (Direct): %.3f bits/s/Hz at SNR = %d dB\n', ...
    max(secrecy_capacity_direct), SNR_dB(find(secrecy_capacity_direct == max(secrecy_capacity_direct), 1)));

fprintf('\nRelay Selection Statistics:\n');
for i = 1:N_relays
    fprintf('  Relay %d: %.1f%% (d_SR=%.2f, d_RD=%.2f, d_RE=%.2f)\n', ...
        i, 100*relay_selection_count(i)/sum(relay_selection_count), ...
        d_SR(i), d_RD(i), d_RE(i));
end
fprintf('==========================\n');
