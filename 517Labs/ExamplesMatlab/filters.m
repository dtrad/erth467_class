clc; clear;
close all;
% Generate white noise input
N = 1000;
x = randn(N,1);

%% 🔷 FIR Filter (MA model)
b_fir = [1 0.5 0.25];  % FIR coefficients (feedforward)
a_fir = 1;             % No feedback

y_fir = filter(b_fir, a_fir, x);

% Time-domain plot
subplot(2,2,1);
plot(y_fir);
title('FIR Output (MA Model)');
xlabel('Time'); ylabel('Amplitude');

% Pole-zero plot
myaxis = [-1.1 1.1 -1.1 1.1];
subplot(2,2,2);
zplane(b_fir, a_fir);
title('FIR Filter: Z-plane');
axis(myaxis);

%% 🔶 IIR Filter (ARMA model)
b_iir = [1];                 % MA part (feedforward)
a_iir = [1 -0.8 0.15];       % AR part (feedback)

y_iir = filter(b_iir, a_iir, x);

% Time-domain plot
subplot(2,2,3);
plot(y_iir);
title('IIR Output (ARMA Model)');
xlabel('Time'); ylabel('Amplitude');

% Pole-zero plot
subplot(2,2,4);
zplane(b_iir, a_iir);
title('IIR Filter: Z-plane');
axis(myaxis);


clc; clear;

% Generate white noise input
N = 1000;
x = randn(N,1);

%% 🔷 FIR Filter (MA model)
b_fir = [1 0.5 0.25];  % FIR coefficients (feedforward)
a_fir = 1;             % No feedback

y_fir = filter(b_fir, a_fir, x);

%% 🔶 IIR Filter (ARMA model)
b_iir = [1];                 % MA part (feedforward)
a_iir = [1 -0.8 0.15];       % AR part (feedback)

y_iir = filter(b_iir, a_iir, x);

%% Plot time-domain signals
figure;
subplot(2,2,1);
plot(y_fir);
title('FIR Output (MA Model)');
xlabel('Time'); ylabel('Amplitude');

subplot(2,2,2);
plot(y_iir);
title('IIR Output (ARMA Model)');
xlabel('Time'); ylabel('Amplitude');

%% Plot pole-zero diagrams
myaxis = [-1.1 1.1 -1.1 1.1];
subplot(2,2,3);
zplane(b_fir, a_fir);
title('FIR Pole-Zero Plot'); axis(myaxis);

subplot(2,2,4);
zplane(b_iir, a_iir);
title('IIR Pole-Zero Plot'); axis(myaxis);

%% Frequency Response (magnitude and phase)
figure;
[H_fir, w] = freqz(b_fir, a_fir, 512);
[H_iir, ~] = freqz(b_iir, a_iir, 512);

subplot(2,1,1);
plot(w/pi, abs(H_fir), 'b', w/pi, abs(H_iir), 'r--');
legend('FIR','IIR');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('|H(w)|');
title('Magnitude Response');

subplot(2,1,2);
plot(w/pi, angle(H_fir), 'b', w/pi, angle(H_iir), 'r--');
legend('FIR','IIR');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (radians)');
title('Phase Response');

%% Power Spectral Density (Welch method)
figure;
[pxx_fir, f] = pwelch(y_fir, [], [], [], 1);
[pxx_iir, ~] = pwelch(y_iir, [], [], [], 1);

plot(f,10*log10(pxx_fir),'b', f,10*log10(pxx_iir),'r--');
legend('FIR','IIR');
xlabel('Frequency'); ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density');
grid on;

clc; clear;

%% Load a real signal (e.g., a chirp)
Fs = 1000;                  % Sampling frequency
t = 0:1/Fs:2;               % 2 seconds
x = chirp(t, 50, 2, 250);   % Frequency sweeps from 50Hz to 250Hz

%% Define FIR (MA) and IIR (ARMA) filters
b_fir = fir1(20, 0.3);       % FIR lowpass filter, cutoff at 0.3*Nyquist
a_fir = 1;

[b_iir, a_iir] = butter(2, 0.3); % IIR Butterworth filter, same cutoff

% Apply filters
y_fir = filter(b_fir, a_fir, x);
y_iir = filter(b_iir, a_iir, x);

