 function [e_eq]=EnergyEqualize(sig,Fs,NBands)
%
% Program to create Energy Equalized speech. 

%NFFT = 128;
%NFFT = 256;
%NFFT = 512;
%NFFT = 1024;
%NFFT = 4096;
NFFT = 2.^round(log2(0.005*Fs));
SIG = spectrogram([sig;zeros(NFFT/2,1)],boxcar(NFFT),NFFT/2,NFFT);
SIG_energy = sum(abs(SIG).^2) + sum(abs(SIG(2:end-1,:)).^2);
SIG_avg = mean(SIG_energy);

%G = min(10^(20/20),max(0,sqrt(SIG_avg./max(0.00000001,SIG_energy))));
G = min(10^(20/20),max(1,sqrt(SIG_avg./max(0.00000001,SIG_energy))));
%G = min(10^(40/20),max(0,sqrt(SIG_avg./max(0.00000001,SIG_energy))));

SIG= SIG.*(ones(NFFT/2+1,1)*G);
sig2 = real(ifft([SIG;conj(flipud(SIG(2:end-1,:)))]));
sig2 = sig2.*(hanning(NFFT)*ones(1,size(sig2,2)));
sig2 = [sig2(1:NFFT/2,:) zeros(NFFT/2,1)] + [zeros(NFFT/2,1) sig2(NFFT/2+1:NFFT,:)];
sig2 = sig2(:);
sig2 = sig2(1:length(sig));
sig2 = sqrt(mean(sig.^2)/mean(sig2.^2))*sig2;
e_eq = sig2;
