% manyplots

% Noise 1 = Baseline
% Noise 2 = Cont
% Noise 3 = SQW
% Nosie 4 = SAM
% Syllable, Noise, Level, SNR

% ABA
close all
clear all
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3('ABA', 1, 70, -10)

% no noise
subplot(3,4,1)
plot(s_orig)
title('ABA')

% baseline
subplot(3,4,2)
plot(s_noise)
title('ABA; 1, 30, -10')

% baseline with vad
subplot(3,4,3)
plot(scaled_vad/50)
hold on
plot(s_orig)
title('VAD With ABA B4 EEQ; Noise = 1, Level = 70, SNR = -10')
hold off

% baseline with vad after eeq
subplot(3,4,4)
plot(scaled_vad/30)
hold on
plot(s)
title('VAD With ABA After EEQ; Noise = 1, Level = 70, SNR = -10')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off
[s_orig1, s_noise1, scaled_vad1, s1]= VAD_Sample_Runs_Attempt3('ABA', 2, 70, -10)

% cont
subplot(3,4,5)
plot(s_noise1)
title('ABA After Adding Noise; Noise = 2, Level = 70 SNR = -10')

% cont with vad
subplot(3,4,6)
plot(scaled_vad1/100)
hold on
plot(s_orig1)
title('VAD With ABA Before EEQ; Noise = 2, Level = 70 SNR = -10')
hold off

% cont with vad after eeq
subplot(3,4,7)
plot(scaled_vad1/50)
hold on
plot(s1)
title('VAD With ABA After EEQ; Noise = 2, Level = 70 SNR = -10')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]=  VAD_Sample_Runs_Attempt3('ABA', 2, 70 0)

% cont
subplot(3,4,8)
plot(s_noise)
title('ABA After Adding Noise; Noise = 2, Level = 70 SNR = 0')

% cont with vad
subplot(3,4,9)
plot(scaled_vad)
hold on
plot(s_orig)
title('VAD With ABA Before EEQ; Noise = 2, Level = 70 SNR = 0')
hold off

% cont with vad after eeq
subplot(3,4,10)
plot(scaled_vad)
hold on
plot(s)
title('VAD With ABA After EEQ; Noise = 2, Level = 70 SNR = 0')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[s_orig, s_noise, scaled_vad, s]= VAD_Sample_Runs_Attempt3('ABA', 2, 70 10)
figure(10)

% cont
subplot(3,4,1)
plot(s_noise)
title('ABA After Adding Noise; Noise = 2, Level = 70 SNR = 10')

% cont with vad
subplot(3,4,2)
plot(scaled_vad)
hold on
plot(s_orig)
title('VAD With ABA Before EEQ; Noise = 2, Level = 70 SNR = 10')
hold off

% cont with vad after eeq
subplot(3,4,3)
plot(scaled_vad)
hold on
plot(s)
title('VAD With ABA After EEQ; Noise = 2, Level = 70 SNR = 10')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VAD_Sample_Runs_Attempt3('ABA', 3, 70 -10)

% cont
figure(10)
subplot(3,4,4)
plot(s_noise)
title('ABA After Adding Noise; Noise = 3, Level = 70 SNR = -10')

% cont with vad
subplot(3,4,5)
plot(scaled_vad)
hold on
plot(s_orig)
title('VAD With ABA Before EEQ; Noise = 3, Level = 70 SNR = -10')
hold off

% cont with vad after eeq
subplot(3,4,6)
plot(scaled_vad)
hold on
plot(s)
title('VAD With ABA After EEQ; Noise = 3, Level = 70 SNR = -10')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VAD_Sample_Runs_Attempt3('ABA', 3, 70 0)

% cont
figure(10)
subplot(3,4,7)
plot(s_noise)
title('ABA After Adding Noise; Noise = 3, Level = 70 SNR = 0')

% cont with vad
subplot(3,4,8)
plot(scaled_vad)
hold on
plot(s_orig)
title('VAD With ABA Before EEQ; Noise = 3, Level = 70 SNR = 0')
hold off

% cont with vad after eeq
subplot(3,4,9)
plot(scaled_vad)
hold on
plot(s)
title('VAD With ABA After EEQ; Noise = 3, Level = 70 SNR = 0')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VAD_Sample_Runs_Attempt3('ABA', 3, 70 10)

% cont
figure(10)
subplot(3,4,10)
plot(s_noise)
title('ABA After Adding Noise; Noise = 3, Level = 70 SNR = 10')

% cont with vad
subplot(3,4,11)
plot(scaled_vad)
hold on
plot(s_orig)
title('VAD With ABA Before EEQ; Noise = 3, Level = 70 SNR = 10')
hold off

% cont with vad after eeq
subplot(3,4,12)
plot(scaled_vad)
hold on
plot(s)
title('VAD With ABA After EEQ; Noise = 3, Level = 70 SNR = 10')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VAD_Sample_Runs_Attempt3('ABA', 4, 30, -10)
% 
% % cont
% subplot(3,4,13)
% plot(s_noise)
% title('ABA After Adding Noise; Noise = 3, Level = 30, SNR = -10')
% 
% % cont with vad
% subplot(3,4,14)
% plot(scaled_vad)
% hold on
% plot(s_orig)
% title('VAD With ABA Before EEQ; Noise = 3, Level = 30, SNR = -10')
% hold off
% 
% % cont with vad after eeq
% subplot(3,4,15)
% plot(scaled_vad)
% hold on
% plot(s)
% title('VAD With ABA After EEQ; Noise = 3, Level = 30, SNR = -10')
% hold off
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VAD_Sample_Runs_Attempt3('ABA', 4, 30, 0)
% 
% % cont
% subplot(3,4,16)
% plot(s_noise)
% title('ABA After Adding Noise; Noise = 3, Level = 30, SNR = 0')
% 
% % cont with vad
% subplot(3,4,17)
% plot(scaled_vad)
% hold on
% plot(s_orig)
% title('VAD With ABA Before EEQ; Noise = 3, Level = 30, SNR = 0')
% hold off
% 
% % cont with vad after eeq
% subplot(3,4,18)
% plot(scaled_vad)
% hold on
% plot(s)
% title('VAD With ABA After EEQ; Noise = 3, Level = 30, SNR = 0')
% hold off
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VAD_Sample_Runs_Attempt3('ABA', 4, 30, 10)
% 
% % cont
% subplot(3,4,19)
% plot(s_noise)
% title('ABA After Adding Noise; Noise = 3, Level = 30, SNR = 10')
% 
% % cont with vad
% subplot(3,4,6)
% plot(scaled_vad)
% hold on
% plot(s_orig)
% title('VAD With ABA Before EEQ; Noise = 3, Level = 30, SNR = 10')
% hold off
% 
% % cont with vad after eeq
% subplot(3,4,7)
% plot(scaled_vad)
% hold on
% plot(s)
% title('VAD With ABA After EEQ; Noise = 3, Level = 30, SNR = 10')
% hold off
% 
% 
