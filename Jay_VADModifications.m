% Jay_VADModifications
%-- 9/12/2017 2:19 PM --%


[x,Fs]=audioread('RDRBOW.wav');
figure(1); plot(x);
n = randn(size(x))*0.1*rms(x); %adding noise
figure(1); plot([x n]); %plotting noise and signal
audiowrite('RDRBOW_SNR20.wav', x+n, Fs); %making new wave file with snr of 20
vadG729Example
[x,Fs]=audioread('RDRBOW.wav');
speech
[speech x(1:80)]
dbquit
[x,Fs]=audioread('RDRBOW.wav');
x_rs = resample(x,8000, Fs); % resampling x by changing Fs
audiowrite('RDRBOW_8kHz.wav', x, 8000); %creating new wavefile with resampled freq- should be x_rs instead of x
vadG729Example
[x,Fs]=audioread('RDRBOW.wav');
t = [0:size(x,1)-1]'/Fs; %sample index/Fs to get time
t(1:10)
1/22050
figure(1); plot(t, x); %plots x with correct axis
figure(1); plot(t, x,'-',time_vec, dec_vec,'-'); %plots x but with vad inside
time_vec
audiowrite('RDRBOW_8kHz.wav', x_rs, 8000);
vadG729Example
figure(1); plot(t, x,'-',time_vec, dec_vec,'-');
help interp1
dec_vec_interp = interp1(time_vec, dec_vec, t, 'nearest'); %interpolates to nearest point
figure(1); plot(t, [x dec_vec_interp],'-');