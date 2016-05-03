%% Sensor data via UDP for realtimeplot
% Used Android App: WirelessIMU by Jan Zwiener

%Resetting MATLAB environment
instrreset
clear
close all
clc
%Creating UDP object
UDPComIn=udp('192.168.0.26','LocalPort',5551);

% Data
accel_data= 0; 
gyro_data= 0;
filter_data= 0;
pitch=0;
roll=0;
yaw= 0;
roll_gyro=0;
pitch_gyro=0;
yaw_gyro=0;

% Bias for Gyro and Accelerometer
accel_bias= [-0.3640    0.0378    0.0222];
gyro_bias= [-0.0138    0.0040    0.0200];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Definitions for Kalman filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
% 
% Used state vector:    x= [ roll pitch roll_rate_bias pitch_rate_bias]'
%

% Inital State
roll_rate_bias0= gyro_bias(1);
pitch_rate_bias0= gyro_bias(2);
x0= [0 0 roll_rate_bias0 pitch_rate_bias0]';
% Initial State covariance matrix
L= 1;
P0= L*eye(4);

% Covariance
Q_roll= 0.003;
Q_pitch= 0.0003;
Q_roll_rate= 0.03;
Q_pitch_rate= 0.03;

R_roll= 10;
R_pitch= 10;



% Observation Model Matrix
H= [ [eye(2) zeros(2)];...
     [zeros(2) eye(2)]];
% Measurement covariance Matrix
R= 1e-2*[ [R_roll 0 0 0];...
          [0 R_pitch 0 0];...
          [0 0 1 0];...
          [0 0 0 1]];
 
x_old= x0;
P_old= P0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count=0;
% Fullscreen figure
f1=figure;
set(f1,'Windowstyle','Docked');

% Plot Smartphone Orientation 3D
box=[[5; -1; -1],...
     [5; 1; -1],...
     [-5; 3; -1],...
     [-5; -3; -1],...
     [5; -1; 1],...
     [5; 1; 1],...
     [-5; 3; 1],...
     [-5; -3; 1]];

box_handle= drawbox(box);


pause(0.1)
%Reading sensor data continuously
tic
while ishandle(f1)     
    
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
      if count == 1
          mag_data0= mag_data(count,1:3);
      end
      
      % Norm measurments
      accel_data(count,1:3)= accel_data(count,1:3)/norm(accel_data(count,1:3));
      mag_data(count,1:3)=mag_data(count,1:3)/norm(mag_data(count,1:3));
      % Subtract bias
      %accel_data(count,1:3)= accel_data(count,1:3)-accel_bias;
      gyro_data(count,1:3)= gyro_data(count,1:3) - gyro_bias;

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%% Calculate angles from gyroscope %%%%%%%%%%%%%%%%%
      % The received gyro data is always in a sensor fixed CS. To get the
      % euler angles in the inertial CS a transformation is required.
%       
%       T_gyro= 1/cos(roll)*[ [0 sin(roll) cos(roll)];...
%                              [0 cos(roll)*cos(pitch) -sin(roll)*cos(pitch)];...
%                              [cos(yaw) sin(roll)*sin(pitch) cos(roll)*cos(pitch)]];
% 
%       gyro_data_corrected(1:3,count)= T_gyro*gyro_data(count,1:3)';


      
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%% Calculate angles from Acceleration %%%%%%%%%%%%%%
           
      m= 0.99;
      roll_accel= atan2(-accel_data(count,1),accel_data(count,3)^2);
      pitch_accel= atan2(accel_data(count,2),sqrt(accel_data(count,2)^2 + accel_data(count,3)^2));

      yaw_mag= atan2(-mag_data(count,2)*cos(roll_accel)+mag_data(count,3)*sin(roll_accel),...
                     mag_data(count,1)*cos(pitch_accel)+mag_data(count,2)*sin(pitch_accel)*sin(roll_accel)+mag_data(count,3)*sin(pitch_accel)*cos(roll_accel)); 
      if count == 1
           yaw_mag0= atan2(-mag_data(count,2)*cos(roll_accel)+mag_data(count,3)*sin(roll_accel),...
                           mag_data(count,1)*cos(pitch_accel)+mag_data(count,2)*sin(pitch_accel)*sin(roll_accel)+mag_data(count,3)*sin(pitch_accel)*cos(roll_accel));
      end
                 
