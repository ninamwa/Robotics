function lab2merge()
%drive from hall: kommentar p� startcoord nederst, drivelab er kommentert
%ut og p� linje 57,58
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
theta_correction=0;
global door_index;
door_index = 1;

%TODO: Legg inn 6177,7000,2,0 nederst i doors_edit.txt hvis vi skal ha med front door.

doors = dlmread('Doors_edit.txt'); % [x,y,bol,detected] bol=1 right, bol=0 left, bol=2 front


%figure(1);
%clf
%axis([-100,20000,-100,20000])
%hold on

reference_path = dlmread('test11.txt');

%theta_correction = driveLab(sp,lidar,1);
theta_correction =0; % NEEDS TO BE REMOVED!!!!!
tic;
t=toc;
while t<2
    t=toc;
end

x_real=odometry(1);
y_real=odometry(2);
reference_path(:,1)=reference_path(:,1)*1000; %+odometry(1);
reference_path(:,2)=reference_path(:,2)*1000;%+odometry(2);
dlmwrite('test11corrected.txt', reference_path,'newline','pc');

%{
x = reference_path(:,1);
y = reference_path(:,2);
radius=100;
for k1 = 1:length(x)
    plot(x(k1),y(k1),'.');
    c = [x(k1) y(k1)];
    pos = [c-radius 2*radius 2*radius];
    rectangle('Position',pos,'Curvature',[1 1])
    axis equal
    text(x(k1) + 0.1,y(k1) + 0.1 ,num2str(k1),'Color','k')
end
%}

for i=1:length(reference_path(:,1))
    ref = reference_path(i,1:2);
    disp(odometry)
    disp(ref)
    disp(norm(odometry(1:2)-ref))
    
    while norm([x_real,y_real]-ref)>100
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
            res = control_system(ref,distance_to_wall,theta_correction,i);
            x_real=res(3);
            y_real=res(4);
            pioneer_set_controls(sp,res(1)+50,res(2));
        else         
            theta_correction = adjustment(rangescan);
            reference_path(:,1:2) =reference_path(:,1:2) * [cos(theta_correction), -sin(theta_corrction); sin(theta_correction), cos(theta_correction)]; 
            fprintf("theta_correction %d :",theta_correction)
            if door_detected_front
                distance_to_wall = detect_door_action(sp,2,lidar,distance_to_door);%front
                door_detected_front = false;
            elseif door_detected_right
                distance_to_wall = detect_door_action(sp,1,lidar,distance_to_door);%right
                door_detected_right = false;
               % distance_to_wall = LD_result(4);
                fprintf("correction %d :",distance_to_wall - 835);       
            elseif door_detected_left 
                 distance_to_wall = detect_door_action(sp,0,lidar,distance_to_door);%left
                 door_detected_left = false;
                 %distance_to_wall = result(4);
            end
            
           corrected_odom = correctOdometry(i,distance_to_wall);
           x_real = corrected_odom(1);
           y_real = corrected_odom(2);
           
            % Check if we need to go to the next reference point. list numbers may be tuned
            if i <= 12 && (x_real > ref(1))            
                break
            elseif i>12 && i <= 57 && y_real > ref(2)
                break
            elseif i >57 && i <= 87 && x_real  < ref(1)
                break
            elseif i > 87 && i <= 101 && y_real < ref(2)
                break
            end
        end
        
    end
    fprintf('POINT REACHED: %d', i)
end
driveLab(sp,lidar,2);
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
%disp(odometry);
end

function nearby_doors = doors_in_range(doors,odom)
% For all doors in list, check if we are close enought, regarding odometry,
% to start searching for the door
% OBS! Odometry errors will make this a problem after a while... tune threshold
%disp(odom)
%start_coordinates  =[3600,2900]; % from lab mm
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