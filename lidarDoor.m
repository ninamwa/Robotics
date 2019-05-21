function ans = lidarDoor(nearby_doors,ranges)  %input: ranges
% Odometry in mm
% Start_coordinates in mm, worldcoordinates

%% TODO: (problem) for halvåpen dør kommer max(norm) til å si at max er der 
%døren går uendelig innover, og ikke dørkarm, som kommer til å gi feil
%dør start.
x= [];
y=[];
distance_to_door = 0;
lidar_error_range = 15; % can be tuned
for n = 1:length(ranges)
    if ranges(n)> lidar_error_range
        xn = cosd(-30+ (n-1)*(240/682)) *ranges(n);
        yn = sind(-30+ (n-1)*(240/682)) *ranges(n);
        x=[x; xn];
        y=[y; yn];
    end

end
points=[x,y];

%% Set rightpoints and leftpoints
leftpoints = [];
rightpoints = [];
for i = 1:length(x)
    if points(i,1)<0 && points(i,2)<2000 % ønsker ikke å kutte liste mer, for out of range problem i løkke
        leftpoints= [points(i,:);leftpoints];
    end
    if points(i,1)>0 && points(i,2)<2000
        rightpoints= [rightpoints;points(i,:)];
    end
end
%% Door_edit.txt is most likely not correct. measure the first door in world to check.
ans = [false,false,false];

%% Set thresholds and parameters
door_threshold = 70; %60? think 70 is too big. How big norm represents a door?
search_range = 1500; % 1000? How far ahead should we look for doors?
door_distance = 50; %2 is probably to small. How close should the robot be to the door before is it denoted as detected?
door_distance_front = 1700;
detect_door_left = false; % results
detect_door_right = false; % results
detect_door_front = false; % results
L_index = 0; % only used for plotting
R_index = 0; % only used for plotting
F_index = 0; % only used for plotting
nearby_door_left=[];
nearby_door_right=[];
nearby_door_front=[];
%% Read doors:
doors = get_doors();
% x,y, 0:RIGHT/1:LEFT/2:FRONT, 0:NOTFOUND/1:FOUND/

%% SET NEARBY DOORS
if ~isempty(nearby_doors)
    for n = 1:length(nearby_doors(:,1))
        if nearby_doors(n,3)==0 % left door
            nearby_door_left = nearby_doors(n,:);
        elseif nearby_doors(n,3)==1 % right door
            nearby_door_right = nearby_doors(n,:);
        elseif nearby_doors(n,3)==2 % front door
            nearby_door_front = nearby_doors(n,:);
        end
    end
end

%% Find norms in right wall
if ~isempty(nearby_door_right)% Right door
    right_door = [0,0];
    % Check rightpoints
    for n = 1:length(rightpoints(:,1))-2
        % In searchrange ( don't want to process more than .. m ahead )
        if rightpoints(n,2) < search_range
            % Find all norms, benches and elevator could be detected
            norm_right(n) = norm(rightpoints(n,:)-rightpoints(n+2,:));
       
            % If the norm is over a threshold, this would be a door
            if norm_right(n) > door_threshold     % Find first maxnorm on rightwall
                Y = norm_right(n);
                % Save start position of door
                right_door = [rightpoints(n,1),rightpoints(n,2)];
                distance_to_door = rightpoints(n,1);
                break
            end
        end
    end
    % If the distance to the door is less than door_distance, we
    % want a DOOR event to occur, and list the door as detected
    if norm(right_door(2))>0 && norm(right_door(2))<door_distance
        R_index = n; % used for plotting
        %doors(nearby_door_right(5),4)=1; 
        detect_door_right = true; % SET GLOBAL RIGHT DOOR TO TRUE
        set_door_detected(nearby_door_right(5))% SET DOOR TO FOUND
    end
end

if ~isempty(nearby_door_left)%  If left door
    %% Find norms on left wall
    left_door = [0,0];
    for n = 1:length(leftpoints(:,1))-2
        if leftpoints(n,2) < search_range
            norm_left(n) = norm(leftpoints(n,:)-leftpoints(n+2,:));
              if norm_left(n) > door_threshold     % Find first maxnorm on rightwall
                Y= norm_left(n);
                % Save start position of door
                left_door = [leftpoints(n,1),leftpoints(n,2)];
                distance_to_door = 835 - leftpoints(n,1);
                break
              end
        end
    end
    if norm(left_door(2))>0 && norm(left_door(2))<door_distance
        L_index = n;
        % doors(nearby_door_left(5),4)=1; SET DOOR TO FOUND
        detect_door_left = true; % SET GLOBAL LEFT DOOR TO TRUE
        set_door_detected(nearby_door_left(5)); % SET DOOR TO FOUND
    end
end
if ~isempty(nearby_door_front)
    all_points = [leftpoints;rightpoints];
    front_points = [];
    for n=1:length(all_points(:,1))
        if sqrt(all_points(n,1)^2) < 300 && all_points(n,2) > 100 
            front_points = [front_points;all_points(n,:)];
        end
    end
    if~isempty(front_points)
        for i = 1:length(front_points(:,1))-2
            norm_front(i) = norm(front_points(i,:)-front_points(i+2,:));
            if norm_front(i) > door_threshold     % Find first maxnorm on rightwall
                Y= norm_left(n);
                % Save start position of door
                front_door = [front_points(n,1),front_points(n,2)];
                break
            end
        end
    % If the distance to the door is less than door_distance, we
    % want a DOOR event to occur, and list the door as detected
    if norm(front_door(2))>0 && norm(front_door(2))< door_distance_front
        F_index = n; % used for plotting
        detect_door_front = true; % SET GLOBAL RIGHT DOOR TO TRUE
        set_door_detected(nearby_door_front(5))% SET DOOR TO FOUND
    end
    end
end


% Booleans that execute an event in cause of true
ans = [detect_door_left, detect_door_right, detect_door_front, distance_to_door];

% Plot rangescan and doors found
%{
figure(2)
plot(leftpoints(:,1),leftpoints(:,2))
hold on
plot(rightpoints(:,1),rightpoints(:,2))
hold on
if L_index ~=0
    plot(leftpoints(L_index,1),leftpoints(L_index,2),'o')
    hold on
end
if R_index ~=0
    plot(rightpoints(R_index,1),rightpoints(R_index,2),'*')
end
if F_index ~=0
    plot(front_points(F_index,1),front_points(F_index,2),'o')
end
hold off
%}
end