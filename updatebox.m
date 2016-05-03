function [ y ] = updatebox(box_handle, box_coordinates )
%Updates a drawed box 


p1=box_coordinates(1:3,1);
p2=box_coordinates(1:3,2);
p3=box_coordinates(1:3,3);
p4=box_coordinates(1:3,4);
p5=box_coordinates(1:3,5);
p6=box_coordinates(1:3,6);
p7=box_coordinates(1:3,7);
p8=box_coordinates(1:3,8);


% Bottom Surface
x1=[ p1(1), p2(1), p3(1), p4(1)];
y1=[ p1(2), p2(2), p3(2), p4(2)];
z1=[ p1(3), p2(3), p3(3), p4(3)];

% Top Surface
x2=[ p5(1), p6(1), p7(1), p8(1)];
y2=[ p5(2), p6(2), p7(2), p8(2)];
z2=[ p5(3), p6(3), p7(3), p8(3)];
%Left Wall
x3=[ p1(1), p4(1), p8(1), p5(1)];
y3=[ p1(2), p4(2), p8(2), p5(2)];
z3=[ p1(3), p4(3), p8(3), p5(3)];
%Right Wall
x4=[ p2(1), p3(1), p7(1), p6(1)];
y4=[ p2(2), p3(2), p7(2), p6(2)];
z4=[ p2(3), p3(3), p7(3), p6(3)];
%Front Wall
x5=[ p1(1), p5(1), p6(1), p2(1)];
y5=[ p1(2), p5(2), p6(2), p2(2)];
z5=[ p1(3), p5(3), p6(3), p2(3)];
%Rear Wall
x6=[ p3(1), p7(1), p8(1), p4(1)];
y6=[ p3(2), p7(2), p8(2), p4(2)];
z6=[ p3(3), p7(3), p8(3), p4(3)];

fill3(box_handle,x1,y1,z1,1,x2,y2,z2,1,x3,y3,z3,1,x4,y4,z4,1,x5,y5,z5,1,x6,y6,z6,1);

end

