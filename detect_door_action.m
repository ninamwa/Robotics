
function detect_door_action(sp,LeftRightFront,lidar,distance_to_door)%L:0,R:1,F:2global door_index
global door_index
pause_turning = 2;
pause_drive_forward = distance_to_door/50 + 10;
if door_index == 1
    pause_drive_forward = pause_drive_forward + 10;
end
if door_index == 3
    pause_drive_forward = pause_drive_forward + 2;
end
if door_index == 10
    pause_drive_forward = distance_to_door/50;
end


if LeftRightFront == 2  %FRONT
    pioneer_set_controls(sp,50,0);
    pause(pause_drive_forward)
    pioneer_set_controls(sp,0,0);
    pause(1);
    rangescan = LidarScan(lidar);
    pause(1);
    % TA STILLING:
    status =  get_door_status(rangescan);
    playSound(status);
    pause(3);
    pioneer_set_controls(sp,0,45);
    pause(pause_turning);
    pioneer_set_controls(sp,0,0);
    pause(1);
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