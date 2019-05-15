%% TODO: Legg inn labben.
% for å få smud sving, sørg for å få en sirkel med sentrum 
% med radius= avstand fra fra-punkt til sentrum og til-punkt til sentrum
map=GetMap(0.01);
show(map);
hold on 
StopPoints = [
            6,7.125;
            19,7.125; %19.5
            20.5,9;%8.508;
            20.5,19.75;%20.5;
            18.6,21.5;
            8.2,21.5; %7.125
            6.125,20.4; % 20.51
            6.177,7.125]; % 0.0633
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
            6.177,20.01; % 20.51
            6.177,7.125
            6.177,4.2
            4.5, 3
            2,3
            
            ]; % 0.0633
    x=(StopPoints(:,1));
    y=(StopPoints(:,2));
%map=GetMap(0.01);
%show(map);
%hold on
    t = linspace(0,1000,length(x));
    u = linspace(0,1000,10000);
    ppx = pchip(t,x);
    xx=ppval(ppx, u);
    ppy = pchip(t,y);
    yy=ppval(ppy,u);
    %plot(x,y,'o',xx,yy,'-','LineWidth',2);
    %grid on
    %grid minor
    x= (xx-StopPoints(1,1))';
    y= (yy -StopPoints(1,2))';
    
    Waypoints = [x,y];
d = dlmread('Doors_edit.txt');
plot(d(:,1)/1000,d(:,2)/1000,'o')

hold off
%       hold off

%dlmwrite('PerfectPathLab.txt', Waypoints,'newline','pc');