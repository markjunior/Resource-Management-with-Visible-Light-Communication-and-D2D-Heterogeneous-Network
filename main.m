% num_eu=3;

l_uu=zeros(num_mu,num_mu);
for i=1:1:num_mu
    for j=1:1:num_mu
        l_uu(i,j)=sqrt((position_user(i,1)-position_user(j,1) )^2 + (position_user(i,2)-position_user(j,2) )^2);
    end
end

l_vu=zeros(num_mu,1);
for i=1:num_mu
    l_vu(i)=sqrt((position_user(i,1) )^2 + (position_user(i,2)-d_end  )^2);
end

l_ue=zeros(num_mu,num_eu);
for i=1:num_mu
    for k=1:num_eu
        l_ue(i,k)=sqrt ((position_user(i,1)-position_eu(k,1))^2 + (position_user(i,2)-position_eu(k,2))^2);
    end
end

record_length=30;
record_final_route_index=zeros(record_length,num_eu);
record_ocean_route=zeros(record_length,2,num_eu);
record_utility_mu_1=zeros(record_length,num_eu);
record_utility_mu_2=zeros(record_length,num_eu);
record_uu_mu=zeros(record_length,num_eu);
record_uu_vlc=zeros(record_length,num_eu);
record_uu_csp=zeros(record_length,num_eu);
record_com_u_csp=zeros(record_length,num_eu);
record_delay=zeros(record_length,num_eu);

for kk=1:num_eu

index_route=0;

ocean_route=zeros(1,2);
for i=1:num_mu
    index_relay=0;
    if(l_vu(i)<=r_max)
        index_route=index_route+1;
        index_relay=index_relay+1;
        next_node=i;
        ocean_route(index_route, index_relay)=i;
       
        if (l_ue(next_node,kk)>r_max)
             new_index_route=0;
            %record_node=next_node;
            new_route=zeros(1,2);
            for j=1:num_mu
                flag=1;
                for k=1:index_relay
                    if (ocean_route(index_route,k)==j)
                        flag=0;
                    end
                end
                
                if (l_uu(next_node,j)<=r_max)
                    if (l_uu(next_node,j)~=0 )
                        if (flag==1)
                            %next_node=j;
                            if (l_ue(j,kk)<=r_max)
                                new_index_route=new_index_route+1;
                                new_route(new_index_route,1:index_relay)=ocean_route(index_route, 1:index_relay);
                                new_route(new_index_route,(index_relay+1))=j;
                            end
                        end
                    end
                end
                
            end
            if (new_index_route==0 )
                index_route=index_route-1;
            else
                ocean_route(index_route:(index_route+new_index_route-1), 1:2)=new_route(1:new_index_route,1:2);
                index_route=index_route+new_index_route-1;
            end
        else
            ocean_route(index_route, 2)=0;
        end
        
        
    end
end
if (index_route==0 )
    isfailure=1
end

record_route= ocean_route;
if (isfailure~=1)
R_max=40;
num_route=size(ocean_route,1);

consider_utility_mu=zeros(num_mu,1).*(-1);


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
temp_u_mu_1=zeros(num_route,num_eu);
temp_u_mu_2=zeros(num_route,num_eu);
delay=zeros(num_route,1);

