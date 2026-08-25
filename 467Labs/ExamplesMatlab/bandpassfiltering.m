% Parameters
dt = 0.004;
nt = 512;
t = (0:nt-1) * dt;

% Create synthetic signal
f1 = 5; f2 = 20; f3 = 60;
signal = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.2*sin(2*pi*f3*t);

% FFT of signal
signal_fft = fft(signal);
freq = (0:nt-1) / (nt*dt);
freq_shifted = ifftshift((-nt/2:nt/2-1)/(nt*dt)); % for plotting symmetry

% Design bandpass filter in frequency domain
f_low = 10; f_high = 40;
bandpass = zeros(1, nt);
bandpass(abs(fftshift(freq_shifted)) >= f_low & abs(fftshift(freq_shifted)) <= f_high) = 1;

% Apply filter and inverse FFT
filtered_fft = signal_fft .* fftshift(bandpass);
filtered_signal = real(ifft(filtered_fft));

% Plot time domain
figure;
subplot(2,1,1)
plot(t, signal, 'b', t, filtered_signal, 'r');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Original', 'Filtered');
title('Time Domain');

% Plot spectra
subplot(2,1,2)
fpos = freq(1:nt/2);
plot(fpos, abs(signal_fft(1:nt/2)), 'b'); hold on;
plot(fpos, abs(filtered_fft(1:nt/2)), 'r');
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Original Spectrum', 'Filtered Spectrum');
title('Frequency Domain');

%%%%
% Parameters
dt = 0.004;
nt = 512;
t = (0:nt-1) * dt;

% Create synthetic signal
f1 = 5; f2 = 20; f3 = 60;
signal = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.2*sin(2*pi*f3*t);

% Filter design
filter_length = 101;  % must be odd
f_low = 10;
f_high = 40;
t_filter = ((-(filter_length-1)/2:(filter_length-1)/2)) * dt;

% Sinc filters
sinc_low = 2*f_high*dt * sinc(2*f_high*t_filter);
sinc_high = 2*f_low*dt * sinc(2*f_low*t_filter);

% Apply window
window = hamming(filter_length)';
sinc_low = sinc_low .* window;
sinc_high = sinc_high .* window;

% Bandpass = lowpass - highpass
bandpass = sinc_low - sinc_high;

% Time-domain convolution
filtered_signal = conv(signal, bandpass, 'same');

% FFT for plotting
freq = (0:nt-1)/(nt*dt);
signal_fft = fft(signal);
filtered_fft = fft(filtered_signal);

% Plot time domain
figure;
subplot(2,1,1)
plot(t, signal, 'b', t, filtered_signal, 'r');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Original', 'Filtered');
title('Time Domain');

% Plot spectra
subplot(2,1,2)
fpos = freq(1:nt/2);
plot(fpos, abs(signal_fft(1:nt/2)), 'b'); hold on;
plot(fpos, abs(filtered_fft(1:nt/2)), 'r');
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Original Spectrum', 'Filtered Spectrum');
title('Frequency Domain');
