% Minimum-phase wavelet construction: Kolmogoroff vs Cepstrum
clear; close all; clc;

%% Parameters
N = 256;               % number of samples in frequency/time
dt = 0.004;            % sampling interval (s)
fnyq = 1/(2*dt);       % Nyquist frequency
freq = linspace(0,fnyq,N/2+1);

% Example amplitude spectrum: a Gaussian-shaped spectrum
f0 = 25; % dominant frequency
amp_spec = exp(-(freq-f0).^2 / (2*10^2)); % Gaussian in Hz

% Make it symmetric for real time series
amp_full = [amp_spec, amp_spec(end-1:-1:2)]; 

%% --- 1. Kolmogoroff method ---
log_amp = log(amp_full + eps);           % log magnitude spectrum
phase = -hilbert(log_amp) ;              % Hilbert transform
phase = imag(phase);                     % keep imaginary part
W_kol = exp(log_amp + 1i*phase);         % complex spectrum
w_kol = real(ifft(W_kol, 'symmetric'));  % minimum-phase wavelet

%% --- 2. Cepstrum method ---
log_spec = log_amp + 1i*zeros(size(log_amp));
cepstrum = ifft(log_spec, 'symmetric');  % real cepstrum
% Zero negative times (keep causal part)
cepstrum_min = [cepstrum(1), 2*cepstrum(2:N/2), zeros(1, N/2-1)];
% Back to log spectrum
log_spec_min = fft(cepstrum_min);
W_cep = exp(log_spec_min);                % complex spectrum
w_cep = real(ifft(W_cep, 'symmetric'));   % minimum-phase wavelet
% padding w_cep to match length 256
w_cep = [w_cep, zeros(1, N-length(w_cep))];
%% --- Plot results ---
t = (0:N-1)*dt;

figure;
subplot(2,1,1)
plot(t, w_kol, 'b', 'LineWidth', 1.5); hold on;
plot(t, w_cep, 'r--', 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Amplitude');
title('Minimum-phase wavelets: Kolmogoroff (blue) vs Cepstrum (red dashed)');
legend('Kolmogoroff', 'Cepstrum');

subplot(2,1,2)
plot(t, w_kol - w_cep, 'k');
xlabel('Time (s)'); ylabel('Difference');
title('Difference (should be near zero)');

