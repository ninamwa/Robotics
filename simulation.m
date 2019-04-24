clear all
h = 0.01;
%sp = serial_port_start();
%pioneer_init(sp);

button = 1;
k=1;
figure(1);
clf
axis([-100,20000,-100,20000])
hold on
path = dlmread('Path.txt');
x = path(:,1);
y = path(:,2);
%while button ==1,
%    [x(k),y(k),button] = ginput(1);
%    plot(x(k),y(k),'bo')
%    k=k+1;
%end

q(1,:) = [0,0,0];
q_obs(1,:) = q(1,:);
dot_q(1,:) = [0,0,0];
plot(q(1,1),q(1,2),'ro');
q_obs2(1) = q_obs(1,3);

k=1;


for k1 = 1:100:length(x)
plot(x(k1),y(k1),'-r');
hold on 
text(x(k1),y(k1),num2str(k1),'Color','r')
end


for k1 = 1:100:length(x),
    q_ref = [x(k1),y(k1)];
    theta_r = atan2(q_ref(2),q_ref(1));
    
    
    
    while norm(q_obs(k,1:2)-q_ref)>0.5,
        theta = q_obs(k,3);
        e(k)=norm(q_ref - q_obs(k,1:2));
        phi(k)=atan2(q_ref(2)-q_obs(k,2),q_ref(1)-q_obs(k,1))-theta_r;
                
        if phi(k)>pi
            phi(k) = phi(k)-2*pi;
        elseif phi(k) < -pi
            phi(k) = phi(k) + 2*pi;
        end
        
        
        alpha(k) = phi(k) - theta+theta_r;
        
        if alpha(k)>pi
            alpha(k) = alpha(k)-2*pi;
        elseif alpha(k) < -pi
            alpha(k) = alpha(k) + 2*pi;
        end
        
        
        
        
        K1 = 0.05;
        K2 = 1;
        K3 = 0.1;
        v_max=100;
        
        %fprintf('e: %d, phi: %d, alpha: %d\n', e(k),phi(k),alpha(k))
        
        v(k) = v_max*tanh(K1*e(k));     
        w(k) = v_max*((1+K2*phi(k)/alpha(k))*(tanh(K1*e(k))/e(k))*sin(alpha(k))+K3*tanh(alpha(k)));
        t = round(w(k)*180/pi);
        fprintf('v: %d, w: %d\n', v(k),t)
        %pioneer_set_controls(sp,v(k),x);
        
        
        q(k+1,1) = q(k,1) + h*cos(theta)*v(k);
        q(k+1,2) = q(k,2) + h*sin(theta)*v(k);
        q(k+1,3) = q(k,3) + h*w(k);
        
       
        q_obs(k+1,:) = q(k+1,:);
        
        
        figure(1)
        plot(q(k+1,1), q(k+1,2), 'go')
        drawnow
        k=k+1;
        disp(['iteration',num2str(k)])
    end
    
end
        