%% Sensor data via UDP

%Resetting MATLAB environment
instrreset
clear
close all
clc
%Creating UDP object
UDPComIn=udp('192.168.0.26','LocalPort',5555);
%set(UDPComIn,'DatagramTerminateMode','off')

accel_data= 0;
time= 0;
scrollWidth= 10;
count= 0;

sensorbar1=bar([0,0,0]);
figure;
sensorbar2=bar([0,0,0]);
%figure;
%dataplot= plot(time,accel_data);
autoArrangeFigures(1,2);
pause(0.1)
%Reading sensor data continuously
longestLag=0;
while ishandle(sensorbar1) && ishandle(sensorbar2)
    tic
    fopen(UDPComIn);
    csvdata=fscanf(UDPComIn);
    scandata=textscan(csvdata,'%f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',' );
    data=[scandata{3},scandata{4},scandata{5}, scandata{7}, scandata{8}, scandata{9}];
    if size(data)==[1 6]
      %set(dataplot,'XData', time(time > time(count)-scrollWidth), 'YData', data(time > time(count)-scrollWidth));
      %axis([time(count)-scrollWidth time(count) min max]);
      set(sensorbar1,'YData',data(1,1:3))
      axis([0.5,3.5,-10,10])
      set(sensorbar2,'YData',data(1,4:6))
    end
  clc
  disp('Data received:')
  disp(data)
  disp('Longest Lag:')
  disp(longestLag)
  fclose(UDPComIn);
  t= toc;
  longestLag=max(t,longestLag);
  pause(0.1);
end
close all