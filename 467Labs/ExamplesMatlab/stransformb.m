function [S, t, f] = stransformb(x, fs)
%STOCKWELL_TRANSFORM  Stockwell (S-) transform of a 1D signal.
%
%   [S, t, f] = STOCKWELL_TRANSFORM(x, fs)
%
%   x  : input signal (vector, real or complex). Column or row.
%   fs : sampling frequency in Hz.
%
%   S  : complex S-transform matrix, size [Nf x Nt],
%        where Nf = Nt = length(x). Rows = frequencies, columns = time.
%   t  : time axis (seconds), length Nt.
%   f  : frequency axis (Hz), length Nf.
%
%   Definition (continuous):
%   S(tau, f) = ∫ x(t) * (|f|/sqrt(2π)) * exp(-f^2 (t - tau)^2 / 2) ...
%               * exp(-i 2π f t) dt
%
%   Discrete implementation here:
%   1) Compute FFT X(k) of x(t).
%   2) For each analysis frequency f_k, build a Gaussian window
%      in the frequency domain centered at f_k whose width is
%      inversely proportional to |f_k|.
%   3) Multiply X(k) by this Gaussian and IFFT → S(f_k, τ).
%
%   Notes:
%   - The line f = 0 is handled specially (it reduces to the
%     average value of the signal).
%   - This implementation is O(N^2 log N), fine for moderate N.
%   - For large seismic gathers you may want to optimize or parallelize.

    % Ensure column vector
    x = x(:);
    N = length(x);
    if N < 2
        error('Input signal must have length >= 2.');
    end

    % Time and frequency axes
    dt = 1/fs;
    t  = (0:N-1).' * dt;              % column, seconds
    % Standard DFT frequency grid (0..fs-Δf)
    f  = (0:N-1).' * (fs / N);        % column, Hz

    % FFT of the signal
    X = fft(x);

    % Preallocate S-transform matrix
    S = zeros(N, N);                  % complex, [Nf x Nt]

    % Handle DC (f = 0) separately:
    % For f = 0, the Gaussian window becomes infinitely wide.
    % The S-transform at f=0 reduces to the average of x(t).
    S(1, :) = mean(x) * ones(1, N);

    % Small epsilon to avoid division by zero for very low f
    eps_f = 1e-12;

    % Vector of all frequencies once, used inside loop
    f_all = f;  % just to emphasize meaning

    % Main loop over frequencies k = 2..N (skip DC)
    for k = 2:N
        fk = f_all(k);

        % Effective frequency magnitude (avoid divide-by-zero)
        magf = abs(fk) + eps_f;

        % Gaussian window in frequency domain centered at fk:
        %   G_k(f) = exp( -2π^2 * ( (f - fk)^2 ) / fk^2 )
        % i.e. width in f grows with |fk|, giving σ_t ∝ 1/|fk|.
        df        = f_all - fk;               % Hz offset
        Gk        = exp( -2 * pi^2 * (df.^2) / (magf^2) );

        % Apply window to spectrum and IFFT → time-localized component
        Yk        = X .* Gk;
        s_row     = ifft(Yk);                 % length N, time samples

        % Store as row in S: row index = frequency index
        S(k, :)   = s_row.';
    end
end
