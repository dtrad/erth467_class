function [X_corr] = Corr_func(data, filter_len, w_min)
%ESTFUNC Summary of this function goes here
%   Detailed explanation goes here
mid = length(data);
dxd = xcorr(w_min);
X_corr = dxd((mid-(filter_len-1)):(mid+filter_len-1));
window=zeros(length(X_corr),1);
start=floor(filter_len/2);
window(start+1:start+filter_len)=hanning(filter_len);
X_corr=X_corr.*window;

end

