function [dataf,DATAHF] = filterfreqdomain(data,filter)
% FILTERFREQDOMAIN filter in frequency domain
data=data(:);
filter=filter(:);
DATA = fft(data);
nf = length(DATA);
NF = length(filter);
DATAH = DATA(1:nf/2);
DATAHF = DATAH.*filter;
DATAF = [DATAHF;zeros(size(DATAHF))];
m=1:NF-1;
DATAF(NF+1+m)=conj(DATAF(NF+1-m));
dataf = real(ifft(DATAF));
% check symmetry was correct;
maxreal = max(abs(real(ifft(DATAF))));
maximag = max(abs(imag(ifft(DATAF))));
fprintf('real part max is %f, imag part max is %f\n',maxreal,maximag);


end