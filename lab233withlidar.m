function lab233withlidar()
delete(timerfindall);
sp = serial_port_start();
pioneer_init(sp);
global odometry;
global door_index;
global x_real
global y_real
global distance_to_wall
global number
global lidar;
door_index = 1;
number = 1;
distance_to_wall = 0;
x_real=odometry(1);
y_real=odometry(2);
SetupLidar();

odometrytmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 0.1, ...
    'StartFcn',{@initOdometry}, ...
    'TimerFcn', {@odometrytimerCallback});

start(odometrytmr);


door_detected_right = false;
door_detected_left = false;
door_detected_front = false;
theta_correction=0;

doors = dlmread('Doors_edit.txt'); % [x,y,bol,detected] bol=1 right, bol=0 left, bol=2 front
reference_path = dlmread('test11.txt');

driveLab(sp,1);

reference_path(:,1)=reference_path(:,1)*1000+odometry(1);
reference_path(:,2)=reference_path(:,2)*1000+odometry(2);
dlmwrite('test11corrected.txt', reference_path,'newline','pc');

% nytt
x_ref = reference_path(:,1);
y_ref = reference_path(:,2);

theta_ref = zeros(1,length(x_ref));
for h = 1:length(x_ref)-1
    theta_ref(h) = atan2( (y_ref(h+1)- y_ref(h)), (x_ref(h+1)-x_ref(h)));
end
%slutt nytt

x = reference_path(:,1);
y = reference_path(:,2);


for h =1:length(reference_path(:,1))
    number = h;
    ref = reference_path(h,1:2);
    disp(odometry)
    disp(ref)
    disp(norm(odometry(1:2)-ref))
    if changeReference(h,ref,x_real,y_real)
        fprintf('POINT REACHED: %d', h)
        continue
    end
    while norm([x_real,y_real]-ref)>150

        nearby_doors = doors_in_range(doors,[x_real,y_real]);
         if ~isempty(nearby_doors)
            rangescan = LidarScan(lidar);
            LD_result = lidarDoor(nearby_doors,rangescan);
            door_detected_left = LD_result(1);
            door_detected_right = LD_result(2);
            door_detected_front = LD_result(3);
            disp(door_detected_right);
            distance_to_door = LD_result(5);
        end

        if ~door_detected_right && ~door_detected_left && ~door_detected_front
            res = control_system(ref,distance_to_wall,theta_correction,h,theta_ref);
            x_real=res(3);
            y_real=res(4);
            pioneer_set_controls(sp,res(1)+70,res(2));
        else
            %theta_correction = adjustment(rangescan)*180/pi - 90;
            %detect_door_action(sp,2,lidar,distance_to_door,theta_correction)
            %i detect door action, ta inn vinkel
            % first_turn = 90 + theta_correction
            
            if door_detected_front
                detect_door_action(sp,2,lidar,distance_to_door);%front
                door_detected_front = false;
            elseif door_detected_right
                detect_door_action(sp,1,lidar,distance_to_door);%right
                door_detected_right = false;
                distance_to_wall = LD_result(4);
                fprintf(2,' Distance to wall %d :\n',distance_to_wall);       
                fprintf(2,' correction %d :\n',distance_to_wall - 835);       
            elseif door_detected_left 
                 detect_door_action(sp,0,lidar,distance_to_door);%left
                 door_detected_left = false;
                 distance_to_wall = LD_result(4);
            end
    
            if changeReference(h,ref,x_real,y_real)
                break
            end
        end
        
    end
    fprintf('POINT REACHED: %d', h)
end
driveLab(sp,2);
delete(odometrytmr);
pioneer_close(sp);
serial_port_stop(sp);
end


function initOdometry(src, event)
global odometry;
odometry = 0;
disp('odometry timer initialised')
end


function odometrytimerCallback(src, event)
global odometry
global x_real
global y_real
global distance_to_wall
global number
odometry = pioneer_read_odometry();
corrected = correctOdometry(number,distance_to_wall);
x_real = corrected(1);
y_real = corrected(2);
end

function nearby_doors = doors_in_range(doors,odom)
% For all doors in list, check if we are close enought, regarding odometry,
% to start searching for the door
% OBS! Odometry errors will make this a problem after a while... tune threshold
%disp(odom)
global door_index;
start_coordinates  =[3600,2600]; % from lab mm
%start_coordinates = [6000,7125];% mm from hall
odom_range_threshold = 1000; % How far is odomotry from a existing door?
nearby_doors=[]; % Initialize list to prevent error
odom_range = norm([doors(door_index,1)-start_coordinates(1),doors(door_index,2)-start_coordinates(2)]-[odom(1),odom(2)]);
%odom
%odom_range
if odom_range < odom_range_threshold && doors(door_index,4)==0
    nearby_doors=[nearby_doors;doors(door_index,:),door_index];
end
end