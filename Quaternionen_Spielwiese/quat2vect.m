function [ v ] = quat2vect( q )
%Converts a quaternion with real part equal zero into a vector

v= q(2:end,1:end);

end

