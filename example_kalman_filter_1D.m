%% Example for an one dimensional kalman filter
clear 
close all
clc


%%%%%%%%%%%%%%%%%%% Generate Signals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Time
t=0:1:100;

% Example for a measured signal 
meas= 2+ 0.8*rand(1,101) + 0.05*t;


%%%%%%%%%%%%%%%%%% Kalman Filter Implementation %%%%%%%%%%%%%%%%%%%%%%%%%%%
% State Space
A= 1;
B= 0;
H= 1;
D= 0;
state_input=0;

[n, m]= size(A);



est0=4
P0=1;
Q= 0.1;
R= 0.001;
est_new=0;





% Initial conditions
est_old= est0;
P_old= P0;

for i=1:101
    % Predict
    est_cur= A * est_old + B * state_input;
    % Predict covariance
    P_cur= A*P_old*A' + Q;
    
    % Innovation
    inn= meas(i) - H * est_cur;
    % Innovation covariance
    S= H*P_cur*H' + R;
    % Kalman Gain
    K= P_cur*H'/S;
    % State Estimation Update
    est_new(i)= est_cur + K*inn;
    % State Estimation covariance Update
    P_new= (eye(n) - K*H)*P_cur;
    
    % Store old values
    est_old= est_new(i);
    P_old= P_new;
    
    
end
    
    





% Plot Signals
f1= figure;
set(f1,'Windowstyle','Docked');
plot(t,meas);
axis([0, max(t), 0, 7]);
hold on
plot(t,est_new);
title('Kalman Filter (1D) Results');
legend('Measured Signal','Kalman Filter Result');
