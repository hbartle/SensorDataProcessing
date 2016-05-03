function [ roll, pitch, yaw ] = quat2euler( q )
%Converts a quaternion to Euler angles in yaw-pitch-roll representation

roll= atan2(2*(q(1)*q(2)+q(3)*q(4)) , q(1)^2-q(2)^2-q(3)^2+q(4)^2);
pitch= -asin(2*(q(2)*q(4)-q(1)*q(3)));
yaw= atan2(2*(q(1)*q(4)+q(2)*q(3)) , q(1)^2+q(2)^2-q(3)^2-q(4)^2);

end

