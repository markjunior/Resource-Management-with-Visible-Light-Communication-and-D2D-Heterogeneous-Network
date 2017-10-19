function outdata = boundary_MU(inputmatrix)
%function outdata=boundary_parallelogram(inputmatrix)£¬this is the user defined function of the example. 
%The purpose of this function is to define a area constrained by a parallelogram
R=20;
x=inputmatrix(:,1);
y=inputmatrix(:,2);
outdata =(x.^2+y.^2<R^2);

end