% Example: asymptotic construction of a Butterworth band-pass filter
%
% This script uses the asymptotic magnitude responses of complementary
% Butterworth low-pass and high-pass filters and multiplies them to obtain
% a band-pass response. The exact (non-asymptotic) magnitudes are computed
% as well for comparison.

% Filter specifications
n_low  = 4;    % order of the low-pass section
n_high = 4;    % order of the high-pass section
w_low  = 2*pi*5;   % lower cutoff in rad/s
w_high = 2*pi*40;  % upper cutoff in rad/s

f_low  = w_low / (2 * pi);
f_high = w_high / (2 * pi);

% Frequency axis (log spaced to emphasise asymptotic behaviour)
w = logspace(log10(w_low) - 2, log10(w_high) + 2, 2000);

% Asymptotic magnitudes
Hlp_asym = ones(size(w));
mask_high = w > w_high;
Hlp_asym(mask_high) = (w_high ./ w(mask_high)).^n_low;

Hhp_asym = ones(size(w));
mask_low = w < w_low;
Hhp_asym(mask_low) = (w(mask_low) ./ w_low).^n_high;

Hbp_asym = Hlp_asym .* Hhp_asym;

% Exact Butterworth magnitudes for comparison
Hlp_exact = 1 ./ sqrt(1 + (w ./ w_high).^(2 * n_low));
Hhp_exact = (w ./ w_low).^n_high ./ sqrt(1 + (w ./ w_low).^(2 * n_high));
Hbp_exact = Hlp_exact .* Hhp_exact;

% Convert to decibels
mag2db = @(x) 20 * log10(abs(x));

figure;
subplot(3, 1, 1);
semilogx(w, mag2db(Hlp_asym), 'k--', 'LineWidth', 1.5);
hold on;
semilogx(w, mag2db(Hlp_exact), 'b', 'LineWidth', 1);
grid on;
ylabel('Magnitude (dB)');
title(sprintf('Low-pass Butterworth (n = %d, \\omega_c = %.1f rad/s)', n_low, w_high));
legend('Asymptotic', 'Exact', 'Location', 'SouthWest');

subplot(3, 1, 2);
semilogx(w, mag2db(Hhp_asym), 'k--', 'LineWidth', 1.5);
hold on;
semilogx(w, mag2db(Hhp_exact), 'r', 'LineWidth', 1);
grid on;
ylabel('Magnitude (dB)');
title(sprintf('High-pass Butterworth (n = %d, \\omega_c = %.1f rad/s)', n_high, w_low));
legend('Asymptotic', 'Exact', 'Location', 'SouthWest');

subplot(3, 1, 3);
semilogx(w, mag2db(Hbp_asym), 'k--', 'LineWidth', 1.5);
hold on;
semilogx(w, mag2db(Hbp_exact), 'm', 'LineWidth', 1);
grid on;
ylabel('Magnitude (dB)');
xlabel('Angular frequency (rad/s)');
title('Band-pass from cascaded Butterworth sections');
legend('Asymptotic product', 'Exact product', 'Location', 'SouthWest');

sgtitle('Butterworth Band-pass via Asymptotic Factors');

% MATLAB Signal Processing Toolbox comparison
fs = 200;                           % sampling frequency in Hz
assert(fs > 2 * f_high, 'Sampling frequency must exceed twice the upper cutoff.');

n_bp = n_low + n_high;              % overall band-pass order
[b_bp, a_bp] = butter(n_bp, [f_low f_high] / (fs / 2), 'bandpass');

% Frequency response of the digital Butterworth filter
[H_bp_dig, f_dig] = freqz(b_bp, a_bp, 1024, fs);
w_dig = 2 * pi * f_dig;

Hlp_asym_dig = ones(size(w_dig));
mask_high_dig = w_dig > w_high;
Hlp_asym_dig(mask_high_dig) = (w_high ./ w_dig(mask_high_dig)).^n_low;

Hhp_asym_dig = ones(size(w_dig));
mask_low_dig = w_dig < w_low;
Hhp_asym_dig(mask_low_dig) = (w_dig(mask_low_dig) ./ w_low).^n_high;

Hbp_asym_dig = Hlp_asym_dig .* Hhp_asym_dig;
Hbp_exact_dig = (1 ./ sqrt(1 + (w_dig ./ w_high).^(2 * n_low))) .* ...
                ((w_dig ./ w_low).^n_high ./ sqrt(1 + (w_dig ./ w_low).^(2 * n_high)));

figure;
semilogx(f_dig, mag2db(Hbp_asym_dig), 'k--', 'LineWidth', 1.5);
hold on;
semilogx(f_dig, mag2db(Hbp_exact_dig), 'm', 'LineWidth', 1);
semilogx(f_dig, mag2db(H_bp_dig), 'g', 'LineWidth', 1);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Band-pass magnitude comparison (analog asymptotic vs digital butter)');
legend('Asymptotic product', 'Exact product', 'Digital butter()', 'Location', 'SouthWest');

% Apply the digital filter to a composite signal
t = (0:1/fs:2)';
x = sin(2 * pi * 2 * t) + sin(2 * pi * 12 * t) + sin(2 * pi * 60 * t);
y = filter(b_bp, a_bp, x);

N = numel(t);
half = floor(N / 2) + 1;            % use one-sided spectrum
f_fft = fs * (0:half-1) / N;
X_fft = abs(fft(x));
Y_fft = abs(fft(y));

figure;
subplot(2, 1, 1);
plot(t, x, 'b', 'LineWidth', 0.8);
hold on;
plot(t, y, 'r', 'LineWidth', 0.8);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Time-domain response of digital Butterworth band-pass');
legend('Input signal', 'Filtered output', 'Location', 'SouthWest');

subplot(2, 1, 2);
plot(f_fft, mag2db(X_fft(1:half) + eps), 'b', 'LineWidth', 0.8);
hold on;
plot(f_fft, mag2db(Y_fft(1:half) + eps), 'r', 'LineWidth', 0.8);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Spectrum before and after filtering');
legend('Input spectrum', 'Filtered spectrum', 'Location', 'SouthWest');
axis([0 fs/2 -100 20]);
