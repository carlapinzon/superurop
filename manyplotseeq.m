function manyplotseeq(syllable)

% Noise 1 = Baseline
% Noise 2 = Cont
% Noise 3 = SQW
% Noise 4 = SAM
% Syllable, Noise, Level, SNR

% ABA
close all

MX = 5e4;


[s_orig, s_noise, vad, s]= VAD_Sample_Runs_Attempt3(syllable, 1, 70, 0)

% no noise
subplot(4,3,1)
plot(s_orig)
title(syllable)
ylim([-1 1]*MX);
xlim([1 length(s_orig)]);
title(syllable,'FontSize',8)

% baseline
subplot(4,3,2)
plot(s)
hold on
plot(vad*.7*MX)
hold off
title('EEQ! Noise: 1, Level: 70 SNR: 0','FontSize',8)
ylim([-1 1]*MX);
xlim([1 length(s_noise)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig1, s_noise1, scaled_vad1, s1]= VAD_Sample_Runs_Attempt3(syllable, 2, 70, -10)

% cont with vad
subplot(3,4,3)
plot(scaled_vad1*.07)
hold on
plot(s1)
title('2, 70, -10')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]=  VAD_Sample_Runs_Attempt3(syllable, 2, 70, 0)

% cont with vad
subplot(3,4,4)
plot(scaled_vad*.07)
hold on
plot(s)
title('2, 70, 0')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3(syllable, 2, 70, 10)

% cont with vad
subplot(3,4,5)
plot(scaled_vad*5e4*.7)
hold on
plot(s)
title('2, 70, 10')
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3(syllable, 3, 70, -10)

% cont with vad
subplot(3,4,6)
plot(scaled_vad*.07)
hold on
plot(s)
title('3, 70, -10')
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3(syllable, 3, 70, 0)

% cont with vad
subplot(3,4,7)
plot(scaled_vad*.07)
hold on
plot(s)
title('3, 70, 0')
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3(syllable, 3, 70, 10)


% cont with vad
subplot(3,4,8)
plot(scaled_vad*.07)
hold on
plot(s)
title('3, 70, 10')
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3(syllable, 4, 70, -10)

% con with vad
subplot(3,4,9)
plot(scaled_vad*.07)
hold on
plot(s)
title('3, 70, -10')
hold off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3(syllable, 4, 70, 0)

% cont with vad
subplot(3,4,10)
plot(scaled_vad*.07)
hold on
plot(s)
title('3, 70, 0')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3(syllable, 4, 70, 10)

% cont with vad
subplot(3,4,11)
plot(scaled_vad*.07)
hold on
plot(s)
% title(ABA After EEQ')
title('3, 70, 10')
ylabel('Relative Amplitude');
xlabel('Time Steps');
hold off


