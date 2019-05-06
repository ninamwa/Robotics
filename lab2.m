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
global door_detected_right;
global door_detected_left;
global doors
door_detected_right = false;
door_detected_left = false;

doors = dlmread('Doors_edit.txt'); % [x,y,bol,detected] bol=1 right, bol=0 left


figure(1);
clf
axis([-100,20000,-100,20000])
hold on

%reference_path=PathPlanner(); 
reference_path = dlmread('test4.txt');
x = reference_path(:,1)*1000;
y = reference_path(:,2)*1000;


radius=40;
for k1 = 1:length(x)
plot(x(k1),y(k1),'.');
c = [x(k1) y(k1)];
pos = [c-radius 2*radius 2*radius];
rectangle('Position',pos,'Curvature',[1 1])
axis equal
text(x(k1) + 0.1,y(k1) + 0.1 ,num2str(k1),'Color','k')
end


for i = 1:length(reference_path(:,1))
    %ref = reference_path(i,:);
    ref = reference_path(i,1:2)*1000;
    disp(odometry);
    
    disp(ref)
    fprintf('error: %d\n', norm(odometry(1:2)-ref))
    while norm(odometry(1:2)-ref)>40
        hold on;
        plot(odometry(1), odometry(2), 'k.');
        drawnow;
        hold off;
        if ~door_detected_right && ~door_detected_left
            res = control_system(odometry,ref,i);
            fprintf('v: %d, w: %d\n', res(1),res(2))
            pioneer_set_controls(sp,res(1),res(2));            
        else
            pioneer_set_controls(sp,50,0);
            pause(8);
            pioneer_set_controls(sp,0,0);
            if door_detected_right
                % Turn 90 degrees right
                pioneer_set_controls(sp,0,-10);
                pause(9)
                pioneer_set_controls(sp,0,0);
                % Get door status and Play sound
                pause(1)
                status = get_door_status(rangescan);
                playSound(status);
                % Turn 90degrees left
                pioneer_set_controls(sp,0,10);
                pause(9)
                pioneer_set_controls(sp,0,0);
                door_detected_right = false;
            end
            if door_detected_left
                % Turn 90degrees left
                pioneer_set_controls(sp,0,10);
                pause(9)
                pioneer_set_controls(sp,0,0);
                % Get door status and Play sound
                pause(1)
                status = get_door_status(rangescan);
                playSound(status);
                % Turn 90degrees right
                pioneer_set_controls(sp,0,-10);
                pause(9)
                pioneer_set_controls(sp,0,0);
                door_detected_left=false;
            end
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
    global door_detected_left;
    global door_detected_right;
    global odometry;

    rangescan = LidarScan(lidar);
    [door_detected_left, door_detected_right] = lidarDoor(odometry,start_coordinates,rangescan)

      
        
    
end
function odometrytimerCallback(src, event)
    global odometry;
    odometry = pioneer_read_odometry();
end