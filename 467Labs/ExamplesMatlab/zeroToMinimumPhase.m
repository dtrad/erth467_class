% Zero-phase -> minimum-phase via constant-Q attenuation + dispersion
clear; close all; clc;
%% First with spike
% Spike (t=0) -> minimum-phase wavelet via constant-Q attenuation + dispersion
clear; close all; clc;

%% Sampling and axes
dt   = 0.001;            % s
N    = 4096;             % samples
t    = (0:N-1)*dt;       % time axis
Fs   = 1/dt;
df   = Fs/N;
f    = (0:N-1)*df;       % Hz (two-sided, unshifted, consistent with fft)

%% Input: a unit spike at t=0
x          = zeros(1,N);
x(1)       = 1;          % delta at t=0
X          = fft(x);     % = 1 for all frequencies (within numerical eps)

%% Constant-Q earth (minimum phase by construction)
Q          = 80;         % constant-Q
Tprop      = 0.6;        % one-way propagation time (s)
A_mag      = exp(-pi*abs(f)*Tprop/Q);     % attenuation magnitude |A(f)|

% Build causal phase from log-magnitude (Kolmogorov/Kramers–Kronig)
logA       = log(A_mag + eps);
phi        = -imag(hilbert(logA));        % Hilbert transform gives min-phase
A          = exp(logA + 1i*phi);          % minimum-phase transfer function

%% Output (propagated spike)
Y          = X .* A;                       % = A, since X=1
y          = real(ifft(Y,'symmetric'));

%% (Optional) diagnostic: real cepstrum to check min-phase character
logSpec    = log(abs(Y) + eps);
c          = real(ifft(logSpec,'symmetric'));
negE       = sum(c(N/2+2:end).^2);         % “negative quefrency” energy
posE       = sum(c(2:N/2).^2);

%% Plots
twin = [0, 0.35];

figure('Name','Time domain','Position',[100 100 920 520]);
subplot(2,1,1);
stem(t(1:200), x(1:200), 'filled'); grid on;
xlabel('Time (s)'); ylabel('Amp');
title('Input: unit spike at t=0'); xlim([0, 0.2]);

subplot(2,1,2);
plot(t, y, 'LineWidth', 1.4); grid on; xlim(twin);
xlabel('Time (s)'); ylabel('Amp');
title('Output after constant-Q earth: asymmetric minimum-phase wavelet');

% Spectral magnitude & phase
fmax = 150; idx = f<=fmax;
figure('Name','Spectrum','Position',[120 120 960 560]);
subplot(2,1,1);
plot(f(idx), abs(Y(idx)), 'LineWidth', 1.3); grid on;
xlabel('Frequency (Hz)'); ylabel('|Y(f)|');
title('Amplitude spectrum (roll-off due to attenuation)');

subplot(2,1,2);
plot(f(idx), unwrap(angle(Y(idx))), 'LineWidth', 1.3); grid on;
xlabel('Frequency (Hz)'); ylabel('Phase (rad)');
title('Causal phase from Hilbert(log|A|) (minimum-phase)');

% Cepstrum
q = t; % same spacing as time here
figure('Name','Cepstrum','Position',[140 140 900 520]);
plot(q, c, 'LineWidth', 1.2); grid on; xlim([0, 0.2]);
xlabel('Quefrency (s)'); ylabel('Cepstrum');
title(sprintf('Real cepstrum (neg/pos energy = %.2e / %.2e)', negE, posE));

%% Notes:
% - Starting from a spike ensures the output equals the earth's minimum-phase
%   impulse response. You should see a sharp leading edge and a decaying tail.
% - The phase is not arbitrarily assigned: it is the unique minimum-phase
%   companion of the chosen |A(f)| via the Hilbert transform of log|A|.




%% Sampling and time axis
dt   = 0.001;          % s
N    = 4096;           % samples (large for smooth spectra)
t    = (0:N-1)*dt;
Fs   = 1/dt;
df   = Fs/N;

% Frequency axis (two-sided, unshifted, consistent with fft)
f    = (0:N-1)*df;              % Hz
f_c  = f;                       % alias for readability

