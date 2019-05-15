function res = control_system(odom,ref,nr)

%tuned parameters
h = false;
if h
    if nr > 43 
        K1 = 0.025;
        K2 = 0.3; 
        K3 = 0.05;
    %elseif nr > 74 
        %K1 = 0.01;
        %K2 = 0.2;
        %K3 = 0.02;
    else 
        K1 = 0.025;
        K2 = 0.5;
        K3 = 0.05;
    end
end

K1 = 0.5;
K2 = 2.3;
K3 = 1.5;
v_max=1.1;
%K1 = 0.41;
%K2 = 1.8;
%K3 = 1.42;
%v_max = 0.5; %maximum linear velocity
%v_max=50;
%w_offset = 0.051;

w_offset = 0;
% Requirements: 
% 2*k1*sqrt(k2) < k3 < k1(1+k2);
% k3 < Kmax;
% k2 > 1;

x = odom(1)/1000;
y= odom(2)/1000;
if odom(3)<= 2048
    theta = ((2*pi) / 4096) * odom(3);
else 
    theta = (((2*pi) / 4096) * odom(3))-(2*pi);
end


if theta>pi
    theta = theta-2*pi;
elseif theta < -pi
    theta = theta + 2*pi;
end

x_r = ref(1)/1000;
y_r = ref(2)/1000;
theta_r = atan2(y_r,x_r);


%Error state in polar representation
e=sqrt((x-x_r)^2+(y-y_r)^2);
phi = atan2(y_r-y,x_r-x)-theta_r;

if phi>pi
    phi = phi-2*pi;
elseif phi < -pi
    phi = phi + 2*pi;
end
        
alpha = phi - theta + theta_r;
        
if alpha>pi
    alpha = alpha-2*pi;
elseif alpha < -pi
    alpha = alpha + 2*pi;
end

%control system
v = v_max*tanh(K1*e);
v = v*1000;
v = round(v);

w = v_max*((1+K2*phi/alpha)*(tanh(K1*e)/e)*sin(alpha)+K3*tanh(alpha));
w = round((w - w_offset)*(180/pi))  ;


if isnan(w)
    w=0;
elseif isnan(v)
    v=0;
end

res = [v,w];

end