com_B=zeros(num_route,1);
for i=1:num_route
    R(i,1)=R_max;
    part_delay(i,1)=G/R(i,1);
    if (ocean_route(i,2)==0 )
        rk=(G+theta*R(i,1))/(4*c*c);
        se=log2(1+tp*l_ue(ocean_route(i,1),kk)^(-2.5)/no_u);
        com_B(i)=rk/se;
        R(i,2)=sqrt( (G+theta*R(i,1)) / (rk/se) );
        R(i,3)=0;
        pay_vlc(i)=theta*(R(i,1)/R(i,2)-1);
        pay_csp(i)=rk*R(i,2)/se-rk*c+G;
        part_delay(i,2)=G/R(i,2);
        part_delay(i,3)=0;
        
        u_mu(i)=al*G-be*part_delay(i,2)-rk*(R(i,2)/se-c)-pay_vlc(i);
        temp_u_mu_1(i,kk)=u_mu(i);
        temp_u_mu_2(i,kk)=0;
    else
        rk=(G+theta*R(i,1))/(4*c*c);
        se=log2(1+tp*l_uu(ocean_route(i,1),ocean_route(i,2))^(-2.5)/no_u);
        com_B(i)=rk/se;
        
        R(i,2)=sqrt( (G+theta*R(i,1)) / (rk/se) );
        part_delay(i,2)=G/R(i,2);
        pay_csp(i)=rk*R(i,2)/se-rk*c;
        u_mu(i)=al*G-be*part_delay(i,2)-rk*(R(i,2)/se-c)-theta*(R(i,1)/R(i,2)-1);
        temp_u_mu_1(i,kk)=u_mu(i);
        pay_vlc(i)=theta*(R(i,1)/R(i,2)-1);
        
        rk=(G+theta*R(i,2))/(4*c*c);
        se=log2(1+tp*l_ue(ocean_route(i,2),kk)^(-2.5)/no_u); 
        com_B(i)=com_B(i)+rk/se;
        R(i,3)=sqrt( (G+theta*R(i,2)) / (rk/se) );        
        part_delay(i,3)=G/R(i,3);
        pay_vlc(i)=pay_vlc(i)+theta*(R(i,2)/R(i,3)-1);
        pay_csp(i)=pay_csp(i)+rk*R(i,2)/se-rk*c+G;
        u_mu(i)=(u_mu(i)+al*G-be*part_delay(i,3)-rk*(R(i,3)/se-c)-theta*(R(i,2)/R(i,3)-1) )/2;
        temp_u_mu_2(i,kk)=al*G-be*part_delay(i,3)-rk*(R(i,3)/se-c)-theta*(R(i,2)/R(i,3)-1);
    end
    delay(i)=sum(part_delay(i,:));
    
end
    [temp_final_delay,temp_final_route_index]=sort(delay);
    
    
    for ss=1:record_length
        record_final_route_index(ss,kk)=temp_final_route_index(ss);
        record_ocean_route(ss,:,kk)=ocean_route(temp_final_route_index(ss),:);
        record_utility_mu_1(ss,kk)=temp_u_mu_1(temp_final_route_index(ss),kk);
        record_utility_mu_2(ss,kk)=temp_u_mu_2(temp_final_route_index(ss),kk);
        
    end
%      [final_delay,final_route_index]=min(delay);
    
    
    
    final_u_mu=u_mu(temp_final_route_index(1));
    u_vlc=pay_vlc(temp_final_route_index(1))-delay(temp_final_route_index(1));
    u_csp=pay_csp(temp_final_route_index(1));
    
    current_u_vlc=u_vlc;
    if (final_u_mu>0 && u_csp>0 && u_vlc>0 )
        flag=0;        
    end
    for ss=1:record_length
        record_final_route_index(ss,kk)=temp_final_route_index(ss);
        record_ocean_route(ss,:,kk)=ocean_route(temp_final_route_index(ss),:);
        record_utility_mu_1(ss,kk)=temp_u_mu_1(temp_final_route_index(ss),kk);
        record_utility_mu_2(ss,kk)=temp_u_mu_2(temp_final_route_index(ss),kk);
        record_uu_mu(ss,kk)=u_mu(temp_final_route_index(ss));
        record_uu_vlc(ss,kk)=pay_vlc(temp_final_route_index(ss))-delay(temp_final_route_index(ss));
        record_uu_csp(ss,kk)=pay_csp(temp_final_route_index(ss));
        record_com_u_csp(ss,kk)=(com_B(temp_final_route_index(ss))-c)*log2(1+tp*100^(-2.5)/com_no_u);
        record_delay(ss,kk)=delay(temp_final_route_index(ss));
    end
