function detect_door_action(sp,LeftRightFront,lidar,distance_to_door)%L:0,R:1,F:2
global door_index

pause_turning = 2;
pause_drive_forward = distance_to_door/50 + 8;
if door_index == 1
    pause_drive_forward = pause_drive_forward + 2;
end

if LeftRightFront == 2
    pioneer_set_controls(sp,0,0);
    pause(1);
    rangescan = LidarScan(lidar);
    pause(1);
    status =  get_door_status_front(rangescan);
    playSound(status);
    pause(3);
    door_index = door_index+1;    
elseif LeftRightFront ==0 || LeftRightFront ==1
    if door_index ~= 6
        pioneer_set_controls(sp,50,0);
        pause(pause_drive_forward);
        pioneer_set_controls(sp,0,0);
    end
    if LeftRightFront == 1 %right
        first_turn = -45;
        second_turn = 45;
        if door_index == 3 || door_index==14
            second_turn =90; % 180 degrees, for doors in corner 1 and 3
        end
    elseif LeftRightFront ==0 %left
        first_turn = 45;
        second_turn = -45;
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
    pause(1)
    door_index = door_index+1;
end

end
