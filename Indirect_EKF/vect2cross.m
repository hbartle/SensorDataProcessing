function [ M ] = vect2cross( v )
%Converts a vector into a matrix which multiplied with an other vector gives the same result as the cross
%product with the initial vector.

M= [ [ 0 -v(3) v(2)];...
     [ v(3) 0 -v(1)];...
     [-v(2) v(1) 0] ];
 


end

