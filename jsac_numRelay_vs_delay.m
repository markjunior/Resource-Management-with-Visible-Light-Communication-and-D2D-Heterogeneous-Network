clear all;
close all;

d_end=20;
num_mu=1000;
r_max=15;


isfailure=0;

position_user = distribute_MU(num_mu);
% load position_eu.mat;

position_user(:,1)=position_user(:,1);
position_user(:,2)=position_user(:,2);

num_eu=15;
position_eu= distribute_EU(num_eu);
be=1;
theta=1;
al=10;
c=1;

tp=5;
no_u=1*10^(-3);
com_no_u=1*10^(-3);

count_c=0;
record_route=[];
ocean_route=zeros(1,2);
last_delay=[];
for num_eu=1:1:15
    num_eu
    G=0;
    count_c=count_c+1;
    main;
% ocean_route=[ocean_route;record_route];
final_real_delay
end

num_eu=1:1:15;
plot(num_eu,final_real_delay,'r-');
hold on;
    
    
    
    