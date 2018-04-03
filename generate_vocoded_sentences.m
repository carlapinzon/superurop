% generate_vocoded_sentences uses the audio files produced by 
% concatenate_sentences as input to Vocoded_Speech_Signal. It writes the
% vocoded outputs into the Noise_Vocoded_Sentences directory.
function generate_vocoded_sentences()
    cd('Sentences/');
    d = dir('*.wav');
    addpath ..
    for i = 1:length(d)
        d(i).name
       [sig,Fs]=audioread(d(i).name);
       env = Vocoded_Speech_Signal(flipud(sig),Fs,80,8020,6);
       audiowrite(['Noise_Vocoded_Sentences/' d(i).name],env,Fs);
    end
end