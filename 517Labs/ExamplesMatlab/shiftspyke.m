% Move a sample in the frequency domain by applying a linear phase filter
N=128;
dt=0.1;
t=1:N;t=t*dt;
fn=1./(2*dt);
df=1/(N*dt);
x=zeros(1,N);
x(10)=1;
f=0:(N/2);
f=f*df;
% define the frequency axis as the FFT does.
ff=[f -f(end-1:-1:2)];
sprintf("the freq axis has the same length as N: %d",max(size(ff)))

% The linear phase can be applied on the full axis to get a full filter
Y=(fft(x).*exp(-i*ff*10));
y=ifft(Y);

% or, we can design a filter that only works on the positive frequencies
%y=ifft(duplic(Y(1:64)));

subplot(211);plot(t,x,'-b',t,real(y),'-r');
xlabel('time')
legend('before','after')
title('spike moved 10 units to the right')

subplot(212);plot(t,real(y),'-r',t,imag(y),'g-')
legend('real','imaginary')
xlabel('time')
title('the imaginary part should be zero')
figure(gcf);