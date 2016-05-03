%% Script using quaternion rotation to rotate a box
clear all
close all
clc


% Plot Box
box=[[5; -1; -1],...
     [5; 1; -1],...
     [-5; 3; -1],...
     [-5; -3; -1],...
     [5; -1; 1],...
     [5; 1; 1],...
     [-5; 3; 1],...
     [-5; -3; 1]];

box_handle= drawbox(box);


theta= 45*pi/180;
q= angleaxis2quat(theta,[1 1 1]);

%q= unitquat(q);

rotated_box= quatrot(q,box);
[roll, pitch, yaw]= quat2euler(q);
roll= roll*180/pi;
pitch= pitch*180/pi;
yaw= yaw*180/pi;

disp(roll)
disp(pitch)
disp(yaw)
drawbox(rotated_box);







