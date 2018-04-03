%PreviousVAD_Sample_Runs_Attempt3

function [RDRBOWNoiseOutput] = VAD_Sample_Runs_Attempt3(Filename)
%% This function runs VAD twice- the first time with noise, and the second
% time without noise. The SamplesPerFrame will remain at 80, but the Filename 
% and the SampleRate can be adjusted. Note that the SampleRate for the
% non-noisy and the noisy waveforms will stay the same.
 
% % waveform to be read in
Filename = 'RDRBOW.wav';
[s,Fsignal]=audioread(Filename);
SamplesPerFrame = 80; %Will stay at 80
SampleRate = Fsignal;

% %% VAD
% 
% audioSource = dsp.AudioFileReader('SamplesPerFrame',SamplesPerFrame,... %Modify different SamplesPerFrame Values
%                               'Filename',Filename,... %Place different fileshere 'RDRBOW_8kHz.wav'
%                                'OutputDataType', 'single');
% 
% % Initialize VAD parameters
% VAD_cst_paramattempt2 = vadInitCstParamsattempt2();
% 
% clear vadG729attempt2
% 
% % Takes in filename and finds number of seconds to run the analysis for
% num_Secs = length(s)/Fs;
% 
% block_duration = SamplesPerFrame/SampleRate; % Block duration in seconds -- 80 smaples / block @ SampleRate.
% numBlocks = round(num_Secs / block_duration); 
% % If sample rate is 8000 Hz and block size is 80 then there are 100 blocks/sec.  
% %So, 1000 blocks = 10 sec.
% % Initialize vectors to store the time and decision outputs.
% dec_vec = zeros(numBlocks,1);
% time_vec = zeros(numBlocks,1);
% for blk = 0:numBlocks-1,
%   % Retrieve one block (80 samples = 10 ms @ 8kHz) of speech data from the audio recorder
%   speech = audioSource();
%   % Call the VAD algorithm
%   decision = vadG729attempt2(speech, VAD_cst_paramattempt2);
%   % Plot speech frame and decision: 1 for speech, 0 for silence
%   % Save time/decision of current block.
%   time_vec(blk+1) = blk * block_duration;
%   dec_vec(blk+1) = decision;
% end
% concat_vec = [dec_vec time_vec];
% 
% %% 
% % figure
% % plot(s)
% % title('Filename')
% 
% % sample index/Fs to get time
% t = [0:size(s,1)-1]'/Fs;
% 
% % interpolates to nearest point
% dec_vec_interp = interp1(time_vec, dec_vec, t, 'nearest'); 
% % plots x but with vad inside
% figure(1)
% plot(t, dec_vec_interp, t, s*5);
% title('VAD Without Noise')


%% Gen Pres reassigns variables
samplerate = Fsignal;
sec = length(s)/samplerate;
% syllable = x;
noise = 3;
proc = 'eeq';
level = 70;
snr = 20; % compute from -20 to +20 in 5db steps
booth = 2;
HB_gain = 7;
atten = 0;
loaded_stimulus = s; %set to x
noise_only = false;

[end_sig] = generate_presentations('RDRBOW.wav', noise, proc, level, snr, samplerate, booth, HB_gain, atten, loaded_stimulus, noise_only);
% 
% SampleRate = samplerate;
% Fs = SampleRate;
% FilenameNoise = 'RDRBOWNoiseOutput4.wav';
% class(s_signal); %s_signal is double, so it should  be norm to values in the range of -1.0 and 1.0
% scaled_s_signal = s_signal *0.9999 / max(abs(s_signal))
% % norm_s_signal = s_signal./norm(s_signal); why shouldn't I use this?
% audiowrite('RDRBOWNoiseOutput4.wav', scaled_s_signal, Fs) 
% 
% %% VAD
% 
% audioSource = dsp.AudioFileReader('SamplesPerFrame',SamplesPerFrame,... %Modify different SamplesPerFrame Values
%                               'Filename',FilenameNoise,... %Place different fileshere 'RDRBOW_8kHz.wav'
%                                'OutputDataType', 'single');
% 
% % Initialize VAD parameters
% VAD_cst_paramattempt2 = vadInitCstParamsattempt2();
% 
% clear vadG729attempt2
% 
% % Takes in filename and finds number of seconds to run the analysis for
% num_Secs = length(s_signal)/Fs;
% 
% block_duration = SamplesPerFrame/SampleRate; % Block duration in seconds -- 80 smaples / block @ SampleRate.
% numBlocks = round(num_Secs / block_duration); % If sample rate is 8000 Hz and block size is 80 then there are 100 blocks/sec.  So, 1000 blocks = 10 sec.
% % Initialize vectors to store the time and decision outputs.
% dec_vec = zeros(numBlocks,1);
% time_vec = zeros(numBlocks,1);
% for blk = 0:numBlocks-1,
%   % Retrieve one block (80 samples = 10 ms @ 8kHz) of speech data from the audio recorder
%   speech = audioSource();
%   % Call the VAD algorithm
%   decision = vadG729attempt2(speech, VAD_cst_paramattempt2);
%   % Plot speech frame and decision: 1 for speech, 0 for silence
%   % Save time/decision of current block.
%   time_vec(blk+1) = blk * block_duration;
%   dec_vec(blk+1) = decision;
% end
% concat_vec = [dec_vec time_vec];
% 
% % sample index/Fs to get time
% t = [0:size(s_signal,1)-1]'/samplerate;
% 
% % interpolates to nearest point
% dec_vec_interp = interp1(time_vec, dec_vec, t, 'nearest'); 
% 
% figure(2)
% plot(dec_vec_interp*10^6)
% title('dec vec interp')
% 
% figure(3)
% plot(s_signal/10^5)
% title('s signal')
% % plots x but with vad inside
% figure(4)
% plot(t, s_signal/10^5, t, dec_vec_interp)
% title('VAD With Noise')
% 
% figure(5)
% RMS = @(x) sqrt(mean(x.^2));
% rmssig = RMS(s_signal)
% rmsn = RMS(n)
% new_snr = (RMS(s_signal)/RMS(n))^2
% 
% 

