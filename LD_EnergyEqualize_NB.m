 function [equalized] = LD_EnergyEqualize_NB(sig,Fs,NBands,Tfast,Tslow,useFIR,gain_bounds_dB)    
%
% Program to create Energy Equalized (multiple band) speech
% sig is the array of speech or speech+noise signal to be vocoded 
% Fs is the sampling frequency associated with sig
% NBands is the number of bands in the TFS signal
% equalized is the NBands band equalized signal

%What is sig? Same as for LD_EEQ?
%Why is this so different from the other fn?

%Why these freq?
% defining lower and upper frequencies of the channels
low_freq = 80;
high_freq = 8020;
% Generate logarithmically spaced frequencies defining the NBand channels
lim_bande = round(logspace(log10(low_freq),log10(high_freq),NBands+1)); %forms vector of NBands +1 numbers btwn low_freq and high_freq

% why is butterworth =3?
% initialization of the vectors containing the filters
butterworth_n = 3;
B=zeros(NBands,2*butterworth_n+1);
A=zeros(NBands,2*butterworth_n+1);
 
% defining order 6 (36dB/oct) passband filters coefficients %Why?
% Why do we use butterworth? 
for kk=1:NBands        
    [B(kk,:),A(kk,:)]=butter(butterworth_n,[lim_bande(kk)/(Fs/2) lim_bande(kk+1)/(Fs/2)]);   
end

% create matrix to hold the bandpassed signals
signal = sig*zeros(1,NBands);
 
% Why do we use this fn?
% As we are using the ‘filtfilt’ MATLAB function we are filtering the speech signal twice (the way round as well) so the filters slope is 72 dB/oct 
for kk=1:NBands
    signal(:,kk)=filtfilt(B(kk,:),A(kk,:),sig);
end

% create matrix to hold the energy equalized parts of each band
equalized = sig*zeros(1,NBands);
for kk=1:NBands
   equalized(:,kk) = LD_EEQ(signal(:,kk),Fs,Tfast,Tslow,useFIR,gain_bounds_dB);
end 
   
% reconstruction of the energy equalized signal
equalized = sum(equalized,2);

 end