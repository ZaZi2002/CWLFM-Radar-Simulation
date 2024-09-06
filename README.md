# CWLFM Radar Simulation

This MATLAB project is for Communication Systems course and simulates Continuous Wave Linear Frequency Modulation (CWLFM) radar. The simulation includes generating triangular LFM signals, adding noise, and performing matched filtering. The results are visualized through various plots showing different stages of the signal processing.

## Project Structure

1. **Generating LFM Signal**
   - Creates a one-period triangular LFM signal.
   - Plots the real and imaginary parts of the generated signal.

2. **Periodic Triangular LFM**
   - Generates a periodic triangular LFM signal for FMCW radar.
   - Visualizes the real and imaginary parts of the continuous triangular LFM.

3. **White Noise Addition**
   - Adds white noise to the generated signal.
   - Plots the white noise for visualization.

4. **Received Signal Simulation**
   - Simulates received signals with different Doppler shifts and noise levels.
   - Plots the real and imaginary parts of the received signals.

5. **Matched Filtering**
   - Applies matched filtering to the received signals.
   - Compares filtered signals with different target scenarios.

6. **Output SNR Calculation**
   - Calculates and displays the Signal-to-Noise Ratio (SNR) of the filtered signals.

## How to Run

1. Ensure you have MATLAB installed on your system.
2. Download or clone this repository.
3. Open MATLAB and navigate to the project directory.
4. Run the script `CWLFM_Radar_Simulation.m` to execute the simulation.

## Dependencies

- MATLAB R2018b or later.
