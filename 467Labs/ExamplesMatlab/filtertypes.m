function [A,B,info] = filtertypes(type, fs, varargin)
% DESIGN_IIR_AB  Return IIR filter polynomials A(z), B(z) for common types.
%   F(z) = B(z)/A(z), with z^-1 form.
%
%   [A,B,info] = design_IIR_AB(TYPE, fs, Name,Value,...)
%
%   TYPE ∈ {'lowpass','highpass','bandpass','notch'}  (case-insensitive)
%   fs   : sampling frequency (Hz)
%
%   Name-Value per TYPE:
%   - lowpass/highpass:
%       'fc'   : cutoff (Hz), required
%   - bandpass / notch:
%       'f0'   : center frequency (Hz), required
%       'BW'   : (3 dB) bandwidth (Hz), required
%
%   Common optional:
%       'Plot' : true/false (default false) -> quick magnitude + pole-zero plots
%
%   Outputs:
%     A, B : row vectors of polynomial coefficients in powers of z^-1
%     info : struct with fields (alpha, r, w0, notes, etc.)
%
%   Examples
%     fs = 1000;
%     % 1) First-order LP @ 40 Hz
%     [A,B] = design_IIR_AB('lowpass', fs, 'fc', 40, 'Plot', true);
%
%     % 2) First-order HP (DC-block) @ 1 Hz
%     [A,B] = design_IIR_AB('highpass', fs, 'fc', 1, 'Plot', true);
%
%     % 3) Biquad band-pass: f0=100 Hz, BW=20 Hz
%     [A,B] = design_IIR_AB('bandpass', fs, 'f0', 100, 'BW', 20, 'Plot', true);
%
%     % 4) Notch (band-stop) @ 60 Hz, BW=3 Hz
%     [A,B] = design_IIR_AB('notch', fs, 'f0', 60, 'BW', 3, 'Plot', true);
%
%   Notes
%   - LP/HP share the same pole at z=alpha (0<alpha<1). HP puts a zero at z=1.
%   - BP uses the standard resonator: H(z)=(1-r^2) z^-1 / (1-2r cos w0 z^-1 + r^2 z^-2),
%     which peaks ≈ unity at w0. (No forced zeros at DC/π.)
%   - Notch uses zeros on the unit circle at ±w0 and nearby poles (radius r).
%
%   Author: ChatGPT (for Daniel)

% -------------------- parse
ip = inputParser;
type = lower(string(type));
addRequired(ip,'type');
addRequired(ip,'fs', @(x)isnumeric(x)&&isscalar(x)&&x>0);

% shared
addParameter(ip,'Plot',false,@(x)islogical(x)&&isscalar(x));

% LP/HP
addParameter(ip,'fc',[],@(x)isnumeric(x)&&isscalar(x)&&x>0);

% BP/Notch
addParameter(ip,'f0',[],@(x)isnumeric(x)&&isscalar(x)&&x>0);
addParameter(ip,'BW',[],@(x)isnumeric(x)&&isscalar(x)&&x>0);

parse(ip,type,fs,varargin{:});
P = ip.Results;

info = struct();

% -------------------- designs
switch type
case "lowpass"
    assert(~isempty(P.fc),'For lowpass, provide ''fc'' (Hz).');
    alpha = exp(-2*pi*P.fc/fs);   % pole radius
    % H_lp(z) = (1 - alpha) / (1 - alpha z^-1)
    A = [1, -alpha];
    B = (1 - alpha) * [1];
    info.alpha = alpha;
    info.notes = 'First-order one-pole low-pass; DC gain = 1.';

case "highpass"
    assert(~isempty(P.fc),'For highpass, provide ''fc'' (Hz).');
    alpha = exp(-2*pi*P.fc/fs);   % shared pole radius
    % H_hp(z) = K * (1 - z^-1) / (1 - alpha z^-1), choose K for |H(pi)|=1:
    % K = (1+alpha)/2
    K = (1 + alpha)/2;
    A = [1, -alpha];
    B = K * [1, -1];
    info.alpha = alpha;
    info.K = K;
    info.notes = 'First-order HP; zero at z=1; unity gain at Nyquist.';

case "bandpass"
    assert(~isempty(P.f0) && ~isempty(P.BW), ...
        'For bandpass, provide ''f0'' and ''BW'' (Hz).');
    w0 = 2*pi*P.f0/fs;                 % center (rad/sample)
    r  = exp(-pi*P.BW/fs);             % pole radius from 3-dB BW (rule-of-thumb)
    % Resonator band-pass (unity-ish peak at w0):
    % H_bp(z) = (1 - r^2) z^-1 / (1 - 2 r cos w0 z^-1 + r^2 z^-2)
    A = [1, -2*r*cos(w0), r^2];
    B = (1 - r^2) * [0, 1, 0];         % i.e., (1 - r^2) z^-1
    info.w0 = w0; info.r = r;
    info.notes = 'Biquad resonator BP; peak ≈ 1 at f0, BW set by r.';

case "notch"
    assert(~isempty(P.f0) && ~isempty(P.BW), ...
        'For notch, provide ''f0'' and ''BW'' (Hz).');
    w0 = 2*pi*P.f0/fs;                 % notch freq (rad/sample)
    r  = exp(-pi*P.BW/fs);             % pole radius (controls notch width)
    % Classic notch:
    % H_notch(z) = (1 - 2 cos w0 z^-1 + z^-2) / (1 - 2 r cos w0 z^-1 + r^2 z^-2)
    A = [1, -2*r*cos(w0), r^2];
    B = [1, -2*cos(w0), 1];
    info.w0 = w0; info.r = r;
    info.notes = 'Biquad notch; zeros on unit circle at ±w0; deep narrow notch as r->1.';

otherwise
    error('Unknown TYPE. Use: lowpass, highpass, bandpass, notch.');
end

% shape as row vectors
A = reshape(A,1,[]);
B = reshape(B,1,[]);

% -------------------- optional plots
if P.Plot
    % quick magnitude response
    nfft = 4096;
    [H,w] = freqz(B,A,nfft,'whole');   %#ok<FREQZ>
    f = (w/(2*pi))*fs;
    figure('Name','Magnitude response'); plot(f, 20*log10(abs(H)+eps));
    grid on; xlim([0 fs/2]);
    xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
    title(sprintf('%s: |H(f)|', upper(type)));

    % pole-zero
    figure('Name','Pole-Zero'); zplane(B,A); grid on;
    title(sprintf('%s: pole-zero plot', upper(type)));
end
end
