function detect_door_action(where)%L:0,R:1,F:2
global door_detected_front
global door_detected_right
global door_detected_left
global lidar
global rangescan
global door_index

if where == 2
    pioneer_set_controls(sp,0,0);
    status =  get_door_status_front(rangescan);
    playSound(status);
    door_detected_front = false;
    door_index = door_index+1;
elseif where ==0 || where ==1
    pioneer_set_controls(sp,50,0);
    pause(8);
    pioneer_set_controls(sp,0,0);
    door_index = door_index+1;
    if where == 1
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
    if where == 0
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