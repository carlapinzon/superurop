function [s_orig, s_noise, scaled_vad, s] = VAD_Sample_Runs_Attempt3(syllable, noise, level, snr)
%% This function runs VAD twice- the first time with noise, and the second
% time without noise. The SamplesPerFrame will remain at 80, but the Filename 
% and the SampleRate can be adjusted. Note that the SampleRate for the
% non-noisy and the noisy waveforms will stay the same.
 
% % waveform to be read in
% syllable = 'ABA';
[s, Fsignal] = audioread(['M:\Experiments\HearingLossSim_2013\TFS_Stimuli\consonants\test_stim\M1',syllable,'7M.wav']);
SamplesPerFrame = 80; %Will stay at 80
% SampleRate = Fsignal;


%% Gen Pres reassigns variables
samplerate = Fsignal;
sec = length(s)/samplerate;
syllable = s;
%noise = 3;
proc = 'eeq';
%level% = 70;
%snr = 20; % compute from -20 to +20 in 5db steps
booth = 2;
HB_gain = 7;
atten = 0;
loaded_stimulus = s; %set to x
noise_only = false;

[s_orig, s_noise, scaled_vad, s] = generate_presentations(syllable, noise, proc, level, snr, samplerate, booth, HB_gain, atten, loaded_stimulus, noise_only);
