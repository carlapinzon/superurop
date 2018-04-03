% generate_presentations generates a signal s that meets the conditions
% specified by the parameters.
% syllable: a CVC syllable to load (for example, "APA"); signal you put in-
% we will use sentences, not CVC
% loaded_stimulus: If loaded_stimulus is equal to [], then the program
% loads the syllable parameter. If loaded_stimulus is not equal to [], then
% the program uses the loaded_stimulus parameter instead.
% noise_only: If noise_only is set to true, then, the program generates a
% presentation only of the noise (no speech).
function [s_orig, s_noise, vad, s] = generate_presentations(syllable, noise, proc, level, snr, samplerate, booth, HB_gain, atten, loaded_stimulus, noise_only)
% syllable- sentence that i find; rainbow passage 
% noise 3
% proc: not sure what to do
% level: 70
% fn of snr; -20 to +20 in 5db steps
% sample rate 44100     

% booth 2
% Hb_gain +6
% attentuation 0
% loaded stimulus: sentences thing 
% noise only: true

global MasterSQW;

% Assigning variables to workspace
% noisevars = load('ConstantNoiseVars.mat');
% assignin('base','MasterNoiseBlock',noisevars.MasterNoiseBlock)
% assignin('base','UnRandom',noisevars.UnRandom)
% assignin('base','MasterSQW',noisevars.MasterSQW)
% assignin('base','MasterSAM',noisevars.MasterSAM)

% allows you to specify what level speech- calibration; ignore this
% 70dB of speech

load M:\Experiments\HearingLossSim_2013\HeadphoneCorr\HD580_correction;
if samplerate ~= Fs_g,
	g = resample(g,samplerate,Fs_g);
end
headphone_comp = g;

syllable = upper(syllable);
atten = atten-HB_gain+6;	

% Read in noise
[n, Fsnoise] = audioread('M:\Experiments\HearingLossSim_2013\TFS_Stimuli\consonants\SSN.wav');
n = resample(n(:,1), samplerate, Fsnoise); %makes sure noise is 1 channel
n = n / rms(n); %centers around 0
% figure
% plot(n)
%title('original noise')


% Load the current stimulus
% If noise_only is true, then load APA. This will only be used for its
% length (so that noise can match the length of a syllable).
if noise_only
    [s,Fs] = audioread((['M:\Experiments\HearingLossSim_2013\TFS_Stimuli\consonants\test_stim\M1APA7M.wav']));
    s = resample(s, samplerate, Fs);
% If no loaded_stimulus was passed, then load the syllable.
elseif length(loaded_stimulus) == 0
    [s,Fs] = audioread(['M:\Experiments\HearingLossSim_2013\TFS_Stimuli\consonants\test_stim\M1',syllable,'7M.wav']);
    s = resample(s, samplerate, Fs);
% If a loaded_stimulus was passed, then use it.
else
    s = loaded_stimulus;
end
s = s(:,1);
s_orig = s;

% fcut = 1000*(2^(9.5/3));
% lpf = firpm(256,[0 fcut-300 fcut+300 samplerate/2]/(samplerate/2),[1 1 0 0]);
% lpf = lpf(:);
% s = fftfilt(lpf,s);

% A-weight and calculate level.  Scale signal to be at set.desiredLevel dB A weighted
original_level = 10*log10(mean(s.^2));
s = s / 10^(original_level/20);       % Normalize s to have an energy of 0 dB.  10*log10(mean(s.^2)) should = 0.
s = s*(10^(level/20));                % Scale up to develred level.  10*log10(mean(s.^2)) = level

% Make sure that the noise is longer than the stimulus
duplication_factor = ceil(length(s) / length(n));
n = repmat(n, duplication_factor,1);

% Baseline noise 30 dB SPL
% First choose a random subsection
start = round(rand(1)*(length(n)-length(s)));
baseline_noise = n(start + [1:length(s)]); %makes the noise the same length as s
baseline_noise = baseline_noise/rms(baseline_noise);
baseline_noise = baseline_noise * 10^(30/20);

% add noise
% First select another random segment from the noise for use by 2, 3, 4
% below.
start = round(rand(1)*(length(n)-length(s)));
n_seg = n(start + [1:length(s)]); % Has an rms of 0dB since n has an rms of 0 dB.
n_lev = level - snr;		% Figure out desired noise level
if noise == 1,
    n = baseline_noise;
    % Don't do anything.  No additional noise.
elseif noise == 2,
    % Additional continuous noise.
    n_seg = n_seg / rms(n_seg);
    n = baseline_noise + n_seg * (10^(n_lev/20));
