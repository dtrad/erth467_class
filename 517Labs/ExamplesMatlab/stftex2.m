close all
clear

% set default figure position
screenSize = get(0, 'ScreenSize');
set(0, 'DefaultFigurePosition', [50, screenSize(4)-400-200, 600-100, 400-100]);

% --- Signal ---
% x = sin(2*pi*100*t) + sin(2*pi*300*t.*(t>0.5));
% fs = 1000;
% t = 0:1/fs:1;
fs = 1000;
t = 0:1/fs:1;
x = sin(2*pi*100*t) + sin(2*pi*300*t.*(t>0.5));

% Parameters
win_len = 256;
hop = 128;
nfft = 512;
window = hamming(win_len);

% --- STFT ---
num_frames = floor((length(x)-win_len)/hop) + 1;
S = zeros(nfft, num_frames);

for k = 1:num_frames
    idx = (1:win_len) + (k-1)*hop;
    xw = x(idx) .* window';
    S(:,k) = fft(xw, nfft);
end

% Plot STFT magnitude
figure;
imagesc((0:num_frames-1)*hop/fs, (0:nfft-1)*fs/nfft, 20*log10(abs(S)));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Short-Time Fourier Transform (STFT)');
colorbar;
% --- ISTFT ---
x_rec = zeros(length(x),1);
win_sum = zeros(length(x),1);

for k = 1:num_frames
    idx = (1:win_len) + (k-1)*hop;
    xw = real(ifft(S(:,k), nfft));
    x_rec(idx) = x_rec(idx) + xw(1:win_len).*window;
    win_sum(idx) = win_sum(idx) + window.^2;
end
x_rec = x_rec ./ (win_sum + eps);

% Plot results
figure;
subplot(2,1,1);
plot(t, x); title('Original Signal'); xlabel('Time (s)');
subplot(2,1,2);
plot(t, x_rec(1:length(t))); title('Reconstructed Signal (Manual ISTFT)'); xlabel('Time (s)');
