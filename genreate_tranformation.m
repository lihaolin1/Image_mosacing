function[H] = genreate_tranformation(use_point1, use_point2) %from 
    H = zeros([3,3]);
%H = [h1,h2,h3;h4,h5,h6;h7,h8,h9];
%     syms p1 p2 p3 p4 p5 p6 p7 p8;
%     syms h1 h2 h3 h4 h5 h6 h7 h8 h9;
%     p1 = h1*use_point1(1,1)+h2*use_point1(1,2)+h3 - use_point2(1,1)*(h7*use_point1(1,1)+h8*use_point1(1,2)+h9);
%     p2 = h4*use_point1(1,1)+h5*use_point1(1,2)+h6 - use_point2(1,2)*(h7*use_point1(1,1)+h8*use_point1(1,2)+h9);
%     
%     [use_point1(1,1),use_point1(1,2),1,0,0,0,-use_point2(1,1)*use_point1(1,1),-use_point2(1,1)*use_point1(1,2),-use_point2(1,1)];
%     [0,0,0,use_point1(1,1),use_point1(1,2),1,-use_point2(1,2)*use_point1(1,1),-use_point2(1,2)*use_point1(1,2),-use_point2(1,2)];
%     
%     p3 = h1*use_point1(2,1)+h2*use_point1(2,2)+h3 - use_point2(2,1)*(h7*use_point1(2,1)+h8*use_point1(2,2)+h9);
%     p4 = h4*use_point1(2,1)+h5*use_point1(2,2)+h6 - use_point2(2,2)*(h7*use_point1(2,1)+h8*use_point1(2,2)+h9);
%     
%     [use_point1(2,1),use_point1(2,2),1,0,0,0,-use_point2(2,1)*use_point1(2,1),-use_point2(2,1)*use_point1(2,2),-use_point2(2,1)];
%     [0,0,0,use_point1(2,1),use_point1(2,2),1,-use_point2(2,2)*use_point1(2,1),-use_point2(2,2)*use_point1(2,2),-use_point2(2,2)];
%     
%     p5 = h1*use_point1(3,1)+h2*use_point1(3,2)+h3 - use_point2(3,1)*(h7*use_point1(3,1)+h8*use_point1(3,2)+h9);
%     p6 = h4*use_point1(3,1)+h5*use_point1(3,2)+h6 - use_point2(3,2)*(h7*use_point1(3,1)+h8*use_point1(3,2)+h9);
%     
%     [use_point1(3,1),use_point1(3,2),1,0,0,0,-use_point2(3,1)*use_point1(3,1),-use_point2(3,1)*use_point1(3,2),-use_point2(3,1)];
%     [0,0,0,use_point1(3,1),use_point1(3,2),1,-use_point2(3,2)*use_point1(3,1),-use_point2(3,2)*use_point1(3,2),-use_point2(3,2)];
%     
%     p7 = h1*use_point1(4,1)+h2*use_point1(4,2)+h3 - use_point2(4,1)*(h7*use_point1(4,1)+h8*use_point1(4,2)+h9);
%     p8 = h4*use_point1(4,1)+h5*use_point1(4,2)+h6 - use_point2(4,2)*(h7*use_point1(4,1)+h8*use_point1(4,2)+h9);
%     
%     [use_point1(4,1),use_point1(4,2),1,0,0,0,-use_point2(4,1)*use_point1(4,1),-use_point2(4,1)*use_point1(4,2),-use_point2(4,1)];
%     [0,0,0,use_point1(4,1),use_point1(4,2),1,-use_point2(4,2)*use_point1(4,1),-use_point2(4,2)*use_point1(4,2),-use_point2(4,2)];
%     
%     A = [use_point1(1,1),use_point1(1,2),1,0,0,0,-use_point2(1,1)*use_point1(1,1),-use_point2(1,1)*use_point1(1,2),-use_point2(1,1);
%     0,0,0,use_point1(1,1),use_point1(1,2),1,-use_point2(1,2)*use_point1(1,1),-use_point2(1,2)*use_point1(1,2),-use_point2(1,2);
%     use_point1(2,1),use_point1(2,2),1,0,0,0,-use_point2(2,1)*use_point1(2,1),-use_point2(2,1)*use_point1(2,2),-use_point2(2,1);
%     0,0,0,use_point1(2,1),use_point1(2,2),1,-use_point2(2,2)*use_point1(2,1),-use_point2(2,2)*use_point1(2,2),-use_point2(2,2);
%     use_point1(3,1),use_point1(3,2),1,0,0,0,-use_point2(3,1)*use_point1(3,1),-use_point2(3,1)*use_point1(3,2),-use_point2(3,1);
%     0,0,0,use_point1(3,1),use_point1(3,2),1,-use_point2(3,2)*use_point1(3,1),-use_point2(3,2)*use_point1(3,2),-use_point2(3,2);
%     use_point1(4,1),use_point1(4,2),1,0,0,0,-use_point2(4,1)*use_point1(4,1),-use_point2(4,1)*use_point1(4,2),-use_point2(4,1);
%     0,0,0,use_point1(4,1),use_point1(4,2),1,-use_point2(4,2)*use_point1(4,1),-use_point2(4,2)*use_point1(4,2),-use_point2(4,2)];
%     %H = [h1,h2,h3,h4,h5,h6,h7,h8,h9]';
    %can assume h9 = 1, so A is:
    A = [use_point1(1,1),use_point1(1,2),1,0,0,0,-use_point2(1,1)*use_point1(1,1),-use_point2(1,1)*use_point1(1,2);
    0,0,0,use_point1(1,1),use_point1(1,2),1,-use_point2(1,2)*use_point1(1,1),-use_point2(1,2)*use_point1(1,2);
    use_point1(2,1),use_point1(2,2),1,0,0,0,-use_point2(2,1)*use_point1(2,1),-use_point2(2,1)*use_point1(2,2);
    0,0,0,use_point1(2,1),use_point1(2,2),1,-use_point2(2,2)*use_point1(2,1),-use_point2(2,2)*use_point1(2,2);
    use_point1(3,1),use_point1(3,2),1,0,0,0,-use_point2(3,1)*use_point1(3,1),-use_point2(3,1)*use_point1(3,2);
    0,0,0,use_point1(3,1),use_point1(3,2),1,-use_point2(3,2)*use_point1(3,1),-use_point2(3,2)*use_point1(3,2);
    use_point1(4,1),use_point1(4,2),1,0,0,0,-use_point2(4,1)*use_point1(4,1),-use_point2(4,1)*use_point1(4,2);
    0,0,0,use_point1(4,1),use_point1(4,2),1,-use_point2(4,2)*use_point1(4,1),-use_point2(4,2)*use_point1(4,2)];
    
    result = [use_point2(1,1),use_point2(1,2),use_point2(2,1),use_point2(2,2),use_point2(3,1),use_point2(3,2),use_point2(4,1),use_point2(4,2)];
    %A*h = result;
    H_temp = A\result';
    H_temp = [H_temp' 1]; %assume h9 = 1
    H(1,:) = H_temp(1:3);
    H(2,:) = H_temp(4:6);
    H(3,:) = H_temp(7:9);
end