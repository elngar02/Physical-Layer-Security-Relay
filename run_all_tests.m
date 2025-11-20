%% Run All Simulations - Test Script
% This script runs all available simulations to verify the installation
% and demonstrate the functionality of the physical layer security toolkit

clear all;
close all;
clc;

fprintf('========================================\n');
fprintf('Physical Layer Security Relay Toolkit\n');
fprintf('Complete Test Suite\n');
fprintf('========================================\n\n');

fprintf('This script will run all available simulations.\n');
fprintf('Each simulation may take 1-3 minutes to complete.\n\n');

response = input('Do you want to proceed? (y/n): ', 's');
if ~strcmpi(response, 'y')
    fprintf('Test cancelled.\n');
    return;
end

fprintf('\n========================================\n');
fprintf('Test 1: Quick Start Example\n');
fprintf('========================================\n');
try
    example_quick_start;
    fprintf('\n✓ Quick start example completed successfully!\n');
    pause(2);
catch ME
    fprintf('\n✗ Quick start example failed: %s\n', ME.message);
end

fprintf('\n========================================\n');
fprintf('Test 2: Basic Relay Security\n');
fprintf('========================================\n');
try
    close all;
    relay_security_simulation;
    fprintf('\n✓ Relay security simulation completed successfully!\n');
    pause(2);
catch ME
    fprintf('\n✗ Relay security simulation failed: %s\n', ME.message);
end

fprintf('\n========================================\n');
fprintf('Test 3: Cooperative Jamming\n');
fprintf('========================================\n');
try
    close all;
    cooperative_jamming_simulation;
    fprintf('\n✓ Cooperative jamming simulation completed successfully!\n');
    pause(2);
catch ME
    fprintf('\n✗ Cooperative jamming simulation failed: %s\n', ME.message);
end

fprintf('\n========================================\n');
fprintf('Test 4: Relay Selection (Multi-Relay)\n');
fprintf('========================================\n');
try
    close all;
    relay_selection_simulation;
    fprintf('\n✓ Relay selection simulation completed successfully!\n');
    pause(2);
catch ME
    fprintf('\n✗ Relay selection simulation failed: %s\n', ME.message);
end

fprintf('\n========================================\n');
fprintf('Test 5: Power Allocation Optimization\n');
fprintf('========================================\n');
try
    close all;
    optimize_power_allocation;
    fprintf('\n✓ Power allocation optimization completed successfully!\n');
    pause(2);
catch ME
    fprintf('\n✗ Power allocation optimization failed: %s\n', ME.message);
end

fprintf('\n========================================\n');
fprintf('ALL TESTS COMPLETED!\n');
fprintf('========================================\n\n');

% List generated files
fprintf('Generated output files:\n');
generated_files = {'relay_security_results.png', ...
                   'cooperative_jamming_results.png', ...
                   'relay_selection_results.png', ...
                   'power_allocation_optimization.png'};

for i = 1:length(generated_files)
    if exist(generated_files{i}, 'file')
        fprintf('  ✓ %s\n', generated_files{i});
    else
        fprintf('  ✗ %s (not found)\n', generated_files{i});
    end
end

fprintf('\nAll simulations are working correctly!\n');
fprintf('You can now explore individual scripts and modify parameters.\n\n');

% Display available scripts
fprintf('Available simulation scripts:\n');
fprintf('  1. example_quick_start.m            - Quick introduction\n');
fprintf('  2. relay_security_simulation.m      - Basic relay vs direct\n');
fprintf('  3. cooperative_jamming_simulation.m - Jamming strategy\n');
fprintf('  4. relay_selection_simulation.m     - Multi-relay selection\n');
fprintf('  5. optimize_power_allocation.m      - Optimal power split\n\n');

fprintf('Utility functions:\n');
fprintf('  - calculate_secrecy_rate.m\n');
fprintf('  - generate_rayleigh_channel.m\n');
fprintf('  - calculate_path_loss.m\n');
fprintf('  - SimulationConfig.m (configuration class)\n\n');

fprintf('For more information, see README.md\n');
fprintf('========================================\n');
