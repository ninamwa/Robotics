%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Digere os pacotes vindos do Pioneer
%
% Rodrigo Ventura, 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pioneer_digest(sp)

global pioneer_odometry;
global pioneer_sonars;

n=0;
while 1
    data = pioneer_recvmsg(sp);
    if isempty(data)
        return
    end

    if data(1)==50 | data(1)==51
        % update odometry reading
        x=parseint(data(2:3));
        y=parseint(data(4:5));
        th=parseint(data(6:7));
        pioneer_odometry = [x, y, th];

        % update sonars readings
        nsonars=data(20);
        for i=1:nsonars
            ptr = 21+(i-1)*3;
            sid = data(ptr);
            rng = parseuint(data(ptr+1:ptr+2));
            pioneer_sonars(sid+1) = rng;
        end
        %pioneer_dumpsip(data);
        n=n+1;
    end
    
    if data(1)== 32
        disp(data)
    end
end

%disp(sprintf('[digested %d messages]\n', n));

return
