function ans = lidarDoor(nearby_doors,ranges)  %input: ranges
% Odometry in mm
% Start_coordinates in mm, worldcoordinates

%% TODO: (problem) for halvåpen dør kommer max(norm) til å si at max er der 
%døren går uendelig innover, og ikke dørkarm, som kommer til å gi feil
%dør start.

%% Door_edit.txt is most likely not correct. measure the first door in world to check.
ans = [false,false,false];
%% Process ranges
ranges = [1357	1355	1341	1334	1324	1322	1318	1310	1299	1292	1285	1285	1280	1279	1275	1267	1260	1256	1256	1253	1251	1238	1235	1234	1226	1224	1222	1218	1208	1208	1208	1206	1205	1195	1194	1184	1179	1179	1179	1173	1167	1167	1166	1164	1166	1166	1162	1161	1161	1159	1148	1145	1145	1145	1133	1129	1129	1129	1129	1129	1129	1120	1120	1114	1112	1107	1100	1095	1074	1074	1074	1083	1084	1094	1095	1097	1095	1097	1097	1093	1090	1090	1090	1090	1097	1097	1099	1099	1098	1086	1094	1090	1090	1086	1086	1086	1085	1085	1085	1086	1077	1077	1077	1087	1087	1090	1090	1087	1087	1080	1074	1074	1074	1107	1144	1149	1149	1146	1149	1151	1151	1152	1152	1152	1148	1145	1145	1142	1148	1161	1164	1161	1162	1162	1162	1162	1162	1163	1163	1168	1165	1169	1170	1173	1170	1173	1177	1180	1180	1181	1183	1181	1180	1180	1180	1180	1180	1184	1185	1185	1190	1194	1196	1199	1201	1201	1202	1202	1202	1210	1213	1218	1221	1224	1224	1227	1228	1243	1245	1248	1253	1253	1253	1263	1263	1269	1271	1273	1273	1278	1279	1286	1304	1313	1315	1317	1334	1334	1334	1339	1349	1351	1352	1354	1372	1372	1374	1378	1381	1382	1389	1404	1406	1415	1422	1423	1448	1463	1463	1463	1451	1430	1430	1412	1403	1403	1403	1410	1424	1447	1452	1458	1462	1474	1482	1507	1511	1516	1520	1524	1540	1558	1559	1568	1589	1592	1607	1615	1626	1643	1653	1661	1680	1688	1688	1711	1731	1764	1769	1785	1787	1787	1803	1828	1837	1857	1875	1877	1895	1915	1932	1949	1983	1990	2003	2030	2046	2068	2088	2118	2139	2151	2172	2207	2215	2250	2286	2302	2336	2355	2389	2419	2446	2488	2506	2563	2590	2633	2682	2722	2772	2828	2858	2914	2975	3028	3067	3118	3176	3194	3333	0	0	0	7	0	4213	4349	4349	4349	4378	4380	4424	4466	4637	4637	4637	4637	4737	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	5309	5309	7	0	0	0	0	0	0	0	0	0	0	0	3013	2903	2833	2759	2689	2625	2625	2563	2465	2415	2415	2415	2429	2436	2436	2436	2419	2368	2341	2293	2253	2208	2152	2108	2060	2026	2026	1988	1946	1674	1657	1647	1616	1604	1583	1564	1546	1523	1512	1485	1476	1452	1435	1427	1408	1387	1382	1364	1355	1335	1304	1272	1264	1246	1241	1241	1241	1243	1249	1254	1279	1282	1291	1306	1313	1313	1313	1302	1302	1302	1299	1310	1312	1320	1325	1330	1330	1339	1348	1351	1351	1364	1370	1374	1375	1382	1391	1402	1405	1409	1410	1411	1422	1443	1445	1449	1452	1463	1467	1485	1487	1488	1508	1518	1518	1525	1539	1548	1562	1564	1586	1588	1596	1604	1627	1628	1634	1649	1669	1671	1682	1698	1710	1726	1733	1741	1769	1772	1790	1794	1815	1823	1840	1853	1872	1891	1907	2260	2294	2313	2313	2347	2374	2388	2418	2458	2497	2524	2542	2588	2617	2652	2686	2713	2766	2816	2831	2888	2923	2999	3049	3115	3146	3204	3276	3346	3405	3485	3555	3637	3721	3779	3797	3800	3804	3989	0	7	0	7	0	0	7	0	0	0	0	0	706	706	705	705	705	705	702	703	703	703	703	703	703	696	696	696	702	702	702	702	697	697	695	695	697	695	695	695	699	694	698	691	697	690	697	696	696	696	696	696	695	697	697	697	702	703	703	703	703	702	702	702	702	707	709	709	712	713	713	713	713	713	713	713	718	719	719	719	718	718	718	722	722	723	722	722	725	725	720	725	725	729	732	733	732	736	736	735	735	738	738	746	746	747	752];
x= [];
y=[];
lidar_error_range = 15; % can be tuned
for n = 1:length(ranges)
    if ranges(n)> lidar_error_range
        xn = cosd(-30+ (n-1)*(240/682)) *ranges(n);
        yn = sind(-30+ (n-1)*(240/682)) *ranges(n);
        x=[x; xn];
        y=[y; yn];
    end

end
points=[x,y];