%% Plot time-domain signals
figure;
subplot(3,1,1);
plot(t, x);
title('Original Chirp Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,2);
plot(t, y_fir);
title('FIR Filtered Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,3);
plot(t, y_iir);
title('IIR Filtered Signal');
xlabel('Time (s)'); ylabel('Amplitude');

%% Plot Frequency Response
figure;
[H_fir, w] = freqz(b_fir, a_fir, 1024);
[H_iir, ~] = freqz(b_iir, a_iir, 1024);

plot(w/pi, 20*log10(abs(H_fir)), 'b', w/pi, 20*log10(abs(H_iir)), 'r--');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
legend('FIR','IIR');
title('Frequency Response of FIR vs IIR');
grid on;

%% Plot Pole-Zero Diagrams
myaxis = [-1.1 1.1 -1.1 1.1];
figure;
subplot(1,2,1);
zplane(b_fir, a_fir); title('FIR Filter Poles/Zeros'); axis(myaxis);

subplot(1,2,2);
zplane(b_iir, a_iir); title('IIR Filter Poles/Zeros'); axis(myaxis);

%% Power Spectral Density
figure;
[pxx_orig, f] = pwelch(x,[],[],[],Fs);
[pxx_fir, ~] = pwelch(y_fir,[],[],[],Fs);
[pxx_iir, ~] = pwelch(y_iir,[],[],[],Fs);

plot(f,10*log10(pxx_orig), 'k', ...
     f,10*log10(pxx_fir), 'b', ...
     f,10*log10(pxx_iir), 'r--');
legend('Original','FIR','IIR');
xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density');
grid on;

%% MA and ARMA
clc; clear;
%close all

N = 1000;                 % Signal length
x = randn(N,1);           % White noise input

%% 🔷 MA Filter (FIR)
theta = [1 0.6 -0.3];     % MA coefficients (q = 2)
y_ma = filter(theta, 1, x);

%% 🔶 ARMA Filter
phi = [1 -0.9 0.3];       % AR part (p = 2)
theta_arma = [1 0.4];     % MA part (q = 1)
y_arma = filter(theta_arma, phi, x);

%% Time-Domain Comparison
figure;
subplot(2,1,1);
plot(y_ma, 'b');
title('MA Filter Output (FIR)');
xlabel('Time'); ylabel('Amplitude');

subplot(2,1,2);
plot(y_arma, 'r');
title('ARMA Filter Output (IIR)');
xlabel('Time'); ylabel('Amplitude');

%% Pole-Zero Diagrams
myaxis = [-1.1 1.1 -1.1 1.1];
figure;
subplot(1,2,1);
zplane(theta, 1);
title('MA Filter: Z-plane'); axis(myaxis);

subplot(1,2,2);
zplane(theta_arma, phi);
title('ARMA Filter: Z-plane'); axis(myaxis);

%% Frequency Response
figure;
[H_ma, w] = freqz(theta, 1, 512);
[H_arma, ~] = freqz(theta_arma, phi, 512);

subplot(2,1,1);
plot(w/pi, 20*log10(abs(H_ma)), 'b', w/pi, 20*log10(abs(H_arma)), 'r--');
legend('MA','ARMA'); title('Magnitude Response');
xlabel('Normalized Frequency (\times\pi)'); ylabel('dB');

subplot(2,1,2);
plot(w/pi, angle(H_ma), 'b', w/pi, angle(H_arma), 'r--');
legend('MA','ARMA'); title('Phase Response');
xlabel('Normalized Frequency (\times\pi)'); ylabel('Phase (rad)');

%% Noth filter with MA and ARMA

clc; clear;
%close all;

%% Signal Parameters
Fs = 1000;                  % Sampling frequency (Hz)
t = 0:1/Fs:1;               % 1 second duration
f0 = 60;                    % Target frequency to notch (Hz)
x = sin(2*pi*f0*t) + 0.5*randn(size(t));  % Signal with 60 Hz + noise

%% 🔷 FIR Notch Filter (MA only — two zeros on unit circle)
w0 = 2*pi*f0/Fs;            % Normalized notch frequency
theta = [1, -2*cos(w0), 1]; % Zeros at e^(±jw0)
a_fir = 1;
y_fir = filter(theta, a_fir, x);

%% 🔶 IIR Notch Filter (ARMA — zeros + poles near unit circle)
r = 0.95;                   % Pole radius (controls notch sharpness)
b_iir = theta;              % Same zeros
a_iir = [1, -2*r*cos(w0), r^2];  % Poles near zeros
y_iir = filter(b_iir, a_iir, x);

%% Plot Time-Domain Output
figure;
subplot(3,1,1);
plot(t, x); title('Original Signal with 60 Hz'); xlabel('Time'); ylabel('Amplitude');

subplot(3,1,2);
plot(t, y_fir, 'b'); title('FIR (MA) Notch Filter Output'); xlabel('Time');

subplot(3,1,3);
plot(t, y_iir, 'r'); title('IIR (ARMA) Notch Filter Output'); xlabel('Time');

%% Frequency Response Comparison
figure;
[H_fir, w] = freqz(theta, a_fir, 1024, Fs);
[H_iir, ~] = freqz(b_iir, a_iir, 1024, Fs);

plot(w, 20*log10(abs(H_fir)), 'b', w, 20*log10(abs(H_iir)), 'r--');
legend('FIR (MA)', 'IIR (ARMA)');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('Notch Filter Frequency Response');
grid on;

%% Pole-Zero Plot
myaxis = [-1.1 1.1 -1.1 1.1];
figure;
subplot(1,2,1);
zplane(theta, a_fir); title('FIR (MA) Filter'); axis(myaxis);

subplot(1,2,2);
zplane(b_iir, a_iir); title('IIR (ARMA) Filter'); axis(myaxis);

% End of filters.m
disp('Filter analysis complete.');
disp('FIR and IIR filters have been applied and analyzed.');
disp('Plots generated for time-domain signals, frequency response, and pole-zero diagrams.');
disp('Power spectral density plots created for both FIR and IIR outputs.');
disp('Notch filter analysis complete with FIR and IIR implementations.');
disp('All operations completed successfully.');
disp('You can now explore the results in the generated figures.');
disp('Thank you for using the filter analysis script!');
disp('End of script.');
