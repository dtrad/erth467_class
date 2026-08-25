% Parameters
N = 2048;
t_max = 10;
t = linspace(-t_max, t_max, N);
dt = t(2) - t(1);

% Smoothed Heaviside function using sigmoid
a = 10;  % steepness parameter
h_smooth = 1 ./ (1 + exp(-a * t));  % sigmoid function

% Numerical FFT
Hf = fftshift(fft(h_smooth)) * dt;

% Frequency axis
df = 1 / (N * dt);
f = (-N/2:N/2-1) * df;
omega = 2 * pi * f;

% Plotting
figure;

subplot(2,2,1);
plot(t, h_smooth);
title('Smoothed Heaviside Function (Sigmoid)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2,2,2);
plot(omega, abs(Hf));
title('Magnitude Spectrum of Smoothed Heaviside');
xlabel('\omega (rad/s)');
ylabel('|H(\omega)|');
grid on;

subplot(2,2,3);
plot(omega, real(Hf));
title('Real Part of H(\omega)');
xlabel('\omega (rad/s)');
ylabel('Re(H(\omega))');
grid on;

subplot(2,2,4);
plot(omega, imag(Hf));
title('Imaginary Part of H(\omega)');
xlabel('\omega (rad/s)');
ylabel('Im(H(\omega))');
grid on;
