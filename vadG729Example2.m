%% G.729 Voice Activity Detection
% This example shows how to implement the ITU-T G.729 Voice Activity 
% Detector (VAD)

% Copyright 2015-2016 The MathWorks, Inc.

%% Introduction
% Voice Activity Detection (VAD) is a critical problem in many speech/audio
% applications including speech coding, speech recognition or speech 
% enhancement. For instance, the ITU-T G.729 standard uses VAD modules to 
% reduce the transmission rate during silence periods of speech.

%% Algorithm
% At the first stage, four parametric features are extracted from the input
% signal. These parameters are the full-band and low-band frame energies,
% the set of line spectral frequencies (LSF) and the frame zero crossing
% rate. If the frame number is less than 32, an initialization stage of the
% long-term averages takes place, and the voice activity decision is forced
% to 1 if the frame energy from the LPC analysis is above 21 dB. Otherwise,
% the voice activity decision is forced to 0. If the frame number is equal
% to 32, an initialization stage for the characteristic energies of the
% background noise occurs.
%
% At the next stage, a set of difference parameters is calculated. This 
% set is generated as a difference measure between the current frame 
% parameters and running averages of the background noise characteristics. 
% Four difference measures are calculated:
%
%  a) A spectral distortion
%
%  b) An energy difference
%
%  c) A low-band energy difference
%
%  d) A zero-crossing difference
%
% The initial voice activity decision is made at the next stage, using 
% multi-boundary decision regions in the space of the four difference 
% measures. The active voice decision is given as the union of the decision
% regions and the non-active voice decision is its complementary logical 
% decision. Energy considerations, together with neighboring past frames 
% decisions, are used for decision smoothing. The running averages have to 
% be updated only in the presence of background noise, and not in the
% presence of speech. An adaptive threshold is tested, and the update takes
% place only if the threshold criterion is met.

%% VAD Implementation
% <matlab:edit('vadG729') vadG729> is the function containing the
% algorithm's implementation. 

%% Initialization
% Set up an audio source. This example uses an audio file reader.
%audioSource = dsp.AudioFileReader('SamplesPerFrame',80,...
%                              'Filename','speech_dft_8kHz.wav',...
%                               'OutputDataType', 'single');
SamplesPerFrame = 80
audioSource = dsp.AudioFileReader('SamplesPerFrame',SamplesPerFrame,... %Modify different SamplesPerFrame Values
                              'Filename',Filename,... %Place different fileshere 'RDRBOW_8kHz.wav'
                               'OutputDataType', 'single');
% Note: You can use a microphone as a source instead by using an audio
% device reader (NOTE: audioDeviceReader requires an Audio System Toolbox
% (TM) license)
% audioSource = audioDeviceReader('OutputDataType', 'single', ...
%                              'NumChannels', 1, ...
%                              'SamplesPerFrame', 80, ...
%                              'SampleRate', 8000);
% Create a time scope to visualize the VAD decision (channel 1) and the
% speech data (channel 2)


% SampleRate = 22050
scope = dsp.TimeScope(2, 'SampleRate', [SampleRate], ... 
                      'BufferLength', 781038, ... #781038
                      'YLimits', [-0.3 1.1], ...
                      'ShowGrid', true, ...
                      'FrameBasedProcessing', true, ...
                      'TimeSpan', 40, ...
                      'Title','Decision speech and speech data', ...
                      'TimeSpanOverrunAction','Scroll');

%% Stream Processing Loop

% Initialize VAD parameters
VAD_cst_param = VAD_cst_paramattempt2
%function VAD_cst_paramattempt2 = vadInitCstParamsattempt2(Fs)

clear vadG729attempt2

% Takes in filename and finds number of seconds to run the analysis for
[s,Fy]=audioread(Filename);


num_Secs = length(s)/Fy;

block_duration = SamplesPerFrame/SampleRate; % Block duration in seconds -- 80 smaples / block @ SampleRate.
numBlocks = round(num_Secs / block_duration); % If sample rate is 8000 Hz and block size is 80 then there are 100 blocks/sec.  So, 1000 blocks = 10 sec.
% Initialize vectors to store the time and decision outputs.
dec_vec = zeros(numBlocks,1);
time_vec = zeros(numBlocks,1);
for blk = 0:numBlocks-1,
  % Retrieve one block (80 samples = 10 ms @ 8kHz) of speech data from the audio recorder
  speech = audioSource();
  % speech = s;
  %speech = x
  % Call the VAD algorithm
  decision = vadG729attempt2(speech, VAD_cst_paramattempt2);
  % Plot speech frame and decision: 1 for speech, 0 for silence
  % scope(decision, speech);
  % Save time/decision of current block.
  time_vec(blk+1) = blk * block_duration;
  dec_vec(blk+1) = decision;
end
release(scope);
concat_vec = [dec_vec time_vec]

%% Cleanup
% Close the audio input device and release resources
release(audioSource);

%% Generating and Using the MEX-File
% MATLAB Coder can be used to generate C code for the function <matlab:edit('vadG729') vadG729>. 
% In order to generate a MEX-file, execute the following command.
% codegen vadG729 -args {single(zeros(80,1)), coder.Constant(VAD_cst_param_modified)} 

%% Speed Comparison
% Creating MEX-Files often helps achieve faster run-times for simulations.
% The following lines of code first measure the time taken by the MATLAB
% function and then measure the time for the run of the corresponding
% MEX-file. Note that the speedup factor may be different for different
% machines.
% audioSource = dsp.AudioFileReader('speech_dft_8kHz.wav', ...
%                               'SamplesPerFrame', 80, ...
%                               'OutputDataType', 'single');
% clear vadG729
% VAD_cst_param_modified = vadInitCstParams_modified;                          
% tic;
% while ~isDone(audioSource)
%   speech = audioSource();
%   decision = vadG729(speech, VAD_cst_param_modified);
% end
% t1 = toc;
% 
% reset(audioSource);
% 
% tic;
% while ~isDone(audioSource)
%   speech = audioSource();
%   decision = vadG729_mex(speech, VAD_cst_param_modified);
% end
% t2 = toc;
% 
% disp('RESULTS:')
% disp(['Time taken to run the MATLAB code: ', num2str(t1), ' seconds']);
% disp(['Time taken to run the MEX-File: ', num2str(t2), ' seconds']);
% disp(['Speed-up by a factor of ', num2str(t1/t2),...
%     ' is achieved by creating the MEX-File']);

%% Reference 
% ITU-T Recommendation G.729 - Annex B: A silence compression scheme for 
% G.729 optimized for terminals conforming to ITU-T Recommendation V.70

displayEndOfDemoMessage(mfilename)
