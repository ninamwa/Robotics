function main_withLidar()
delete(timerfindall);
sp = serial_port_start();
pioneer_init(sp);
global odometry;
global door_index;
global x_real
global y_real
global distance_to_wall
global number
door_index = 1;
number = 1;
distance_to_wall = 0;
global corr_y;
global corr_x;
corr_y = 0;
corr_x = 0;
SetupLidar();

vlist =[];
wlist=[];

odometrytmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 0.1, ...
    'StartFcn',{@initOdometry}, ...
    'TimerFcn', {@odometrytimerCallback});

start(odometrytmr);
x_real=odometry(1);
y_real=odometry(2);

door_detected_right = false;
door_detected_left = false;
door_detected_front = false;
theta_correction=0;

doors = dlmread('Doors_edit.txt');
reference_path = dlmread('test11.txt');

driveLab(sp,1);

reference_path(:,1)=reference_path(:,1)*1000+odometry(1);
reference_path(:,2)=reference_path(:,2)*1000+odometry(2);
dlmwrite('test11corrected.txt', reference_path,'newline','pc');

x_ref = reference_path(:,1);
y_ref = reference_path(:,2);

theta_ref = zeros(1,length(x_ref));
for h = 1:length(x_ref)-1
    theta_ref(h) = atan2( (y_ref(h+1)- y_ref(h)), (x_ref(h+1)-x_ref(h)));
end
theta_ref(length(x_ref)) = theta_ref(length(x_ref)-1);

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
            %disp('in nearby doors');
            rangescan = LidarScan(lidar);
            LD_result = lidarDoor(nearby_doors,rangescan);
            door_detected_left = LD_result(1);
            door_detected_right = LD_result(2);
            door_detected_front = LD_result(3);
            distance_to_door = LD_result(5);
            if door_index == 12
                door_detected_left = false;
                door_index = door_index+1;
            end
            
        end
        
        if ~door_detected_right && ~door_detected_left && ~door_detected_front
            res = control_system(ref,theta_ref,h);
            x_real=res(3);
            y_real=res(4);
            vlist = [vlist,res(1)+150];
            wlist = [wlist,res(2)];
            pioneer_set_controls(sp,res(1)+150,res(2));
        else
            if door_detected_front
                detect_door_action(sp,2,lidar,distance_to_door);%front
                door_detected_front = false;
                distance_to_wall = LD_result(4);
            
            elseif door_detected_right
                distance_to_wall = LD_result(4);
                detect_door_action(sp,1,lidar,distance_to_door);%right
                door_detected_right = false;
                door_detected_left = false;

            elseif door_detected_left
                detect_door_action(sp,0,lidar,distance_to_door);%left
                door_detected_left = false;
                distance_to_wall = LD_result(4);

            end
            if door_index == 6 && distance_to_wall < 350
                distance_to_wall = 450;
            end 
            if distance_to_wall < 250 
                distance_to_wall = 350;
            elseif distance_to_wall > 1400
                distance_to_wall = 1300;
            end
               
            if h <= 12
                corr_y = corr_y + (distance_to_wall-835);
            elseif h <= 21
                corr_x= corr_x + (distance_to_wall-835);
            elseif h <= 29
                corr_y = corr_y - (distance_to_wall-835);
            elseif h <= 45
                corr_x = corr_x - (distance_to_wall-835);
            end
            if changeReference(h,ref,x_real,y_real)
                break
            end
        end
        
    end
    %fprintf('POINT REACHED: %d', h)
end

figure(1)
plot(vlist);
figure(2)
plot(wlist);

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
corrected = correctOdometry(number);
x_real = corrected(1);
y_real = corrected(2);
end

function nearby_doors = doors_in_range(doors,odom)
    % For all doors in list, check if we are close enought, regarding odometry,
    % to start searching for the door
    
    nearby_doors = [];
    global door_index;
    if door_index <=20
        start_coordinates  =[3600,2600]; % from lab mm
        odom_range_threshold = 1000; % How far is odomotry from a existing door?
        nearby_doors=[]; % Initialize list to prevent error
        odom_range = norm([doors(door_index,1)-start_coordinates(1),doors(door_index,2)-start_coordinates(2)]-[odom(1),odom(2)]);
        if odom_range < odom_range_threshold && doors(door_index,4)==0
            nearby_doors=[nearby_doors;doors(door_index,:),door_index];
        end
    end
end