% Compare the Wiener Deconvolution problem with the least squares problem, which, 
% instead of a filter, obtains the reflectivity directly from the data. 
% Set the two systems of equations and compare what are the requirements on both cases. 
% The Wiener deconvolution problem is better, why?


clear; close all; clc;

% Parameters
dt = 0.001;          % sampling interval (s)
nt = 512;            % number of samples
t = (0:nt-1) * dt;

% --- 1. Synthetic reflectivity: sparse spikes
r_true = zeros(nt, 1);
r_true([50, 120, 250, 400]) = [0.6, -0.4, 0.5, -0.3];

% --- 2. Wavelet: Ricker
f0 = 25;
tw = -0.05:dt:0.05;
w = (1 - 2*(pi*f0*tw).^2) .* exp(-(pi*f0*tw).^2);
nw = length(w);

% --- 3. Generate data by convolution
d = conv(r_true, w, 'same');

% --- 4. Wiener Deconvolution (Filter applied to data to estimate reflectivity)
L = 40;  % Wiener filter length

% Autocorrelation of the data
Rdd = xcorr(d, L, 'biased');
mid = L + 1;
R = toeplitz(Rdd(mid:mid+L-1));

% Assume desired output is spike: crosscorr = first L values of Rdd
rdr = zeros(L,1); rdr(1) = 1;  % ideal autocorrelation with delta desired

% Solve Wiener-Hopf equations
f_wiener = R \ rdr;

% Apply Wiener filter to data
r_wiener = conv(d, f_wiener, 'same');

% --- 5. Least Squares Reflectivity Inversion
% Build convolution matrix W
W = zeros(nt, nt);
half_nw = floor(nw/2);
for i = 1:nt
    for j = 1:nw
        k = i - half_nw + j - 1;
        if k >= 1 && k <= nt
            W(i, k) = w(j);
        end
    end
end

% Solve normal equations: WᵗW r = Wᵗ d
r_ls = (W' * W) \ (W' * d);

% --- 6. Plotting
figure;

subplot(4,1,1);
plot(t, r_true);
title('True Reflectivity');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,2);
plot(t, d);
title('Data (Wavelet * Reflectivity)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,3);
plot(t, r_wiener);
title('Estimated Reflectivity (Wiener Deconvolution)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,4);
plot(t, r_ls);
title('Estimated Reflectivity (Least Squares Inversion)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
