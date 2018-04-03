function VAD_Sample_Runs_Attempt2 = VAD_Sample_Runs_Attempt2(Filename)
% This function runs VAD twice- the first time with noise, and the second
% time without noise. The SamplesPerFrame will remain at 80, but the Filename 
% and the SampleRate can be adjusted. Note that the SampleRate for the
% non-noisy and the noisy waveforms will stay the same.

% 
% % waveform to be read in
Filename = 'RDRBOW.wav';
[s,Fs]=audioread(Filename);
SamplesPerFrame = 80; %Will stay at 80
SampleRate = Fs;
% Fs automatically become Sampling Frequency
VAD_cst_paramattempt2 = vadInitCstParamsattempt2(Fs);


vadG729Example2;

figure
plot(s)
hold on
title('Filename')
% sample index/Fs to get time
t = [0:size(s,1)-1]'/Fs;

% interpolates to nearest point
dec_vec_interp = interp1(time_vec, dec_vec, t, 'nearest'); 
dec_vec;
% plots x but with vad inside
figure(1);
% subplot(311);
plot(t, dec_vec_interp, t, s*5);
% subplot(312);
% plot(s(dec_vec_interp==1));
% subplot(313);
% plot(s(dec_vec_interp~=1));
title('VAD Without Noise')



%adds noise
%n = randn(size(x))*0.1*rms(x); 
%y= x+n;

%reassigns variables
[s,Fs]=audioread(Filename);
samplerate = Fs;
sec = length(s)/samplerate;
% syllable = x;
noise = 3;
proc = 'eeq';
level = 70;
snr = -10; % compute from -20 to +20 in 5db steps
booth = 2;
HB_gain = 7;
atten = 0;
loaded_stimulus = s; %set to x
noise_only = false;

s_signal = generate_presentations('RDRBOW.wav', noise, proc, level, snr, samplerate, booth, HB_gain, atten, loaded_stimulus, noise_only);

SamplesPerFrame = 80; %Will stay at 80
SampleRate = samplerate;

% Fs automatically become Sampling Frequency
VAD_cst_paramattempt2 = vadInitCstParamsattempt2(Fs);

%%VAD_cst_param_modified = vadInitCstParams_modified(samplerate);


s = s_signal;
vadG729Example2;

% sample index/Fs to get time
t = [0:size(s,1)-1]'/samplerate;

% interpolates to nearest point
dec_vec_interp = interp1(time_vec, dec_vec, t, 'nearest'); 
dec_vec;
% plots x but with vad inside
figure();
% subplot(311);
plot(t, dec_vec_interp, t, s*5);
% subplot(312);
%plot(s(dec_vec_interp==1));
%subplot(313);
%plot(s(dec_vec_interp~=1));
title('VAD With Noise')

% 
% % runs VAD again with noise
% Filename_Noisy = 'RDRBOW_Noisy.wav';
% audiowrite(Filename_Noisy, y, Fs)
% 
% 
% [y,Fs]=audioread(Filename_Noisy);
% SamplesPerFrame = 80;
% SampleRate = Fs;
% 
% % rename so will run in VAD function
% Filename = Filename_Noisy;
% 
% % Fs automatically become Sampling Frequency
% VAD_cst_param_modified = vadInitCstParams_modified(Fs);
% 
% % keep SamplesPerFrame = 80
% % change SampleRate to = Fs
% vadG729Example
% 
% dec_vec_interp_y = interp1(time_vec, dec_vec, t, 'nearest'); 
% 
% figure(2);
% subplot(311);
% plot(t, dec_vec_interp_y, t, y*5);
% subplot(312);
% plot(y(dec_vec_interp_y==1));
% subplot(313);
% plot(y(dec_vec_interp_y~=1));
% title('VAD With Noise')
% 
% 
% 
% 
% SampleRate = 8000;
% x_orig = x;
% x8k = resample(x_orig,SampleRate,Fs);
% Filename = 'RDRBOW_8k.wav'
% audiowrite(Filename, x8k, SampleRate);
% VAD_cst_param_modified = vadInitCstParams_modified(SampleRate);
% vadG729Example
% 
% % interpolates to nearest point
% dec_vec_interp_8k = interp1(time_vec, dec_vec, t, 'nearest'); 
% 
% figure(3);
% subplot(311);
% plot(t, dec_vec_interp_8k, t, x_orig*5);
% subplot(312);
% plot(x_orig(dec_vec_interp_8k==1));
% subplot(313);
% plot(x_orig(dec_vec_interp_8k~=1));
% 
% 
% 
