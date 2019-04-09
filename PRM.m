
function [path,xx,yy] = PRM(totalpath,map,NumNodes, ConnectionDistance, startLocation,endLocation)

prm = robotics.PRM(map);

prm.NumNodes = NumNodes;
prm.ConnectionDistance = ConnectionDistance;
path = findpath(prm, startLocation, endLocation);

% Tune nodes
while isempty(path)
    % No feasible path found yet, increase the number of nodes
    prm.NumNodes = prm.NumNodes + 10;
    
    % Use the |update| function to re-create the PRM roadmap with the changed
    % attribute
    update(prm);
    
    % Search for a feasible path with the updated PRM
    path = findpath(prm, startLocation, endLocation);
end
%show(prm)
%hold on

%% Interpolation
    x=(path(:,1));
    y=(path(:,2));

    t = linspace(0,1000,length(x));
    u = linspace(0,1000,10000);
    ppx = pchip(t,x);
    xx=ppval(ppx, u);
    ppy = pchip(t,y);
    yy=ppval(ppy,u);
    %plot(x,y,'o',xx,yy,'-','LineWidth',2);

if length(totalpath)>1
    show(prm)
    hold on
    % make total path list, remove duplicates
    path = [totalpath;path];
    endpoint = path(1,:);
    path = unique(path,'rows', 'stable');
    path = [path;endpoint];
    
    i = 1;
    while true          
       if sqrt((path(i,1)-path(i+1,1))^2) < 10 && sqrt((path(i,2)-path(i+1,2))^2) < 10
           if i == length(path)-1
               path(i,:) = [];
               break
           end
           path(i+1,:) = [];
           if (i == length(path))
               break
           end
       else
           i = i+1;
       end
       if (i == length(path)+1)
           break
       end
    end
    
    x=(path(:,1));
    y=(path(:,2));

    t = linspace(0,1000,length(x));
    u = linspace(0,1000,10000);
    ppx = pchip(t,x);
    xx=ppval(ppx, u);
    ppy = pchip(t,y);
    yy=ppval(ppy,u);
    plot(x,y,'o',xx,yy,'-','LineWidth',2);
    grid on
    grid minor
end
end