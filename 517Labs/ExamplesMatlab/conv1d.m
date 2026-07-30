function [y]=conv1d(x,b)
    % wrapper for contran to do convolution
    nx=length(x);
    nb=length(b);
    ny=nx+nb-1;
    y=zeros(1,ny);
    [y,~]=contran(0,0,nx,x,nb,b,y);
end
