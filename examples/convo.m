function[y] = convo(x,b)
% function[y] = convo(x,b)
% Daniel Trad, UBC, 2001 (output oriented)

nx=length(x);
nb=length(b);
ny=nx+nb-1;

for iy = 1:ny,
  y(iy) = 0.0;
  for ib=1:iy,
    if (ib <= nb) & (iy-ib+1 <= nx),
      y(iy) = y(iy) + x(iy-ib+1)*b(ib);
    end
  end
end
