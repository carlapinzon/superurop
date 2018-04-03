% x: The signal to be processed
% Fs: The sampling frequency of x
% Tfast: The fast/short time constant in milliseconds
% Tslow: The slow/long time constant in milliseconds
% useFIR: A boolean indicating the type of moving average filter that should be used.
%         If true, indicates a FIR filter should be used.
%         If false, indicates an IIR filter should be used.
% gain_bounds_DB: the lower and upper bounds, in dB, of the gain
% gain: The gain to be applied to x for the EEQ processing

function [gain] = EEQ_gain(x, Fs, Tfast, Tslow, useFIR, gain_bounds_dB)
    x = x(:); % ensure x is a column vector
    x_squared = abs(x).^2;
    
    % set the moving average function
    if useFIR
        ave_fHandle = @FIR;
    else
        ave_fHandle = @IIR;
    end
    
    T_fast_samples = ceil(Fs * Tfast / 1000);
    
    Ex_fast = ave_fHandle([x_squared;zeros(T_fast_samples,1)], Fs, Tfast);
    Ex_fast = Ex_fast(T_fast_samples+1:end);
    
    % Fast attack slow release
    Ex_slow = ave_fHandle([x_squared;zeros(T_fast_samples,1)], Fs, Tslow);
    Ex_slow = Ex_slow(T_fast_samples+1:end);
    Ex_slow_fa_sr = max(Ex_slow, Ex_fast);
    
    % Compute the gain, taking care to avoid dividing by zero
    % Take the square root because the gain will be multiplied by the original
    % signal, not its energy
    gain = sqrt(Ex_slow_fa_sr ./ max(Ex_fast, 10^-10));
    % Undo the decibels operation
    gain_bounds = 10.^(gain_bounds_dB/20);
    % Ensure that the gain falls within the bounds
    gain = max(gain_bounds(1), min(gain, gain_bounds(2)));
    
    % Ensure that the energy of the equalized signal is equal to the energy
    % of the original signal
    x_eq = gain.*x;
    x_eq_squared = abs(x_eq).^2;
    Ex_slow = ave_fHandle(x_squared, Fs, Tslow);
    Ex_eq_slow = ave_fHandle(x_eq_squared, Fs, Tslow);

    gain_eq = sqrt(Ex_slow ./ max(Ex_eq_slow, 10^-10));
    gain_bounds_eq_dB = [-3,3];
    gain_bounds_eq = 10.^(gain_bounds_eq_dB/20);
    gain_eq = max(gain_bounds_eq(1), min(gain_eq, gain_bounds_eq(2)));
    
    gain = gain_eq .* gain;
end

function [Ex_fir] = FIR(x_squared, Fs, T)
    L = floor(Fs * T / 1000);
    if mod(L,2) == 0 % ensure that L is odd
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
    B = 1-alpha;
    A = [1, -alpha];
    Ex_iir = filter(B,A,x_squared(:));
end