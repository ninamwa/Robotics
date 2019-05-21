function status = get_door_status(ranges)

%% TO TEST WITH LIDAR:
%SetupLidar(); MATLAB MÅ VÆRE 1,  port_name ='/dev/tty.usbmodem1421';
%ranges=LidarScan(lidar);

%% TO TEST WITH RANGES FILES:
%halfopendoor.txt
%opendoor.txt
%closeddoor.txt
%ranges = dlmread('halfopendoor2.txt');
status= 'half';

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
eliminate_x = 900; % only look at x=[-eliminate_x:eliminate_x]
eliminate_y = 100; % only look at y>eliminate_y
for i =1:length(x)
    if x(i)>-eliminate_x && x(i)<eliminate_x
        if y(i)>eliminate_y
            points=[points;x(i),y(i)];
        end
    end
end

x=points(:,1);
y=points(:,2);
figure(2)
plot(x,y);
hold on
distance_to_wall = y(1);%y(length(y));
plot(x(1),y(1),'o');

%plot(x(length(y)),y(length(y)),'o');

%% Define thresholds
open_threshold = distance_to_wall+1100; % bigger than
closed_threshold = distance_to_wall+150; % less than
closed_diff_threshold = 30; % threshold for difference between points in closed door
search_range_door = 170; % not used
% check x= [-search_range_door,0,search_range_door]
%for thresholds

%% Find y values in before - middle - after
%{
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
%}
for i=1:length(x)
    if x(i)<=0
        middle_index=i;
        middle=y(middle_index);
        if x(i)<0
            middle_index=i-1;
            middle=y(middle_index);
        end
        plot(x(middle_index),middle,'*');
        break
    end
end

after=y(middle_index -5);
before = y(middle_index +5);
plot(x(middle_index-5),after,'o');
plot(x(middle_index+5),before,'o');
hold off

%% Check y values in before - middle - after
%before
%middle
%after
%sqrt((before-after)^2)
%sqrt((middle-after)^2)
%sqrt((before-middle)^2)
if  middle > open_threshold && after >open_threshold % before > open_threshold &&
    status = 'open';
elseif before <closed_threshold && middle <closed_threshold && after <closed_threshold
    % check if closed or half open by checking the differnence between points
    if sqrt((before-after)^2)<closed_diff_threshold && sqrt((middle-after)^2)<closed_diff_threshold && sqrt((before-middle)^2)<closed_diff_threshold
        status = 'closed';
    end
else
    status = 'half';
end
end