%     flag
%     record_u_vlc<=current_u_vlc
    
 end

%     last_delay(count_c,kk)=u_csp(count_iter);
%     com_u_csp(count_c,kk)=(com_B(temp_final_route_index(1))-c)*log2(1+tp*100^(-2.5)/com_no_u);
    
end
end
current_ind=ones(num_eu,1);
match_end=1;
error=0;
flag_zero=zeros(num_eu,1);
while(match_end==1)
    match_end=0;
    for kk=1:num_eu
      if(flag_zero(kk)==0)
        if(consider_utility_mu (record_ocean_route(current_ind(kk),1,kk))==0)
            consider_utility_mu (record_ocean_route(current_ind(kk),1,kk))=record_utility_mu_1(current_ind(kk),kk);
            match_flag=kk;
        else
            if( consider_utility_mu (record_ocean_route(current_ind(kk),1,kk))>=record_utility_mu_1(current_ind(kk),kk))
                current_ind(kk)=current_ind(kk)+1;
                match_end=1;
                if(current_ind(kk)>record_length)
                    error=1;
                    match_end=0;
                    flag_zero(kk)=1;
                end                
            else
                consider_utility_mu (record_ocean_route(current_ind(kk),1,kk))=record_utility_mu_1(current_ind(kk),kk);
                current_ind(match_flag)=current_ind(match_flag)+1;
                match_end=1;
                if(current_ind(match_flag)>record_length)
                    error=1;
                    match_end=0;
                    flag_zero(match_flag)=1;
                end                
            end
        end   
    end
       if(flag_zero(kk)==0)
       if(record_ocean_route(current_ind(kk),2,kk)~=0)
           if(consider_utility_mu (record_ocean_route(current_ind(kk),2,kk))==0)
               consider_utility_mu (record_ocean_route(current_ind(kk),1,kk))=record_utility_mu_2(current_ind(kk),kk);
               match_flag=kk;
           else
               if( consider_utility_mu (record_ocean_route(current_ind(kk),2,kk))>=record_utility_mu_2(current_ind(kk),kk))
                   current_ind(kk)=current_ind(kk)+1;
                   match_end=1;
                   if(current_ind(kk)>record_length)
                       error=1;
                       match_end=0;
                       flag_zero(kk)=1;
                   end
                   
               else
                   consider_utility_mu (record_ocean_route(current_ind(kk),2,kk))=record_utility_mu_2(current_ind(kk),kk);
                   current_ind(match_flag)=current_ind(match_flag)+1;
                   match_end=1;
                   if(current_ind(match_flag)>record_length)
                       error=1;
                       match_end=0;
                       flag_zero(match_flag)=1;
                   end
                   
               end
           end
       end
       end
    end
end

for kk=1:num_eu
    if(flag_zero(kk)==1)
        last_delay(count_c,kk)=0;
        com_u_csp(count_c,kk)=0;
    else
%         last_delay(count_c,kk)=record_uu_csp(current_ind(kk),kk);
        last_delay(count_c,kk)=record_uu_mu(current_ind(kk),kk);
%         last_delay(count_c,kk)=record_uu_vlc(current_ind(kk),kk);
        if (record_uu_mu(current_ind(kk),kk)==0)
            last_delay(count_c,kk)=0;
        end
        
        
        com_u_csp(count_c,kk)=record_com_u_csp(current_ind(kk),kk);
    end
end
if(flag_zero(1)==1)
    final_real_delay(count_c)=0;
else
    final_real_delay(count_c)=record_delay(current_ind(1),1); 
end
final_last_delay(count_c)=sum(last_delay(count_c,:));
final_com_u_csp(count_c)=sum(com_u_csp(count_c,:));
if(final_com_u_csp(count_c)<0)
    final_com_u_csp(count_c)=0;
end