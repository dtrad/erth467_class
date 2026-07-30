% ==============================================================
% Butterworth band-pass pole-zero map
% ==============================================================

clear; clf
close all

% ----- User parameters
fs  = 2000;       % sampling freq (for context)
fl  = 50;         % low cutoff (Hz)
fh  = 200;        % high cutoff (Hz)
nl  = 2;          % low side (high-pass) order
nh  = 3;          % high side (low-pass) order

% ----- Analog corner rad/s
wl = 2*pi*fl;
wh = 2*pi*fh;

% ----- Low-pass Butterworth poles (unit cutoff)
%   Poles equally spaced on LHP semicircle of radius 1
p_lp = exp( 1j*pi*( (1:2*nh-1)/(2*nh) ) );
p_lp = p_lp(real(p_lp)<0).';   % keep LHP only
p_lp = wh * p_lp;              % scale to cutoff wh

% ----- High-pass Butterworth poles
p_hp = exp( 1j*pi*( (1:2*nl-1)/(2*nl) ) );
p_hp = p_hp(real(p_hp)<0).';   % LHP only
p_hp = wl * p_hp;              % scale to cutoff wl

% ----- Band-pass total poles = union of both
poles = [p_lp; p_hp];

% ----- Zeros
zeros_low  = zeros(nl,1);      % nl zeros at origin (kill DC)
zeros_high = [];               % nh zeros at infinity (not shown)
zeros_all  = [zeros_low;];     % only finite zeros plotted

% ----- Plot
figure(1); clf;
plot(real(poles), imag(poles), 'x','LineWidth',2,'MarkerSize',8); hold on;
if ~isempty(zeros_all)
    plot(real(zeros_all), imag(zeros_all), 'o','LineWidth',1.5,'MarkerSize',8);
end
xlabel('Re\{s\} (rad/s)'); ylabel('Im\{s\} (rad/s)');
title(sprintf('Butterworth Band-Pass Poles & Zeros  (n_l=%d, n_h=%d)', nl, nh));
axis equal; grid on;
line([0 0], ylim, 'Color',[0.4 0.4 0.4],'LineStyle',':');
legend('Poles','Zeros (at s=0)','Location','best');
