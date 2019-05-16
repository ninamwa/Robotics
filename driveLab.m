function driveLab(type)
%measurements 2850, 4200
%drive out of lab 
delete(timerfindall);
sp = serial_port_start();
pioneer_init(sp);
pause(2)
if type == 1
    pioneer_set_controls(sp,500,0);
    pause(5.7);
    pioneer_set_controls(sp,0,0);
    pioneer_set_controls(sp,0,45);
    pause(2);
    pioneer_set_controls(sp,500,0);
    pause(8.6);
    pioneer_set_controls(sp,0,0);
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


pioneer_close(sp);
serial_port_stop(sp);
end