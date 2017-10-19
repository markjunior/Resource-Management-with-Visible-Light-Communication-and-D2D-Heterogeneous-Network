% clear all;
% close all;


d_end=20;
num_mu=300;
r_max=20;


isfailure=0;

% position_user = distribute_MU(num_mu);
load position_eu.mat;
num_mu=300;
position_user(:,1)=position_user(:,1);
position_user(:,2)=position_user(:,2);

num_eu=5;
load position_eu_num_5;
% position_eu= distribute_EU(num_eu);

theta=1;
al=10;
be=1;
max_c=2;

tp=1;
no_u=1*10^(-4);
com_no_u=1*10^(-4);

count_c=0;
record_route=[];
ocean_route=zeros(1,2);
last_delay=[];
for c=0.4:0.1:max_c
    c
    G=0;
    count_c=count_c+1;
    main;
% ocean_route=[ocean_route;record_route];

end

c=0.4:0.1:max_c;
plot(c,final_last_delay,'r-');
hold on;
% plot(c,final_com_u_csp,'b-');
% hold on;
    
    
    
    