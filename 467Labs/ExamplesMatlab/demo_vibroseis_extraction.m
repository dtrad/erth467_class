% ---------------------------------------------------------------
% Vibroseis simulation and signal extraction with known source
% - Build LFM sweep s(t) from f1->f2 (Klauder autocorrelation)
% - Convolve reflectivity r with s; add noise -> d
% - (A) Matched filter: correlate d with time-reversed s => r * (s ⊗ s)
% - (B) Deterministic decon: R̂ = F^{-1}{ S*(w) / (|S(w)|^2 + λ) * D(w) }
% ---------------------------------------------------------------
clear;
close all;
rng(0);

% ---- Parameters
fs   = 500;            % Hz
dt   = 1/fs;
Tsw  = 8.0;            % sweep length (s)
f1   = 10;             % Hz
f2   = 120;            % Hz
Trec = 6.0;            % record length (s) (reflectivity support)
Nsw  = round(Tsw*fs);
Nrec = round(Trec*fs);

% ---- Build linear FM sweep (phase-integrated)
t  = (0:Nsw-1)*dt;
phi = 2*pi*( f1*t + 0.5*(f2-f1)/Tsw * t.^2 );   % instantaneous phase
s   = sin(phi).';                                % column vector
% Normalize sweep energy
s = s / norm(s);

% ---- Synthetic reflectivity (sparse spikes)
r = zeros(Nrec,1);
idx = round([0.35 0.9 1.6 2.3 3.0 3.8 4.6 5.2]*fs);
amp = [ 0.7 -0.4 0.5 0.3 -0.6 0.25 0.4 -0.35 ];
r(idx) = amp;

% ---- Data: d = r * s + noise
d_clean = conv(r,s,'full');
SNRin_dB = -3;                                        % tough case
sigma = rms(d_clean) / (10^(SNRin_dB/20));
d = d_clean + sigma*randn(size(d_clean));

% ---- (A) Matched filtering (time reversal of s)
hMF = flipud(s);
yMF = conv(d, hMF,'full');                            % correlation output
klauder = xcorr(s,s);                                 % Klauder wavelet (for reference)

% ---- Deconvolve Klauder from matched filter output
Nfft_yMF = 2^nextpow2(length(yMF));
K = fft(klauder, Nfft_yMF);
YMF = fft(yMF, Nfft_yMF);
lambda_klauder = 0.02;
Hklauder = conj(K) ./ (abs(K).^2 + lambda_klauder);   % stabilized inverse Klauder
r_mfdeconv_full = ifft(Hklauder .* YMF, 'symmetric');
idx0 = round((length(klauder)+1)/2);                  % zero-lag of Klauder
r_mfdeconv = r_mfdeconv_full(idx0:idx0+length(r)-1);  % trim to reflectivity support

% ---- (B) Deterministic decon with known sweep
% Pad to the same FFT size
Nfft = 2^nextpow2(length(d));
S = fft(s, Nfft);
D = fft(d, Nfft);

% Tikhonov (Wiener-like) stabilizer
lambda = 0.02;                                        % tweak as needed
G = conj(S) ./ (abs(S).^2 + lambda);                  % inverse of sweep
Rhat = ifft(G .* D, 'symmetric');                     % reflectivity estimate (long)
rhat = Rhat(1:length(r));                             % trim to target support

% ---- Plots
t_r   = (0:length(r)-1)*dt;
t_d   = (0:length(d)-1)*dt;
t_yMF = (0:length(yMF)-1)*dt;
t_sw  = (0:length(s)-1)*dt;

figure('Name','Vibroseis & Extraction'); clf
subplot(4,1,1)
plot(t_sw, s); grid on; xlim([0 Tsw])
title(sprintf('Known LFM sweep  f1=%g Hz → f2=%g Hz, T=%.1fs', f1,f2,Tsw))
ylabel('s(t)')

subplot(4,1,2)
plot(t_r, r, 'k'); hold on
plot(t_d, d/max(abs(d))*0.8, 'r'); grid on
xlim([0 Trec+Tsw]); ylim([-1.1 1.1])
title(sprintf('Reflectivity r(t) (black) and noisy data d(t) (red, scaled), SNR=%.1f dB', SNRin_dB))
ylabel('amp')

subplot(4,1,3)
plot(t_yMF, yMF/max(abs(yMF)), 'b'); grid on
xlim([0 Trec+2*Tsw]); ylim([-1.1 1.1])
title('Matched filter output  y_{MF}(t) = d ⊗ s  (≈ r convolved with Klauder)')
ylabel('corr')

subplot(4,1,4)
plot(t_r, r, 'k','LineWidth',1.2); hold on
plot(t_r, rhat, 'm'); grid on
plot(t_r, r_mfdeconv, 'b');
xlim([0 Trec]); ylim([min(-1,min(rhat)-0.1) max(1,max(rhat)+0.1)])
legend('true r','decon r̂','MF decon','Location','best')
title(sprintf('Deterministic decon (stabilized inverse):  \\lambda = %.3g', lambda))
xlabel('Time (s)'); ylabel('amp')

% ---- Spectral glance (optional)
figure('Name','Spectra'); clf
[Sw,f] = pwelch(s, hamming(round(0.5*fs)), [], [], fs);
[Dw,~] = pwelch(d, hamming(round(0.5*fs)), [], [], fs);
[Rw,~] = pwelch(rhat, hamming(round(0.5*fs)), [], [], fs);
plot(f, 20*log10(Sw/max(Sw)),'k','LineWidth',1.1); hold on
plot(f, 20*log10(Dw/max(Dw)),'r'); 
plot(f, 20*log10(Rw/max(Rw)),'m'); grid on; xlim([0 fs/2])
legend('|S|','|D|','|R̂|'); ylabel('dB (norm)'); xlabel('Hz')
title('Spectral view: sweep, data, recovered reflectivity')

% ---- Print a quick note on Klauder width
[acSW,lag] = xcorr(s,'coeff');
[~,k0] = max(acSW);
% approx main-lobe half-width by first zero-crossing around center
kz = k0 + find(acSW(k0:end)<0,1,'first'); 
if ~isempty(kz)
    fprintf('Klauder main-lobe ~ %.1f ms (rough)\n', 1e3*abs(lag(kz)-lag(k0))*dt);
end
