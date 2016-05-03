function [ f_G ] = getobjfunc_acc( q, S_a)
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

f_G1= 2*(q(2)*q(4)-q(1)*q(3))-S_a(1);
f_G2= 2*(q(1)*q(2)+q(3)*q(4))-S_a(2);
f_G3= 1-2*q(2)^2-q(3)^2 -S_a(3);
f_G= [ f_G1; f_G2; f_G3];

end

