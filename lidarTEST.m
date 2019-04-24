function ans = lidarTEST()%,hallway) %in degrees
%% TODO : 
% ONLY CHECK FOR DOORS WITHIN -800: LITT FREM
%% TODO: ONLY SET TRUE/ CHECK FOR DOORS IF IT IS CLOSER THAN 50 MM

%% TODO: CHANGE MAX LENGTH OF DOOR, MAKE BOOLEAN FOR DOUBLEDOOR?

%% TODO: MAKE SOUND IF SOMETHING IS IN RANGE X: -400:600 ellerno


orientation = -10;

%ranges = LidarScan(lidar);
ranges = [1357	1355	1341	1334	1324	1322	1318	1310	1299	1292	1285	1285	1280	1279	1275	1267	1260	1256	1256	1253	1251	1238	1235	1234	1226	1224	1222	1218	1208	1208	1208	1206	1205	1195	1194	1184	1179	1179	1179	1173	1167	1167	1166	1164	1166	1166	1162	1161	1161	1159	1148	1145	1145	1145	1133	1129	1129	1129	1129	1129	1129	1120	1120	1114	1112	1107	1100	1095	1074	1074	1074	1083	1084	1094	1095	1097	1095	1097	1097	1093	1090	1090	1090	1090	1097	1097	1099	1099	1098	1086	1094	1090	1090	1086	1086	1086	1085	1085	1085	1086	1077	1077	1077	1087	1087	1090	1090	1087	1087	1080	1074	1074	1074	1107	1144	1149	1149	1146	1149	1151	1151	1152	1152	1152	1148	1145	1145	1142	1148	1161	1164	1161	1162	1162	1162	1162	1162	1163	1163	1168	1165	1169	1170	1173	1170	1173	1177	1180	1180	1181	1183	1181	1180	1180	1180	1180	1180	1184	1185	1185	1190	1194	1196	1199	1201	1201	1202	1202	1202	1210	1213	1218	1221	1224	1224	1227	1228	1243	1245	1248	1253	1253	1253	1263	1263	1269	1271	1273	1273	1278	1279	1286	1304	1313	1315	1317	1334	1334	1334	1339	1349	1351	1352	1354	1372	1372	1374	1378	1381	1382	1389	1404	1406	1415	1422	1423	1448	1463	1463	1463	1451	1430	1430	1412	1403	1403	1403	1410	1424	1447	1452	1458	1462	1474	1482	1507	1511	1516	1520	1524	1540	1558	1559	1568	1589	1592	1607	1615	1626	1643	1653	1661	1680	1688	1688	1711	1731	1764	1769	1785	1787	1787	1803	1828	1837	1857	1875	1877	1895	1915	1932	1949	1983	1990	2003	2030	2046	2068	2088	2118	2139	2151	2172	2207	2215	2250	2286	2302	2336	2355	2389	2419	2446	2488	2506	2563	2590	2633	2682	2722	2772	2828	2858	2914	2975	3028	3067	3118	3176	3194	3333	0	0	0	7	0	4213	4349	4349	4349	4378	4380	4424	4466	4637	4637	4637	4637	4737	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	6	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	5309	5309	7	0	0	0	0	0	0	0	0	0	0	0	3013	2903	2833	2759	2689	2625	2625	2563	2465	2415	2415	2415	2429	2436	2436	2436	2419	2368	2341	2293	2253	2208	2152	2108	2060	2026	2026	1988	1946	1674	1657	1647	1616	1604	1583	1564	1546	1523	1512	1485	1476	1452	1435	1427	1408	1387	1382	1364	1355	1335	1304	1272	1264	1246	1241	1241	1241	1243	1249	1254	1279	1282	1291	1306	1313	1313	1313	1302	1302	1302	1299	1310	1312	1320	1325	1330	1330	1339	1348	1351	1351	1364	1370	1374	1375	1382	1391	1402	1405	1409	1410	1411	1422	1443	1445	1449	1452	1463	1467	1485	1487	1488	1508	1518	1518	1525	1539	1548	1562	1564	1586	1588	1596	1604	1627	1628	1634	1649	1669	1671	1682	1698	1710	1726	1733	1741	1769	1772	1790	1794	1815	1823	1840	1853	1872	1891	1907	2260	2294	2313	2313	2347	2374	2388	2418	2458	2497	2524	2542	2588	2617	2652	2686	2713	2766	2816	2831	2888	2923	2999	3049	3115	3146	3204	3276	3346	3405	3485	3555	3637	3721	3779	3797	3800	3804	3989	0	7	0	7	0	0	7	0	0	0	0	0	706	706	705	705	705	705	702	703	703	703	703	703	703	696	696	696	702	702	702	702	697	697	695	695	697	695	695	695	699	694	698	691	697	690	697	696	696	696	696	696	695	697	697	697	702	703	703	703	703	702	702	702	702	707	709	709	712	713	713	713	713	713	713	713	718	719	719	719	718	718	718	722	722	723	722	722	725	725	720	725	725	729	732	733	732	736	736	735	735	738	738	746	746	747	752];
x= [];
y=[];
for n = 1:length(ranges)
    if ranges(n)> 10
        xn = cosd(-30+ orientation +(n-1)*(240/682)) *ranges(n);
        yn = sind(-30+ orientation +(n-1)*(240/682)) *ranges(n);
        x=[x; xn];
        y=[y; yn];
    end

