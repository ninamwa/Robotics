function lab2()
delete(timerfindall);
sp = serial_port_start();
pioneer_init(sp);


lidartmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 1, ...
    'StartFcn',{@initLidar}, ...
    'TimerFcn', {@lidartimerCallback});


odometrytmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 0.1, ...
    'StartFcn',{@initOdometry}, ...
    'TimerFcn', {@odometrytimerCallback});

%start(lidartmr);
start(odometrytmr);
global odometry;
global door_detected;
door_detected = false;

figure(1);
clf
axis([-100,20000,-100,20000])
hold on

%reference_path=PathPlanner(); 
reference_path = dlmread('Path.txt');
x = reference_path(:,1);
y = reference_path(:,2);


radius=40;
for k1 = 1:100:length(x)
plot(x(k1),y(k1),'.');
c = [x(k1) y(k1)];
pos = [c-radius 2*radius 2*radius];
rectangle('Position',pos,'Curvature',[1 1])
axis equal
end


for i = 1:100:length(reference_path(:,1))
    ref = reference_path(i,:);
    disp(odometry);
    
    disp(ref)
    fprintf('error: %d\n', norm(odometry(1:2)-ref))
    while norm(odometry(1:2)-ref)>40
        hold on;
        plot(odometry(1), odometry(2), 'k.');
        drawnow;
        hold off;
        if ~door_detected
            res = control_system(odometry,ref);
            fprintf('v: %d, w: %d\n', res(1),res(2))
            pioneer_set_controls(sp,res(1),res(2));            
        else 
            true_door = searchQR();
            if true_door
                %Turn 90degrees
                status = get_door_status();
                playSound(status);
            end
            door_detected=false;
        end
        
    end
    fprintf('POINT REACHED: %d', i)
end

delete(lidartmr);
delete(odometrytmr);
pioneer_close(sp);
serial_port_stop(sp);
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
    odometry = pioneer_read_odometry();
end