%% Sensor data via UDP

%Resetting MATLAB environment
instrreset
clear
close all
clc
%Creating UDP object
UDPComIn=udp('192.168.0.26','LocalPort',5555);
%set(UDPComIn,'DatagramTerminateMode','off')



longestLag=0;
while 1
    tic
    fopen(UDPComIn);
    csvdata=fscanf(UDPComIn);
%     scandata=textscan(csvdata,'%f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',' );
%     data=[scandata{3},scandata{4},scandata{5}, scandata{7}, scandata{8}, scandata{9}];
    
    clc
    disp('Data received:')
    disp(csvdata)
    disp('Longest Lag:')
    disp(longestLag)
    fclose(UDPComIn);
    t= toc;
    longestLag=max(t,longestLag);
    pause(0.1);
end
close all
    
