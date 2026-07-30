% DEMO_BUTTERFLY_FFT  Run and visualize the radix-2 butterfly.
clear; clc;

% Example input (feel free to change):
N = 8;                                           % must be power of 2
n = (0:N-1).';
x = cos(2*pi*(1/N)*n) + 0.5*sin(2*pi*(2/N)*n);   % real test signal

% Compute our FFT and compare to MATLAB’s fft:
[X, stages] = fft_radix2_butterfly(x);
Xref = fft(x);

fprintf('Max abs diff vs fft(): %g\n', max(abs(X - Xref)));

% --------- Simple butterfly diagram (data flow only) ----------
% This shows stage-by-stage layout (no numeric labels to keep it clean).
S = numel(stages);               % = log2(N)+1
figure('Color','w'); hold on;
title(sprintf('Butterfly Data Flow (N=%d, %d stages)', N, S-1));
axis off;

xgap = 1.2;
ygap = 1.0;

% Node positions
pos = zeros(S, N, 2);            % (stage, row, [x y])
for s = 1:S
    for r = 1:N
        pos(s,r,1) = (s-1)*xgap;
        pos(s,r,2) = -(r-1)*ygap;
    end
end

% Draw nodes
for s = 1:S
    for r = 1:N
        plot(pos(s,r,1), pos(s,r,2), 'o', 'MarkerSize', 6, 'MarkerFaceColor',[0.6 0.8 1], 'MarkerEdgeColor',[0.3 0.3 0.3]);
    end
end

% Draw stage connections (explicit butterflies)
for s = 2:S
    m = 2^(s-1);     % butterfly size at this stage
    half = m/2;
    % groups of size m
    for k = 1:m:N
        i1 = k : k+half-1;
        i2 = k+half : k+m-1;

        % straight-through lines
        for idx = 1:half
            r1 = i1(idx); r2 = i2(idx);
            % straight edges
            plot([pos(s-1,r1,1) pos(s,r1,1)], [pos(s-1,r1,2) pos(s,r1,2)], '-','Color',[0.6 0.6 0.6]);
            plot([pos(s-1,r2,1) pos(s,r2,1)], [pos(s-1,r2,2) pos(s,r2,2)], '-','Color',[0.6 0.6 0.6]);

            % cross edges (to suggest combine/split)
            plot([pos(s-1,r1,1) pos(s,r2,1)], [pos(s-1,r1,2) pos(s,r2,2)], '-','Color',[0.5 0.5 0.5]);
            plot([pos(s-1,r2,1) pos(s,r1,1)], [pos(s-1,r2,2) pos(s,r1,2)], '-','Color',[0.5 0.5 0.5]);
        end
    end
end

% Optional: annotate stage labels
for s = 1:S
    text(pos(s,1,1), pos(s,1,2)+0.7*ygap, sprintf('Stage %d', s-1), 'HorizontalAlignment','center', 'FontWeight','bold');
end

% --------- Print a few butterflies with twiddle factors ----------
fprintf('\nSample butterfly details from Stage 1 (size-2 butterflies):\n');
fprintf('Top = u + t,  Bottom = u - t,  t = W_m^k * bottom_input\n\n');

% Illustrate stage 2 (first butterfly stage) formulas for the first group:
m = 2; half = 1;
Wm = exp(-1i*2*pi*(0:half-1)'/m);
k = 1;                          % first group
i1 = k : k+half-1;
i2 = k+half : k+m-1;

u = stages{1}(i1);              % stage 0 output (bit-reversed input)
bt = stages{1}(i2);
t = Wm .* bt;

top_out    = u + t;
bottom_out = u - t;

disp(table(u, bt, t, top_out, bottom_out, 'VariableNames', ...
    {'u','bottom_in','t=W_m^k*bottom','top_out','bottom_out'}));
