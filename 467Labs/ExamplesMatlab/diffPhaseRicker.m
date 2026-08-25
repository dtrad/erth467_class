% Parameters
dt = 0.001;                   % sampling interval (s)
tmax = 0.2;                   % half-width in time
t = -tmax:dt:tmax;            % time vector
f0 = 25;                      % dominant frequency (Hz)

% --- 1. Zero-phase Ricker wavelet (standard)
ricker = (1 - 2*(pi*f0*t).^2) .* exp(-(pi*f0*t).^2);

% --- 2. 90-degree phase-shifted Ricker (Hilbert transform)
ricker_90 = imag(hilbert(ricker));

% --- 3. Minimum-phase version (via real cepstrum method)
n = length(ricker);
R = fft(ricker);
A = abs(R);
logA = log(A + eps);               % Avoid log(0)
cep = ifft(logA, 'symmetric');

% Minimum phase: zero negative times in cepstrum
cep_min = cep;
cep_min(ceil(n/2)+1:end) = 0;
logA_min = fft(cep_min);
R_min = exp(logA_min);
ricker_min = real(ifft(R_min));

% --- 4. Maximum-phase Ricker = time reverse of minimum-phase
ricker_max = fliplr(ricker_min);

% Time axis for min/max phase
t_min = (0:length(ricker_min)-1) * dt;

% --- Plotting all wavelets
figure;

subplot(4,1,1);
plot(t, ricker, 'k');
title('Zero-Phase Ricker Wavelet');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,2);
plot(t, ricker_90, 'm');
title('90° Phase-Shifted (Hilbert) Ricker');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,3);
plot(t_min, ricker_min, 'b');
title('Minimum-Phase Ricker');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,4);
plot(t_min, ricker_max, 'r');
title('Maximum-Phase Ricker');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