%% Zero-phase Ricker source (symmetric)
f0   = 25;                      % dominant frequency (Hz)
t0   = 0.2;                     % center time to keep wavelet in window
tau  = t - t0;
pi2f2 = (pi*f0)^2;
% Classic Ricker
w0   = (1 - 2*pi2f2*tau.^2).*exp(-pi2f2*tau.^2);
W0   = fft(w0);                  % spectrum (real, ~zero phase)

%% Constant-Q earth: attenuation magnitude and causal (min-phase) phase
Q        = 80;                   % constant-Q
Tprop    = 0.6;                  % one-way propagation time (s) for the path
% Constant-Q amplitude decay: |A(f)| = exp(-pi f T / Q)
A_mag    = exp(-pi*abs(f_c)*Tprop/Q);

% Build causal phase via Hilbert transform of log-magnitude (Kolmogorov)
% 1) Two-sided log magnitude (even)
logA     = log(A_mag + eps);
% 2) Phase is the (negative) Hilbert transform of log magnitude
%    (imag(hilbert(.)) is the Hilbert transform)
phi      = -imag(hilbert(logA));

% Earth transfer function (minimum phase by construction)
A        = exp(logA + 1i*phi);

%% Propagate the source
S        = W0 .* A;             % spectrum after propagation
s        = real(ifft(S, 'symmetric'));

%% Diagnostics: check "minimum-phase-like" via cepstrum
% Real cepstrum from log spectrum magnitude
logSpec_out = log(abs(S) + eps);
c_out       = real(ifft(logSpec_out, 'symmetric'));

% A crude min-phase check:
% energy in negative "quefrency" should be small for minimum-phase signals
neg_part_energy = sum(c_out(N/2+2:end).^2);
pos_part_energy = sum(c_out(2:N/2).^2);

%% Plots
twin = [t0-0.15, t0+0.35];

figure('Name','Time-domain wavelets','Position',[100 100 900 520]);
subplot(2,1,1);
plot(t, w0, 'LineWidth', 1.4); xlim(twin);
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
title('Original zero-phase Ricker');

subplot(2,1,2);
plot(t, s, 'LineWidth', 1.4); xlim(twin);
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
title('After propagation in constant-Q earth: asymmetric (minimum-phase-like)');

% Spectral magnitude and phase
fmaxplot = 150;
idx = f_c <= fmaxplot;

figure('Name','Spectrum and Phase','Position',[120 120 950 560]);
subplot(2,1,1);
plot(f_c(idx), abs(W0(idx)), 'LineWidth', 1.3); hold on;
plot(f_c(idx), abs(S(idx)),  'LineWidth', 1.3);
xlabel('Frequency (Hz)'); ylabel('|Spectrum|'); grid on;
legend('Source |W_0|','After earth |S|','Location','northeast');
title('Amplitude spectra (high-f cut by attenuation)');

subplot(2,1,2);
% Unwrap the total phase of the propagated spectrum
phi_total = unwrap(angle(S));
plot(f_c(idx), phi_total(idx), 'LineWidth', 1.3); grid on;
xlabel('Frequency (Hz)'); ylabel('Phase (rad)');
title('Phase introduced by causal dispersion (minimum-phase)');

% Cepstrum view
q = (0:N-1)*dt;  % quefrency axis in seconds (same spacing as time here)
figure('Name','Cepstrum (minimum-phase check)','Position',[140 140 900 520]);
plot(q, c_out, 'LineWidth', 1.2); xlim([0, 0.2]);
xlabel('Quefrency (s)'); ylabel('Cepstrum amplitude'); grid on;
title(sprintf('Real cepstrum of propagated signal  (neg/pos energy = %.2e / %.2e)', ...
              neg_part_energy, pos_part_energy));

%% Notes:
% - The earth filter A(f) is built minimum-phase by taking phase = -Hilbert{log|A|}.
% - Multiplying the zero-phase source spectrum by A(f) produces a causal, asymmetric
%   output wavelet that is minimum-phase-like (cepstrum negative part small).
% - Q, Tprop control the strength of attenuation and dispersion (shape asymmetry).
