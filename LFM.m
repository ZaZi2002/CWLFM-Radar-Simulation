%%%%%%%%%%% LINEAR FREQUENCY MODULATION CWRADAR
close all
clear all
clc
%% Generating main LFM period
t1 = 2;     % every chirp time period
fs = 100;     % sampling frequency
t = 0:1/fs:2*t1;     % time domain              
fo = 5;     % sweep bandwidth
fc = 6;
y1 = chirp(t,fc-fo,2*t1,fc+3*fo,'complex');     % accending chirp
y1 = y1 .* (heaviside(t) - heaviside(t-t1));
y2 = chirp(t,fc+3*fo,2*t1,fc-fo,'complex');     % decending chirp  
y2 = y2 .* (heaviside(t-t1) - heaviside(t-t1*2));
y = y1 + y2;     % creating triangular chirp

% plotting
figure(2);
subplot(2,1,1)
plot(t,real(y))
axis tight
grid on
title('Real Part of a one period triangular LFM')
subplot(2,1,2)
plot(t,imag(y))
xlabel('Time (s)')
title('Imaginary Part of a one period triangular LFM')
axis tight
grid on

%% Generating periodic triangular LFM
N = 3;     % number of periodes repeated
t = 0:1/fs:2*N*t1 + (N-1)/fs;     % new time domain  
signal_transform = repmat(y,1,N);     % periodic triangular LFM for FMCW radar

% plotting
figure(3);
subplot(2,1,1)
plot(t,real(signal_transform))
axis tight
grid on
title('Real Part of continuous triangular LFM')
subplot(2,1,2)
plot(t,imag(signal_transform))
xlabel('Time (s)')
title('Imaginary Part of continuous triangular LFM')
axis tight
grid on

%% Generating white noise
% finding power of the signal and SNR
SNR_input = 10;     % input desired SNR
power_noise = 1;     % noise power
power_input_signal = SNR_input*power_noise;     % finding power of raw signal
A = (power_input_signal/mean(abs(signal_transform).^2))^0.5;     % finding aplitude
signal_transform = A*signal_transform;

% creating noise
t = 0:1/fs:2*N*t1 + (N-1)/fs;     % new time domain
t_size = size(t);
numberOfSamples = t_size(2);
noise = wgn(numberOfSamples,1,power_noise);
noise = transpose(noise);

% plotting
figure(4);
plot(t,noise);
axis tight
title('White noise')
grid on

%% Generating recived signal
B = 0.5;    % waste of power amplitude
% found signals
signal_recived_found = B*signal_transform + noise;
t_shift1 = 1*fs;     % time shift of the first recived signal
signal_recived_found_1 = circshift(signal_recived_found,t_shift1); % recived signal which is not moving

t_shift2 = 1.5 *fs;     % time shift of the first recived signal
fd = 0.02;     % dopler frequency
signal_recived_found_2 = circshift(signal_recived_found,t_shift2); % recived signal which is getting close
signal_recived_found_2 = signal_recived_found_2.*exp(2.*pi.*fd.*t);  % frequency shift 

t_shift3 = 0.7 *fs;     % time shift of the first recived signal
fd = 0.01;     % dopler frequency
signal_recived_found_3 = circshift(signal_recived_found,t_shift3); % recived signal which is getting far
signal_recived_found_3 = signal_recived_found_3.*exp(2.*pi.*fd.*t); % frequency shift 

% not found signals 
signal_recived_notfound = noise;     % when there is not anything recived signal is just noise

% plotting
t = 0:1/fs:2*(N)*t1 + (N-1)/fs; 
figure(5);
subplot(2,1,1)
plot(t,real(signal_recived_found_1))
axis tight
grid on
title('Real Part of recived signal num1')
subplot(2,1,2)
plot(t,imag(signal_recived_found_1))
xlabel('Time (s)')
title('Imaginary Part of recived signal num1')
axis tight
grid on

%% Matched filter
filtered_signal = conv(signal_recived_found,y);
filtered_signal_1 = conv(signal_recived_found_1,y);
filtered_signal_2 = conv(signal_recived_found_2,y);
filtered_signal_3 = conv(signal_recived_found_3,y);

% plotting one filtered signal
t = 0:1/fs:2*(N+1)*t1 + (N-1)/fs; 
figure(6);
subplot(2,1,1)
plot(t,real(filtered_signal))
xlabel('Time (s)')
axis tight
grid on
title('Real Part of filtered signal')
subplot(2,1,2)
plot(t,imag(filtered_signal))
xlabel('Time (s)')
title('Imaginary Part of filtered signal')
axis tight
grid on

% plotting filtered signal with no target
t = 0:1/fs:2*(N)*t1 + (N-1)/fs; 
figure(7);
subplot(2,1,1)
plot(t,real(signal_recived_notfound))
xlabel('Time (s)')
axis tight
grid on
title('Real Part of no target signal')
subplot(2,1,2)
plot(t,imag(signal_recived_notfound))
xlabel('Time (s)')
title('Imaginary Part of no target signal')
axis tight
grid on

% plotting all filtered signals in order to compare
t = 0:1/fs:2*(N+1)*t1 + (N-1)/fs; 
figure(8);
subplot(4,2,1)
plot(t,real(filtered_signal))
axis tight
grid on
title('Real Part of no t/f shift recived signal')
xlabel('Time (s)')
subplot(4,2,2)
plot(t,imag(filtered_signal))
xlabel('Time (s)')
title('Imaginary Part of no t/f shift recived signal')
axis tight
grid on
subplot(4,2,3)
plot(t,real(filtered_signal_1))
xlabel('Time (s)')
title('Real Part of stationaray target')
axis tight
grid on
subplot(4,2,4)
plot(t,imag(filtered_signal_1))
xlabel('Time (s)')
title('Imaginary Part of stationaray target')
axis tight
grid on
subplot(4,2,5)
plot(t,real(filtered_signal_2))
xlabel('Time (s)')
axis tight
grid on
title('Real Part of getting close target')
subplot(4,2,6)
plot(t,imag(filtered_signal_2))
xlabel('Time (s)')
title('Imaginary Part of getting close target')
axis tight
grid on
subplot(4,2,7)
plot(t,real(filtered_signal_3))
xlabel('Time (s)')
title('Real Part of getting far target')
axis tight
grid on
subplot(4,2,8)
plot(t,imag(filtered_signal_3))
xlabel('Time (s)')
title('Imaginary Part of getting far target')
axis tight
grid on

%% Output SNR
SNR_output = 10*log10(mean(abs(filtered_signal).^2) / power_noise)
SNR_output_1 = 10*log10(mean(abs(filtered_signal_1).^2) / power_noise)
SNR_output_2 = 10*log10(mean(abs(filtered_signal_2).^2) / power_noise)
SNR_output_3 = 10*log10(mean(abs(filtered_signal_3).^2) / power_noise)

