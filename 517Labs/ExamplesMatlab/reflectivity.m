% Compare auto-convolution vs recursive reflectivity calculation
close all
clear
% Input reflectivity series (interface reflectivities)
N = 10;                          % Number of layers
R = randn(1, N) * 0.1;           % Small reflectivity for stability
T = sqrt(1 - R.^2);              % Transmission coefficients

% --- Method 1: Auto-convolution ---
auto_reflectivity = conv(R, R);  % Length 2N - 1

% --- Method 2: Recursive reflectivity ---
% Initialize impulse response of earth (reflectivity series)
refl_recursive = zeros(1, 2*N - 1);  
refl_recursive(N) = R(1);  % Centered at time 0

% Loop to compute recursive reflectivity including multiples
for i = 2:N
    temp = refl_recursive;
    shift = i - 1;
    new_term = R(i);
    
    % Multiply existing reflectivity with R(i) and T's to simulate multiple reflections
    transmission_product = prod(T(1:i-1))^2;  % T1*T2*...*T_{i-1} squared
    
    % Primary reflection contribution
    refl_recursive(N + shift) = refl_recursive(N + shift) + transmission_product * R(i);
    
    % Add internal multiples (optional for higher accuracy)
    % For educational purposes only, not full wave modeling
    for j = 1:i-1
        refl_recursive(N + shift - 2*j) = refl_recursive(N + shift - 2*j) + ...
            R(i) * (R(j)^2) * transmission_product;
    end
end

% --- Plotting ---
t_auto = -(N-1):(N-1);
t_recur = -(N-1):(N-1);

figure;
subplot(3,1,1);
stem(1:N, R, 'filled');
title('Original Reflection Coefficients');
xlabel('Layer index');
ylabel('R');

subplot(3,1,2);
stem(t_auto, auto_reflectivity, 'filled');
title('Auto-Convolution Reflectivity');
xlabel('Time sample');
ylabel('Amplitude');

subplot(3,1,3);
stem(t_recur, refl_recursive, 'filled');
title('Recursive Reflectivity (Physical Model)');
xlabel('Time sample');
ylabel('Amplitude');



%%
% Reflectivity example: 3-layer model (2 interfaces)
clear; 
%close all; 
%clc;

% Define reflection coefficients at interfaces
R = [0.3, -0.2];  % R1 between Layer 1 & 2, R2 between Layer 2 & 3
T = sqrt(1 - R.^2);  % Transmission coefficients

% Time axis (centered around sample 0)
N = 5;  % Length of output series for plotting
t = -(N-1)/2 : (N-1)/2;

% --- Auto-Convolution Reflectivity ---
R_ext = [R(1), R(2), zeros(1, N-3)];
auto_refl = conv(R_ext, R_ext, "full");  % Numerical auto-convolution

% --- Recursive Reflectivity (physical) ---
% We'll place primaries and first-order multiples manually

phys_refl = zeros(1, N);
mid = ceil(N/2);  % Center index

% Primary reflections
phys_refl(mid) = R(1);            % t = 0
phys_refl(mid+1) = T(1)^2 * R(2); % t = +1 (transmitted R2)

% First-order multiple from R2 bouncing back to R1
phys_refl(mid+2) = R(1) * R(2) * T(1)^2;  % t = +2

% --- Plotting ---
figure;

subplot(3,1,1);
stem([0 1], R, 'filled');
title('Original Reflection Coefficients');
xlabel('Interface index');
ylabel('R');

subplot(3,1,2);
stem(t, auto_refl(1:length(t)), 'filled');
title('Auto-Convolved Reflectivity (Wrong Amplitudes)');
xlabel('Time sample');
ylabel('Amplitude');

subplot(3,1,3);
stem(t, phys_refl, 'filled');
title('Recursive Reflectivity (Correct Amplitudes)');
xlabel('Time sample');
ylabel('Amplitude');

sgtitle('Comparison of Auto-Convolution vs Recursive Reflectivity (3-Layer Model)');
