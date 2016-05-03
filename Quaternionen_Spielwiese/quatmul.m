function [ q_out ] = quatmul( q1, q2 )
%Multiply two quaternions
q1=q1(:);
q2=q2(:);


% q_out(1)= q1(1)*q2(1) - q1(2)*q2(2) - q1(3)*q2(3) - q1(4)*q2(4);
% q_out(2)= q1(1)*q2(2) + q1(2)*q2(1) + q1(3)*q2(4) - q1(4)*q2(3);
% q_out(3)= q1(1)*q2(3) - q1(2)*q2(4) + q1(3)*q2(1) + q1(4)*q2(2);
% q_out(4)= q1(1)*q2(4) + q1(2)*q2(3) - q1(3)*q2(2) + q1(4)*q2(1);
% q_out=q_out(:);

% Probably faster:

q_out= [ q1(1)*q2(1)-dot(q1(2:4),q2(2:4)); q1(1)*q2(2:4)+q2(1)*q1(2:4)+cross(q1(2:4),q2(2:4))];



end

