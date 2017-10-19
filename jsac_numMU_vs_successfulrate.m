% clear all;
% close all;

d_end=20;
num_mu=300;
r_max=13;


isfailure=0;

position_user = distribute_MU(num_mu);


position_user(:,1)=position_user(:,1);
position_user(:,2)=position_user(:,2);

% num_eu=5;
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
max_iter=10;

successfulrate=[];
count_numEU=0;
for num_eu=1:5
    count_numEU=count_numEU+1;
    count_success=0;
for count=1:1:max_iter
    
    position_user = distribute_MU(num_mu);
% load position_eu.mat;

    position_user(:,1)=position_user(:,1);
    position_user(:,2)=position_user(:,2);

    G=0;
    count_c=count_c+1;
    main;
% ocean_route=[ocean_route;record_route];

  if(flag_zero(1)==0)
      count_success=count_success+1;
  end
      
end

successfulrate(count_numEU)=count_success/max_iter
end

num_eu=1:5;
plot(num_eu,successfulrate,'r-');
hold on;

