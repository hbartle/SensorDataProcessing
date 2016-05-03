%% Plot position of Smartphone in realtime
% Used Android App: WirelessIMU by Jan Zwiener
% Algorithm: Gradient Descent (Madgwick)

%Resetting MATLAB environment
instrreset
clear
close all
clc
%Creating UDP object
UDPComIn=udp('192.168.178.53','LocalPort',5555);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Previous quaternion estimate
SE_q_est_old= [1 0 0 0]';


% Vector describing the earths magnetic field in earth CS
bx=0;
bz=0;
E_b= [bx 0 bz]';
% Gravitional vector in earth CS
E_g= [0 0 -1]';

% Initial Bias for Gyro
gyro_bias= [-0.0138    0.0040    0.0200];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count=0;
% Fullscreen figure
f1=figure;
set(f1,'Windowstyle','Docked');

% Plot Smartphone Orientation 3D
box=[[-1; 5; -1],...
     [1; 5; -1],...
     [3; -5; -1],...
     [-3; -5; -1],...
     [-1; 5; 1],...
     [1; 5; 1],...
     [3; -5; 1],...
     [-3; -5; 1]];


box_handle= drawbox(box);

pause(0.1)
%Reading sensor data continuously
tic
while ishandle(f1)     
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% Get Data over UDP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Open Stream
    fopen(UDPComIn);
    % Scan for new data, formatted in CSV format
    csvdata=fscanf(UDPComIn);
    % Get single float values
    scandata=textscan(csvdata,'%f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',' );
    if cellfun(@isempty,scandata)== [0 0 0 0 0 0 0 0 0 0 0 0 0]
      count= count + 1;
      time(count)=toc;
      % Time since last sample
      if count> 1
        delta_t= time(count)-time(count-1);
      else
        delta_t= time(count);
      end
      % Raw sensor data
      accel_data(count,1:3)= [scandata{3},scandata{4},scandata{5}];
      gyro_data(count,1:3)= [scandata{7}, scandata{8}, scandata{9}];
      mag_data(count,1:3)= [scandata{11}, scandata{12}, scandata{13}];

      mag_data(count,1:3)=mag_data(count,1:3)/norm(mag_data(count,1:3));


      % Norm measurments
      accel_data(count,1:3)= accel_data(count,1:3)/norm(accel_data(count,1:3));
      mag_data(count,1:3)=mag_data(count,1:3)/norm(mag_data(count,1:3));
      % Subtract bias
      gyro_data(count,1:3)= gyro_data(count,1:3) - gyro_bias;

      
      % Initial yaw angle from magnetometer data
      if count == 1
          E_b= mag_data(count,1:3);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%% Get Quaternion from Gyroscope data %%%%%%%%%%%%%%

      S_w= vect2quat(gyro_data(count,:));
      
      SE_q_dot= 0.5*quatmul(SE_q_est_old,S_w);
      
      SE_q_w_est= SE_q_est_old + SE_q_dot*delta_t; 
      
      SE_q_w_est= unitquat(SE_q_w_est);
      
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%% Get Quaternion from Accel and Mag Data %%%%%%%%%%%%%%
      % To correct Gyroscope measurements Accelerometer and Magnetometer
      % Data is used. Due to the highly nonlinearity of the three
      % dimensional problem a gradient descent approximation algorithm is
      % used to solve a minimization problem.
      
      
      %%% Accelerometer Data %%%
      S_a= accel_data(count,:);
      % Calculate objective function
      f_G= getobjfunc_acc(SE_q_est_old,S_a);
      
      
      
      %%% Magnetometer Data %%%
      S_m= mag_data(count,:);
      % Calculate objective function
      f_M= getobjfunc_mag(SE_q_est_old,E_b,S_m);
      
      %%% Jacobi matrices %%%
      j_G= jacobi_acc(SE_q_est_old);
      j_M= jacobi_mag(SE_q_est_old,E_b);
      
      F_GM= [f_G; f_M];
      J_GM= [j_G; j_M];
      
      %%% Get gradients %%%
      grad_F= J_GM'*F_GM;
      grad_F= j_G'*f_G;
      norm_grad_f= norm(grad_F);
      
      %%% Gradient Descent %%%
      alpha= 1;
      GD_gain(count)= alpha* norm(SE_q_dot)*delta_t; 
      
      SE_q_grad= SE_q_est_old - GD_gain(count) * grad_F/norm_grad_f; 
      
      SE_q_grad= unitquat(SE_q_grad);

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%% Complementary filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      CF_gain=0.3;
      %SE_q_grad=0;
      SE_q_est_new= (1-CF_gain)*SE_q_w_est + CF_gain*SE_q_grad;
      
      SE_q_est_new= unitquat(SE_q_est_new);
      
      SE_q_est_old= SE_q_est_new;

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%% PLOT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
      
      C_q= quat2mat(SE_q_est_new);
      box_rotated=C_q*box;
      drawbox(box_rotated);

    end
  fclose(UDPComIn);
  pause(0.01);
end
