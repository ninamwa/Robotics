clear all
h = 0.1;

button = 1;
k=1;
figure(1);
clf
axis([-30,30,-30,30])
hold on

while button ==1,
    [x(k),y(k),button] = ginput(1);
    plot(x(k),y(k),'bs')
    k=k+1;;
end

q(1,t) = [0,0,0];
q_obs(1,t) = q(1,t);
dot_q(1,t) = [0,0,0];
plot(q(1,1),q(1,2),'ro');
q_obs2(1) = q_obs(1,3);

k=1;
for k1 = 1:length(x),
    q_ref = [x(k1),y(k1)];
    while norm(q_obs(k,1:3)-q_ref)>0.5,
        q(k)=norm[q_ref - q_obs(k,1:2));
        phi(k)=atan2(q_ref(2)-q_obs(k,2),q_ref(1)-q_obs(k,1));
        alpha(k) = phi(k) - q_obs(k,3);
        
        if alpha(k)>pi
            alpha(k) = alpha(k)-2*pi;
        elseif alpha(k) <= pi
            alpha(k) = alpha(k) + 2*pi;
        end
        
        K1 = 1;
        K2 = 1;
        K3 = 1;
        v_max=1;
        v(k) = v_max*tanh(k1*e(k));
        w(k) = v_max*((1+K2*phi(k))*tanh(K1*e(k))/e(k)*sin(alpha(k))+K3*tanh  %??????
        
        if(q(KH,3)>pi) %%hva er KH? 
            q(KH,3)=q(KH,3)-2*pi;
        elseif (q(KH,3)<=pi)
            q(KH,3)=q(KH,3)+2*pi;
        end  
        q_obs(KH,t) = q(KH,:)
        
        
        figure()
        plot
        drawnow
        k=k+1;
        disp('iteration',num2str(k))
        