%       if sign(accel_data(count,3)) == 1
%         roll_accel= asin(-accel_data(count,1)/(sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2)));
%         pitch_accel= asin(-accel_data(count,2)/(sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2)));
%       else
%         roll_accel= pi-asin(-accel_data(count,1)/(sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2)));
%         pitch_accel= asin(-accel_data(count,2)/(sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2)));          
%       end
%       roll_accel= asin(accel_data(count,1)/norm(accel_data(count,1:3)));
%       pitch_accel= asin(accel_data(count,2)/norm(accel_data(count,1:3)));
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%% Complementary filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      c=0.8;
      k=1;

      roll= c*(roll- k*gyro_data(count,2)*(delta_t)) + (1-c)*(roll_accel);
      pitch= c*(pitch+ k*gyro_data(count,1)*(delta_t)) + (1-c)*(pitch_accel);
      %yaw= c*(yaw + k*gyro_data(count,3)*delta_t) + (1-c)*(-yaw_mag0+yaw_mag);
      
      filter_data(count,1:3)= [-roll, -pitch, yaw];
%       T= rotZ(filter_data(count,3))*rotY(filter_data(count,2))*rotX(filter_data(count,1));
%       filter_data(count,1:3)=(T'*filter_data(count,1:3)')';
      
      

      %filter_data(count,1:3)= [-roll, -pitch, yaw];
      %yaw= c*(yaw + k*gyro_data(count,3)*delta_t) + (1-c)*(-yaw_mag0+yaw_mag);
     
      %filter_data(count,1:3)= [-roll, -pitch, yaw];
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%% Kalman filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%       % State Transition Model Matrix
%       F= [ [1 0 -delta_t 0];...
%            [0 1 0 -delta_t];...
%            [0 0 1 0];...
%            [0 0 0 1]];
%       % Control Input Model Matrix
%       B= [ [delta_t 0 0 0];...
%            [0 delta_t 0 0];...
%            [0 0 0 0];...
%            [0 0 0 0]];
%       
%       
%       % Process noise covariance matrix
%       Q_new= delta_t*[ [Q_roll 0 0 0];...
%                    [0 Q_pitch 0 0];...
%                    [0 0 Q_roll_rate 0];...
%                    [0 0 0 Q_pitch_rate]];
%                
%       % Input control vector (Gyro Rate Measurments)
%       u_new= [gyro_data(count,2) -gyro_data(count,1) 0 0]';
%       
%       % State Measurments (Angles from Accelerometer)
%       z_new= [-roll_accel, -pitch_accel 0 0]';
%       
%       % A priori state
%       x_cur= F*x_old + B*u_new;
%       P_cur= F*P_old*F' + Q_new;
%       
%       % Innovation
%       y_new=  z_new - H*x_cur;
%       % Innovation covariance matrix
%       S_new= H*P_cur*H' + R;
%       
%       % Kalman Gain
%       K_new= P_cur*H'/S_new;
%       
%       % New State
%       x_new= x_cur + K_new * y_new;
%       % New State covariance
%       P_new= (eye(4) - K_new*H)*P_cur;
%       
%       
%       % Store for next iteration
%       x_old= x_new;
%       P_old= P_new;
%       filter_data(count,1:2)= [x_new(1), x_new(2)];
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%% Calculate DCM and rotate box %%%%%%%%%%%%%%%%%%%%%%      

      %T= rotX(filter_data(count,1))*rotY(filter_data(count,2))*rotZ(filter_data(count,3));
      T= rotZ(filter_data(count,3))*rotY(filter_data(count,2))*rotX(filter_data(count,1));
      
      
      box_rotated=T*box;
      
      drawbox(box_rotated);

    
      clc
      disp('Data Received:')
      disp(scandata)
      disp('Acceleration data received:')
      disp(accel_data(count,1:3))
      disp('Calculated Angles from Accel Data')
      disp('    Roll      Pitch')
      disp(['    ' num2str(roll_accel*180/pi) '   ' num2str(pitch_accel*180/pi)])
      disp('Gyro data received:')
      disp(gyro_data(count,1:3))
      disp('Filtered angles:')
      disp('    Roll     Pitch      Yaw')
      disp(filter_data(count,1:3)*180/pi)
    end
  fclose(UDPComIn);
  pause(0.01);
end
close all