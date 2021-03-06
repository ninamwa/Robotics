function status = get_door_status(ranges)
global door_index
status= 'half'; % initialize
middle = 0;
after = 0;
before = 0;

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

distance_to_wall = y(1); % rightermost point
if door_index == 1
    distance_to_wall = y(length(y)); % use left point instead, double door
end

%% Define thresholds
open_threshold = distance_to_wall+1100; % bigger than
closed_threshold = distance_to_wall+200; % less than
closed_diff_threshold = 70; % threshold for difference between points in closed door
search_range_door = 150;
% check x= [-search_range_door,0,search_range_door]
%for thresholds

%% Find y values in before - middle - after

for i=1:length(x)
    if x(i)<-search_range_door
        before=y(i+1);
        before = (y(i-1) + y(i) + y(i+1) + y(i+2) + y(i+3) )/5;
        break
    end
end
for i=1:length(x)
    if x(i)<search_range_door
        after = y(i-1); 
        after =( y(i-2) + y(i-1) + y(i) + y(i+1) + y(i+2))/5;
        break
    end
end

for i=1:length(x)
    if x(i)<=0
        middle_index=i;
        middle=y(middle_index);
        if x(i)<0
            middle_index=i-1;
            middle=y(middle_index);
            
        end
        middle = (y(middle_index-2) + y(middle_index-1) + y(middle_index) + y(middle_index+1)+y(middle_index+2))/5;
        break
    end
end

%% Check y values in before - middle - after

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