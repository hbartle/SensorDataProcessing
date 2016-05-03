function [ q_out ] = unitquat( q_in )
%Converts a quaternion into a unit quaternion

euclid_norm= norm(q_in);

q_out= q_in/euclid_norm;

end

