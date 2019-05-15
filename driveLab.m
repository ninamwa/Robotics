function driveLab(sp,type)
%measurements 285, 420
%drive out of lab 
if type == 1
    pioneer_set_controls(sp,100,0);
    pause(2.85);
    pioneer_set_controls(sp,0,45);
    pause(2);
    pioneer_set_controls(sp,100,0);
    pause(4.2);
    pioneer_set_controls(sp,0,-45);
    pause(2);
    pioneer_set_controls(sp,0,0);
end
%drive into lab
if type==2
    pioneer_set_controls(sp,100,0);
    pause(4.2);
    pioneer_set_controls(sp,0,-45);
    pause(2);
    pioneer_set_controls(sp,100,0);
    pause(2.85);
    pioneer_set_controls(sp,0,0);   
end

end