function randdata=constraintrnd(outbnd,func,num,coverrate)
%function rand_data=constraintrnd(out_bound,function_name,number_to_generate,cover_rate)
%This is a function for generating uniform random numbers within a constraint area definded by a certain user function.
%principle of this function is: first generate a set of random numbers over the out bound area and then eliminate the numbers that not satisfy the constraint area defined by the user function.
%1-Explanation of the four input variables.
%out_bound: a 2-by-n matrix defines a rectangular area as the out-bounded area of the random numbers.Here 'n' is the dimension of the constraint area. It should cover the whole constraint area. only within this area will the random numbers generated. [Be awared: first row is the lower bound, second row is the upper bound]
%function_name: user defined function name that specify the constraint area.
%number_to_generate: how many random numbers to generate, default 100
%cover_rate:Not dispensible. Since the originally generated numbers are distributed thoughout the out bounded area, some of them will be eliminated, so generate more original numbers are needed. And this variable defines the rate :original number/number_to_generate. Default: depending on number_to_generate.
%2-user function
%The input variable of the user function is a m-by-n matrix where m is the number_to_generate and n is the dimension of the constraint area.
%And the output variable of the user function is a m-by-1 boolean vector with the "1" elements meaning that the corresponding row of the input matrix is within the constraint area.
%3-An example
%Here is an example of generating random numbers within an ellipse: x^2/4+y^2/9=1
%First of all, we should define a user function, with the following lines:
%> function outdata=ellipse(inputmatrix)
%> x=inputmatrix(:,1);y=inputmatrix(:2);
%> outdata=(x.*x/4+y.*y/9<=1);
%> end
%Then we save the file as "ellipse.m"
%Now we can call "constrainrnd" function to generate random numbers. To solve the problem, just call: randomdata=constraintrnd([-2,-3;2,3],'ellipse',10)
%By Xaero Chang 05/08/2007 @ PG-China
%http://Xaero.mmiyy.cn

%1  Verify input variables
    
    
switch nargin
	case 0,1
		error('Not enough input arguments');
	case 2
		%num_new=100;
        if num<10
             num_new=num*100;
        elseif num<100
             num_new=num*10;
        else
             num_new=num;
        end
        coverrate=3;
	case 3
        if num<10
             num_new=num*100;
        elseif num<100
             num_new=num*10;
        else
             num_new=num;
        end
		%if num_new<6
			%coverrate=num_new;
			%num_new=100;
		%else
			coverrate=12/log(num_new);
		%end
	case 4
        if num<10
             num_new=num*100;
        elseif num<100
             num_new=num*10;
        else
             num_new=num;
        end
		%num_new=round(num_new);
		%if num_new<6
			%num_new=100;
		%end
		if coverrate<0 | coverrate>100
			coverrate=12/log(num_new);
		end
	otherwise
		warning('Too many argument');
end


%2 Generate original variables. 
%   To be compatible with Octave, unifrnd function is replaced by rand function here.
[y,n]=size(outbnd);
if ~isequal(y,2)
	error('The out bound matrix should be 2-by-n');
end

%randdata=zeros(num_new,n);
randdata=[];
togen=round(num_new*coverrate);
%Begin the generation procedure.
while 1
	originrnd=zeros(togen,n);
	for f=1:n
		originrnd(:,f)=rand(togen,1)*(outbnd(2,f)-outbnd(1,f))+outbnd(1,f);%产生在下边界和上边界之间平均分布的点的各维坐标
	end
	try
		idx=feval(func,originrnd);%把符合条件，即在条件范围内的坐标行记为1，反之记为0
	catch
		error('Error when evaluating user defined function');
	end
	avail=sum(idx);
   
	randdata(end+1:end+avail,:)=originrnd(idx,:);%把记为1的行复制到randdata中
	[y,n]=size(randdata);
%keyboard;
	if y<num_new
        if avail==0
            avail=0.1;
        end
		togen=round(1.2*(num_new-y)*togen/avail);
	else
		randdata(num+1:end,:)=[];
		return
	end
end
	












