
function B = butterworth_bandpass(f, fh, fl, nh, nl)
%BUTTERWORTH_BANDPASS Butterworth bandpass frequency response.
%
% B = butterworth_bandpass(f, fh, fl, nh, nl)
%
% Inputs:
%   f  - Frequency vector (Hz)
%   fh - Lower cutoff frequency (Hz)
%   fl - Upper cutoff frequency (Hz)
%   nh - High-pass order
%   nl - Low-pass order
%
% Output:
%   B  - Real-valued bandpass amplitude response
%
% The response is the product of a Butterworth
% high-pass and low-pass amplitude response.

if fh <= 0 || fl <= fh
    error('Require 0 < fh < fl.');
end

f = abs(f);  % Allow positive and negative frequencies

% High-pass Butterworth response
Bh = 1 ./ sqrt(1 + (fh ./ max(f, eps)).^(2*nh));

% Low-pass Butterworth response
Bl = 1 ./ sqrt(1 + (f ./ fl).^(2*nl));

% Bandpass response
B = Bh .* Bl;

% Exact zero-frequency response
B(f == 0) = 0;
end
