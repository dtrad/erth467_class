function [X, stages] = fft_radix2_butterfly(x)
%FFT_RADIX2_BUTTERFLY  Iterative radix-2 Cooley–Tukey with stage capture.
%   [X, STAGES] = fft_radix2_butterfly(x)
%   - x: input vector (length N must be a power of 2)
%   - X: FFT result
%   - stages: cell array, stages{s} = data after stage s (stage 0 is bit-reversed input)

    x = x(:);                     % column vector
    N = numel(x);
    assert( N>0 && bitand(N, N-1)==0, 'Length must be a power of 2.' );

    % --- Bit-reversal permutation ---
    br = bitrevorder(0:N-1)+1;    % MATLAB’s built-in bitrevorder indices (+1 for 1-based)
    y  = x(br);

    % Keep all stage outputs for teaching
    stages = cell(1, log2(N)+1);
    stages{1} = y;                % stage 0 (after bit-reversal)

    % --- Iterative butterflies ---
    m = 2;                        % butterfly size
    s = 2;                        % stage counter (stages{2} will be after first butterflies)
    while m <= N
        half = m/2;
        % Twiddle factors for this stage:
        Wm = exp(-1i*2*pi*(0:half-1)'/m);   % column vector of twiddles

        % Process groups of size m
        for k = 1:m:N
            i1 = k : k+half-1;
            i2 = k+half : k+m-1;

            t  = Wm .* y(i2);
            u  = y(i1);

            y(i1) = u + t;        % top output
            y(i2) = u - t;        % bottom output
        end

        stages{s} = y;            % capture after this stage
        s = s + 1;
        m = m * 2;
    end

    X = y;
end
