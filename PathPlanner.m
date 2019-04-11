
function Waypoints = PathPlanner()

%% Parameters
robotRadius = 0.2; % was 0.2;
%resolution = 28.5*1000/430; % mm/cell
NumNodes=1300; % gir smudere resultat kan tunes
NumNodes= 1000; %1300; % gir smudere resultat kan tunes
ConnectionDistance = 60; % høyere gir færre punkter % kan tunes
WallMargin = 7;
Waypoints =[];
ranges = []; % kan legge til lidar i viz
StopPoints = [128,140;360,140;412,175;409,415;400,425;159,425;128,390;128,140];
%StopPoints = [124,140;412,250;280,427;124,140]; alternative stop points,
%midt i gangen

%% Get map
map = GetMap(WallMargin);  % get map with good margins for path finder

%% Initialize visualizer
%viz = Visualizer2D;
%viz.hasWaypoints = true;
%viz.hasLidar = false; % må endres

%% Get PRM
path = [];
xx = [];
yy = [];
totalpath = [];
lastiter = length(StopPoints(:,1))-1;

for i=1:lastiter
    if(i == lastiter)
        totalpath=path;
    end
    [p,x,y] = PRM(totalpath,map,NumNodes,ConnectionDistance, StopPoints(i,:), StopPoints(i+1,:)); % can tune the NodeNum and ConnectionDistance
    if(i == lastiter)
        xx = x.';
        yy = y.';
        resultPath = p;
    else 
        path = [path;p];
    end
end   
path = resultPath;

%% Visualize
%pose = [path(1,1), path(1,2),0];
%Waypoints = [xx,yy];
%map2 = GetMap(robotRadius);
%viz.mapName = 'map2';
%viz(pose,path);

%for i = 1:length(Waypoints(:,1))
%    pose = [Waypoints(i,1),Waypoints(i,2),0];
%    theta = atan2(Waypoints(i,2),Waypoints(i,1))
%    pose = [Waypoints(i,1),Waypoints(i,2),theta*180/pi];
    %ranges = lidar(pose);
    %viz(pose,Waypoints,ranges)
%    viz(pose,path);
%end
%robo = InitController(map2,path,0.3,2,0.5)
Waypoints = ([xx,yy]-[path(1,1),path(1,2)])*(28.5/430)*1000; % multiply with 1000 to go from m to mm
%disp(Waypoints)
end
