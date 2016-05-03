function [ v_rot_q ] = quatrot( q, v )
%rotates a vector with quaternion rotation

% v_q= vect2quat(v);
% 
% v_rot_q= quatmul(q,quatmul(v_q,quatinv(q)));
% % v_rot= quat2vect(v_rot_q);


q_rot= quat2mat(q);
v_rot= q_rot*v;

end

