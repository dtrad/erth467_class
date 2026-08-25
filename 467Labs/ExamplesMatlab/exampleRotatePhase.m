% Parameters
dt = 0.001;
t = -0.2:dt:0.2;
f0 = 25;

% Ricker wavelet (zero-phase)
ricker = (1 - 2*(pi*f0*t).^2) .* exp(-(pi*f0*t).^2);

% Phase rotations (example)
phi_list = [0, 45, 90, 180];  % in degrees

% Generate rotated wavelets
w0   = rotate_phase(ricker, phi_list(1));
w45  = rotate_phase(ricker, phi_list(2));
w90  = rotate_phase(ricker, phi_list(3));
w180 = rotate_phase(ricker, phi_list(4));

% Plotting
figure;
plot(t, w0, 'k', 'DisplayName', '0°');
hold on;
plot(t, w45, 'b', 'DisplayName', '45°');
plot(t, w90, 'r', 'DisplayName', '90°');
plot(t, w180, 'g', 'DisplayName', '180°');
title('Ricker Wavelet with Phase Rotation');
xlabel('Time (s)');
ylabel('Amplitude');
legend;
grid on;
