%% Configuration File for Physical Layer Security Simulations
% Modify these parameters to customize your simulation
% After editing, run the desired simulation script

classdef SimulationConfig
    properties (Constant)
        %% Monte Carlo Parameters
        N_MONTE_FULL = 1000;        % Number of iterations for full simulations
        N_MONTE_QUICK = 100;        % Number of iterations for quick tests
        
        %% SNR Parameters
        SNR_MIN_DB = 0;             % Minimum SNR in dB
        SNR_MAX_DB = 30;            % Maximum SNR in dB
        SNR_STEP_DB = 2;            % SNR step size in dB
        
        %% System Topology (Default Configuration)
        % All distances are normalized
        
        % Distances for basic relay scenario
        DIST_SOURCE_RELAY = 1.0;
        DIST_RELAY_DEST = 1.0;
        DIST_SOURCE_DEST = 2.0;
        DIST_SOURCE_EVE = 1.5;
        DIST_RELAY_EVE = 1.5;
        
        %% Channel Parameters
        PATH_LOSS_EXPONENT = 2.5;   % Typical range: 2 (free space) to 4 (urban)
        
        %% Cooperative Jamming Parameters
        POWER_SPLIT_INFO = 0.7;     % Fraction of power for information (eta)
                                     % Remaining power used for jamming
        
        %% Relay Selection Parameters
        NUM_RELAYS = 4;             % Number of available relays
        
        %% Outage Calculation
        TARGET_SECRECY_RATE = 1.0;  % Target secrecy rate for outage (bits/s/Hz)
        
        %% Visualization Parameters
        FIGURE_WIDTH = 800;
        FIGURE_HEIGHT = 600;
        LINE_WIDTH = 2;
        MARKER_SIZE = 6;
        FONT_SIZE = 11;
    end
    
    methods (Static)
        function config = getConfig()
            % Return all configuration as a struct
            config.N_monte_full = SimulationConfig.N_MONTE_FULL;
            config.N_monte_quick = SimulationConfig.N_MONTE_QUICK;
            config.SNR_min_dB = SimulationConfig.SNR_MIN_DB;
            config.SNR_max_dB = SimulationConfig.SNR_MAX_DB;
            config.SNR_step_dB = SimulationConfig.SNR_STEP_DB;
            config.d_SR = SimulationConfig.DIST_SOURCE_RELAY;
            config.d_RD = SimulationConfig.DIST_RELAY_DEST;
            config.d_SD = SimulationConfig.DIST_SOURCE_DEST;
            config.d_SE = SimulationConfig.DIST_SOURCE_EVE;
            config.d_RE = SimulationConfig.DIST_RELAY_EVE;
            config.alpha = SimulationConfig.PATH_LOSS_EXPONENT;
            config.eta = SimulationConfig.POWER_SPLIT_INFO;
            config.N_relays = SimulationConfig.NUM_RELAYS;
            config.target_rate = SimulationConfig.TARGET_SECRECY_RATE;
        end
        
        function SNR_dB = getSNRRange()
            % Get SNR range array
            SNR_dB = SimulationConfig.SNR_MIN_DB : ...
                     SimulationConfig.SNR_STEP_DB : ...
                     SimulationConfig.SNR_MAX_DB;
        end
        
        function printConfig()
            % Print current configuration
            fprintf('=== SIMULATION CONFIGURATION ===\n');
            fprintf('Monte Carlo iterations: %d (full), %d (quick)\n', ...
                SimulationConfig.N_MONTE_FULL, SimulationConfig.N_MONTE_QUICK);
            fprintf('SNR range: %d to %d dB (step: %d dB)\n', ...
                SimulationConfig.SNR_MIN_DB, SimulationConfig.SNR_MAX_DB, ...
                SimulationConfig.SNR_STEP_DB);
            fprintf('Path loss exponent: %.1f\n', SimulationConfig.PATH_LOSS_EXPONENT);
            fprintf('Power split (eta): %.2f\n', SimulationConfig.POWER_SPLIT_INFO);
            fprintf('Number of relays: %d\n', SimulationConfig.NUM_RELAYS);
            fprintf('================================\n\n');
        end
    end
end
