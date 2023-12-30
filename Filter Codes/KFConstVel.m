function [xhat, SNRr, SNR, RMSE] = KFConstVel(R, Q, inp, show_plot, event)

input_x = inp.time_series;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%modif
%  inp = inp';

event_inds = get_event_inds(event, inp);
input_x = detrend(input_x, 1, event_inds);

%
%   Continuous-time system
%
A = [0 1;-1 -1];
B = [0 0]'; Bw = [1 0]';
C = [1 0];
D = 0;
sys = ss(A,[B Bw],C,D);

%tlab

%   Discretization
%
T = 0.004; % sampling time
sysd = c2d(sys,T);
Ad = sysd.a; 
Bd = sysd.b(:,1); Bwd = sysd.b(:,2);
Cd = sysd.c; Dd = sysd.d;

%Bwd = [1 0]';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%const vel model %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Ad = [1 k;0 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%   Design of time-varying Kalman filter
%
kfinal = length(input_x); % number of iteration
% kfinal = length(w0);
M(:,:,1) = eye(2); % Error covariance initial value
for k = 1:kfinal
    %
    %   (TASK) WRITE CODE FOR COMPUTING TIME-VARYING 
    %   KALMAN GAIN HERE!!!
    %
    P(:,:,k) = M(:,:,k) ...
    -M(:,:,k)*Cd'/(Cd*M(:,:,k)*Cd'+Q)*Cd*M(:,:,k);

    M(:,:,k+1) = [1 k;0 1]*P(:,:,k)*[1 k;0 1]'+Bwd*R*Bwd';
    %
    %   Kalman gain
    %
    K(:,:,k)=P(:,:,k)*C'/Q;
    
end


K1sub = K(1,1,:); K1 = K1sub(:);
K2sub = K(2,1,:); K2 = K2sub(:);

if show_plot
    figure()
    subplot(2,1,1), plot(K1) 
    title('Time Varying Kalman gain','fontsize',12,'fontweight','bold')
    ylabel('K1','fontsize',12,'fontweight','bold')
    set(gca,'fontsize',12,'fontweight','bold') % Fontsize
    subplot(2,1,2), plot(K2) 
    ylabel('K2','fontsize',12,'fontweight','bold')
    set(gca,'fontsize',12,'fontweight','bold') % Fontsize
    xlabel('k','fontsize',12,'fontweight','bold')
end

%
%   Input-output data for the state estimator design
%
u = [ones(1,10) zeros(1,10) ...
    ones(1,10) zeros(1,10)]; % square-wave input
w = sqrt(R)*randn(size(u)); % disturbance input
[y0,Ttmp,X] = lsim(sysd,[u;w]); % output without measurement noise
v = sqrt(Q)*randn(size(y0)); % measurement noise
y = y0+v; % measurement with noise
real1 = X(:,1);
real2 = X(:,2);
% %
%   State estimate with time-varying Kalman filter
%
% xhat(0|-1) (time update)
xhat_t(:,:,1) = [0 0]'; % initial estimate
%y_a =y;
y_a = input_x(1,1:kfinal)';

for k = 1:kfinal
    xhat_m(:,:,k) = xhat_t(:,:,k)+K(:,:,k)*...
        (y_a(k)-Cd*xhat_t(:,:,k)); % xhat(k|k) (measurement update)
    xhat_t(:,:,k+1) = [1 k;0 1]*xhat_m(:,:,k);%+Bd*u(k); % xhat(k+1|k)
end

% theta after correction
xhatm1sub = xhat_m(1,1,:); xhatm1 = xhatm1sub(:); 
% d(theta)/dt after correction
xhatm2sub = xhat_m(2,1,:); xhatm2 = xhatm2sub(:); 
% theta after prediction
xhatt1sub = xhat_t(1,1,:); xhatt1 = xhatt1sub(:); 
% d(theta)/dt after prediction
xhatt2sub = xhat_t(2,1,:); xhatt2 = xhatt2sub(:); 

xhat = xhatt1';
xhat(:,1) = [];
% xhat = sgolayfilt(xhat,5,111);

if show_plot
    figure()
    kgrid = 1:kfinal;
    subplot(2,1,1), plot(kgrid,y_a+1,kgrid,xhatm1,'r',kgrid,xhatt1(1:end-1),'g-.')
    title('Trajectories with time varying kamlan gain','fontsize',12,'fontweight','bold')
    legend('measurement','correction','prediction')
    set(gca,'fontsize',12,'fontweight','bold') % Fontsize
    subplot(2,1,2), plot(kgrid,y_a,kgrid,xhatm2,'r',kgrid,xhatt2(1:end-1),'g-.')
    legend('true x_2','correction','prediction')
    set(gca,'fontsize',12,'fontweight','bold') % Fontsize

    figure();
    plot(input_x,'b');
    hold on; 
    plot(xhat, 'r'); 
    xlabel('Time');
    ylabel('Signal Magnitude'); 
    title('KF with Constant Vel. Model'); 
    legend('raw EOG','KF-Constant Vel. - EOG')
end

%%KF Quality
%% SNR wrt to raw
SNRr = snr(input_x,abs(input_x-xhat));
%% SNR wrt to filtered signal
SNR = snr(xhat,abs(input_x-xhat));
%% MSE -  Mean Square Error
RMSE = sqrt(mean(input_x-xhat).^2);

end