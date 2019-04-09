%% Parameters
robotRadius = 0.2; % was 0.2;
NumNodes=1300; % gir smudere resultat kan tunes
ConnectionDistance = 60; % høyere gir færre punkter % kan tunes
sampleTime = 0.1;
startLocation = [124 140];
Waypoints =[];
ranges = [];
StopPoints = [128,140;360,140;412,175;409,415;400,425;159,425;128,390;128,140];
%StopPoints = [124,140;412,250;280,427;124,140];

%% Get map
map = GetMap(6.5);  % get map with good margins for path finder

%% Initialize visualizer
viz = Visualizer2D;
viz.hasWaypoints = true;
viz.hasLidar = false; % må endres

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
pose = [startLocation(1), startLocation(2),0];
Waypoints = [xx,yy];
map2 = GetMap(robotRadius);
viz.mapName = 'map2';
viz(pose,path);

for i = 1:length(Waypoints(:,1))
    pose = [Waypoints(i,1),Waypoints(i,2),0];
    %ranges = lidar(pose);
    %viz(pose,Waypoints,ranges)
    viz(pose,path);
end

