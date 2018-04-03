% concatenate_sentences reads the audio files from 8 different directories
% and concatenates 5 minutes worth of randomly chosen files into one large
% file, which is written in the Sentences directory. The individual audio
% files are first clipped to remove silence at the beginning and end and
% are then passed through window functions to smooth the transition between
% sentences.
function concatenate_sentences()
    % The sampling rate to use for all the sentences
    Fs = 44100;
    % The cutoff frequency of the lowpass filter used on the sentences
    filter_cutoff = 10; 
    % Amount of silence in seconds to leave between sentences
    padding = 0.1; 
    % The length of the file of concatenated sentences in samples
    max_concat_length = 2 * 60 * Fs;
    
    % Directory names within 'Shared/Speech_Stimuli/Sentences'
    directories = {};
    % Female speakers
    directories{end+1,1} = 'CUNY_sentences';
    directories{end+1,1} = 'MIT_IEEE_Sentences/Lorraine';
    directories{end+1,1} = 'RainbowPassage/Unprocessed';
    directories{end+1,1} = 'House_IEEE_Sentences/Orig_Female_Talker';
    % Male speakers
    directories{end+1,1} = 'Harvard_IEEE_Sentences/IEEE_Male_sentences';
    directories{end+1,1} = 'MIT_IEEE_Sentences/Ken';
    directories{end+1,1} = 'House_IEEE_Sentences/Orig_Male_talker';
    directories{end+1,1} = 'HINT_sentences';
    
    for dd = 1:numel(directories)
        dir_path = sprintf('../../Shared/Speech_Stimuli/Sentences/%s/',directories{dd});
        if strcmp(directories{dd},'RainbowPassage/Unprocessed') % Deal with rainbow passage separately
            rainbow(dir_path);
            continue;
        elseif strcmp(directories{dd},'HINT_sentences') % Account for the different structure of the HINT_sentences directory
            d_perm = randperm(260) + 9;
        else
            d = dir([dir_path '*.wav']);
            d_perm = d(randperm(length(d)));
        end
        
        x_concat = [];

        % Define the parameters of the window function to be used in between sentences
        y = (1:4410)' * (pi/4410);
        window_down = sqrt(.5 * cos(y) + .5);
        window_up = sqrt(.5 * -cos(y) + .5);
        prev_sig_end = zeros(Fs*padding,1);

        for i = 1:numel(d_perm)
            if length(x_concat) > max_concat_length
                break;
            end
            
            if strcmp(directories{dd},'HINT_sentences')
                name = sprintf('List_%i\\%03d.wav', fix(d_perm(i)/10), d_perm(i));
            else
                name = d_perm(i).name;
            end
            
            [x_temp,Fs_temp] = audioread([dir_path,name]);
            x_temp = x_temp(:,1);
            x = resample(x_temp,Fs,Fs_temp);
            x = x * 0.1 / rms(x);
            x = x-mean(x); % Cancel out any consistent DC offset

            % For HINT, add 100 msec of inter-gap noise to start and end
            if strcmp(directories{dd},'HINT_sentences')
                ramp_on = 0.5 - 0.5*cos((0:256)'*pi/256);
                ramp_off = 1-ramp_on;
                ramp_on = sqrt(ramp_on);
                ramp_off = sqrt(ramp_off);
                x(1:257) = x(1:257).*ramp_on;
                x(end-256:end) = x(end-256:end).*ramp_off;
                % load noise
                [n,Fs_n] = audioread('gap_noise.wav');
                block_len = 0.5*Fs_n;
                n_block = n(round((length(n)-block_len-10)*rand(1))+(1:block_len));
                n_start = n_block(1:0.1*Fs_n);
                n_end = n_block(end-0.1*Fs_n+1:end);
                n_start(end-256:end) = n_start(end-256:end).*ramp_off;
                n_end(1:257) = n_end(1:257).*ramp_on;
                x(1:257) = x(1:257) + n_start(end-256:end);
                x(end-256:end) = x(end-256:end) + n_end(1:257);
                x = [n_start(1:end-257);x;n_end(258:end)];
            end
            
            [B,A] = butter(3, filter_cutoff/(Fs/2));
            x_db = 20 * log10(max(0, filtfilt(B, A, abs(x))));

            % Find the first place where x_db >= -35
            i1 = find(x_db >= -35, 1); 
            % Find the last place where x_db < -40 before x_db >= -35 for first time
            start_point = find(x_db(1:i1) < -48, 1, 'last');
            % Find the last place where x_db >= -35
            i2 = find(x_db >= -35, 1, 'last');
            % Find the first place where x_db <= -40 after x_db >= -35 for last time
            end_point = find(x_db(i2:end) <= -48, 1, 'first') + i2 - 1;

            % x(start_point:end_point) is the portion of the sentence that we
            % are interested in keeping. The next part of the code is concerned
            % with creating a separation of length Fs*padding in between the
            % sentences. The end of the previous sentence is passed through a
            % decreasing window, and the beginning of the current sentence is
            % passed through an increasing window.

            % Get Fs*padding samples of the sentence before the part being kept
            i_start = max(1, start_point - Fs*padding);
            curr_sig_start = x(i_start : start_point - 1);
            % Ensure that the signal has Fs*padding entries
            curr_sig_start = padarray(curr_sig_start, Fs*padding-length(curr_sig_start),'post');

            % TODO: Does this need to be normalized?
            transition_sig = (prev_sig_end .* window_down) + (curr_sig_start .* window_up);
            x_concat = [x_concat; transition_sig; x(start_point:end_point)];

            % Modify prev_sig_end to be the end of this sentence
            i_end = min(length(x), end_point + Fs*padding);
            prev_sig_end = x(end_point + 1 : i_end);
            % Ensure that the signal has Fs*padding entries
            prev_sig_end = padarray(prev_sig_end, Fs*padding-length(prev_sig_end),'post');
        end  
        audiowrite(['Sentences/' strrep(directories{dd},'/','-') '.wav'],x_concat,Fs);
    
    end
    
end

function rainbow(dir_path)
    [x_temp,Fs_temp] = audioread([dir_path 'RDRBOW.WAV']);
    Fs = 44100;
    filter_cutoff = 10;
    x_temp = x_temp(:,1);
    x = resample(x_temp,Fs,Fs_temp);
    x = x * 0.1 / rms(x);
    [B,A] = butter(3, filter_cutoff/(Fs/2));
    x_db = 20 * log10(max(0, filtfilt(B, A, abs(x))));
    i = find(x_db>-40); % find indices where x_db > -40
    i2 = find(i(2:end)-i(1:end-1) >= 4410); % Find places where there’s more than a 4410 gap between indices with x_db > -40
    ia_vector = i(i2);
    ib_vector = i(i2+1);
    
    padding = 4410;
    % Define the parameters of the window functions
    y = [1:padding]' * (pi/padding);
    window_down = sqrt(.5 * cos(y) + .5);
    window_up = sqrt(.5 * -cos(y) + .5);
    
    x_new = [];
    prev_ib = 0;
    for j = 1:length(ia_vector)
        ia = ia_vector(j);
        ib = ib_vector(j);
        ramp_down = x(ia:ia+padding-1) .* window_down;
        ramp_up = x(ib-padding+1:ib) .* window_up;
        
        x_new = [x_new; x(prev_ib+1:ia-1); ramp_down+ramp_up];
        prev_ib = ib;
    end
    x_new = [x_new; x(prev_ib+1:end)];
    audiowrite('Sentences/RDRBOW.WAV',x_new,Fs);
end