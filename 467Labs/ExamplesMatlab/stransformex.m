close all
clear

% set default figure position
screenSize = get(0, 'ScreenSize');
set(0, 'DefaultFigurePosition', [50, screenSize(4)-400-200, 600-100, 400-100]);

% --- Signal ---
% x = sin(2*pi*100*t) + sin(2*pi*300*t.*(t>0.5));
% fs = 1000;
% t = 0:1/fs:1;
fs = 1000;
t = 0:1/fs:1;
x = sin(2*pi*100*t) + sin(2*pi*300*t.*(t>0.5));

% plot signal in time domain
figure;
plot(t,x);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');   


fmin=10;
fmax=350;
nft=256;

% --- STransform --- James Irving version
[S,f]=stransform3(x,t,nft,fmin,fmax);
figure;
imagesc(t,f,abs(S));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('S-transform magnitude |S(f,t)|');
colorbar;
figure(gcf);


% Compute S-transform with second verson 
[S, tt, ff] = stransformb(x, fs);

% Plot magnitude
figure;
imagesc(tt, ff, abs(S));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('S-transform magnitude |S(f,t)|');
colorbar;

% Optional: limit frequency axis for nicer display
ylim([0 fmax]);

%% example 2 
x = chirp(t,100,1,300,'linear');

% plot signal in time domain
figure;
plot(t,x);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');   


% --- STransform --- James Irving version
[S,f]=stransform3(x,t,nft,fmin,fmax);
figure;
imagesc(t,f,abs(S));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('S-transform magnitude |S(f,t)|');
colorbar;
figure(gcf);


% Compute S-transform with second verson 
[S, tt, ff] = stransformb(x, fs);

% Plot magnitude
figure;
imagesc(tt, ff, abs(S));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('S-transform magnitude |S(f,t)|');
colorbar;
ylim([0 fmax]);

