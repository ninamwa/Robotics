function mapInflated = GetMap(robotRadius)
%% Create Binary OccupancyGrid
%{
% https://se.mathworks.com/help/robotics/ref/robotics.binaryoccupancygrid-class.html#bunq527-2
% An occupied location is represented as true (1) and a free location is represented as false (0).
% resolution specified in cells per meter.
%image = imread('Piso005crop.png');
%image = image(70:1680,330:1970);
%}
image = imread('map2.png');
image = image(55:500,50:480); % 572?×?524
imageBW = image < 200;
map = robotics.BinaryOccupancyGrid(imageBW,19.99999);

%{
show(map, "grid")
mat = occupancyMatrix(map); % returns occupancy values stored in the occupancy grid object as a matrix.

occval = getOccupancy(map,[1 4]);   
returns an array of occupancy values for an input array of world coordinates, xy. 
Each row of xy is a point in the world, represented as an [x y] coordinate pair.

 xy = grid2world(map,ij) converts a [row col] array of grid indices, ij, to an array of world coordinates, xy.
 ij = world2grid(map,xy) converts an array of world coordinates, xy, to a [rows cols] array of grid indices, ij.
%}


%% Define Robot Dimensions and Inflate the Map
% PRM does not account for the dimension of the robot, and hence providing an inflated map to the PRM takes into account the robot dimension. 
mapInflated = copy(map);
inflate(mapInflated,robotRadius);

end