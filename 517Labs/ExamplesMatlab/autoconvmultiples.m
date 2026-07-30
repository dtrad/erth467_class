%% Multiples from auto-convolution of primaries (1-D, normal incidence)

clear; close all; clc

% ---- Time axis
dt  = 0.001;          % s
nt  = 400;
t   = (0:nt-1).' * dt;

% ---- Primary reflectivity: a few interfaces (times in samples)
r = zeros(nt,1);
idx = [50, 120, 200];        % sample indices (i.e., 0.05 s, 0.12 s, 0.20 s)
amp = [ 0.30, -0.20, 0.25];  % primary reflection coefficients
r(idx) = amp;

% ---- Build multiples via auto-convolution (2nd and 3rd order)
m2_full = conv(r, r, 'full');                 % length = 2*nt-1
m3_full = conv(conv(r, r, 'full'), r, 'full');

% Center back to original length for display (like 'same' but explicit)
trim = @(x) x( floor((length(x)-nt)/2)+1 : floor((length(x)-nt)/2)+nt );
m2 = trim(m2_full);
m3 = trim(m3_full);

% ---- Total reflectivity with up to 3rd order
R  = r + m2 + m3;

% ---- A zero-phase Ricker wavelet
f0   = 25;                 % Hz
Tw   = 0.128;              % wavelet length
tw   = (-Tw/2:dt:Tw/2).';
pi2f2t2 = (pi*f0*tw).^2;
w    = (1 - 2*pi2f2t2).*exp(-pi2f2t2);

% ---- Convolve to make seismic traces
d_primary = conv(r,  w, 'same');
d_m2      = conv(m2, w, 'same');
d_m3      = conv(m3, w, 'same');
d_total   = conv(R,  w, 'same');

% ---- Plot reflectivities
figure('Color','w','Position',[100 100 900 700])

subplot(2,2,1)
stem(t, r, 'filled'); grid on
xlabel('Time (s)'); ylabel('Amplitude')
title('Primary reflectivity r(t)')

subplot(2,2,2)
stem(t, m2, 'filled'); grid on
xlabel('Time (s)'); ylabel('Amplitude')
title('Second-order multiples m_2(t) = r*r')

subplot(2,2,3)
stem(t, m3, 'filled'); grid on
xlabel('Time (s)'); ylabel('Amplitude')
title('Third-order multiples m_3(t) = r*r*r')

subplot(2,2,4)
stem(t, R, 'filled'); grid on
xlabel('Time (s)'); ylabel('Amplitude')
title('Total reflectivity R \approx r + m_2 + m_3')

% ---- Plot data traces (wavelet-convolved)
figure('Color','w','Position',[100 100 900 600])
plot(t, d_total, 'k-', 'LineWidth',1.2); hold on
plot(t, d_primary, 'b--', 'LineWidth',1)
plot(t, d_m2, 'r-.', 'LineWidth',1)
plot(t, d_m3, 'g:', 'LineWidth',1)
grid on; xlim([0 t(end)])
xlabel('Time (s)'); ylabel('Amplitude')
title('Seismic traces (wavelet * reflectivity components)')
legend('Total','Primary','2^{nd}-order mult.','3^{rd}-order mult.','Location','best')

% ---- (Optional) Show where m2 spikes should land by t_i + t_j
ti = idx*dt;  % primary times
pairs = sort(ti(:) + ti(:).');  % all t_i + t_j (including i=j)
pairs = unique(pairs(:));
disp('Candidate 2nd-order multiple times (s):')
disp(pairs.' )