elseif noise == 3, %%%%use noise = 3
    win = sin(2*pi*(10/samplerate)*[0:length(s)-1]' + 2*pi*rand(1));
    win = (sign(win) + 1)/2;    % Make it a raised square wave
    n_seg = win.*n_seg;         % Apply window to noise segment
    n_seg = n_seg / rms(n_seg); % Make n_seg have an rms of 0 dB- want to finish manipulating (e.g., windowing) before finding rms
    n_seg = n_seg * (10^(n_lev/20)); % Make n_seg have an rms of n_lev dB
    10*log10(mean(n_seg.^2));
    %rms(n_seg) = sqrt(mean(n_seg.^2))
    20*log10(rms(n_seg));
    n = baseline_noise + n_seg;
    % n
elseif noise == 4,
    win = sin(2*pi*(10/samplerate)*[0:length(s)-1]' + 2*pi*rand(1));
    win = (win + 1)/2;          % Make it a raised sinusoid
    n_seg = win.*n_seg;         % Apply window to noise segment
    n_seg = n_seg / rms(n_seg); % Make n_seg have an rms of 0 dB
    n = baseline_noise + n_seg * (10^(n_lev/20));
elseif noise == 5 || noise == 6 || noise == 7
    % VC noise
    % Load a block
    if noise == 5
        num_speakers = 1;
    elseif noise == 6
        num_speakers = 2;
    elseif noise == 7
        num_speakers = 4;
    end
    % Random gender
    if randi(2) == 1
        gender = 'M';
    else
        gender = 'F';
    end
    noise_temp = get_vocoded_speech(num_speakers, gender, length(s)/samplerate);
    noise_temp = resample(noise_temp, samplerate, 44100);
    % Scale to desired SPL
    noise_temp = noise_temp/rms(noise_temp);
    n_lev = level - snr;		% Figure out desired noise level
    noise_temp = scale(noise_temp,n_lev);
    % Add in
    n = baseline_noise + noise_temp;        
end

% use unprocessed signal
s_orig = s;
% figure(1)
% plot(s_orig)
% title('Syllable Before Adding Noise')

% new signal; speech plus noise get added together
s = (s(:)+n(:));
s_noise = s;
% figure(2)
% plot(s_noise)
% title('Syllable After Adding Noise')

% figure(12)
% plot(n)
% title('Noise')

s_raw = s;
switch proc
    case {'eeq'}, % where we're doing EEQ
        Tfast = 5;
        Tslow = 200;
        useFIR = false;
        gain_bounds_dB = [0, 20];
        [s_eeq, eeq_scale] = LD_EEQ(s, samplerate, Tfast, Tslow, useFIR, gain_bounds_dB);
                
        % Run VAD on input.  G729 vad assumes inputs in the range of -1 to
        % 1 (i.e., digital audio).  At this point, s is in SPL -- which is
        % large.  We need to scale s down to use in the vad.  Assume that
        % 110 dB SPL <==> +1 in the digital signal.  This means that
        % we can scale the input down by 110 dB.
        use_G729 = false; true;
        if use_G729
            vad_scale = 10^(-110/20);
            vad = vad_decision(s*vad_scale, samplerate);
        else
            vad = pseudo_vad_zerocrossing(s, samplerate);
            vad_samplerate = vad
        end    
        %scaled_vad = vad*5000;
        % close all
%         figure(3)
%         plot(scaled_vad)
%         hold on
%         plot(s_orig)
%         title('VAD With Syllable Before EEQ')
%         hold off
        
        
        scaled_s_signal = s *0.9999 / max(abs(s));
        audiowrite('noise.wav', scaled_s_signal, samplerate);%waveform and spectogram of signal; energy vs time

        
        % Right now, s_eeq = s.*eeq_scale.  This applies the gain
        % indiscriminately.  We only want to appply the gain when the VAD
        % detects a voice.  For this reason, cap eeq_scale(vad==0) = 1.  In
        % other words, whenever vad==0 (i.e., no voice) force the eeq_scale
        % to be one (i.e. do-nothing).
        eeq_scale(vad==0) = min(eeq_scale(vad==0), 1);
        
        % Now apply our revised gain and overwrite s
        s = eeq_scale .* s;        
end


end_sig  = s;
n=n;

% figure(4)
% plot(scaled_vad)
% hold on
% plot(s)
% title('VAD With Syllable After EEQ')
% hold off
% 
% figure(5)
% plot(s_orig)
% hold on
% plot(vad*5000)
% title('Original Syllable')

scaled_s_signal = s *0.9999 / max(abs(s));
audiowrite('eeq1.wav', scaled_s_signal, samplerate);%waveform and spectogram of signal; energy vs time
% plot([1:length(s)]/samplerate,s time vector,s
% dec_vec = 
% plot(t, end_sig/10^5, time_vec, dec_vec)
% plot(t, end_sig/10^5)
% title('final signal')
% xlabel('Time (s)');
% figure(14)
% Nx = length(s);
% nsc = floor(Nx/4.5);
% nov = floor(nsc/2);
% nff = max(256,2^nextpow2(nsc));


% specgram([s_raw; s]);                                               