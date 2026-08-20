% everything following the percent sign is a comment; it does nothing.

clear; % clears all variables from Matlab's memory.

n=101; % the semi-colon forces Matlab to NOT print the value of n.
x0=-2.0;
T=abs(2*x0); % abs(c) returns the absolute value of c.
x=zeros(n,1); % create a vector of zeros with n rows and 1 column
y=zeros(n,1); % create a vector of zeros with n rows and 1 column
for ii=1:1:n % equivalent to: for ii=1:101
    x(ii) = x0 + T*(ii-1)/(n-1);
    % Conditional: the if/else checks whether x(ii) is negative.
    % If true, it assigns y(ii) the negated value (-x) to compute |x|.
    % Otherwise, it assigns y(ii) the original value to compute |x|.
    if x(ii) < 0
        y(ii) = -x(ii);
    else
        y(ii) = x(ii);
    end
end

plot(x,y);

