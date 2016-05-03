function [ q_out ] = angleaxis2quat( angle, axis )
%Converts an angle and an axis into a quaternion
axis=axis(:);
axis=axis/norm(axis);
q_out= [cos(angle/2); sin(angle/2)*axis];

end

