function [Ormsby] = Design_Ormsby(f_vec, f_LC, f_H, f_L, f_HC)

Ormsby = zeros(size(f_vec));

ramp_up = f_vec >= f_LC & f_vec <= f_H;
Ormsby(ramp_up) = (f_vec(ramp_up) - f_LC) ./ (f_H - f_LC);

pass_band = f_vec > f_H & f_vec < f_L;
Ormsby(pass_band) = 1.0;

ramp_down = f_vec >= f_L & f_vec <= f_HC;
Ormsby(ramp_down) = (f_HC - f_vec(ramp_down)) ./ (f_HC - f_L);

Ormsby = max(Ormsby, 0.0);
Ormsby = min(Ormsby, 1.0);

end
