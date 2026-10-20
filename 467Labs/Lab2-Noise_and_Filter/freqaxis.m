function [freqs,freqhalf] = freqaxis(dt,nt)
% return full freq and half frequency axis (positive frequencies only)

fnyquist = 1/(2*dt); % Nyquist frequency
nf = nt; % number of frequency samples
df = 1/(nf*dt); % frequency sampling interval
freqs = -fnyquist:df:fnyquist-df;
freqhalf = freqs(nf/2+1:nf);
end