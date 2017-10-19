clear all;
close all;

d_end=20;
max_num_mu=100;
r_max=15;
% load numRelay_delay.mat;

isfailure=0;





theta=1;
al=5;


tp=0.5;
no_u=1*10^(-3);

count_num_mu=0;
record_route=[];
ocean_route=zeros(1,2);
last_delay=[];


count_num_mu=0;
last_delay=[];
% ori_position_user = distribute_MU(max_num_mu);
load temp_a;

position_user(:,1)=ori_position_user(:,1)+d_end/2;
position_user(:,2)=ori_position_user(:,2)+d_end/2;

for num_mu=10:10:max_num_mu
    
     G=0;
count_num_mu=count_num_mu+1;

main;
% ocean_route=[ocean_route;record_route];
record_route= ocean_route;

if (isfailure~=1)
R_max=40;
num_route=size(ocean_route,1);
c=0.5;

record_u_vlc=0;
current_u_vlc=0;
step=0.1;
% g=0.1;
count_iter=0;
flag=1;

final_u_mu=[];
u_vlc=[];
u_csp=[];

 while ( (record_u_vlc<=current_u_vlc) || flag==1) 
     
    flag=1;
    count_iter=count_iter+1;
record_u_vlc=current_u_vlc;
 G=G+step;

R=zeros(num_route,3);
pay_vlc=zeros(num_route,1);
pay_csp=zeros(num_route,1);
part_delay=zeros(num_route,3);
u_mu=zeros(num_route,1);
delay=zeros(num_route,1);

for i=1:num_route
    
    R(i,1)=R_max;
    part_delay(i,1)=G/R(i,1);
    if (ocean_route(i,2)==0 )
        rk=(G+theta*R(i,1))/(4*c*c);
        se=log2(1+tp*l_ue(ocean_route(i,1))^(-2.5)/no_u);
        R(i,2)=sqrt( (G+theta*R(i,1)) / (rk/se) );
        R(i,3)=0;
        pay_vlc(i)=theta*(R(i,1)/R(i,2)-1);
        pay_csp(i)=rk*R(i,2)/se-rk*c+G;
        part_delay(i,2)=G/R(i,2);
        part_delay(i,3)=0;
        
        u_mu(i)=al*G-part_delay(i,2)-rk*(R(i,2)/se-c)-pay_vlc(i);
    else
        rk=(G+theta*R(i,1))/(4*c*c);
        se=log2(1+tp*l_uu(ocean_route(i,1),ocean_route(i,2))^(-2.5)/no_u);
        R(i,2)=sqrt( (G+theta*R(i,1)) / (rk/se) );
        part_delay(i,2)=G/R(i,2);
        pay_csp(i)=rk*R(i,2)/se-rk*c;
        u_mu(i)=al*G-part_delay(i,2)-rk*(R(i,2)/se-c)-theta*(R(i,1)/R(i,2)-1);
        pay_vlc(i)=theta*(R(i,1)/R(i,2)-1);
        
        rk=(G+theta*R(i,2))/(4*c*c);
        se=log2(1+tp*l_ue(ocean_route(i,2))^(-2.5)/no_u);        
        R(i,3)=sqrt( (G+theta*R(i,2)) / (rk/se) );        
        part_delay(i,3)=G/R(i,3);
        pay_vlc(i)=pay_vlc(i)+theta*(R(i,2)/R(i,3)-1);
        pay_csp(i)=pay_csp(i)+rk*R(i,2)/se-rk*c+G;
        u_mu(i)=(u_mu(i)+al*G-part_delay(i,3)-rk*(R(i,3)/se-c)-theta*(R(i,2)/R(i,3)-1) )/2;
    end
    delay(i)=sum(part_delay(i,:));
    
end
final_delay=[];
final_route_index=[];
    [final_delay,final_route_index]=min(delay);
    final_u_mu(count_iter)=u_mu(final_route_index);
    u_vlc(count_iter)=pay_vlc(final_route_index)-delay(final_route_index);
    u_csp(count_iter)=pay_csp(final_route_index);
    current_u_vlc=u_vlc(count_iter);
    if (final_u_mu(count_iter)>0 && u_csp(count_iter)>0 && u_vlc(count_iter)>0 )
        flag=0;        
    end
    flag;
    record_u_vlc<=current_u_vlc;
    
 end

    last_delay(count_num_mu)=final_delay;
    
 end

end

num_mu=10:10:max_num_mu;
plot(num_mu,last_delay,'r-');
hold on;
    
%    count=1:count_iter;
%    plot(count, u_vlc,'r-');
%    hold on;
    
    