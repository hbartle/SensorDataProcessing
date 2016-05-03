%% Accelerometer data via UDP for realtimeplot
% Used Android App: WirelessIMU by Jan Zwiener

%Resetting MATLAB environment
instrreset
clear
close all
clc
%Creating UDP object
UDPComIn=udp('192.168.0.26','LocalPort',5552);



g=[0 0 -1]';
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
      mag_data(count,1:3)= [scandata{11}, scandata{12}, scandata{13}];
      
      mag_data(count,1:3)=mag_data(count,1:3)/norm(mag_data(count,1:3));
      if count == 1
          mag_data0= mag_data(count,1:3);
      end
      
      % Norm measurments
      accel_data(count,1:3)= accel_data(count,1:3)/norm(accel_data(count,1:3));
      mag_data(count,1:3)=mag_data(count,1:3)/norm(mag_data(count,1:3));



      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%% Calculate angles from Acceleration %%%%%%%%%%%%%%
           
      m= 0.99;
      roll_accel= atan2(-accel_data(count,1),accel_data(count,3)^2);
      pitch_accel= atan2(accel_data(count,2),sqrt(accel_data(count,1)^2 + accel_data(count,3)^2));

      yaw_mag= atan2(-mag_data(count,2)*cos(roll_accel)+mag_data(count,3)*sin(roll_accel),...
                     mag_data(count,1)*cos(pitch_accel)+mag_data(count,2)*sin(pitch_accel)*sin(roll_accel)+mag_data(count,3)*sin(pitch_accel)*cos(roll_accel)); 
      if count == 1
           yaw_mag0= atan2(-mag_data(count,2)*cos(roll_accel)+mag_data(count,3)*sin(roll_accel),...
                           mag_data(count,1)*cos(pitch_accel)+mag_data(count,2)*sin(pitch_accel)*sin(roll_accel)+mag_data(count,3)*sin(pitch_accel)*cos(roll_accel));
      end
                 
%       if sign(accel_data(count,3)) == 1
%         roll_accel= atan2(-accel_data(count,1),accel_data(count,3));
%         pitch_accel= atan2(accel_data(count,2),(sqrt(accel_data(count,1)^2 + accel_data(count,3)^2)));
%       else
%         roll_accel= pi-atan2(-accel_data(count,1)/(sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2)));
%         pitch_accel= atan(-accel_data(count,2)/(sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2)));          
%       end

      




       
      q_axis= cross(g,accel_data(count,1:3)');
      q_angle= + dot(accel_data(count,1:3)',g);
      
      q= angleaxis2quat(q_angle,q_axis);
 
      q= unitquat(q);
        
      angles_accel(count,1:3)=[roll_accel, pitch_accel, 0];
      
      % Update Box
      T= quat2mat(q);
      box_rotated=T*box;
      drawbox(box_rotated);
      
      
      
      
      clc
      disp('Accelerometer data Received:')
      disp(accel_data(count,1:3))
      disp('Angles from Accelerometer data');
      disp(angles_accel(count,1:3)*180/pi)
      disp('Magnetometer data Received:')
      disp(mag_data(count,1:3))
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
