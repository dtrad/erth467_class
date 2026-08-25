% Test the contran function with example data
x = [1, 2, 3];
b = [0.2, 0.5, 0.3];
    
% Test convolution
y_conv = conv1d(x, b);
disp('Convolution result:');
disp(y_conv);

% compare with conv
y_matlab = conv(x,b);
disp('convolution matlab')
disp(y_matlab)

% Test correlation (has a problem)
%y_corr = corr1d(x, y_conv);
%disp('Correlation result:');
%disp(y_corr);

