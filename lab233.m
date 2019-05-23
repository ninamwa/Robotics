function lab233()
delete(timerfindall);
sp = serial_port_start();
pioneer_init(sp);

odometrytmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 0.1, ...
    'StartFcn',{@initOdometry}, ...
    'TimerFcn', {@odometrytimerCallback});

start(odometrytmr);
global odometry;

door_detected_right = false;
door_detected_left = false;
door_detected_front = false;
distance_to_wall = 0;
theta_correction=0;
global door_index;
door_index = 1;

doors = dlmread('Doors_edit.txt'); % [x,y,bol,detected] bol=1 right, bol=0 left, bol=2 front

figure(1);
clf
axis([-100,20000,-100,20000])
hold on

reference_path = dlmread('test11.txt');

driveLab(sp,1);
x_start=odometry(1);
y_start=odometry(2);
x_real=odometry(1);
y_real=odometry(2);
reference_path(:,1)=reference_path(:,1)*1000+odometry(1);
reference_path(:,2)=reference_path(:,2)*1000+odometry(2);

x = reference_path(:,1);
y = reference_path(:,2);
radius=150;
for k1 = 1:length(x)
    plot(x(k1),y(k1),'.');
    c = [x(k1) y(k1)];
    pos = [c-radius 2*radius 2*radius];
    rectangle('Position',pos,'Curvature',[1 1])
    axis equal
    text(x(k1) + 0.1,y(k1) + 0.1 ,num2str(k1),'Color','k')
end

for i=1:length(reference_path(:,1))
    ref = reference_path(i,1:2);
    disp(odometry)
    disp(ref)
    disp(norm(odometry(1:2)-ref))
    
    while norm([x_real,y_real]-ref)>150
        nearby_doors = doors_in_range(doors,[x_real,y_real]);
        if ~isempty(nearby_doors)
            disp('in nearby doors')
            door_detected_right = true;
            distance_to_door = 0;
        end

        if ~door_detected_right && ~door_detected_left && ~door_detected_front
            res = control_system(ref,distance_to_wall,theta_correction,i);
            x_real=res(3);
            y_real=res(4);
            pioneer_set_controls(sp,res(1)+70,res(2));
        else         
                theta_correction = 0;
                pioneer_set_controls(sp,0,0);
                pioneer_set_controls(sp,50,0);
                pause(10);
                pioneer_set_controls(sp,0,0);
                prompt = 'What is the distance to the wall? ';
                distance_to_wall = input(prompt);
                fprintf('correction %d :',distance_to_wall - 835); 
                door_detected_right = false;
            
            corrected_odom = correctOdometry(i,distance_to_wall);
            x_real = corrected_odom(1);
            y_real = corrected_odom(2);
           
            % Check if we need to go to the next reference point. list numbers may be tuned
            if changeReference(i,ref,x_real,y_real)
                break
            end
        end
        
    end
    fprintf('POINT REACHED: %d', i)
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
global odometry;
odometry = pioneer_read_odometry();
end

function nearby_doors = doors_in_range(doors,odom)
% For all doors in list, check if we are close enought, regarding odometry,
% to start searching for the door
% OBS! Odometry errors will make this a problem after a while... tune threshold
%disp(odom)
start_coordinates  =[3600,2600]; % from lab mm
%start_coordinates = [6000,7125];% mm from hall
global door_index;
odom_range_threshold =600; % How far is odomotry from a existing door?
nearby_doors=[]; % Initialize list to prevent error
i=door_index; % must be incremented
odom_range = norm([doors(i,1)-start_coordinates(1),doors(i,2)-start_coordinates(2)]-[odom(1),odom(2)]);
%odom
%odom_range
if odom_range < odom_range_threshold && doors(i,4)==0
    nearby_doors=[nearby_doors;doors(i,:),i];
end
end