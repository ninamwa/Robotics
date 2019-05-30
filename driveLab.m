function driveLab(sp,type)
pause(2)
if type == 1
    pioneer_set_controls(sp,250,0);

    pause(11.4);
    pioneer_set_controls(sp,0,0);

    pioneer_set_controls(sp,0,44);

    pause(2);
    pioneer_set_controls(sp,250,0);

    pause(16);
    pioneer_set_controls(sp,0,0);

    pioneer_set_controls(sp,0,-45);

    pause(2);
    pioneer_set_controls(sp,0,0);

    pause(1);    
    
end
%drive into lab
if type==2
    pioneer_set_controls(sp,100,0);

    pause(37);
    
    pioneer_set_controls(sp,0,-45);

    pause(2);
    
    pioneer_set_controls(sp,100,0);

    pause(27);
    
    pioneer_set_controls(sp,0,0); 

end

end