%% Set rightpoints and leftpoints
leftpoints = [];
rightpoints = [];
for i = 1:length(x)
    if points(i,1)<0 && points(i,2)<2000 % ønsker ikke å kutte liste mer, for out of range problem i løkke
        leftpoints= [points(i,:);leftpoints];
    end
    if points(i,1)>0 && points(i,2)<2000
        rightpoints= [rightpoints;points(i,:)];
    end
end

%% Set thresholds and parameters
door_threshold = 70; %60? think 70 is too big. How big norm represents a door?
search_range = 1500; % 1000? How far ahead should we look for doors?
door_distance = 30; %2 is probably to small. How close should the robot be to the door before is it denoted as detected?
door_distance_front = 1700;
detect_door_left = false; % results
detect_door_right = false; % results
detect_door_front = false; % results
L_index = 0; % only used for plotting
R_index = 0; % only used for plotting
F_index = 0; % only used for plotting
nearby_door_left=[];
nearby_door_right=[];
nearby_door_front=[];
%% Read doors:
doors = get_doors();
% x,y, 0:RIGHT/1:LEFT/2:FRONT, 0:NOTFOUND/1:FOUND/

%% SET NEARBY DOORS
if ~isempty(nearby_doors)
    for n = 1:length(nearby_doors(:,1))
        if nearby_doors(n,3)==0 % left door
            nearby_door_left = nearby_doors(n,:);
        elseif nearby_doors(n,3)==1 % right door
            nearby_door_right = nearby_doors(n,:);
        elseif nearby_doors(n,3)==2 % front door
            nearby_door_front = nearby_doors(n,:);
        end
    end
end

%% Find norms in right wall
if ~isempty(nearby_door_right)% Right door
    right_door = [0,0];
    % Check rightpoints
    for n = 1:length(rightpoints(:,1))
        % In searchrange ( don't want to process more than .. m ahead )
        if rightpoints(n,2) < search_range
            % Find all norms, benches and elevator could be detected
            norm_right(n) = norm(rightpoints(n,:)-rightpoints(n+2,:));
       
            % If the norm is over a threshold, this would be a door
            if norm_right(n) > door_threshold     % Find first maxnorm on rightwall
                Y = norm_right(n);
                % Save start position of door
                right_door = [rightpoints(n,1),rightpoints(n,2)];
                break
            end
        end
    end
    % If the distance to the door is less than door_distance, we
    % want a DOOR event to occur, and list the door as detected
    if norm(right_door(2))>0 && norm(right_door(2))<door_distance
        R_index = n; % used for plotting
        %doors(nearby_door_right(5),4)=1; 
        detect_door_right = true; % SET GLOBAL RIGHT DOOR TO TRUE
        set_door_detected(nearby_door_right(5))% SET DOOR TO FOUND
    end
end

if ~isempty(nearby_door_left)%  If left door
    %% Find norms on left wall
    left_door = [0,0];
    for n = 1:length(leftpoints(:,1))
        if leftpoints(n,2) < search_range
            norm_left(n) = norm(leftpoints(n,:)-leftpoints(n+2,:));
              if norm_left(n) > door_threshold     % Find first maxnorm on rightwall
                Y= norm_left(n);
                % Save start position of door
                left_door = [leftpoints(n,1),leftpoints(n,2)];
                break
              end
        end
    end
    if norm(left_door(2))>0 && norm(left_door(2))<door_distance
        L_index = n;
        % doors(nearby_door_left(5),4)=1; SET DOOR TO FOUND
        detect_door_left = true; % SET GLOBAL LEFT DOOR TO TRUE
        set_door_detected(nearby_door_left(5)); % SET DOOR TO FOUND
    end
end
if ~isempty(nearby_door_front)
    all_points = [leftpoints;rightpoints];
    front_points = [];
    for n=1:length(all_points(:,1))
        if sqrt(all_points(n,1)^2) < 300 && all_points(n,2) > 100 
            front_points = [front_points;all_points(n,:)];
        end
    end
    if~isempty(front_points)
        for i = 1:length(front_points(:,1))-2
            norm_front(i) = norm(front_points(i,:)-front_points(i+2,:));
            if norm_front(i) > door_threshold     % Find first maxnorm on rightwall
                Y= norm_left(n);
                % Save start position of door
                front_door = [front_points(n,1),front_points(n,2)];
                break
            end
        end
    % If the distance to the door is less than door_distance, we
    % want a DOOR event to occur, and list the door as detected
    if norm(front_door(2))>0 && norm(front_door(2))< door_distance_front
        F_index = n; % used for plotting
        detect_door_front = true; % SET GLOBAL RIGHT DOOR TO TRUE
        set_door_detected(nearby_door_front(5))% SET DOOR TO FOUND
    end
    end
end


% Booleans that execute an event in cause of true
ans = [detect_door_left, detect_door_right, detect_door_front];

% Plot rangescan and doors found
figure(2)
plot(leftpoints(:,1),leftpoints(:,2))
hold on
plot(rightpoints(:,1),rightpoints(:,2))
hold on
if L_index ~=0
    plot(leftpoints(L_index,1),leftpoints(L_index,2),'o')
    hold on
end
if R_index ~=0
    plot(rightpoints(R_index,1),rightpoints(R_index,2),'*')
end
if F_index ~=0
    plot(front_points(F_index,1),front_points(F_index,2),'o')
end
hold off

end