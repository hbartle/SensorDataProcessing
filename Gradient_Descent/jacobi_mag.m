function [ J ] = jacobi_mag( q, b)
%Calculates the jacobian for the magnetometer objective function used in
%the gradient descent algorithm

J= 2* [ [-b(3)*q(3), b(3)*q(4), -2*b(1)*q(3)-b(3)*q(1), -2*b(1)*q(4)+b(3)*q(2)];...
        [-b(1)*q(4)+b(3)*q(2), b(1)*q(3)+b(3)*q(1), b(1)*q(2)+b(3)*q(4), -b(1)*q(1)+b(3)*q(3)];...
        [b(1)*q(3), b(1)*q(4)-2*b(3)*q(2), b(1)*q(1)-2*b(3)*q(3), b(1)*q(2)]];

end

