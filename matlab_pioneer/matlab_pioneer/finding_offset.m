function [odometryRes] = finding_offset()
sp = serial_port_start;
pioneer_init(sp)
odometryRes = [];
odometryRes = [pioneer_read_odometry,odometryRes];

global pioneer_timer

for i = 1:50
    pioneer_timer.StartFcn = @(~,thisEvent)disp([thisEvent.Type ' executed '...
     datestr(thisEvent.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF')]);
    pioneer_set_controls(sp,50,0);
    odometryRes = [pioneer_read_odometry;odometryRes];
    fprintf('This message is sent at time %s\n', datestr(now,'HH:MM:SS.FFF'));
    pause(4);
    pioneer_set_controls(sp,0,0);
    pioneer_timer.StopFcn = @(~,thisEvent)disp([thisEvent.Type ' executed '...
    datestr(thisEvent.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF')]);
end
disp(odometryRes);
pioner_close(sp);
delete(timerfindall);
end