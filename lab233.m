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
door_index = 1;
number = 1;
distance_to_wall = 0;
global corr_y;
global corr_x;

corr_y = 0;
corr_x = 0;

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
             disp('in nearby doors');
            %rangescan = LidarScan(lidar);
            %LD_result = lidarDoor(nearby_doors,rangescan);
            RLF = doors(door_index,3);
            if RLF == 1
                door_detected_right = true;
                nearby_doors = [];
            elseif RLF == 0
                door_detected_left = true;
                nearby_doors = [];
            else
                door_detected_front = true;
                nearby_doors = [];
            end
            %disp(door_detected_right);
            %distance_to_door = LD_result(5);
            
            if  door_index ==6
                door_index = door_index +1;
                door_detected_left = false;
                door_detected_right = false;
            end
            
        end

        if ~door_detected_right && ~door_detected_left && ~door_detected_front
            res = control_system(ref,distance_to_wall,theta_correction,h,theta_ref);
            x_real=res(3);
            y_real=res(4);
            pioneer_set_controls(sp,res(1)+150,res(2));
        else
            pioneer_set_controls(sp,0,0);
            pioneer_set_controls(sp,100,0);
            pause(5);
            if door_index == 3 || door_index == 15
                pause(3);
            elseif door_index == 10 
                disp("DOOR10")
                pause(8);
                pioneer_set_controls(sp,0,0);
            end
            
            pioneer_set_controls(sp,0,0);
     
            prompt = 'What is the distance to the wall? ';
            distance_to_wall = input(prompt);
            if h <= 12
                corr_y = corr_y + (distance_to_wall-835);
            elseif h <= 21
                corr_x= corr_x + (distance_to_wall-835);
            elseif h <= 29
                corr_y = corr_y + (distance_to_wall-835);
            elseif h <= 45
                corr_x = corr_x + (distance_to_wall-835);
            end
            fprintf('correction %d :',distance_to_wall - 835);
            fprintf('door_index %d : ', door_index);
            if door_index == 3 || door_index == 10 || door_index == 15
                pioneer_set_controls(sp,0,45);
                pause(2);
                pioneer_set_controls(sp,0,0);
            end
            
            door_detected_right = false;
            door_detected_left = false;
            door_detected_front = false;
            
            door_index = door_index +1;
            
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
    nearby_doors = [];
    global door_index;
    if door_index <=20
        start_coordinates  =[3600,2600]; % from lab mm
        %start_coordinates = [6000,7125];% mm from hall
        odom_range_threshold = 800; % How far is odomotry from a existing door?
        nearby_doors=[]; % Initialize list to prevent error
        odom_range = norm([doors(door_index,1)-start_coordinates(1),doors(door_index,2)-start_coordinates(2)]-[odom(1),odom(2)]);
        %odom
        %odom_range
        if odom_range < odom_range_threshold && doors(door_index,4)==0
            nearby_doors=[nearby_doors;doors(door_index,:),door_index];
        end
    end
end
            