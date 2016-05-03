 %% Sensor data via UDP for realtimeplot

%Resetting MATLAB environment
instrreset
clear
close all
clc
%Creating UDP object
UDPComIn=udp('192.168.0.26','LocalPort',5555);

% Data
accel_data= 0;
gyro_data= 0;
filter_data= 0;
pitch=0;
roll=0;

% Variables for the real time plot
time= 0;
scrollWidth= 3;
count= 0;
accel_min=-15;
accel_max= 15;
gyro_min=-10;
gyro_max= 10;
filter_min= -180;
filter_max= 180;

% Fullscreen figure
f1=figure;
set(f1,'Windowstyle','Docked');

% Set up accleration data plot for all three dimensions
ax1= subplot(1, 3, 1);
accel_plot(1)= plot(time,accel_data);
title('Acceleration');
axis(ax1,[0 10 accel_min accel_max]);
accel_plot(2)= copyobj(accel_plot(1),ax1);
accel_plot(3)= copyobj(accel_plot(1),ax1);


% Set up gyro data plot for all three dimensions
%figure(2)
ax2= subplot(1, 3, 2);
gyro_plot(1)= plot(time,gyro_data);
title('Gyro');
axis(ax2,[0 10 gyro_min gyro_max]);
gyro_plot(2)= copyobj(gyro_plot(1),ax2);
gyro_plot(3)= copyobj(gyro_plot(1),ax2);

% Filtered Data
ax3= subplot(1, 3, 3);
filter_plot(1)= plot(time,filter_data);
title('Filtered');
axis(ax3,[0 10 filter_min filter_max]);
filter_plot(2)= copyobj(filter_plot(1),ax3);
filter_plot(3)= copyobj(filter_plot(1),ax3);

%autoArrangeFigures(1,2);
pause(0.1)
%Reading sensor data continuously
tic
while ishandle(f1)
    
    fopen(UDPComIn);
    csvdata=fscanf(UDPComIn);
    
    scandata=textscan(csvdata,'%f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',' );
    if cellfun(@isempty,scandata)== [0 0 0 0 0 0 0 0 0 1 1 1 1]
      count= count + 1;
      time(count)=toc;
      accel_data(count,1:3)= [scandata{3},scandata{4},scandata{5}];
      % Norm
      %accel_data(count,1:3)= accel_data(count,1:3)/sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2);
      
      
      gyro_data(count,1:3)= [scandata{7}, scandata{8}, scandata{9}];
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%% Calculate Orientation %%%%%%%%%%%%%%%%%%%%
      
      %pitch_accel= atan2(accel_data(count,1),(sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2)))*180/pi;
      %roll_accel= atan2(accel_data(count,2),(sqrt(accel_data(count,1)^2 + accel_data(count,2)^2 + accel_data(count,3)^2)))*180/pi;
      
      pitch_accel= atan2(accel_data(count,2),accel_data(count,3) )*180/pi;
      roll_accel= atan2(accel_data(count,1),accel_data(count,3))*180/pi;
      
      m= 0.99;
      pitch_accel= atan2(-accel_data(count,1),sqrt(m*accel_data(count,2)^2 + accel_data(count,3)^2));
      roll_accel= atan2(accel_data(count,2),sqrt(accel_data(count,1)^2 + accel_data(count,3)^2));
      
      
      c=0.9;
      k=0.3;
      
      % Complementary filter
      if count > 1  
        pitch= c*(pitch+ gyro_data(count,2)*(time(count)-time(count-1))) + (1-c)*(pitch_accel);
        roll= c*(roll+ gyro_data(count,1)*(time(count)-time(count-1))) + (1-c)*(roll_accel);
%         pitch= (pitch + k*gyro_data(count,1)*(time(count)-time(count-1)));
%         roll= (roll + k*gyro_data(count,2)*(time(count)-time(count-1)));
      else
        pitch= c*(pitch+ gyro_data(count,2)*(time(count))) + (1-c)*(pitch_accel);
        roll= c*(roll+ gyro_data(count,1)*(time(count))) + (1-c)*(roll_accel);
%         pitch= (pitch + k*gyro_data(count,1)*(time(count)));
%         roll= (roll + k*gyro_data(count,2)*(time(count)));
      end
      
      filter_data(count,1:2)= [pitch*180/pi, roll*180/pi];
      
    % Plot Raw Accel data
      if size(accel_data(count,1:3))==[1 3]
          set(accel_plot(1),'XData', time(time > time(count)-scrollWidth), 'YData', accel_data((time > time(count)-scrollWidth),1), 'Color','r');
          set(accel_plot(2),'XData', time(time > time(count)-scrollWidth), 'YData', accel_data((time > time(count)-scrollWidth),2), 'Color','g');
          set(accel_plot(3),'XData', time(time > time(count)-scrollWidth), 'YData', accel_data((time > time(count)-scrollWidth),3), 'Color','b');
          axis(ax1, [time(count)-scrollWidth time(count) accel_min accel_max]);
      end
    % Plot Raw gyro Data
      if size(gyro_data(count,1:3))==[1 3]
          set(gyro_plot(1),'XData', time(time > time(count)-scrollWidth), 'YData', gyro_data((time > time(count)-scrollWidth),1), 'Color','r');
          set(gyro_plot(2),'XData', time(time > time(count)-scrollWidth), 'YData', gyro_data((time > time(count)-scrollWidth),2), 'Color','g');
          set(gyro_plot(3),'XData', time(time > time(count)-scrollWidth), 'YData', gyro_data((time > time(count)-scrollWidth),3), 'Color','b');
          axis(ax2, [time(count)-scrollWidth time(count) gyro_min gyro_max]);
      end 
    % Plot filtered data
      set(filter_plot(1),'XData', time(time > time(count)-scrollWidth), 'YData', filter_data((time > time(count)-scrollWidth),1), 'Color','r');
      set(filter_plot(2),'XData', time(time > time(count)-scrollWidth), 'YData', filter_data((time > time(count)-scrollWidth),2), 'Color','g');
      %set(gyro_plot(3),'XData', time(time > time(count)-scrollWidth), 'YData', gyro_data((time > time(count)-scrollWidth),3), 'Color','b');
      axis(ax3, [time(count)-scrollWidth time(count) filter_min filter_max]);
    
      clc
      disp('Acceleration data received:')
      disp(accel_data(count,1:3))
      disp('Calculated Angles from Accel Data')
      disp(filter_data(count,1:2))
      disp('Gyro data received:')
      disp(gyro_data(count,1:3))
    end
  fclose(UDPComIn);
  pause(0.05);
end
close all