% saw_tooth Generate a symmetric sawtooth (absolute value) waveform
% 
% [x,y] = saw_tooth(n,x0) returns vectors x and y of length n that form
% a "sawtooth" or absolute-value shape on the interval [x0, x0+T], where
% T = abs(2*x0). The function builds x by concatenating the left segment
% from x0 to 0 and the right segment from the first positive step to
% x0+T. y contains the corresponding absolute-value waveform: y = |x|.
%
% Inputs
%   n  - number of samples (positive integer)
%   x0 - left endpoint (negative or zero for typical symmetric shape)
%
% Outputs
%   x  - sample locations (1-by-n vector)
%   y  - waveform values (1-by-n vector), equal to abs(x)
%
% Example
%   [x,y] = saw_tooth(101,-2);
%
function[x,y] = saw_tooth(n,x0)
% example: [x,y] = saw_tooth(101,-2);
T = abs(2*x0);
x1 = [x0:T/(n-1):0];
x2 = [T/(n-1):T/(n-1):x0+T];
x = [x1,x2];
y = [-x1,x2];
end

