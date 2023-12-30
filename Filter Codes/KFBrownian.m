function [xhat, SNRr, SNR, RMSE] = KFBrownian(Q, R, inp, show_plot, event)

input_x = inp.time_series;

A = 1; % State transition matrix
% Observation model
C = 1;
N = 1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%modif
% inp = inp';
% inp_detrend = detrend(inp);
event_inds = get_event_inds(event, inp);
input_x = detrend(input_x, 1, event_inds);

z = input_x; 
m = size(C, 1); % Number of sensors
n = size(C, 2); % Number of state values
numobs = size(z, 2); % Number of observations

% observation Algorithem
xhat = zeros(n, numobs);
xhat(:,1) =  z(:,1)/C;

% Initialize P, I
P = ones(size(A));
I = eye(size(A));

%------Kalman Filter Algorithem-----
for k = 2:numobs
    % Predict from previous
    xhat(:,k) = A * xhat(:,k-1);
    P         = A * P * A' + Q;
    
    % New value estimation
    G         = P  * C' / (C * P * C' + R); %% Kalman Gain Calculation
    P         = (P - G * C) * P;
    xhat(:,k) = xhat(:,k) + G * (z(:,k) - C * xhat(:,k)); %%Estimation
    
end

 %xhat = xhat - mean(xhat);
 %xhat = detrend(xhat);%VarName5

%  xhat = sgolayfilt(xhat,5,111);

% Run the Kalman filter on fused sensors
% figure(1);
% % nXhat = myKalman([inp'], A, [C1], [R1], Q);
% subplot(2,1,1);
% plot(inp)
% 
% hold on;
% plot(xhat,'r');
% legend('input','Est.out');
% title('Estimated value and input value');
% xlabel('Time 1/60 Sec.');
% ylabel('Angle (Degrees)');
% subplot(2,1,2);
% plot(xhat,'r');
% title('Estimated value vs Time');
% xlabel('Time 1/60 Sec.');
% ylabel('Angle (Degrees)');

% Plot
if show_plot
    figure();
    plot(input_x,'b');
    hold on; 
    plot(xhat, 'r'); 
    xlabel('Sample No.');
    ylabel('Signal Magnitude'); 
    title('Filtered Signal'); 
    legend('raw EOG','KF-Brownian - EOG');
end

%%KF Quality
%% SNR wrt to raw
SNRr = snr(input_x,abs(input_x-xhat));
%% SNR wrt to filtered signal
SNR = snr(xhat,abs(input_x-xhat));
%% MSE -  Mean Square Error
RMSE = sqrt(mean(input_x-xhat).^2);
end
