function lab2merge()
delete(timerfindall);
sp = serial_port_start();
pioneer_init(sp);
global lidar;
SetupLidar();

%{
do not need lidar timer
lidartmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 1, ...
    'StartFcn',{@initLidar}, ...
    'TimerFcn', {@lidartimerCallback});

%}
odometrytmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 0.1, ...
    'StartFcn',{@initOdometry}, ...
    'TimerFcn', {@odometrytimerCallback});

%start(lidartmr);
start(odometrytmr);
global odometry;

door_detected_right = false;
door_detected_left = false;
door_detected_front = false;
distance_to_wall = 0;
global door_index;
door_index = 1;

%TODO: Legg inn 6177,7000,2,0 nederst i doors_edit.txt hvis vi skal ha med front door.

doors = dlmread('Doors_edit.txt'); % [x,y,bol,detected] bol=1 right, bol=0 left, bol=2 front


figure(1);
clf
axis([-100,20000,-100,20000])
hold on

%reference_path=PathPlanner();
reference_path = dlmread('test11.txt');
x = reference_path(:,1)*1000;
y = reference_path(:,2)*1000;


radius=150;
for k1 = 1:length(x)
    plot(x(k1),y(k1),'.');
    c = [x(k1) y(k1)];
    pos = [c-radius 2*radius 2*radius];
    rectangle('Position',pos,'Curvature',[1 1])
    axis equal
    text(x(k1) + 0.1,y(k1) + 0.1 ,num2str(k1),'Color','k')
end

x_real=0;
y_real=0;
%driveLab(sp,1);
for i = 1:length(reference_path(:,1))
    ref = reference_path(i,1:2)*1000;
    fprintf("odom %d: ",odometry);
    fprintf("ref %d: ",ref);
    fprintf('error: %d\n', norm(odometry(1:2)-ref))
    
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
        %hold on;
        %plot(odometry(1), odometry(2), 'k.');
        %drawnow;
        %hold off;
        if ~door_detected_right && ~door_detected_left && ~door_detected_front
            res = control_system(odometry,ref,distance_to_wall,i);
            x_real=res(3);
            y_real=res(4);
            pioneer_set_controls(sp,res(1),res(2));
        else         
            if door_detected_front
                detect_door_action(sp,2,lidar,distance_to_door);%front
                door_detected_front = false;
            elseif door_detected_right
                detect_door_action(sp,1,lidar,distance_to_door);%right
                door_detected_right = false;
                distance_to_wall = LD_result(4);
                fprintf("correction %d :",distance_to_wall - 835);       
            elseif door_detected_left 
                 detect_door_action(sp,0,lidar,distance_to_door);%left
                 door_detected_left = false;
                 distance_to_wall = result(4);

            end
            % Check if we need to go to the next reference point. list numbers may be tuned
            if i <= 15 && (odometry(1) > ref(1))
                break
            elseif i>15 && i <= 57 && odometry(2) > ref(2)
                break
            elseif i >57 && i <= 87 && odometry(1)  < ref(1)
                break
            elseif i > 87 && i <= 101 && odometry(2) < ref(2)
                break
            end
            
        end
        
    end
    fprintf('POINT REACHED: %d', i)
end
%driveLab(sp,2);
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
global odometry;
odometry = pioneer_read_odometry();
end

function nearby_doors = doors_in_range(doors,odom)
% For all doors in list, check if we are close enought, regarding odometry,
% to start searching for the door
% OBS! Odometry errors will make this a problem after a while... tune threshold
disp(odom)
%start_coordinates  =[3600,2600]; % from lab mm
start_coordinates = [6000,7125];% mm from hall
global door_index;
odom_range_threshold = 1000; % How far is odomotry from a existing door?
nearby_doors=[]; % Initialize list to prevent error
i=door_index; % must be incremented
odom_range = norm([doors(i,1)-start_coordinates(1),doors(i,2)-start_coordinates(2)]-[odom(1),odom(2)]);
%odom
%odom_range
if odom_range < odom_range_threshold && doors(i,4)==0
    nearby_doors=[nearby_doors;doors(i,:),i];
end
end