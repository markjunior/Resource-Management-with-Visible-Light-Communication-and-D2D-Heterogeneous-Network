% clear all;
% close all;

load position_eu.mat;
d_end=20;
num_mu=300;
r_max=18;


isfailure=0;

% position_user = distribute_MU(num_mu);


position_user(:,1)=position_user(:,1);
position_user(:,2)=position_user(:,2);

num_eu=3;
% position_eu= distribute_EU(num_eu);
% be=1;
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
for be=1:1:6
    
    G=0;
    count_c=count_c+1;
    main;
% ocean_route=[ocean_route;record_route];

end

be=1:1:6;
plot(be,final_last_delay,'r-');
hold on;
% plot(c,final_com_u_csp,'b-');
% hold on;
    
    
    
    