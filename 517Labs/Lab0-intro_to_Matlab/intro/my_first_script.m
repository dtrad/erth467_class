% Example of a Matlab script
% A MATLAB script is a plain .m file containing a sequence of commands
% that run in the current workspace (no inputs or outputs). Use scripts
% to automate tasks, run procedures, and create simple workflows.
% everything following the percent sign is a comment; it does nothing.

n=101; % the semi-colon forces Matlab to NOT print the value of n.
x=zeros(n,1); % create a vector of zeros with n rows and 1 column
y=zeros(n,1); % create a vector of zeros with n rows and 1 column
for ii=1:1:n % equivalent to: for ii=1:101
    x(ii) = -2.0*pi + 4.0*pi*(ii-1)/(n-1);
    y(ii) = sin(x(ii));
end

plot(x,y);
