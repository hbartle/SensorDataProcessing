%% Test script 
clear all
close all
clc

connector on 12345

%% Mobile device and sensors
android= mobiledev();

android.AccelerationSensorEnabled=1;
android.AngularVelocitySensorEnabled=1;
android.OrientationSensorEnabled=1;
android.Logging=1;

%% Plot Data
% Define Constants
min= -90;
max= 90;
scrollWidth= 5;

delay=0.001;
% Define variables
time=0;
data=0;
count=0;



%% Set up plot
plotGraph= plot(time,data);
title('Android Sensor Data', 'Fontsize', 25);
xlabel('Time','Fontsize', 15);
ylabel('Pitch','Fontsize', 15);
axis([0 10 min max]);
grid on;
pause(0.1);

disp('Close Plot to end Session.');

tic;

while ishandle(plotGraph)
    dat= android.Orientation;
    
    if (~isempty(dat))
        count= count+1;
        time(count)= toc;
        data(count)= dat(2);
        
  
        
        if( scrollWidth >0)
            set(plotGraph,'XData', time(time > time(count)-scrollWidth), 'YData', data(time > time(count)-scrollWidth));
            axis([time(count)-scrollWidth time(count) min max]);
        else
            set(plotGraph,'XData', time, 'YData', data);
            axis([0 time(count) min max]);
        end
        
        pause(delay);
    end
    
end

disp('Session terminated...');
        


    



