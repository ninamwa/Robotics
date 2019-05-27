function door_bol = lidarDoor(nearby_doors,ranges)  %input: ranges


% doors: x,y, 0:RIGHT/1:LEFT/2:FRONT

x= [];
y=[];
distance_to_wall = 0;
distance_to_door = 0;
lidar_error_range = 20; % can be tuned
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
for q = 1:length(x)
    if points(q,1)<0 && points(q,2)<2000  
        leftpoints= [points(q,:);leftpoints];
    end
    if points(q,1)>0 && points(q,2)<2000
        rightpoints= [rightpoints;points(q,:)];
    end
end

%% Set thresholds and parameters
door_threshold = 60; % How big norm represents a door?
search_range = 1500; % 1000? How far ahead should we look for doors?
door_distance = 500; % How close should the robot be to the door before is it denoted as detected?
door_distance_front = 1500;
detect_door_left = false; % results
detect_door_right = false; % results
detect_door_front = false; % results
L_index = 0; % only used for plotting
R_index = 0; % only used for plotting
F_index = 0; % only used for plotting
nearby_door_left=[];
nearby_door_right=[];
nearby_door_front=[];

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
                break
            end
        end
    end
    % If the distance to the door is less than door_distance, we
    % want a DOOR event to occur, and list the door as detected
    if  norm(right_door(2)) < door_distance 
        distance_to_wall = rightpoints(n,1);
        distance_to_door = rightpoints(n,2);
        R_index = n; % used for plotting
        detect_door_right = true; % SET GLOBAL RIGHT DOOR TO TRUE
        
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
                break
              end
        end
    end
    if norm(left_door(2))<door_distance 
        if distance_to_wall == 0
            distance_to_wall = 835; %1670 + leftpoints(n,1);
        end
        leftpoints(n,1)
        %if distance_to_wall == 0
        %    distance_to_wall = 835;
        %end
        distance_to_door = leftpoints(n,2);
        L_index = n;
        
        detect_door_left = true; % SET GLOBAL LEFT DOOR TO TRUE
  
    end
end
if ~isempty(nearby_door_front)
    all_points = [leftpoints;flip(rightpoints)];
    front_points = [];
    for n=1:length(all_points(:,1))
        if sqrt(all_points(n,1)^2) < 1000 && all_points(n,2) > 500 
            front_points = [front_points;all_points(n,:)];
        end
    end
    if~isempty(front_points)
        for q = 1:length(front_points)-1
            if sqrt(front_points(q,1)^2) < 10
                middle_reading = front_points(q-1,2);
                before_val = front_points(q+10,2);
                after_val = front_points(q-10,2);
                distance_to_door = (middle_reading + before_val + after_val)/3;
                break
            end
            if distance_to_door < door_distance_front
                detect_door_front = true;
                distance_to_door = distance_to_door - 835 - 70; % distance_to_door- half of hall - door
                distance_to_wall = 835;
            end
        end
        %{
        for q = 1:length(front_points(:,1))-2
            norm_front(q) = norm(front_points(q,:)-front_points(q+2,:));
            if norm_front(q) > door_threshold     % Find first maxnorm on rightwall
                Y= norm_front(q);
                % Save start position of door
                front_door = [front_points(q,1),front_points(q,2)];
                break
            end
        end
    % If the distance to the door is less than door_distance, we
    % want a DOOR event to occur, and list the door as detected
    if norm(front_door(2))>0 && norm(front_door(2))< door_distance_front
        F_index =q; % used for plotting
        detect_door_front = true; % SET GLOBAL RIGHT DOOR TO TRUE
        distance_to_door = front_points(q,2);
        %set_door_detected(nearby_door_front(5))% SET DOOR TO FOUND
    end
        %}
    end
end


% Booleans that execute an event in cause of true
door_bol = [detect_door_left, detect_door_right, detect_door_front, distance_to_wall,distance_to_door];

% Plot rangescan and doors found
%plot(leftpoints);
%if L_index ~=0
%    plot(leftpoints(L_index,1),leftpoints(L_index,2),'*');
%end
%filename = "plotdoor" + num2str(R_index) +".fig";
%savefig(filename)

end