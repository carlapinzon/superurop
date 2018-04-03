% gender: 'F' for female and 'M' for male
% duration in seconds
function vocoded = get_vocoded_speech(num_talkers, gender, duration)
    p = randperm(4);
    speakers = p(1:num_talkers);
    
    % Directory names within 'Shared/Speech_Stimuli/Sentences/Noise_Vocoded_Sentences'
    directories = cell(8,1);
    % Female speakers
    directories{1} = 'CUNY_sentences';
    directories{2} = 'MIT_IEEE_Sentences-Lorraine';
    directories{3} = 'RDRBOW';
    directories{4} = 'House_IEEE_Sentences-Orig_Female_Talker';
    % Male speakers
    directories{5} = 'Harvard_IEEE_Sentences-IEEE_Male_sentences';
    directories{6} = 'MIT_IEEE_Sentences-Ken';
    directories{7} = 'House_IEEE_Sentences-Orig_Male_talker';
    directories{8} = 'HINT_sentences';
    
    Fs = 44100;
    num_samples = int64(Fs*duration);
    added_clips = zeros(num_samples,1);
    
    for i = 1:length(speakers)
       if strcmp(gender,'F') == 1 % Consider female sentences
           name = directories{speakers(i)};
       else % Consider male sentences
           name = directories{speakers(i) + 4};
       end
       
       sig = audioread(sprintf('Sentences/%s.wav', name));
       
       % Randomly select a segment of sig of with the specified duration
       start_point = randi([1, length(sig)-num_samples+1]);
       clip = sig(start_point : start_point+num_samples-1);
       
       % Obtain the RMS of the first signal. The RMS of all other signals
       % will be set to match this one.
       if i == 1
           base_rms = rms(clip);
       end
       
       % Scale the signal to ensure that all have the same RMS
       scale = base_rms / rms(clip);
       added_clips = added_clips + clip*scale;
    end
    
    low_freq = 80;
    high_freq = 8020;
    NBands = 6;
    vocoded = Vocoded_Speech_Signal(added_clips,Fs,low_freq,high_freq,NBands);
end