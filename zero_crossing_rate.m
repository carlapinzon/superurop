function z_rate = zero_crossing_rate(x,Fs)

avg_window = 0.02;
L = round(avg_window*Fs);
d = sign(sign(x(1:end-1)) -0.5) ~= sign(sign(x(2:end)) -0.5);

% Apply an L-tap moving average filter -- L samples.
z_rate = fftfilt(ones(L,1)/L, [d(:); zeros(L,1)]);
z_rate = z_rate(round(L/2)+[1:size(x,1)]);

z_rate = z_rate / avg_window;

