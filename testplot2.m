function testplot2()

figure(1);
clf
axis([-100,20000,-100,20000])
hold on

%reference_path=PathPlanner();
reference_path = dlmread('test11.txt');
x = reference_path(:,1)*1000;
y = reference_path(:,2)*1000;


radius=150;
for k1 = 1:length(x)
    plot(x(k1),y(k1),'.');
    c = [x(k1) y(k1)];
    pos = [c-radius 2*radius 2*radius];
    rectangle('Position',pos,'Curvature',[1 1])
    axis equal
    text(x(k1) + 0.1,y(k1) + 0.1 ,num2str(k1),'Color','k')
end