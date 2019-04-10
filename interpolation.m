function [] = interpolation()
%%Matlab function spline is also an option (instead of pchip)
path = [150.0000  150.0000,
  147.3550  163.6026,
  191.6168  153.8500,
  237.0325  156.9595,
  267.1587  153.1129,
  305.9034  153.4435,
  332.7173  155.6144,
  367.5739  155.5459,
  414.7362  165.4423,
  428.3428  199.3001,
  421.4153  334.5193,
  415.0453  379.9167,
  396.5028  405.0178,
  409.00 415.00,
  400 425,
  159 425,
  128 390]
%Questions: 
%Is it necessary to do the interpolation of x and y separately? 
%x = -3:3; 
%y = [-1 -1 -1 0 1 1 1]; 
x = path(:,1);
y=path(:,2);
%xq1 = x(1,1):.01:x(20,1);
%p = pchip(x,y,xq1);
%disp(p)
%plot(x,y,'o',xq1,p,'-')


t=linspace(0,1000,length(x));
ppx=pchip(t,x);
xx = ppval(ppx, linspace(0,1000,10000));
ppy=pchip(t,y);
yy = ppval(ppy, linspace(0,1000,10000));
plot(x,y,'o',xx,yy,'-')
%plot(xx,yy)
end %function