function res = control_system(ref,theta_ref,nr)
global odometry;
global x_real;
global y_real;
global number
nr = number;

%tuned parameters
K1 = 0.025;
K2 = 0.5;
K3 = 0.05;

v_max=50;
w_offset = 0;

x=x_real;
y=y_real;
if odometry(3)<= 2048
    theta = ((2*pi) / 4096) * odometry(3);
else 
    theta = (((2*pi) / 4096) * odometry(3))-(2*pi);
end

if theta>pi
    theta = theta-2*pi;
elseif theta < -pi
    theta = theta + 2*pi;
end

x_r = ref(1);
y_r = ref(2);
theta_r = theta_ref(nr);


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
v = round(v);

w = v_max*((1+K2*phi/alpha)*(tanh(K1*e)/e)*sin(alpha)+K3*tanh(alpha));
w = round((w - w_offset)*(180/pi))  ;

%if w > 50
%    w = 20;
%elseif w < -50
%    w = -20;
%end

if isnan(w)
    w=0;
elseif isnan(v)
    v=0;
end


res = [v,w];

end