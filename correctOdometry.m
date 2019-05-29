function corrected = correctOdometry(nr)
global odometry
global last_correction_y
last_correction_y = 0;
global last_correction_x
last_correction_x = 0;
global corr_x
global corr_y

if nr <= 12
    x = odometry(1)-corr_x;
    y = odometry(2)+corr_y;
elseif nr <= 21
    x = odometry(1) - corr_x;
    y = odometry(2) + corr_y;
elseif nr <= 29
    x = odometry(1) - corr_x;
    y = odometry(2) + corr_y;
elseif nr <= 45
    x = odometry(1) - corr_x;
    y = odometry(2) + corr_y;
end
corrected = [x,y];
end