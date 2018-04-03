% VAD_Test
% Add SQW Noise to Rainbow passage as a function of the SNR and then apply
% VAD. Make sure to match up the timing of the VAD with the timing of the
% waveform. 
global s;
[x,fs] = audioread('M1ABA7M.wav');

sec = length(x)/fs;
syllable = x;
noise = 3;
proc = 0;
level = 70;
snr = 0; % compute from -20 to +20 in 5db steps
samplerate = 44100;
booth = 2;
HB_gain = 7;
atten = 0;
loaded_stimulus = [];
noise_only = false;

generate_presentations('ABA', noise, proc, level, snr, samplerate, booth, HB_gain, atten, loaded_stimulus, noise_only);

s % Now contains the syllable ABA added to SQW noise
