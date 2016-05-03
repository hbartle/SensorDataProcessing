function [ rot_mat ] = quat2mat( q )
%Converts a quaternion into a rotation matrix

rot_mat= [ [q(1)^2+q(2)^2-q(3)^2-q(4)^2, 2*q(2)*q(3)-2*q(1)*q(4), 2*q(2)*q(4)+2*q(1)*q(3)];...
           [2*q(2)*q(3)+2*q(1)*q(4), q(1)^2-q(2)^2+q(3)^2-q(4)^2, 2*q(3)*q(4)-2*q(1)*q(2)];...
           [2*q(2)*q(4)-2*q(1)*q(3), 2*q(3)*q(4)+2*q(1)*q(2), q(1)^2-q(2)^2-q(3)^2+q(4)^2]];


end

