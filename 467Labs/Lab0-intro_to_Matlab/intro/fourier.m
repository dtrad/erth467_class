% fourier Demonstrate Fourier series approximation of a sawtooth/absolute-value waveform
% This script generates a sawtooth waveform using saw_tooth, then plots the
% original function and successive partial Fourier cosine-series
% approximations (odd harmonics) to illustrate convergence.
% Example: run the script to see plots for M = 1,3,5,7,9.
[x,f] = saw_tooth(101,-2);

subplot(3,2,1),plot(x,f),xlabel('x'),title('f(x)');

a0=2;

x_approx = [-2:.1:2];
f_approx = .5*a0*ones(size(x_approx));
for ii=1:1:5
    M = 2*ii-1;
    a = -8/(M*pi)^2;
    f_approx = f_approx + a*cos(M*pi*x_approx/2);
    t = sprintf('M=%i',M);
    subplot(3,2,ii+1),plot(x_approx,f_approx),xlabel('x'),title(t);
end




