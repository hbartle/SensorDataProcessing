function [ J ] = jacobi_acc( q )
%Calculates the jacobian for the accelerometer objective function used in
%the gradient descent algorithm

J= 2*[ [-q(3), q(4), -q(1), q(2)];...
       [q(2), q(1), q(4), q(3)];...
       [0 -2*q(2), -2*q(3) 0]];
   


end

