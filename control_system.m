function res = control_system(odom,ref)

%tuned parameters
K1 = 0.05;
K2 = 1;
K3 = 0.05;
v_max = 50; %maximum linear velocity
w_offset = 0.051;

% Requirements: 
% 2*k1*sqrt(k2) < k3 < k1(1+k2);
% k3 < Kmax;
% k2 > 1;

x = odom(1);
y=odom(2);
theta = ((2*pi) / 4096) * odom(3);

if theta>pi
    theta = theta-2*pi;
elseif theta < -pi
    theta = theta + 2*pi;
end

x_r = ref(1);
y_r = ref(2);
if x_r
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

fprintf('e: %d, phi: %d, alpha: %d\n', e,phi,alpha)


%control system
v = v_max*tanh(K1*e);
v = round(v);

w = v_max*((1+K2*phi/alpha)*(tanh(K1*e)/e)*sin(alpha)+K3*tanh(alpha));
w = w - w_offset;
w=w*180/pi;
w=round(w);

res = [v,w];

end