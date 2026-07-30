% Wavelet acts as a band-pass filter on reflectivity
clear; close all; clc;

%% Sampling
dt = 0.002;                   % s
N  = 2048;                    % samples
t  = (0:N-1)*dt;              % time
Fs = 1/dt; df = Fs/N;         % Hz
f  = (0:N-1)*df;              % two-sided (fft order)

%% 1) White reflectivity (broadband)
rng(0);
r = 0.02*randn(1,N);          % small random reflectivity (approx. white)

%% 2) Zero-phase Ricker wavelet (band-limited)
f0 = 25;                      % dominant freq (Hz)
t0 = 0.12;                    % center time (keep wavelet inside window)
tau = t - t0;
pi2f2 = (pi*f0)^2;
w = (1 - 2*pi2f2*tau.^2).*exp(-pi2f2*tau.^2);   % Ricker

%% 3) Seismic trace = reflectivity * wavelet (time convolution => freq product)
s = conv(r, w, 'same');       % observed trace

%% 4) Spectra
R = fft(r);
W = fft(w);
S = fft(s);

% One-sided indices for plotting clarity
imax = floor(N/2);
fo   = f(1:imax);

% Amplitude spectra (one-sided)
absR = abs(R(1:imax));
absW = abs(W(1:imax));
absS = abs(S(1:imax));

% Normalize for visual comparison
absR = absR./max(absR);
absW = absW./max(absW);
absS = absS./max(absS);

%% Plots: time domain
figure('Name','Time domain','Position',[80 80 950 600]);
subplot(3,1,1);
plot(t, r, 'k'); grid on; xlim([0 0.6]);
xlabel('Time (s)'); ylabel('r(t)');
title('Reflectivity (approximately white)');

subplot(3,1,2);
plot(t, w, 'b','LineWidth',1.2); grid on; xlim([t0-0.15 t0+0.15]);
xlabel('Time (s)'); ylabel('w(t)');
title('Zero-phase Ricker wavelet (band-limited)');

subplot(3,1,3);
plot(t, s, 'r'); grid on; xlim([0 0.6]);
xlabel('Time (s)'); ylabel('s(t) = r * w');
title('Seismic trace (band-limited reflectivity)');

%% Plots: frequency domain
figure('Name','Frequency domain','Position',[120 120 980 640]);

subplot(2,1,1);
plot(fo, absR, 'k'); hold on;
plot(fo, absW, 'b','LineWidth',1.2);
plot(fo, absS, 'r','LineWidth',1.2);
grid on; xlim([0 150]);
xlabel('Frequency (Hz)'); ylabel('Normalized amplitude');
legend('|R(f)|','|W(f)|','|S(f)|','Location','northeast');
title('Amplitude spectra (one-sided)');

% Show that |S(f)| ≈ |W(f)| * |R(f)| by overlaying the product
prodSpec = absW .* absR; 
prodSpec = prodSpec ./ max(prodSpec + eps);

subplot(2,1,2);
plot(fo, absS, 'r','LineWidth',1.2); hold on;
plot(fo, prodSpec, 'm--','LineWidth',1.3);
grid on; xlim([0 150]);
xlabel('Frequency (Hz)'); ylabel('Normalized amplitude');
legend('|S(f)|','|W(f)|·|R(f)|','Location','northeast');
title('Verification: convolution in time ⇒ multiplication in frequency');

%% Notes:
% - The reflectivity is ~white, so |R(f)| is ~flat.
% - The Ricker wavelet |W(f)| is band-pass.
% - The output |S(f)| ≈ |W(f)|·|R(f)| ≈ |W(f)|, showing the wavelet
%   acts as a band-pass filter on the reflectivity.
