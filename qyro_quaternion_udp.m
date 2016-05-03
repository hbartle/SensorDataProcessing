%% Gyro data via UDP for realtimeplot
% Used Android App: WirelessIMU by Jan Zwiener

%Resetting MATLAB environment
instrreset
clear
close all
clc
%Creating UDP object
UDPComIn=udp('192.168.0.26','LocalPort',5555);



q=[1 0 0 0]';
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
    
    % Open Stream
    fopen(UDPComIn);
    % Scan for new data, formatted in CSV format
    csvdata=fscanf(UDPComIn);
    % Get single float values
    scandata=textscan(csvdata,'%f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',' );
    if cellfun(@isempty,scandata)== zeros(1,13)
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

        
      
      q_dot= 0.5*quatmul(q,vect2quat(gyro_data(count,:)'));
      
      q= q + q_dot*delta_t;
 
      q= unitquat(q);
        
      
      % Update Box
      T= quat2mat(q);
      box_rotated=T*box;
      drawbox(box_rotated);
      
      
      
      
      clc

      disp('Quaternion:')
      disp(q);
      disp('Euler Angles from quaternion')
      [q_roll, q_pitch, q_yaw]= quat2euler(q);
      q_eul_angles=[q_roll, q_pitch, q_yaw];
      disp(q_eul_angles*180/pi);
      
    end
  fclose(UDPComIn);
  pause(0.01);
end