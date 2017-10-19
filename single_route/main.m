

l_uu=zeros(num_mu,num_mu);
for i=1:1:num_mu
    for j=1:1:num_mu
        l_uu(i,j)=sqrt ((position_user(i,1)-position_user(j,1) )^2 + (position_user(i,2)-position_user(j,2) )^2);
    end
end

l_vu=zeros(num_mu,1);
for i=1:num_mu
    l_vu(i)=sqrt ((position_user(i,1) )^2 + (position_user(i,2) )^2);
end

l_ue=zeros(num_mu,1);
for i=1:num_mu
    l_ue(i)=sqrt ((position_user(i,1))^2 + (position_user(i,2)-d_end )^2);
end


index_route=0;

ocean_route=zeros(1,2);
for i=1:num_mu
    index_relay=0;
    if(l_vu(i)<=r_max)
        index_route=index_route+1;
        index_relay=index_relay+1;
        next_node=i;
        ocean_route(index_route, index_relay)=i;
       
        if (l_ue(next_node)>r_max)
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
                            if (l_ue(j)<=r_max)
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

