% Parameters
N = 2048;                     
t_max = 10;                   
t = linspace(-t_max, t_max, N); 
dt = t(2) - t(1);              

% Heaviside function: H(t)
h = double(t >= 0);

% Numerical FFT
Hf = fftshift(fft(h)) * dt;

% Frequency axis
df = 1 / (N * dt);
f = (-N/2:N/2-1) * df;         
omega = 2 * pi * f;           

% Analytical (principal value of 1/(iω)), avoiding division by zero
eps = 1e-6;  % small epsilon to avoid division by zero
omega_analytical = omega;
omega_analytical(abs(omega) < eps) = eps;  
Hf_analytical = 1 ./ (1i * omega_analytical);

% Plot magnitude
figure;
subplot(2,2,1);
plot(omega, abs(Hf), 'b', 'DisplayName', 'Numerical');
hold on;
plot(omega, abs(Hf_analytical), 'r--', 'DisplayName', 'Analytical (1/iω)');
title('Magnitude Spectrum');
xlabel('\omega (rad/s)');
ylabel('|H(\omega)|');
legend;
grid on;

% Plot phase
subplot(2,2,2);
plot(omega, angle(Hf), 'b', 'DisplayName', 'Numerical');
hold on;
plot(omega, angle(Hf_analytical), 'r--', 'DisplayName', 'Analytical (1/iω)');
title('Phase Spectrum');
xlabel('\omega (rad/s)');
ylabel('Phase (rad)');
legend;
grid on;

% Real part
subplot(2,2,3);
plot(omega, real(Hf), 'b', 'DisplayName', 'Numerical');
hold on;
plot(omega, real(Hf_analytical), 'r--', 'DisplayName', 'Analytical');
title('Real Part of H(\omega)');
xlabel('\omega (rad/s)');
ylabel('Re(H(\omega))');
legend;
grid on;

% Imaginary part
subplot(2,2,4);
plot(omega, imag(Hf), 'b', 'DisplayName', 'Numerical');
hold on;
plot(omega, imag(Hf_analytical), 'r--', 'DisplayName', 'Analytical');
title('Imaginary Part of H(\omega)');
xlabel('\omega (rad/s)');
ylabel('Im(H(\omega))');
legend;
grid on;
