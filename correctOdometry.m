function corrected = correctOdometry(nr,distance_to_wall)
global odometry
correction=0;
if distance_to_wall ~= 0 
  correction = distance_to_wall - 835; %mm, half hall
end
fprintf('odom1: %d, odom2: %d \n', odometry(1), odometry(2))
if nr <= 12
    x = odometry(1);
    y = odometry(2)+correction;
elseif nr <= 30
    x = odometry(1)- correction;
    y = odometry(2);
elseif nr <= 45
    x = odometry(1) ;
    y = odometry(2)- correction;
elseif nr <= 101 
    x = odometry(1) + correction;
    y = odometry(2);
end
corrected = [x,y];
end