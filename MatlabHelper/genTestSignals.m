clear 
close all

f = [1000 500 250 125 63];
x = [];
fs = 48000;
len = 2;
dt = 0:len*fs-1;
for kk = 1:length(f)
    x = [x 0.5*sin(2*pi*dt*f(kk)/fs)];
end
audiowrite('AkustikSinusoid.wav',x,fs);

f = [440 220 110 55];
x = [];
fs = 48000;
len = 2;
dt = 0:len*fs-1;
for kk = 1:length(f)
    x = [x 0.5*sin(2*pi*dt*f(kk)/fs)];
end
audiowrite('MusicalSinusoid.wav',x,fs);


