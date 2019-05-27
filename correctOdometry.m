function corrected = correctOdometry(nr,distance_to_wall)
global odometry
global last_correction_y
last_correction_y = 0;
global last_correction_x
last_correction_x = 0;
correction=0;
if distance_to_wall ~= 0 
  correction = distance_to_wall - 835; %mm, half hall
end

if nr <= 12
    x = odometry(1);
    y = odometry(2)+correction;
    last_correction_y = correction;
elseif nr <= 20
    x = odometry(1) - correction;
    y = odometry(2) + last_correction_y;
    last_correction_x = correction;
elseif nr <= 27
    x = odometry(1) - last_correction_x;
    y = odometry(2) - correction;
    last_correction_y = correction;
elseif nr <= 44 
    x = odometry(1) + correction;
    y = odometry(2) - last_correction_y;
end
corrected = [x,y];
fprintf('x_real: %d, y_real: %d \n', corrected(1), corrected(2))
end