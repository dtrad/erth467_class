% ---------------------------------------------------------------
% Matched filter demo for a noisy digital link (BPSK over AWGN)
% - Pulse shaping: rectangular pulse p[n] (unit energy)
% - Receiver MF: h[n] = time-reversed p[n]
% - Sampling at symbol instants -> decisions -> BER
% ---------------------------------------------------------------
clear;
close all;
rng(1);

% ----- system params
Nsym = 2e4;            % number of symbols (for BER curve)
L    = 8;              % samples per symbol (oversampling)
p    = ones(1,L)/sqrt(L);          % rectangular pulse, unit energy
h    = fliplr(p);                   % matched filter
EbN0dB = 0:2:14;                    % SNR sweep for BER

% ----- generate random BPSK symbols {+1,-1}
a = 2*(rand(1,Nsym)>0.5)-1;

% ----- upsample and shape
u = upsample(a,L);                     % insert L-1 zeros between symbols
s = conv(u,p,'full');                  % transmit waveform

% ----- helper for sampling indices after MF
% Output length after s * h is length(s)+L-1.
% First symbol's peak occurs at index (2*L-1); then every L samples.
idx0 = 2*L-1;
idx  = idx0 : L : idx0 + (Nsym-1)*L;

% ----- BER sweep
ber = zeros(size(EbN0dB));
for k = 1:numel(EbN0dB)
    % Es = Eb for BPSK; choose Es=1 -> Eb/N0 sets N0.
    EbN0   = 10.^(EbN0dB(k)/10);
    N0     = 1/EbN0;                   % since Eb=1
    sigma2 = N0/2;                     % real AWGN per sample (discrete-time)

    w = sqrt(sigma2) * randn(size(s)); % white noise at channel
    r = s + w;                         % received

    % matched filter & sample
    z = conv(r,h,'full');
    z_samp = z(idx);

    % decisions & BER
    a_hat = sign(z_samp);
    ber(k) = mean(a_hat ~= a);
end

% ----- One-shot visualization at a moderate SNR
EbN0dB_show = 6;
EbN0_show   = 10^(EbN0dB_show/10);
N0_show     = 1/EbN0_show; sigma2_show = N0_show/2;
w_show = sqrt(sigma2_show)*randn(size(s));
r_show = s + w_show;
z_show = conv(r_show,h,'full');
z_samp_show = z_show(idx);

figure('Name','Waveforms (example realization)'); clf
t = (0:numel(r_show)-1)/L;
subplot(3,1,1)
plot(t, s); xlim([0, 80/L]); grid on
title('Transmit waveform (pulse-shaped)'); ylabel('s[n]')
subplot(3,1,2)
plot(t, r_show); xlim([0, 80/L]); grid on
title(sprintf('Received = s + w  (E_b/N_0 = %g dB)', EbN0dB_show)); ylabel('r[n]')
subplot(3,1,3)
tt = (0:numel(z_show)-1)/L;
plot(tt, z_show); hold on
stem((idx-1)/L, z_samp_show, 'filled'); xlim([0, 80/L]); grid on
title('Matched-filter output with decision samples'); ylabel('z[n]'); xlabel('symbol time')

% ----- BER curve and theory
Pb_theory = qfunc(sqrt(2*10.^(EbN0dB/10)));  % BPSK over AWGN

figure('Name','BER'); clf
semilogy(EbN0dB, ber, 'o-','LineWidth',1.2); hold on
semilogy(EbN0dB, Pb_theory, '--','LineWidth',1.2);
grid on; xlabel('E_b/N_0 (dB)'); ylabel('BER')
legend('Simulated (MF receiver)','BPSK theory','Location','southwest')
title('Matched filter maximizes SNR at sampling instant → BER approaches theory')


