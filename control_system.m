function res = control_system(odom,ref)

% where the variable v represents the velocity of the coordinate frame O 
% moving in a heading ? relative to the global frame G
% The subscript r denotes the reference frame. 
% That is, vr and ?r are reference velocity and reference heading angle of the coordinate frame R, respectively. 

%tuned parameters
K1 = 0.41;
K2 = 2.94;
K3 = 1.42;
v_max = 50; %maximum linear velocity
w_offset =0; %0,051

% Requirements: 
% 2*k1*sqrt(k2) < k3 < k1(1+k2);
% k3 < Kmax;
% k2 > 1;

x = odom(1);
y=odom(2);
theta=odom(3);
x_r = ref(1);
y_r = ref(2);
theta_r = atan2(y_r,x_r);

%Error state in polar representation
e=(x-x_r)^2+(y-y_r)^2;
phi = atan2(-(y-y_r),-(x-x_r))-theta_r;
if phi>pi
    phi = phi-2*pi;
elseif phi < -pi
    phi = phi + 2*pi;
end
        
alpha = phi - theta+theta_r;
        
if alpha>pi
    alpha = alpha-2*pi;
elseif alpha < -pi
    alpha = alpha + 2*pi;
end

%control system
v = v_max*tanh(K1*e);
w = v_max*((1+K2*phi)*tanh(K1*e)/e*sin(alpha)+K3*tanh(alpha));
w = w - w_offset;
res = [v,w];

end