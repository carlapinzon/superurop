function vad = pseudo_vad_zerocrossing(signal, Fs)

% More like a consonant detector.  Does not get vowels.

% NOT REAL TIME!!!!!
z_rate = zero_crossing_rate(signal,Fs);
z_rate = (z_rate - median(z_rate)).^2;

vad = z_rate >= 0.5;