% Demonstrate that cross-correlation equals convolution with a reversed signal.
% Two short sequences are used to keep the numbers easy to verify by hand.

% 8-point signal
x = [1 2 3 4 5 6 7 8];

% 3-point signal
h = [2 -1 0.5];

% Cross-correlation between x and h (full length)
xc = xcorr(x, h);

% Convolution of x with time-reversed h (fliplr reverses a row vector)
conv_equiv = conv(x, fliplr(h));

% Display results
fprintf('x          = [%s]\n', num2str(x));
fprintf('h          = [%s]\n', num2str(h));
fprintf('xcorr(x,h) = [%s]\n', num2str(xc));
fprintf('conv(x,flip(h)) = [%s]\n', num2str(conv_equiv));

% Verify equality (allow for tiny numerical noise)
max_diff = max(abs(xc - conv_equiv));
fprintf('Max difference: %g\n', max_diff);
if max_diff < 1e-12
    disp('Cross-correlation matches convolution with reversed h.');
else
    disp('Results differ — check definitions.');
end
