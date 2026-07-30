function [y]=convi(x,b)
% Simplest convolution (input oriented);
    nx=length(x);
    nb=length(b);
    ny=nx+nb-1;
    y=zeros(1,ny);
    for ib = 1:nb
        for ix = 1:nx
            y(ib + ix - 1) = y(ib + ix - 1) + b(ib) * x(ix);
        end
    end
end
