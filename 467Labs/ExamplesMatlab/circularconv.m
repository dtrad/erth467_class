% show that convolution is different from circular convolution
a = [1 2 3 4];
b = [5,6,7,8];
lc=conv(a,b);
cc=ifft(fft(a).*fft(b));
fprintf("Before zero padding\n");
text1=sprintf("%4.0f",lc(1:7));
text2=sprintf("%4.0f",cc);
display("linear convolution = " + text1)
display("circular convolution = " + text2);

fprintf("After zero padding\n");
% Now pad with zeroes
a = [1 2 3 4 0 0 0 0];
b = [5,6,7,8 0 0 0 0];
lc=conv(a,b);
cc=(ifft(fft(a).*fft(b)));

text1 = sprintf("%4.0f",lc(1:8));
text2 = sprintf("%4.0f",cc);
display("linear convolution = " + text1)
display("circular convolution = " + text2);

