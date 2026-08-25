% set default figure position
screenSize = get(0, 'ScreenSize');
set(0, 'DefaultFigurePosition', [50, screenSize(4)-400-200, 600-100, 400-100]);

% Gabor Transform Example
clear; close all; clc;

fs = 1000;                         % Sampling frequency
t = 0:1/fs:2;                      % Time vector (2 seconds)
x = chirp(t,100,1,300,'linear');   % Chirp from 100 to 300 Hz

% --- Define Gaussian window (Gabor window) ---
sigma = 0.05;                      % Standard deviation in seconds
L = round(6*sigma*fs);             % Window length ~ ±3σ
g = exp(-0.5*((-L/2:L/2)/ (sigma*fs)).^2);
g = g(:);                          % Column vector
window = g / norm(g);              % Normalize window energy

% --- STFT with Gaussian window (Gabor transform) ---
hop = round(length(window)/4);     % 75% overlap
nfft = 512;
num_frames = floor((length(x)-length(window))/hop) + 1;

S = zeros(nfft, num_frames);
for k = 1:num_frames
    idx = (1:length(window)) + (k-1)*hop;
    xw = x(idx) .* window';
    X = fft(xw, nfft);
    S(:,k) = X;
end

% --- Plot the magnitude of the Gabor transform ---
freq = (0:nfft/2)*fs/nfft;
time = (0:num_frames-1)*hop/fs;

figure;
imagesc(time, freq, 20*log10(abs(S(1:nfft/2+1,:))));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Gabor Transform (Gaussian-windowed STFT)');
colorbar;
colormap jet;


% --- Inverse Gabor Transform ---
x_rec = zeros(size(x));
win_sum = zeros(size(x));
window=window';
for k = 1:num_frames
    idx = (1:length(window)) + (k-1)*hop;
    xw = real(ifft(S(:,k), nfft));
    xw=xw.';
    x_rec(idx) = x_rec(idx) + xw(1:length(window)).*window;
    win_sum(idx) = win_sum(idx) + window.^2;
end
x_rec = x_rec ./ (win_sum + eps);

% --- Compare original and reconstructed signals ---
figure;
subplot(2,1,1);
plot(t, x); title('Original Signal'); xlabel('Time (s)');
subplot(2,1,2);
plot(t, x_rec); title('Reconstructed Signal (Inverse Gabor Transform)'); xlabel('Time (s)');


