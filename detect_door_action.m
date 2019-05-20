function detect_door_action(LeftRightFront)%L:0,R:1,F:2
global door_detected_front
global door_detected_right
global door_detected_left
global lidar
global rangescan
global door_index
global sp
pause_turning = 2;

if LeftRightFront == 2
    pioneer_set_controls(sp,0,0);
    pause(1);
    rangescan = LidarScan(lidar);
    pause(1);
    status =  get_door_status_front(rangescan);
    playSound(status);
    pause(3);
    door_detected_front = false;
    door_index = door_index+1;    
elseif LeftRightFront ==0 || LeftRightFront ==1
    pioneer_set_controls(sp,50,0);
    pause(8);
    pioneer_set_controls(sp,0,0);
    if LeftRightFront == 1 %right
        first_turn = -45;
        second_turn = 45;
        door_detected_right = false;
        if door_index == 3
            second_turn =90; % 180 degrees, dette må nok gjøres for dør i hjørne 3 og :)
        end
    elseif LeftRightFront ==0 %left
        first_turn = 45;
        second_turn = -45;
        door_detected_left = false;
    end
    %Turn 90 degrees
    pioneer_set_controls(sp,0,first_turn);
    pause(pause_turning)
    pioneer_set_controls(sp,0,0);
    pause(1)
    rangescan = LidarScan(lidar);
    pause(1)
    % Get door status and Play sound
    status = get_door_status(rangescan);
    playSound(status);
    pause(3);
    % Turn 90degrees
    pioneer_set_controls(sp,0,second_turn);
    pause(pause_turning)
    pioneer_set_controls(sp,0,0);
    door_index = door_index+1;
end
    
end
