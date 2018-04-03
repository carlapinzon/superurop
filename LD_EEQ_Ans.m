% EEQ REAL TIME PROCESSING

% x: The signal to be processed
% Fs: The sampling frequency of x
% Tfast: The fast/short time constant in milliseconds
% Tslow: The slow/long time constant in milliseconds
% useFIR: A boolean indicating the type of moving average filter that should be used.
%         If true, indicates a FIR filter should be used.
%         If false, indicates an IIR filter should be used.
% gain_bounds_DB: the lower and upper bounds, in dB, of the gain

% VAD would go in the program x_eq = gain.*x
% VAD detector would be same sizez as x- apply when vad is detected

function [x_eq] = LD_EEQ(x, Fs, Tfast, Tslow, useFIR, gain_bounds_dB)
    x = x(:); % ensure x is a column vector
    x_squared = abs(x).^2; %Why do we square x? Why not square and take the square root?
    % energy is sq of signal (definition)- if we want rms, avg energy
    % square rooted
    % basically looking at instant energy as fn of time
    % want to equate the 2 energies- calculate slow and fast based on
    % square
    % when we calculate the gain, we sqrt it below
    % sq signal x b4 put into filtering bc want to smooth energy over time
    
    
    % set the moving average function
    % picks a FIR or IIR
    % Why do we use FIR/IIR? I didn't know they were in the EEQ algorithm.
    % two options
    if useFIR
        ave_fHandle = @FIR; 
    else
        ave_fHandle = @IIR;
    end
    
    T_fast_samples = ceil(Fs * Tfast / 1000); %number of samples
    
    %applies filter using 
    Ex_fast = ave_fHandle([x_squared;zeros(T_fast_samples,1)], Fs, Tfast); %Why do we need the zeros? Bc moving avg have a delay in them inherently that's equal to the time cosntant
    % adds samples at end and then takes them off at the beg- fast energy
    % is more properly time aligned w the input the waveform
    % strips delay from gain
    % delayed wrt input so strip Tfast samples off of it, but must keep teh
    % same length
    Ex_fast = Ex_fast(T_fast_samples+1:end); %Why do we do this?
    
    % can only correct fast or slow- cant shift things around relative to
    % one another so with Ex_slow she also uses T_fast samples
    % feeding same input x, calc energy, from that same input, deriving
    % fast and slow avg
    % delays x so time aligns with this signals
    % bc shes sending the same x to both of them, she can only delay x
    % once, not sep for both
    % delaying x by advancing Ex_fast by T_fast samples
    % for consistency, advancing Ex_slow by same T)fast samples
    % both by same amt so remains consistent
    
    
    % Fast attack slow release 
    % What is fast attack slow release? - respond quickly to quick response
    % in energy but respons slowly to downward response in energy
    % take the max of the fast and the slow energies 
    % when something comes in, sudden onset of energy, slow avg will take
    % moment to react to it, but fast avg will go up really quickly
    % fast lookinag at most recent 50, slow looking at most recent 1000
    % asmples 
    % when energy releases, dont wanna release quickly 
    % slow avg- slow attack slow release 
    Ex_slow = ave_fHandle([x_squared;zeros(T_fast_samples,1)], Fs, Tslow);
    Ex_slow = Ex_slow(T_fast_samples+1:end);
    Ex_slow_fa_sr = max(Ex_slow, Ex_fast); %Why do we take the max of the 2? dodesnt make a diff if lower bound of gain is 0 db
    % bc gain is th
    
    % Compute the gain, taking care to avoid dividing by zero
    % Take the square root because the gain will be multiplied by the original
    % signal, not its energy
    gain = sqrt(Ex_slow_fa_sr ./ max(Ex_fast, 10^-10)); %why is this the gain? prevents divide by 0
    % apply a gain to equate the energies
    % Ex_slow is desired energy- want to raise up the dip to match the
    % required energy
    %  this ratio will always be >1 bc exSlowFaSR always >= Ex fast
    % gain can never be <1 
    
    % Undo the decibels operation
    gain_bounds = 10.^(gain_bounds_dB/20); %Why do we do this?  converts to linear value
    % Ensure that the gain falls within the bounds
    gain = max(gain_bounds(1), min(gain, gain_bounds(2))); %restricts the range
    % dont want to attenuate- make dips more audible
    % dont want to over amplify noise floor
    
    % Ensure that the energy of the equalized signal is equal to the energy
    % of the original signal
    % applies gain to signal
    
    %%% vad ==1 if voice oresent and 0 ow, leave it alone 
    %%% gain(vad ==0) =1; dont wanna change anything
    %%% voice is not detected, disable eeq processing, dont wanna amplify dips that are not noise
    
    % play with vad fn and determine what its doing on these signals
    
    x_eq = gain.*x;
    

    
    % always amplifying certain quiet areas, never attenuate loud areas
    % output signal will be louder than input signal
    % 2nd phase where we renormalized level of signal so same as input
    % level- jsut didnt make signal louder
    % disable 
