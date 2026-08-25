function [b]=corr1d(x,y)
    % wrapper for contran to do correlation
    nx=length(x);
    ny=length(y);
    nb=nx+ny-1;
    b=zeros(1,nb);
    [~,b]=contran(1,0,nx,x,nb,b,y);
end


