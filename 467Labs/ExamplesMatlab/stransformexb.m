% demo_stockwell.m
fs = 1000;           % Hz
T  = 1;              % seconds
t  = (0:1/fs:T-1/fs);

% Test signal: 50 Hz tone in first half, 150 Hz tone in second half
x = zeros(size(t));
x(t < 0.5) = sin(2*pi*50*t(t < 0.5));
x(t >= 0.5) = sin(2*pi*150*t(t >= 0.5));

% Compute S-transform
[S, tt, ff] = stransformb(x, fs);

% Plot magnitude
figure;
imagesc(tt, ff, abs(S));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('S-transform magnitude |S(f,t)|');
colorbar;

% Optional: limit frequency axis for nicer display
ylim([0 250]);
