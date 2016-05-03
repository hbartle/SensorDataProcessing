function [ q ] = euler2quat( roll, pitch, yaw )
%Converts euler angles into a quaternion using the ZYX rotation sequence

q(1)= cos(pitch/2)*cos((roll+yaw)/2);
q(2)= sin(pitch/2)*cos((roll-yaw)/2);
q(3)= sin(pitch/2)*sin((roll-yaw)/2);
q(4)= cos(pitch/2)*sin((roll+yaw)/2);
end

