# Physical Layer Security with Relay Systems

This repository contains MATLAB implementations for simulating physical layer security in wireless communication systems with relay nodes. The code demonstrates various relay-assisted secure transmission techniques commonly studied in physical layer security research.

## Overview

Physical layer security is a technique to secure wireless communications by exploiting the physical characteristics of wireless channels. This implementation focuses on relay-assisted systems where a relay node helps improve the secrecy capacity between a source (Alice) and destination (Bob) in the presence of an eavesdropper (Eve).

## System Model

The system consists of:
- **Source (Alice)**: The transmitter sending confidential information
- **Relay**: An intermediate node helping the transmission
- **Destination (Bob)**: The legitimate receiver
- **Eavesdropper (Eve)**: An adversary trying to intercept the communication

## Features

### 1. Basic Relay Security (`relay_security_simulation.m`)
- Implements Decode-and-Forward (DF) relay protocol
- Compares relay-assisted transmission with direct transmission
- Calculates secrecy capacity and outage probability
- Considers Rayleigh fading channels with path loss

### 2. Cooperative Jamming (`cooperative_jamming_simulation.m`)
- Implements relay-based cooperative jamming
- Power allocation between information and jamming signals
- Demonstrates how jamming can improve secrecy against eavesdroppers
- Compares performance with and without jamming

### 3. Utility Functions
- `calculate_secrecy_rate.m`: Computes secrecy rate from channel gains
- `generate_rayleigh_channel.m`: Generates Rayleigh fading channel coefficients
- `calculate_path_loss.m`: Calculates path loss based on distance

## Requirements

- MATLAB R2016b or later
- No additional toolboxes required (uses base MATLAB functions)

## Usage

### Running the Basic Relay Simulation

```matlab
% Run the main relay security simulation
relay_security_simulation
```

This will:
1. Simulate a relay-assisted secure communication system
2. Compare with direct transmission (no relay)
3. Generate plots of secrecy capacity and outage probability vs SNR
4. Save results as `relay_security_results.png`

### Running the Cooperative Jamming Simulation

```matlab
% Run the cooperative jamming simulation
cooperative_jamming_simulation
```

This will:
1. Simulate cooperative jamming strategy
2. Compare with non-jamming approach
3. Generate plot of secrecy capacity vs SNR
4. Save results as `cooperative_jamming_results.png`

## Key Parameters

You can modify these parameters in the simulation scripts:

- `N_monte`: Number of Monte Carlo iterations (default: 1000)
- `SNR_dB`: SNR range in dB (default: 0:2:30)
- `alpha`: Path loss exponent (default: 2 or 2.5)
- `d_SR, d_RD, d_SD, d_SE, d_RE`: Normalized distances between nodes
- `eta`: Power allocation factor for cooperative jamming (default: 0.7)

## Output

The simulations generate:
1. **Console output**: Progress updates and summary statistics
2. **Figures**: Plots showing:
   - Secrecy capacity vs SNR
   - Outage probability vs SNR (for basic relay)
   - Comparison between different strategies
3. **PNG files**: Saved plots for documentation

## Performance Metrics

### Secrecy Capacity
The achievable rate for secure communication:
```
C_s = max(C_main - C_eavesdropper, 0)
```

### Outage Probability
Probability that secrecy rate falls below a target threshold:
```
P_out = Pr(C_s < R_target)
```

## Example Results

Typical observations:
- Relay-assisted transmission provides higher secrecy capacity compared to direct transmission
- Cooperative jamming can further enhance security by degrading eavesdropper's channel
- Performance improves with increasing SNR
- Optimal power allocation depends on channel conditions and node positions

## Theory Background

### Decode-and-Forward (DF) Relay
The relay decodes the source message and forwards it to the destination. The end-to-end rate is limited by the weaker of the two hops:
```
C_relay = min(C_SR, C_RD)
```

### Cooperative Jamming
The relay transmits jamming signals to confuse the eavesdropper while the destination can cancel or mitigate the jamming effect using side information.

## Customization

To adapt the code for your research:

1. **Change channel model**: Modify channel generation in the main loop
2. **Add relay selection**: Implement multiple relays and selection criteria
3. **Different protocols**: Implement Amplify-and-Forward (AF) or other protocols
4. **Optimize power allocation**: Add optimization for the power split parameter `eta`
5. **Add imperfect CSI**: Introduce channel estimation errors

## References

This implementation is based on common approaches in physical layer security research:
- Wyner, A. D. (1975). "The wire-tap channel"
- Bloch, M., & Barros, J. (2011). "Physical-Layer Security"
- Various IEEE papers on relay-assisted physical layer security

## Contributing

Feel free to extend this code for your research. Possible extensions:
- Multiple relay selection algorithms
- Different relay protocols (AF, CF)
- Imperfect channel state information
- Multiple antenna systems (MIMO)
- Energy harvesting relays

## License

This code is provided for educational and research purposes.

## Contact

For questions or suggestions, please open an issue on GitHub.
