function [vad] = vad_decision(s, Fs);
% [vad] = vad_decision(s, Fs)
%
% Runs G729 VAD on the input s.
%
% s = input signal
% Fs = sample rate of input
%
% vad = VAD decision vector.  This is the same length as s.  It is equal to
% 1 whenever voice is detected and 0 when voice is not detected.

if (size(s,2) ~= 1)
    error('Input must be a column vector');
end

% Initialize VAD parameters
VAD_cst_param = vadInitCstParams; %VAD_cst_paramattempt2

% Create a vector of times for the input signal (used later)
t = [0:size(s,1)-1]' / Fs;

% Resample input to internal sample rate.  VAD G729 operates on inputs
% sampled at 8 kHz.
Fs_internal = 8000;
s_internal = resample(s, Fs_internal, Fs);

% Input is processed in blocks of block_size samples.  Zero pad input so
% that there is an integer number of full blocks.
block_size = 80;
number_blocks = ceil(length(s_internal)/block_size);
s_internal = [s_internal; zeros(number_blocks*block_size - size(s_internal,1),1)];

% Vector of times associated with each block.  Each block is block_size in
% duration -- so successive times are separated by the number of seconds
% corresponding to block_size.  The time-offset centers the times within
% each block.
time_step_sec = block_size / Fs_internal;
time_offset_sec = time_step_sec/2;
t_internal = time_step_sec*([1:number_blocks]'-1) + time_offset_sec;

% Iterate through the blocks and make the VAD decision
vad_internal = zeros(number_blocks,1);
for blk = 1:number_blocks,
   % Indices of current block
   blk_ind = (blk-1)*block_size + [1:block_size]';
   
   % Current block of data
   block_data = s_internal(blk_ind);

   % Process the block of data for VAD
   vad_internal(blk) = vadG729use(single(block_data), VAD_cst_param);
end


% keyboard

% vad_internal contains the VAD decision at the time specified in
% t_internal.  For the output, we want a VAD decision for the times in the
% actual input signal s -- whose times are specified in the vector t from
% above.  Use nearest-neighbor interpolation to do this.
vad = interp1(t_internal, vad_internal, t, 'nearest');

% At this point, vad is exactly the same length as the input s.