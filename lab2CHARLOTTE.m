function lab2()
delete(timerfindall);
sp = serial_port_start();
pioneer_init(sp);

global rangescan;
global odometry;


lidartmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 1, ...
    'StartFcn',{@initLidar}, ...
    'TimerFcn', {@lidartimerCallback});


odometrytmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 0.1, ...
    'StartFcn',{@initOdometry}, ...
    'TimerFcn', {@odometrytimerCallback});

start(lidartmr);
start(odometrytmr);
global door_detected_right;
global door_detected_left;
global door_detected_front;
global doors
global lidar
global door_index;
SetupLidar();
door_detected_right = false;
door_detected_left = false;
door_detected_front = false; 
global start_coordinates;
%start_coordinates  =[2000,3000]; % from lab mm
start_coordinates = [6000,7125];% mm from hall
global nearby_doors;
doors = dlmread('Doors_edit.txt'); % [x,y,bol,detected] bol=1 right, bol=0 left, bol=2 front

door_index = 1;
%figure(1);
%clf
%axis([-100,20000,-100,20000])
%hold on

reference_path = dlmread('test4.txt');
x = reference_path(:,1)*1000;
y = reference_path(:,2)*1000;

h = false;
if h
    radius=40;
    for k1 = 1:length(x)
    plot(x(k1),y(k1),'.');
    c = [x(k1) y(k1)];
    pos = [c-radius 2*radius 2*radius];
    rectangle('Position',pos,'Curvature',[1 1])
    axis equal
    text(x(k1) + 0.1,y(k1) + 0.1 ,num2str(k1),'Color','k')
    end
end

pioneer_set_controls(sp,100,0)
for i = 1:length(reference_path(:,1))
    %ref = reference_path(i,:);
    ref = reference_path(i,1:2)*1000;
    %disp(odometry);
    
    %disp(ref)
    %fprintf('error: %d\n', norm(odometry(1:2)-ref))
    while norm(odometry(1:2)-ref)>40 
        %hold on;
        %plot(odometry(1), odometry(2), 'k.');
        %drawnow;
        %hold off;
        nearby_doors = doors_in_range(start_coordinates,odometry);
        if ~isempty(nearby_doors)
                %nearby_doors
                pioneer_set_controls(sp,0,0)
                rangescan = LidarScan(lidar);
                ans = lidarDoor(nearby_doors,rangescan);
                door_detected_left = ans(1);
                door_detected_right = ans(2);
                door_detected_front = ans(3);
        %% ONLY FOR DEBUGGING
                if door_detected_right|| door_detected_left || door_detected_front
                    disp("door detected");
                    %pioneer_set_controls(sp,0,0);
                end
        
        end 
    %    if ~door_detected_right && ~door_detected_left && ~door_detected_front
     %       res = control_system(odometry,ref,i);
            %fprintf('v: %d, w: %d\n', res(1),res(2))
      %      pioneer_set_controls(sp,res(1),res(2)); 
    
      
      %% If any doors are in range of odometry

       if door_detected_front
          pioneer_set_controls(sp,0,0);
          status =  get_door_status_front(rangescan);
          playSound(status);
          door_detected_front = false;
          door_index = door_index+1;
       elseif door_detected_right || door_detected_left
           pioneer_set_controls(sp,50,0);
           pause(8);
           pioneer_set_controls(sp,0,0);
           door_index = door_index+1;
           if door_detected_right
                %Turn 90 degrees right
               pioneer_set_controls(sp,0,-10);
               pause(9)
                rangescan = LidarScan(lidar);
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
               %Turn 90degrees left
               pioneer_set_controls(sp,0,10);
               pause(9)
               rangescan = LidarScan(lidar);
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
%         
%     end
%     fprintf('POINT REACHED: %d', i)
% end
    end
%delete(lidartmr);
%delete(odometrytmr);
%pioneer_close(sp);
%serial_port_stop(sp);
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
    global odometry;
    global lidar
    global start_coordinates;
    global nearby_doors;
    nearby_doors = doors_in_range(start_coordinates,odometry);
end


function odometrytimerCallback(src, event)
    global odometry;
    odometry = pioneer_read_odometry();
end

%% Check if we are close to a door
function nearby_doors = doors_in_range(start_coordinates,odom)
    % For all doors in list, check if we are close enought, regarding odometry,
    % to start searching for the door
    % OBS! Odometry errors will make this a problem after a while... tune threshold
    global door_index;
    odom_range_threshold = 1000; % How far is odomotry from a existing door?
    doors = get_doors();
    nearby_doors=[]; % Initialize list to prevent error
    i=door_index; % must be incremented
        odom_range = norm([doors(i,1)-start_coordinates(1),doors(i,2)-start_coordinates(2)]-[odom(1),odom(2)]);
        %odom
        %odom_range
        if odom_range < odom_range_threshold && doors(i,4)==0 
            nearby_doors=[nearby_doors;doors(i,:),i];
        end
    

end     
