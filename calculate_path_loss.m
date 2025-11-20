function [PL] = calculate_path_loss(distance, alpha)
% CALCULATE_PATH_LOSS Calculate path loss based on distance
%
% Inputs:
%   distance - Distance between transmitter and receiver (normalized)
%   alpha    - Path loss exponent (typically 2-4)
%
% Output:
%   PL - Path loss coefficient
%
% Path loss model:
%   PL = distance^(-alpha)

    if distance <= 0
        error('Distance must be positive');
    end
    
    if alpha < 0
        error('Path loss exponent must be non-negative');
    end
    
    PL = distance^(-alpha);
end
