% x: The signal to be processed
% Fs: The sampling frequency of x
% Tfast: The fast/short time constant in milliseconds
% Tslow: The slow/long time constant in milliseconds
% useFIR: A boolean indicating the type of moving average filter that should be used.
%         If true, indicates a FIR filter should be used.
%         If false, indicates an IIR filter should be used.
% gain_bounds_DB: the lower and upper bounds, in dB, of the gain

function [x_eq] = LD_EEQ(x, Fs, Tfast, Tslow, useFIR, gain_bounds_dB)
    x = x(:); % ensure x is a column vector
    x_squared = abs(x).^2; %Why do we square x? Why not square and take the square root?
    
    % set the moving average function
    % picks a FIR or IIR
    % Why do we use FIR/IIR? I didn't know they were in the EEQ algorithm.
    if useFIR
        ave_fHandle = @FIR; 
    else
        ave_fHandle = @IIR;
    end
    
    T_fast_samples = ceil(Fs * Tfast / 1000); %number of samples
    
    %applies filter using 
    Ex_fast = ave_fHandle([x_squared;zeros(T_fast_samples,1)], Fs, Tfast); %Why do we need the zeros?
    Ex_fast = Ex_fast(T_fast_samples+1:end); %Why do we do this?
    
    % Fast attack slow release 
    % What is fast attack slow release?
    Ex_slow = ave_fHandle([x_squared;zeros(T_fast_samples,1)], Fs, Tslow);
    Ex_slow = Ex_slow(T_fast_samples+1:end);
    Ex_slow_fa_sr = max(Ex_slow, Ex_fast); %Why do we take the max of the 2?
    
    % Compute the gain, taking care to avoid dividing by zero
    % Take the square root because the gain will be multiplied by the original
    % signal, not its energy
    gain = sqrt(Ex_slow_fa_sr ./ max(Ex_fast, 10^-10)); %why is this the gain?
    % Undo the decibels operation
    gain_bounds = 10.^(gain_bounds_dB/20); %Why do we do this?
    % Ensure that the gain falls within the bounds
    gain = max(gain_bounds(1), min(gain, gain_bounds(2))); 
    
%     vad == 1 if voice present and 0 otherwise;
%     gain(vad==0) = 1;
    
    % Ensure that the energy of the equalized signal is equal to the energy
    % of the original signal
    x_eq = gain.*x;   
        
%     x_eq_squared = abs(x_eq).^2;
%     Ex_slow = ave_fHandle(x_squared, Fs, Tslow); %Why do we need to find Ex_slow in this way when we found it a different way above?
%     Ex_eq_slow = ave_fHandle(x_eq_squared, Fs, Tslow);
% 
%     gain_eq = sqrt(Ex_slow ./ max(Ex_eq_slow, 10^-10)); %is this gain just normalizing the signal?
%     gain_bounds_eq_dB = [-3,3]; %Why are these the bounds?
%     gain_bounds_eq = 10.^(gain_bounds_eq_dB/20);
%     gain_eq = max(gain_bounds_eq(1), min(gain_eq, gain_bounds_eq(2)));
%     
%     x_eq = gain_eq .* x_eq; %Why do we have two gains?
end
% Why fftfilt for FIR and filter for IIR?


function [Ex_fir] = FIR(x_squared, Fs, T)
    L = floor(Fs * T / 1000); %Why do we take the floor?
    if mod(L,2) == 0 % ensure that L is odd %Why must this be odd? Why doesn't IIR have to be odd?
        L = L+1;
    end
    delay = (L-1)/2;
    h = ones(L,1)/L; % L-point averaging filter
    Ex_fir = fftfilt(h,x_squared(:));
end

% group delay 
function [Ex_iir] = IIR(x_squared, Fs, T)
    T_samples = Fs * T / 1000; % Time constant in terms of samples
    alpha = exp(-1/T_samples);
    
    % Generate filter from difference equation:
    % Ex[n] = (1-alpha)*x_squared[n] + alpha*Ex[n-1]
    B = 1-alpha; % Why are these the values for B and A?
    A = [1, -alpha];
    Ex_iir = filter(B,A,x_squared(:));
end