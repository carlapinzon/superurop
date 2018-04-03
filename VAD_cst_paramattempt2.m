function VAD_cst_paramattempt2 = vadInitCstParamsattempt2()

%% Algorithm Constants Initialization
VAD_cst_paramattempt2.Fs = single(8000);  % Sampling Frequency
VAD_cst_paramattempt2.M  = single(10);    % Order of LP filter
VAD_cst_paramattempt2.NP = single(12);    % Increased LPC order

VAD_cst_paramattempt2.No = single(128);   % Number of frames for long-term minimum energy calculation
VAD_cst_paramattempt2.Ni = single(32);    % Number of frames for initialization of running averages
VAD_cst_paramattempt2.INIT_COUNT = single(20);

% High Pass Filter that is used to preprocess the signal applied to the VAD
% Highpass Elliptical filter with cutorr = 140 Hz, passband ripple =
% 0.25dB, stopband ripple is 40 dB down.
%VAD_cst_paramattempt2.HPF_sos = single([0.92727435, -1.8544941, 0.92727435, 1, -1.9059465, 0.91140240]);
[b, a] = ellip(2, 0.25, 40, 140/(0.5*8000), 'high');
VAD_cst_paramattempt2.HPF_sos = [b a];

VAD_cst_paramattempt2.L_WINDOW = single(240);  % Window size in LP analysis
VAD_cst_paramattempt2.L_NEXT   = single(40);   % Lookahead in LP analysis
VAD_cst_paramattempt2.L_FRAME  = single(80);   % Frame size

L1 = VAD_cst_paramattempt2.L_NEXT;
L2 = VAD_cst_paramattempt2.L_WINDOW - VAD_cst_paramattempt2.L_NEXT;
VAD_cst_paramattempt2.hamwindow = single([0.54 - 0.46*cos(2*pi*(0:L2-1)'/(2*L2-1));
                                 cos(2*pi*(0:L1-1)'/(4*L1-1))]);

% LP analysis, lag window applied to autocorrelation coefficients
VAD_cst_paramattempt2.lagwindow = single([1.0001; exp(-1/2 * ((2 * pi * 60 / VAD_cst_paramattempt2.Fs) * (1:VAD_cst_paramattempt2.NP)').^2)]);

% Correlation for a lowpass filter (3 dB point on the power spectrum is
% at about 2 kHz)
VAD_cst_paramattempt2.lbf_corr = single([0.24017939691329, 0.21398822343783, 0.14767692339633, ...
                      0.07018811903116, 0.00980856433051,-0.02015934721195, ...
                      -0.02388269958005,-0.01480076155002,-0.00503292155509, ...
                      0.00012141366508, 0.00119354245231, 0.00065908718613, ...
                      0.00015015782285]');