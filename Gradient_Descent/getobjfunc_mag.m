function [ f_M ] = getobjfunc_mag( q, b,m )
%Calculates a objectfunction to a given quaternion and given observed
% vector for use in the gradient descent minimization problem.
% Equation:
%           f= SE_q* x E_d x SE_q - S_s
%
% Where: 
%           f:      Objective function (to minimize)
%           SE_q:   Quaternion estimate
%           E_d:    Predefined reference direction in earth CS
%           S_s:    Measured direction in the sensor CS


f1= 2*b(1)*(0.5-q(3)^2-q(4)^2) + 2*b(3)*(q(2)*q(4)-q(1)*q(3)) - m(1);
f2= 2*b(1)*(q(2)*q(3)-q(1)*q(4)) + 2*b(3)*(q(1)*q(2)+q(3)*q(4)) -m(2);
f3= 2*b(1)*(q(1)*q(3)+q(2)*q(4)) + 2*b(3)*(0.5-q(2)^2-q(3)^2) - m(3);

f_M= [f1; f2; f3];

end

