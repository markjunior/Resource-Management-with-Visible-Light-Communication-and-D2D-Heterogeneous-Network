function user_position = distribute_MU (n_user)
%function user_position = distribute_user (n_user), distribute_user.m 
%功能：让用户在小区内均匀分布
%输入：n_user：小区用户数
%输出：user_position：小区内用户的坐标；


R=20;

randomdata=constraintrnd([-R,-R;R,R],'boundary_MU',n_user);
user_position=randomdata;
