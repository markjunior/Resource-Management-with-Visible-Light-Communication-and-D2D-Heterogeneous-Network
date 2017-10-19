% clear all;
% close all;


d_end=20;
num_mu=500;
r_max=20;


isfailure=0;

% position_user = distribute_MU(num_mu);
 load position_eu.mat;

position_user(:,1)=position_user(:,1);
position_user(:,2)=position_user(:,2);

num_eu=2;
% position_eu= distribute_EU(num_eu);
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
for al=5:1:15
    
    G=0;
    count_c=count_c+1;
    main;
% ocean_route=[ocean_route;record_route];

end

al=5:1:15;
plot(al,final_last_delay,'r-');
hold on;
% plot(c,final_com_u_csp,'b-');
% hold on;
    
    
    
    