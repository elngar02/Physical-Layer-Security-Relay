%% Quick Example - Physical Layer Security with Relay
% This is a simple example to demonstrate the basic concepts
% Run this first to understand how the system works

clear all;
close all;
clc;

fprintf('========================================\n');
fprintf('Physical Layer Security - Quick Example\n');
fprintf('========================================\n\n');

%% Simple Scenario Setup
fprintf('Setting up a simple scenario...\n');
fprintf('- Source (Alice) wants to send secure data to Destination (Bob)\n');
fprintf('- A Relay helps improve the communication\n');
fprintf('- An Eavesdropper (Eve) tries to intercept\n\n');

% Single SNR point for demonstration
SNR_dB = 20;
SNR = 10^(SNR_dB/10);
fprintf('Operating at SNR = %d dB\n\n', SNR_dB);

% System setup
alpha = 2;  % Path loss exponent

% Distances (normalized)
d_SR = 1.0;   % Source to Relay
d_RD = 1.0;   % Relay to Destination  
d_SD = 2.0;   % Source to Destination (direct)
d_SE = 1.5;   % Source to Eavesdropper
d_RE = 1.5;   % Relay to Eavesdropper

fprintf('Distance configuration:\n');
fprintf('  Source -> Relay: %.1f\n', d_SR);
fprintf('  Relay -> Destination: %.1f\n', d_RD);
fprintf('  Source -> Destination (direct): %.1f\n', d_SD);
fprintf('  Source -> Eavesdropper: %.1f\n', d_SE);
fprintf('  Relay -> Eavesdropper: %.1f\n\n', d_RE);

% Calculate path losses
PL_SR = calculate_path_loss(d_SR, alpha);
PL_RD = calculate_path_loss(d_RD, alpha);
PL_SD = calculate_path_loss(d_SD, alpha);
PL_SE = calculate_path_loss(d_SE, alpha);
PL_RE = calculate_path_loss(d_RE, alpha);

%% Single Channel Realization
fprintf('Generating random channel realizations...\n');

% Generate Rayleigh fading channels
h_SR = generate_rayleigh_channel(PL_SR);
h_RD = generate_rayleigh_channel(PL_RD);
h_SD = generate_rayleigh_channel(PL_SD);
h_SE = generate_rayleigh_channel(PL_SE);
h_RE = generate_rayleigh_channel(PL_RE);

% Channel gains
g_SR = abs(h_SR)^2;
g_RD = abs(h_RD)^2;
g_SD = abs(h_SD)^2;
g_SE = abs(h_SE)^2;
g_RE = abs(h_RE)^2;

fprintf('\nChannel gains (|h|^2):\n');
fprintf('  g_SR = %.4f\n', g_SR);
fprintf('  g_RD = %.4f\n', g_RD);
fprintf('  g_SD = %.4f\n', g_SD);
fprintf('  g_SE = %.4f\n', g_SE);
fprintf('  g_RE = %.4f\n\n', g_RE);

%% Calculate Capacities - Direct Transmission
fprintf('=== Direct Transmission (no relay) ===\n');

C_Bob_direct = log2(1 + SNR * g_SD);
C_Eve_direct = log2(1 + SNR * g_SE);
C_secrecy_direct = max(C_Bob_direct - C_Eve_direct, 0);

fprintf('Capacity at Bob: %.3f bits/s/Hz\n', C_Bob_direct);
fprintf('Capacity at Eve: %.3f bits/s/Hz\n', C_Eve_direct);
fprintf('Secrecy Capacity: %.3f bits/s/Hz\n\n', C_secrecy_direct);

%% Calculate Capacities - Relay-Assisted Transmission
fprintf('=== Relay-Assisted Transmission (DF) ===\n');

% Capacity from Source to Relay
C_SR = log2(1 + SNR * g_SR);
fprintf('Source -> Relay capacity: %.3f bits/s/Hz\n', C_SR);

% Capacity from Relay to Destination
C_RD = log2(1 + SNR * g_RD);
fprintf('Relay -> Destination capacity: %.3f bits/s/Hz\n', C_RD);

% End-to-end capacity (limited by weakest link in DF)
C_Bob_relay = min(C_SR, C_RD);
fprintf('End-to-end capacity: %.3f bits/s/Hz\n', C_Bob_relay);

% Eavesdropper can listen to both hops (take the best)
C_SE = log2(1 + SNR * g_SE);
C_RE = log2(1 + SNR * g_RE);
C_Eve_relay = max(C_SE, C_RE);
fprintf('Eavesdropper capacity (best hop): %.3f bits/s/Hz\n', C_Eve_relay);

% Secrecy capacity
C_secrecy_relay = max(C_Bob_relay - C_Eve_relay, 0);
fprintf('Secrecy Capacity: %.3f bits/s/Hz\n\n', C_secrecy_relay);

%% Comparison
fprintf('=== COMPARISON ===\n');
fprintf('Direct transmission secrecy: %.3f bits/s/Hz\n', C_secrecy_direct);
fprintf('Relay-assisted secrecy: %.3f bits/s/Hz\n', C_secrecy_relay);

if C_secrecy_relay > C_secrecy_direct
    improvement = ((C_secrecy_relay - C_secrecy_direct) / C_secrecy_direct) * 100;
    fprintf('\nRelay provides %.1f%% improvement! ✓\n', improvement);
else
    fprintf('\nDirect transmission is better in this realization.\n');
    fprintf('Note: This can happen due to random fading.\n');
end

fprintf('\n========================================\n');
fprintf('To run full simulations with multiple iterations:\n');
fprintf('  >> relay_security_simulation\n');
fprintf('  >> cooperative_jamming_simulation\n');
fprintf('  >> relay_selection_simulation\n');
fprintf('========================================\n');
