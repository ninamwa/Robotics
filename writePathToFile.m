reference_path = dlmread('PerfectPathHall.txt');

x = reference_path(:,1);
y = reference_path(:,2);

matrix=[];
radius=40;
i=1;
for k1 = 1:100:length(x)
    matrix=[matrix;x(k1), y(k1), i];
    i=i+1;
end
    
dlmwrite('test000.txt', matrix, 'newline','pc');