% % %     x_eq_squared = abs(x_eq).^2;
% % %     Ex_slow = ave_fHandle(x_squared, Fs, Tslow); %Why do we need to find Ex_slow in this way when we found it a different way above?
% % %     % calc slow avg of input signal ^
% % %     % calc slow avg of one she just calculated
% % %     Ex_eq_slow = ave_fHandle(x_eq_squared, Fs, Tslow);
% % % 
% % %     % finds gain that equates the two energies- trying to undo the inherent
% % %     % gain/ long term gain that she might have added in
% % %     gain_eq = sqrt(Ex_slow ./ max(Ex_eq_slow, 10^-10)); %is this gain just normalizing the signal?
% % %     gain_bounds_eq_dB = [-3,3]; %Why are these the bounds?- restricts to be in these bounds- 
% % %     gain_bounds_eq = 10.^(gain_bounds_eq_dB/20);
% % %     gain_eq = max(gain_bounds_eq(1), min(gain_eq, gain_bounds_eq(2)));
% % %     
% % %     x_eq = gain_eq .* x_eq; %Why do we have two gains?
end
% Why fftfilt for FIR and filter for IIR?
% fftfilt- can only do FIR, v efficient
% filter designed for IIR, could do FIR but not as efficient
% fir reacts more quickly for offset- not what we want
% fir and iir really pretty similar 
% iir better

% use the one that performs better 

% designs filter to have a certain time constant- 3 or 300ms
% FIR- better moving average, weights everything within the past ms more
% evenly- more uniformly 
% store a lot of memory 

% iir weights more recent data heavily
% requires 1 history memory location- much cheaper computational operation

% 2 flavors of doing the same thing- laura just wanted the option

% check arguments with ave_fHandle
function [Ex_fir] = FIR(x_squared, Fs, T)
    L = floor(Fs * T / 1000); %Why do we take the floor?- converts to integer number of samples
    if mod(L,2) == 0 % ensure that L is odd %Why must this be odd? Why doesn't IIR have to be odd?
        L = L+1;
    end
    delay = (L-1)/2;
    h = ones(L,1)/L; % L-point averaging filter
    Ex_fir = fftfilt(h,x_squared(:));
    
    % taking most recent number of samples and averaging together
    % moving average- uniform weighted box car window
    % depends on time constant
    % averaging most recent L samples 
end

% group delay 
function [Ex_iir] = IIR(x_squared, Fs, T)
    T_samples = Fs * T / 1000; % Time constant in terms of samples
    alpha = exp(-1/T_samples);
    
    % current energy = previous energy*0.9 + newest sample energy*0.1
    % avg of infinite number of samples with exponential weighting
    % most recent has a weighting of 0.1
    % next has most recent of 0.1*0.9
    % next is 0.1*0.9^3
    
    % Generate filter from difference equation:
    % Ex[n] = (1-alpha)*x_squared[n] + alpha*Ex[n-1]
    B = 1-alpha; % Why are these the values for B and A?
    A = [1, -alpha];
    Ex_iir = filter(B,A,x_squared(:));
end