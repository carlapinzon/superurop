function d = voicing_detector(s, Fs)
% NOT GOOD FOR REALTIME -- delay would be too big.

pitch_range = [100 300];
pitch_period_range = 1./pitch_range;
pitch_period_range_samples = pitch_period_range * Fs;
max_pitch_period = max(pitch_period_range_samples);
min_pitch_period = round(min(pitch_period_range_samples));

span = 10;
NFFT = 2^ceil(log2(10*max_pitch_period));
step = 128;

window = [ones(NFFT/2,1); zeros(NFFT/2,1)];  % NFFT long.  Zero pad so that convolution output is long enough.
S = spectrogram(s, window, NFFT-step, NFFT);  % Take FFT of overlapped, windowed blocks.
R = S.*conj(S);  % Convolution of each block FFT with its time reverse.
r = real(ifft([R; conj(flipud(R(2:end-1,:)))]));
r = r(1:NFFT/2+1,:);
keyboard

