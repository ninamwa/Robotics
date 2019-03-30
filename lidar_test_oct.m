%
%
MATLAB = 0;

for k=1:1000,
    scan = LidarScan(lidar);
    
    if MATLAB
        disp(['scan ', num2str(k), ' length: ', num2str(length(scan));
    else
        printf(['scan ', num2str(k), ' length: ', num2str(length(scan)),'\n']);
        fflush(stdout);
    end
    plot(scan);
    
    pause(0.1);
end