function status = get_door_status_front(ranges)%lidar,ranges)
%% TODO: TUNE PARAMETERS

%% TO TEST WITH LIDAR:
%SetupLidar(); MATLAB MÅ VÆRE 1,  port_name ='/dev/tty.usbmodem1421';
%ranges=LidarScan(lidar);

%% TO TEST WITH RANGES FILES:
%halfopendoor.txt
%opendoor.txt
%closeddoor.txt
%ranges = dlmread('closeddoor.txt');

%% Define thresholds
eliminate_x = 900; % only look at x=[-eliminate_x:eliminate_x]
eliminate_y = 100; % only look at y>eliminate_y

%% THESE NEED TO BE TUNED
open_threshold = 4000; % bigger than
closed_threshold = 3000; % less than
closed_diff_threshold = 80; % threshold for difference between points in closed door
search_range_door = 199; 
% check x= [-search_range_door,0,search_range_door]
%for thresholds


%% Process ranges
x= [];
y=[];
for n = 1:length(ranges)
    if ranges(n)> 20
        xn = cosd(-30+ (n-1)*(240/682)) *ranges(n);
        yn = sind(-30+ (n-1)*(240/682)) *ranges(n);
        x=[x; xn];
        y=[y; yn];
    end

end
points=[];

%% Eliminate irrelevant points:
for i =1:length(x)
    if x(i)>-eliminate_x && x(i)<eliminate_x
        if y(i)>eliminate_y
            points=[points;x(i),y(i)];
        end
    end
end

x=points(:,1);
y=points(:,2);

plot(x,y);
hold on


%% Find y values in before - middle - after
for i=1:length(x)
    if x(i)<-search_range_door
        before=y(i);
        plot(x(i),before,'o');
        hold on
        break
    end
end
for i=1:length(x)
    if x(i)<search_range_door 
        after=y(i);
        plot(x(i),after,'o');
        hold on
        break
    end
end
for i=1:length(x)
    if x(i)<0 
        middle=y(i);
        plot(x(i),middle,'*');
        hold off
        break
    end
end
%% Check y values in before - middle - after
if before >open_threshold && middle >open_threshold && after >open_threshold
    status = 'open';
elseif before <closed_threshold && middle <closed_threshold && after <closed_threshold
    % check if closed or half open by checking the differnence between points
    if sqrt((before-after)^2)<closed_diff_threshold && sqrt((middle-after)^2)<closed_diff_threshold && sqrt((before-middle)^2)<closed_diff_threshold 
    status = 'closed';
    end
else
    status = 'half';
end

%'open'
%'half'
%'closed'
end