% FOR STARTING IN HALL
map=GetMap(0.01);
show(map);
hold on 
StopPoints = [
            6,7.125;
            20.2,7.125; 
            20.5,9;
            20.5,19.75;
            18.6,21.5;
            6.732,21.5;
            6.125,20;
            6.177,7.125];
    x=(StopPoints(:,1));
    y=(StopPoints(:,2));
    t = linspace(0,1000,length(x));
    u = linspace(0,1000,10000);
    ppx = pchip(t,x);
    xx=ppval(ppx, u);
    ppy = pchip(t,y);
    yy=ppval(ppy,u);
    plot(x,y,'o',xx,yy,'-','LineWidth',2);
    grid on
    grid minor
    hold on
    x= (xx-StopPoints(1,1))';
    y= (yy -StopPoints(1,2))';
    
    Waypoints = [x,y];

%dlmwrite('PerfectPathHall.txt', Waypoints,'newline','pc');

% FOR STARTING AT LAB
StopPoints = [2,3
            4.5, 3
            6.177,4.2
            6.177,6.0
            7.5  ,7.125
            
            19.5,7.125; 
            20.5,8.508;
            20.5,20.5;
            19,21.5;
            7.124,21.5;
            6.177,20.01; 
            6.177,7.125
            6.177,4.2
            4.5, 3
            2,3
            
            ]; 
    x=(StopPoints(:,1));
    y=(StopPoints(:,2));

    t = linspace(0,1000,length(x));
    u = linspace(0,1000,10000);
    ppx = pchip(t,x);
    xx=ppval(ppx, u);
    ppy = pchip(t,y);
    yy=ppval(ppy,u);

    x= (xx-StopPoints(1,1))';
    y= (yy -StopPoints(1,2))';
    
    Waypoints = [x,y];
d = dlmread('Doors.txt');
plot(d(:,1)/1000,d(:,2)/1000,'r*')

hold off

%dlmwrite('PerfectPathLab.txt', Waypoints,'newline','pc');