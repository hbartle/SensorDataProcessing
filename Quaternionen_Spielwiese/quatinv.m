function [ q_t ] = quatinv( q )
%Inverts a quaternion
q=q(:);

q_t=  [q(1); -q(2:4)];
euclid_norm= norm(q);

q_inv= q_t/euclid_norm;


end

