function lab2()

lidartmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 1, ...
    'StartFcn',{@initLidar}, ...
    'TimerFcn', {@lidartimerCallback});


odometrytmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 1, ...
    'StartFcn',{@initOdometry}, ...
    'TimerFcn', {@odometrytimerCallback});

start(lidartmr);
start(odometrytmr);
global odometry;
global door_detected;
door_detected = false;
cont = true;
reference_path=PathPlanner(); 
for i = 1:length(reference_path(:,1))
    ref = reference_path(i,:);
    while norm(odometry(1:2)-ref)>0.5
        if door_detected
            true_door = searchQR();
            if true_door
                %Turn 90degrees
                status = get_door_status();
                playSound(status);
            end
            door_detected=false;
        else 
            odom = pioneer_read_odometry();
            [v,w] = control_system(odom,ref);
            pioneer_set_controls(v,w);
            %robot_control along trajectory from saved position
            %end of path reached: cont = false;
        end
    end
end

delete(lidartmr);
delete(odometrytmr);
end

function door_true = searchQR()
    message = test_qr_webcam();
    if strcmp(message,DOOR)
        door_true = true;
    else
        door_true = false;
    end
end

function initLidar(src, event)
    global rangescan;
    rangescan = 0;
    disp('lidar timer initialised')
end

function initOdometry(src, event)
    global odometry;
    odometry = 0;
    disp('odometry timer initialised')
end

%door threshold: office 7cm, bathroom 10cm
function lidartimerCallback(src, event)
    global rangescan;
    global door_detected;
    global odometry;
    threshold = 60;
    left = [];
    right = [];
    sum_left = [];
    sum_right = [];
    rangescan = LidarScan(lidar);
    left = [left,rangescan(85)]
    right = [right,rangescan(597)]
    sum_left = [left, left(end)-left(length(left)-1)]
    sum_right = [right, right(end)-right(length(right)-1)]
    
    if(sum_left(end)>threshold)
        door_detected = true
    end
    if(sum_right(end)>threshold)
        door_detected = true
    end
   
        
    
end
function odometrytimerCallback(src, event)
    global odometry;
    %odometry = pioneer_read_odometry();
end