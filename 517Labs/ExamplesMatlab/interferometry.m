% Time parameters
dt = 0.001;            % time step (s)
tmax = 2;              % total time (s)
t = 0:dt:tmax;         % time axis
nt = length(t);

% Source wavelet: Ricker
f0 = 25;                     % dominant frequency in Hz
tw = -0.1:dt:0.1;            % wavelet time axis (centered)
w = (1 - 2*(pi*f0*tw).^2) .* exp(-(pi*f0*tw).^2);  % Ricker wavelet
nw = length(w);

% Velocity model and offsets
v = 2000;                    % velocity (m/s)
offset1 = 500;               % distance to receiver 1
offset2 = 1000;              % distance to receiver 2

% Delays in time and samples
t1 = offset1 / v;
t2 = offset2 / v;
delay1 = round(t1 / dt);     % sample index for R1
delay2 = round(t2 / dt);     % sample index for R2

% Create empty traces
r1 = zeros(1, nt);
r2 = zeros(1, nt);

% Wavelet insertion index (centered)
i1 = delay1 - floor(nw/2);
i2 = delay2 - floor(nw/2);

% Insert wavelet into r1 and r2 (only if inside bounds)
if i1 > 0 && (i1 + nw - 1 <= nt)
    r1(i1 : i1 + nw - 1) = w;
end
if i2 > 0 && (i2 + nw - 1 <= nt)
    r2(i2 : i2 + nw - 1) = w;
end

% Interferometry by cross-correlation
[cc, lags] = xcorr(r2, r1, 'none');  % 'none' avoids error
time_lags = lags * dt;
cc = cc / max(abs(cc));              % optional normalization

% Plotting
figure;

subplot(3,1,1);
plot(t, r1);
title('Recorded Signal at Receiver 1');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(t, r2);
title('Recorded Signal at Receiver 2');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(time_lags, cc);
title('Cross-Correlation (Virtual Shot at R1, Receiver at R2)');
xlabel('Lag Time (s)');
ylabel('Amplitude');
grid on;