end
points=[x,y];


leftpoints = [];
rightpoints = [];

left_door=[];
right_door=[];


for i = 1:length(x)
    if points(i,1)<0 && points(i,2)<2000 % ønsker ikke å kutte liste mer, for out of range problem i løkke
        leftpoints= [points(i,:);leftpoints];
    end
    if points(i,1)>0 && points(i,2)<2000
        rightpoints= [rightpoints;points(i,:)];
    end
end

%% PLOT HALL
plot(leftpoints(:,1),leftpoints(:,2));
hold on
plot(rightpoints(:,1),rightpoints(:,2));
hold on

setParam = 0;
while setParam ==0
rightdoor = false;
leftdoor = false;
start_door_edge = 0;
stop_door=0;
stop_door_edge =0;
detecteddoor = false;
c = 100;
diffx = 0;
diffy = 0;
diff=0;
setParam=1;
end

%% FOR RIGHT CORRIDOR
for i = 1:length(rightpoints(:,1))
    if rightpoints(i,2) < 1500 % ønsker bare å se på disse
        % Hvis stigningen fortsetter i neste 5 punkter, og for avstand fra
        % robot ikke mer enn 1500
        if rightpoints(i,1)<rightpoints(i+1,1) && rightpoints(i,1)<rightpoints(i+2,1)
            start_door_edge=rightpoints(i,1); %Potensiell start av dør
            start_door_edge_y=rightpoints(i,2); %Potensiell start av dør
            slopey =  (abs(rightpoints(i+2,2))-abs(rightpoints(i,2))) / (rightpoints(i+2,1)-rightpoints(i,1));
        end
        while start_door_edge~=0 && slopey > 0 && slopey < 0.5 && rightpoints(i,1) < rightpoints(c+i,1)
            if rightpoints(c+i,1)-rightpoints(c+i+2,1)>20
                break  
            end
            diffx = rightpoints(c+i,1)-rightpoints(i,1); 
            diffy = abs(rightpoints(c+i,2))-abs(rightpoints(i,2));
            c=c+1;
        end
        if diffx > 50 && diffy > 700 %&& diffx dørkarm diff y dør
            detecteddoor = true;
            stop_door=c+i;
            diffx=0;
            diffy=0;
            break
        else
            start_door_edge =0;
            c=100;
        end
    end
end

%% CHECK LAST EDGE, RIGHT
c=1;
if detecteddoor % hvis potensiell dør er funnet
    for i = stop_door:length(rightpoints(:,1))
        if rightpoints(i,2)<1500 % ønsker bare å se på disse
            if rightpoints(i,1)>rightpoints(i+1,1) && rightpoints(i,1)>rightpoints(i+2,1)
                stop_door_edge=rightpoints(i,1); % potensiell slutt på dør
                slopey =  abs((abs(rightpoints(i+2,2))-abs(rightpoints(i,2))) / (abs(rightpoints(i+2,1))-abs(rightpoints(i,1))));
            end
            while stop_door_edge~=0 && slopey > 0 && slopey < 0.5 && rightpoints(i,1)>rightpoints(c+i,1) 
                if abs(rightpoints(c+i+2,2))-abs(rightpoints(c+i,2))>10
                    break  
                end
                diff = rightpoints(i,1)-rightpoints(c+i,1);  
                c=c+1;
            end
            if diff > 40 % dørkarm
                rightdoor = true;
                right_door = [start_door_edge,start_door_edge_y];
                % [start,stop] in y direction from robot
                break
            else
                stop_door_edge =0;
                c=1;
            end
        end
    end
