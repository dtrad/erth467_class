close all
clear
% Set default figure position
screenSize = get(0, 'ScreenSize');
set(0, 'DefaultFigurePosition', [50, screenSize(4)-400-200, 600-100, 400-100]);

%% Example: STFT and inverse STFT in MATLAB
fs = 1000;                         % Sampling frequency
t = 0:1/fs:1;                      % Time vector (2 seconds)
x = chirp(t,100,1,300,'linear');   % Linear chirp from 100 to 300 Hz

% Parameters
window = hamming(256);
noverlap = 128;
nfft = 512;

% --- Forward STFT ---
[S,F,T] = stft(x, fs, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);


%% Plot STFT magnitude
% use imagesc for visualization
figure;
imagesc(T, F, 20*log10(abs(S)));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');% Set default figure position
title('Short-Time Fourier Transform (STFT)');
colorbar;   

% --- Inverse STFT ---
x_rec = istft(S, fs, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);

% Compare original and reconstructed signals
% pad x_rec to match length of x if necessary
x_rec = x_rec.';
if length(x_rec) > length(x)
    x_rec = x_rec(1:length(x));
end
if length(x_rec) < length(x)
    x_rec = [x_rec, zeros(1, length(x)-length(x_rec))];
end
% Plot original and reconstructed signals
figure;
subplot(2,1,1);
plot(t, x); title('Original Signal'); xlabel('Time (s)');
subplot(2,1,2);
plot(t, x_rec(1:length(t))); title('Reconstructed Signal (ISTFT)'); xlabel('Time (s)');

