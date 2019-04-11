clear all
h = 0.1;

button = 1;
k=1;
figure(1);
clf
axis([-30,30,-30,30])
hold on
path = PathPlanner();
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
for k1 = 1:100:length(x),
    plot(x(k1),y(k1),'bo');
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
        
        
        K1 = 1;
        K2 = 1;
        K3 = 1;
        v_max=1;
        v(k) = v_max*tanh(K1*e(k));
        w(k) = v_max*((1+K2*phi(k))*tanh(K1*e(k))/e(k)*sin(alpha(k))+K3*tanh(alpha(k)));
        
        q(k+1,1) = q(k,1) + h*cos(q(k,3))*v(k);
        q(k+1,2) = q(k,2) + h*sin(q(k,3))*v(k);
        q(k+1,3) = q(k,3) + h*w(k);
        
       
        q_obs(k+1,:) = q(k+1,:);
        
        
        figure(1)
        plot(q(k+1,1), q(k+1,2), 'go')
        drawnow
        k=k+1;
        disp(['iteration',num2str(k)])
    end
end
        