end


leftpoints= [-leftpoints(:,1),leftpoints(:,2)];
setParam = 0;
while setParam ==0
leftdoor = false;
start_door_edge = 0;
stop_door=0;
stop_door_edge =0;
detecteddoor = false;
c = 100;
diffx = 0;
diffy = 0;
diff=0;
setParam=1;
end
%% FOR LEFT CORRIDOR
for i = 1:length(leftpoints(:,1))
    if leftpoints(i,2) < 1500 % ønsker bare å se på disse
        % Hvis stigningen fortsetter i neste 5 punkter, og for avstand fra
        % robot ikke mer enn 1500
        if leftpoints(i,1)<leftpoints(i+1,1) && leftpoints(i,1)<leftpoints(i+2,1)
            start_door_edge=leftpoints(i,1); %Potensiell start av dør
            start_door_edge_y=leftpoints(i,2); %Potensiell start av y
            slopey =  (abs(leftpoints(i+2,2))-abs(leftpoints(i,2))) / (leftpoints(i+2,1)-leftpoints(i,1));
        end
        while start_door_edge~=0 && slopey > 0 && slopey < 0.5 && leftpoints(i,1) < leftpoints(c+i,1)
            if leftpoints(c+i,1)-leftpoints(c+i+2,1)>20
                break  
            end
            diffx = leftpoints(c+i,1)-leftpoints(i,1); 
            diffy = abs(leftpoints(c+i,2))-abs(leftpoints(i,2));
            c=c+1;
        end
        if diffx > 50 && diffy > 700 %&& diffx dørkarm diff y: dørlengde
            detecteddoor = true;
            stop_door=c+i;
            diffx=0;
            diffy=0;
            break
        else
            start_door_edge =0;
            c=100;
        end
    end
end

%% CHECK LAST EDGE, LEFT
c=1;
if detecteddoor % hvis potensiell dør er funnet
    for i = stop_door:length(leftpoints(:,1))
        if leftpoints(i,2)<1500 % ønsker bare å se på disse
            if leftpoints(i,1)>leftpoints(i+1,1) && leftpoints(i,1)>leftpoints(i+2,1)
                stop_door_edge=leftpoints(i,1); % potensiell slutt på dør
                slopey =  abs((abs(leftpoints(i+2,2))-abs(leftpoints(i,2))) / (abs(leftpoints(i+2,1))-abs(leftpoints(i,1))));
            end
            while stop_door_edge~=0 && slopey > 0 && slopey < 0.5 && leftpoints(i,1)>leftpoints(c+i,1) 
                if abs(leftpoints(c+i+2,2))-abs(leftpoints(c+i,2))>10
                    break  
                end
                diff = leftpoints(i,1)-leftpoints(c+i,1);  
                c=c+1;
            end
            if diff > 40 % dørkarm
                leftdoor = true;
                left_door = [-start_door_edge ,start_door_edge_y];
                % [start,stop] in y direction from robot
                break
            else
                stop_door_edge =0;
                c=1;
            end
        end
    end
end

ans = [leftdoor, rightdoor];

%% IS THERE A DOOR ON RIGHT OR LEFT WITHIN THE RANGE?
if length(left_door)>0
fprintf("Left door: x: %d, y: %d \n",left_door(1),left_door(2))
plot(left_door(1),left_door(2),'+')
hold on
end
if length(right_door)>0
fprintf("Right door: x: %d, y: %d \n",right_door(1),right_door(2))
plot(right_door(1),right_door(2),'+')
end
hold off
%plot(left_door(1),left_door(2),'+')
%hold on
%plot(right_door(1),right_door(2),'+')

end