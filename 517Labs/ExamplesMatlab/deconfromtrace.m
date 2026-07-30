%Q2 converted to matlab
r2 = [0, 0.5, 0]
w2 = [-0.2, 0.4, -0.2] %Fill in this expression 


%Exercise 2a
Z1 = 1500*1000 %Fill in to calculate impedance (Z1) of layer 1

Z2 = Z1*(1+r2)./(1-r2) %Fill in this formula HINT: use ./ not /

%Exercise 2b
s2 = nonzeros(conv(w2,r2))

Z = [Z1 0 0 0];

for i = 1:length(s2)
    Z(i+1) = Z(i)*(1+s2(i))./(1-s2(i)) %might be too tricky for some students to fill this in
end
Z

%%

%GOPH 559 lab5
% Perform velocity inversion from reflectivity for constant density
% Adjust the the wavelet frequency to get the best match you can between 
% original velocity model and inverted
close all
% velocity model (v velocity, h tickness, r density)

dt=0.001;
v1=1500;h1=100;r1=1;
v2=2600;h2=250;r2=1;
v3=2000;h3=200;r3=1;
v4=3000;h4=200;r4=1;
truemodel=createVel([v1,v2,v3,v4],[h1,h2,h3,h4],dt);

% calculate reflection coefficients
re1=refl(v1,v2,r1,r2,h1,dt);
re2=refl(v2,v3,r2,r3,h2,dt);
re3=refl(v3,v4,r3,r4,h3,dt);
reflectivity=[re1;re2;re3;zeros(floor(h4/v4/dt),1)];

%Wavelet parameters
%Try changing the low and high frequency cut-offs to observe the change in 
%the wavelet, and the effects on the band-limited seismic inversion
f1=5;f2=10;f3=60;f4=70;
[wavelet,twav]=ormsby(f1,f2,f3,f4,0.100,dt);

trace=conv(reflectivity,wavelet,'same');

figure(1)
% Plot the reflectivity function
subplot(311);plot(twav*1000,wavelet);title('true wavelet');xlabel('time (ms)')
axis([-175 175 -0.05 0.1]) %For same scale as other plots
subplot(312);plot(reflectivity);title('true reflectivity');xlabel('time (ms)')
subplot(313);plot(trace);title('seismic trace');xlabel('time (ms)')
figure(gcf);

%Fourier transform of wavelet, reflectivity, trace
nw=length(wavelet);
nr=length(reflectivity);
n=max(nw,nr);
T=fft(trace);
W=fft(wavelet,n);
R=fft(reflectivity,n);

%Frequency spectra
figure(2)
f=freqaxis(dt,n);
subplot(311),plot(f,abs(fftshift(W))),title('wavelet spectrum');xlabel('freq')
subplot(312),plot(f,abs(fftshift(R))),title('reflectivity spectrum');xlabel('freq')
subplot(313),plot(f,abs(fftshift(T))),title('trace spectrum');xlabel('freq')


Rdecon = mydeconv(trace,wavelet);
Rdeconspectrum = fft(Rdecon);
figure(3)
subplot(311);plot(twav*1000,wavelet);title('wavelet');xlabel('time (ms)')
axis([-175 175 -0.05 0.1]) %For same scale as other plots
subplot(312);plot(trace);title('seismic trace');xlabel('time (ms)')
subplot(313),plot(Rdecon),title('deconvolved reflectivity');xlabel('time(ms)')

figure(4)
subplot(311),plot(f,abs(fftshift(W))),title('wavelet spectrum');xlabel('freq')
subplot(312),plot(f,abs(fftshift(T))),title('trace spectrum');xlabel('freq')
subplot(313),plot(f,abs(fftshift(Rdeconspectrum))),title('deconvolved reflectivity');xlabel('time(ms)')

% Perform reflectivity inversion from full band reflectivity
vrecovfull=inversion(v1,reflectivity);
% Perform reflectivity inversion from seismic trace
vrecovbandlim=inversion(v1,trace);

% Perform reflectivity inversion from deconvolved trace
vrecovdecon=inversion(v1,mydeconv(trace,wavelet));


figure(5);
z=1:length(truemodel);
subplot(311);plot(z,truemodel,z,vrecovfull);title('velocity inversion b from full band')
subplot(312);plot(z,truemodel,z,vrecovbandlim);title('velocity inversion b from band limited')
subplot(313);plot(z,truemodel,z,vrecovdecon);title('velocity inversion b from decon')

%figure(gcf)

%figure(5)
%plot(mydeconv(trace,wavelet));
%figure(gcf)


function [model]=createVel(vel,h,dt)
nlayers=length(vel);
model=[];
for i=1:nlayers
    ntimesteps=floor(h(i)/vel(i)/dt);
    model=[model;ones(ntimesteps,1)*vel(i)];
end
length(model);
end

function [vel]=inversion(v1,refl)
vel=ones(size(refl))*v1;
for i=2:length(refl)
    vel(i)=vel(i-1)*(1+refl(i))/(1-refl(i));
end
end

function [c]=mydeconv(a,b)
n=2*length(a);
A=fft(a,n);
B=fft(b,n);
C=(conj(B).*A)./((conj(B).*B)+1e-3); %originally 1e-8
c=real(ifft(C));
c=[zeros(50,1);c(1:(length(a)-50))];

end

% function to calculate reflection coefficients
function [r]=refl(v1,v2,r1,r2,h1,dt)
c=(v2*r2-v1*r1)/(v2*r2+v1*r1);
nzeros=floor((h1/v1)/dt);
r=zeros(nzeros,1);
r(end)=c;
end

% function to calculate wavelet
function w = myricker(dt,f)
nw=4./f/dt;
nw=2*floor(nw/2)+1;
nc=floor(nw/2);
i=1:nw;
alpha=(nc-i+1).*f*dt;
beta=alpha.^2;
w=(1.-beta.*2).*exp(-beta);
w=w(:);
end

function [f]=freqaxis(dt,nt)
% function [f]=freqaxis(dt,nt)
f=(-nt+1)/2:(nt-1)/2;
f=f/(dt*nt);
end
