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


% Create Filter object
AHRS= MadgwickAHRS('SamplePeriod',0.0017,'Beta',1);


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

      % Initial yaw angle from magnetometer data
      if count == 1
          E_b= mag_data(count,1:3);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%% Madwicks algorithm %%%%%%%%%%%%%%%%%%%%%%%%%
      
      AHRS.Update(gyro_data(count,:)*180/pi,accel_data(count,:),mag_data(count,:));
      q= AHRS.Quaternion;
      
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%% PLOT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
      
      C_q= quat2mat(q);
      box_rotated=C_q*box;
      drawbox(box_rotated);
      disp(time(count));

    end
  fclose(UDPComIn);
  pause(0.01);
end