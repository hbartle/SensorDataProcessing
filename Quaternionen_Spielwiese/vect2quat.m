function [ q ] = vect2quat( v )
%Converts a vector into a quaternion with real part eual zero
v=v(:);

[~, n]= size(v);

q= [ zeros(1,n); v];


end

