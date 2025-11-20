%% Optimal Power Allocation for Cooperative Jamming
% This script finds the optimal power allocation factor (eta) that
% maximizes the secrecy capacity in a cooperative jamming system
%
% The power split between information and jamming is optimized
% for given SNR and channel conditions

clear all;
close all;
clc;

%% System Parameters
N_monte = 500;               % Number of Monte Carlo iterations (reduced for optimization)
SNR_dB = 20;                 % Operating SNR in dB
SNR = 10^(SNR_dB/10);        % Convert to linear scale

% Distance parameters (normalized)
d_SR = 1;                    % Distance Source to Relay
d_RD = 1;                    % Distance Relay to Destination
d_SD = 1.8;                  % Distance Source to Destination (direct)
d_SE = 1.2;                  % Distance Source to Eavesdropper
d_RE = 0.8;                  % Distance Relay to Eavesdropper

% Path loss exponent
alpha = 2.5;

% Calculate path loss coefficients
PL_SR = calculate_path_loss(d_SR, alpha);
PL_RD = calculate_path_loss(d_RD, alpha);
PL_SD = calculate_path_loss(d_SD, alpha);
PL_SE = calculate_path_loss(d_SE, alpha);
PL_RE = calculate_path_loss(d_RE, alpha);

%% Test different power allocation factors
eta_range = 0.1:0.05:0.95;   % Power allocation factor range
secrecy_capacity_vs_eta = zeros(length(eta_range), 1);

fprintf('Optimizing Power Allocation for Cooperative Jamming...\n');
fprintf('Operating SNR: %d dB\n', SNR_dB);
fprintf('Number of iterations: %d\n', N_monte);
fprintf('Testing %d different eta values...\n\n', length(eta_range));

%% Optimization Loop
for eta_idx = 1:length(eta_range)
    eta = eta_range(eta_idx);
    fprintf('Testing eta = %.2f... ', eta);
    
    secrecy_sum = 0;
    
    for iter = 1:N_monte
        % Generate Rayleigh fading channel coefficients
        h_SR = generate_rayleigh_channel(PL_SR);
        h_RD = generate_rayleigh_channel(PL_RD);
        h_SD = generate_rayleigh_channel(PL_SD);
        h_SE = generate_rayleigh_channel(PL_SE);
        h_RE = generate_rayleigh_channel(PL_RE);
        
        % Channel gains (squared magnitudes)
        g_SR = abs(h_SR)^2;
        g_RD = abs(h_RD)^2;
        g_SD = abs(h_SD)^2;
        g_SE = abs(h_SE)^2;
        g_RE = abs(h_RE)^2;
        
        % Power allocation
        P_info = eta * SNR;      % Power for information
        P_jam = (1 - eta) * SNR; % Power for jamming
        
        % SINR at destination (coherent combining of direct and relay paths)
        gamma_D = P_info * (g_SD + g_RD);
        
        % SINR at eavesdropper (suffers from jamming)
        gamma_E = (P_info * g_SE) / (1 + P_jam * g_RE);
        
        % Secrecy capacity
        C_D = log2(1 + gamma_D);
        C_E = log2(1 + gamma_E);
        secrecy_rate = max(C_D - C_E, 0);
        
        secrecy_sum = secrecy_sum + secrecy_rate;
    end
    
    % Average secrecy capacity for this eta
    secrecy_capacity_vs_eta(eta_idx) = secrecy_sum / N_monte;
    
    fprintf('Average Secrecy = %.3f bits/s/Hz\n', secrecy_capacity_vs_eta(eta_idx));
end

%% Find Optimal Power Allocation
[max_secrecy, optimal_idx] = max(secrecy_capacity_vs_eta);
optimal_eta = eta_range(optimal_idx);

fprintf('\n=== OPTIMIZATION RESULTS ===\n');
fprintf('Optimal power allocation factor (eta): %.2f\n', optimal_eta);
fprintf('Information power: %.1f%%\n', optimal_eta * 100);
fprintf('Jamming power: %.1f%%\n', (1 - optimal_eta) * 100);
fprintf('Maximum secrecy capacity: %.3f bits/s/Hz\n', max_secrecy);
fprintf('============================\n\n');

