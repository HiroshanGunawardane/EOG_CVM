function [xhat, SNRr, SNR, RMSE] = Bandpass(~, ~, inp, ~, event)
input_x = inp.time_series;
input_x = detrend(input_x);
%  event_inds = get_event_inds(event, inp);
% input_x = detrend(input_x, 1, event_inds);

xhat = bandpass(input_x,[0.5,35],250);

%KF Quality
% SNR wrt to raw
SNRr = snr(input_x,abs(input_x-xhat));
% SNR wrt to filtered signal
SNR = snr(xhat,abs(input_x-xhat));
% MSE -  Mean Square Error
RMSE = sqrt(mean(input_x-xhat).^2);
end