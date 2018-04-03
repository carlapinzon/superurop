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

subplot_idx = 4;
for n = 2:4,
    for snr = [-10:10:10],
        [s_orig1, s_noise1, vad1, s1]= VAD_Sample_Runs_Attempt3(syllable, n, 70, snr);
        subplot(4,3,subplot_idx);
        subplot_idx = subplot_idx + 1;
        plot(s1)
        hold on
        plot(vad1*.7*MX)
        hold off
        ylim([-1 1]*MX);
        xlim([1 length(s_noise1)]);
        ylabel('Relative Amplitude');
        xlabel('Time Steps');
        title(sprintf('N=%i; Level=70; SNR=%i',n,snr),'FontSize',8);
    end
end