%% Plot Results
figure('Position', [100, 100, 800, 600]);

% Main plot: Secrecy Capacity vs Power Allocation
subplot(2,1,1);
plot(eta_range, secrecy_capacity_vs_eta, 'b-', 'LineWidth', 2);
hold on;
plot(optimal_eta, max_secrecy, 'ro', 'MarkerSize', 12, 'LineWidth', 2);
grid on;
xlabel('Power Allocation Factor \eta (Information Power)', 'FontSize', 12);
ylabel('Secrecy Capacity (bits/s/Hz)', 'FontSize', 12);
title(sprintf('Secrecy Capacity vs Power Allocation (SNR = %d dB)', SNR_dB), 'FontSize', 14);
legend('Secrecy Capacity', sprintf('Optimal \\eta = %.2f', optimal_eta), 'Location', 'best');
text(optimal_eta, max_secrecy*0.95, sprintf('  Max: %.3f bits/s/Hz', max_secrecy), ...
    'FontSize', 10, 'Color', 'red');
set(gca, 'FontSize', 11);

% Subplot: Power allocation visualization
subplot(2,1,2);
bar_data = [optimal_eta, 1-optimal_eta];
bar(bar_data, 'FaceColor', [0.3 0.6 0.9]);
set(gca, 'XTickLabel', {'Information Power', 'Jamming Power'});
ylabel('Power Fraction', 'FontSize', 12);
title('Optimal Power Split', 'FontSize', 14);
grid on;
ylim([0 1]);
for i = 1:2
    text(i, bar_data(i) + 0.05, sprintf('%.1f%%', bar_data(i)*100), ...
        'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold');
end
set(gca, 'FontSize', 11);

% Save figure
saveas(gcf, 'power_allocation_optimization.png');
fprintf('Results saved to power_allocation_optimization.png\n');

%% Additional Analysis: Sensitivity to SNR
fprintf('\nAnalyzing sensitivity to SNR...\n');
SNR_test = [10, 15, 20, 25, 30];
optimal_eta_vs_snr = zeros(length(SNR_test), 1);

for snr_test_idx = 1:length(SNR_test)
    current_snr_dB = SNR_test(snr_test_idx);
    current_snr = 10^(current_snr_dB/10);
    
    % Quick search for optimal eta at this SNR
    test_eta = 0.5:0.05:0.9;
    test_secrecy = zeros(length(test_eta), 1);
    
    for test_idx = 1:length(test_eta)
        eta_test = test_eta(test_idx);
        secrecy_sum_test = 0;
        
        for iter = 1:100  % Fewer iterations for quick test
            h_SR = generate_rayleigh_channel(PL_SR);
            h_RD = generate_rayleigh_channel(PL_RD);
            h_SD = generate_rayleigh_channel(PL_SD);
            h_SE = generate_rayleigh_channel(PL_SE);
            h_RE = generate_rayleigh_channel(PL_RE);
            
            g_SR = abs(h_SR)^2;
            g_RD = abs(h_RD)^2;
            g_SD = abs(h_SD)^2;
            g_SE = abs(h_SE)^2;
            g_RE = abs(h_RE)^2;
            
            P_info = eta_test * current_snr;
            P_jam = (1 - eta_test) * current_snr;
            
            gamma_D = P_info * (g_SD + g_RD);
            gamma_E = (P_info * g_SE) / (1 + P_jam * g_RE);
            
            C_D = log2(1 + gamma_D);
            C_E = log2(1 + gamma_E);
            secrecy_sum_test = secrecy_sum_test + max(C_D - C_E, 0);
        end
        
        test_secrecy(test_idx) = secrecy_sum_test / 100;
    end
    
    [~, opt_idx] = max(test_secrecy);
    optimal_eta_vs_snr(snr_test_idx) = test_eta(opt_idx);
    
    fprintf('  SNR = %d dB: Optimal eta = %.2f\n', current_snr_dB, optimal_eta_vs_snr(snr_test_idx));
end

fprintf('\nOptimization complete!\n');
