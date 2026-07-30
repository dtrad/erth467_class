% Data Auto-Cross Correlation
% This script performs auto-correlation on a dataset
% Create a synthetic dataset for demonstration
close all; clear; clc;

data = randn(1000, 1);
% Compute the auto-correlation
[acor, lag] = xcorr(data, 'coeff');
% Plot the results
figure;
plot(lag, acor);
title('Auto-Correlation of Synthetic Data');
xlabel('Lag');
ylabel('Correlation Coefficient');

%% create a reflectivity series with a few spikes and calculate its autocorrelation
data = zeros(1000, 1);
data(100) = 1;   % spike at index 100
data(300) = -1;  % spike at index 300
data(700) = 0.5; % spike at index 700
[acor, lag] = xcorr(data, 'coeff');
dt=0.004;
t= 1:length(data);
t = t * dt; % Convert to time vector
figure;
subplot(2,1,1);
plot(t,data);
title('Reflectivity Series');
xlabel('Sample Index');
ylabel('Amplitude');
subplot(2,1,2);
plot(lag, acor);
title('Auto-Correlation of Reflectivity Series');
xlabel('Lag');
ylabel('Correlation Coefficient');  

%% create a Ricker wavelet and calculate its autocorrelation    
f = 5; % frequency of the Ricker wavelet
ricker_wavelet = (1 - 2 * (pi * f * (t - 0.5)).^2) .* exp(-(pi * f * (t - 0.5)).^2);
[acor, lag] = xcorr(ricker_wavelet, 'coeff');   
figure;
subplot(2,1,1);
plot(t, ricker_wavelet);
title('Ricker Wavelet');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(2,1,2);
plot(lag, acor);
title('Auto-Correlation of Ricker Wavelet');
xlabel('Lag');
ylabel('Correlation Coefficient');      

%% convolution of the reflectivity series with the Ricker wavelet
conv_result = conv(data, ricker_wavelet, 'full');
conv_result = conv_result(1:length(data)); % match length of original data
figure;
subplot(2,1,1);
plot(t, conv_result);
title('Convolution of Reflectivity Series with Ricker Wavelet');
xlabel('Time (s)');
ylabel('Amplitude');
% calculate the auto-correlation of the convolution result
[acor_conv, lag_conv] = xcorr(conv_result, 'coeff');

% Plot the auto-correlation of the convolution result
subplot(2,1,2);
plot(lag_conv, acor_conv);

%% Extract the central part of the auto-correlation usign a rect window
window_size = 100; % size of the rectangular window
half_window = floor(window_size / 2);
central_acor = acor_conv(length(acor_conv)/2 - half_window : length(acor_conv)/2 + half_window);
central_lag = lag_conv(length(acor_conv)/2 - half_window : length(acor_conv)/2 + half_window);
figure;
subplot(2,1,1);
title('Auto-Correlation of Convolution Result');
xlabel('Lag');
ylabel('Correlation Coefficient');
hold on;
plot(central_lag, central_acor, 'r', 'LineWidth', 2);
legend('Full Auto-Correlation', 'Central Part');        

% Compare with the auto-correlation of the wavelet
[acor_wavelet, lag_wavelet] = xcorr(ricker_wavelet, 'coeff');
subplot(2,1,2);
plot(lag_wavelet, acor_wavelet);
title('Auto-Correlation of Ricker Wavelet');
xlabel('Lag');
ylabel('Correlation Coefficient');
hold on;
plot(central_lag, central_acor, 'r', 'LineWidth', 2);
legend('Wavelet Auto-Correlation', 'Central Part of Convolution Auto-Correlation'); 

% Repeat using a Hamming window
hamming_window = hamming(window_size);
central_acor_hamming = acor_conv(length(acor_conv)/2 - half_window : length(acor_conv)/2 + half_window) .* hamming_window;
figure;
subplot(2,1,1);
plot(central_lag, central_acor_hamming, 'b', 'LineWidth', 2);
title('Auto-Correlation of Convolution Result with Hamming Window');
xlabel('Lag');
ylabel('Correlation Coefficient');
hold on;
plot(central_lag, central_acor, 'r', 'LineWidth', 2);
legend('Hamming Windowed Auto-Correlation', 'Central Part');        
subplot(2,1,2);
plot(lag_wavelet, acor_wavelet);
title('Auto-Correlation of Ricker Wavelet');
xlabel('Lag');
ylabel('Correlation Coefficient');
hold on;
plot(central_lag, central_acor, 'r', 'LineWidth', 2);
legend('Wavelet Auto-Correlation', 'Central Part of Convolution Auto-Correlation'); 

% plot the central part of the auto-correlation of the wavelet to match the extracted autocorrelation
central_acor_wavelet = acor_wavelet(length(acor_wavelet)/2 - half_window : length(acor_wavelet)/2 + half_window);
central_lag_wavelet = lag_wavelet(length(acor_wavelet)/2 - half_window : length(acor_wavelet)/2 + half_window);
figure;
subplot(2,1,1);
plot(central_lag_wavelet, central_acor_wavelet, 'g', 'LineWidth', 2);
title('Central Part of Wavelet Auto-Correlation');
xlabel('Lag');
ylabel('Correlation Coefficient');
hold on;
plot(central_lag, central_acor, 'r', 'LineWidth', 2);
legend('Central Wavelet Auto-Correlation', 'Central Part of Convolution Auto-Correlation');
subplot(2,1,2);
plot(central_lag, central_acor_hamming, 'b', 'LineWidth', 2);
title('Central Part of Hamming Windowed Auto-Correlation');
xlabel('Lag');
ylabel('Correlation Coefficient');
hold on;
plot(central_lag, central_acor, 'r', 'LineWidth', 2);
legend('Hamming Windowed Central Auto-Correlation', 'Central Part of Convolution Auto-Correlation');    