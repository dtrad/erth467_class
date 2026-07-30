A = 2; %Set A as 2 (semicolon suppresses output
B = 5;

fprintf('A and B are %i and %i \n',A,B); %Write to console

fprintf('Rounding 2.3 up gives %f \n',ceil(2.3));
fprintf('Rounding 2.3 down gives %f \n',floor(2.3));
fprintf('Rounding 2.3 to the nearest integer gives %f \n',round(2.3));

fprintf('Imaginary number squared is %f \n',1i^2);
comp = 1+1i;
fprintf('Imaginary number plus one is %f + %fi \n',real(comp),imag(comp));

fprintf('A+B = %f \n',A+B);
fprintf('A-B = %f \n',A-B);
fprintf('A*B = %f \n',A*B);
fprintf('A/B = %f \n',A/B);
fprintf('A^B = %f \n',A^B);

fprintf('A is \n');
A = [1;2;3] %Column vector
fprintf('A is \n');
A = [1,2,3] %Row vector
fprintf('A is \n');
A = -1:2:7
fprintf('B is \n');
B = linspace(7,15,5)

A(3); % Gets third element of A. Note the 1-indexing
fprintf('The third element of A is %f \n',A(3));

%%

A' %The ' symbol denotes transpose. If considering complex numbers, ' is conjugate transpose and .' is transpose only
[1;1i]'
[1;1i].'
B*A' %Matrix multiplication of row and column vector
% B*A
B.*A %Elementwise multiplication of vectors
B./A %Elementwise division of vectors
A+2 %Adds scalar to every element
A+B %Elementwise addition
C=A+B' %Result at indices m and n is A_m + B_n 
D = 1:25 %1x25 row vector
D = reshape(D,5,5) %Changes D to a 5x5 vector. Right click 'reshape' and select  open "reshape"   to learn more about this MATLAB function
imagesc(D); %Make an image based on the values of D

%%
D(2,3) %Second row, third column
D(3,2:4) %Third row, entries 2-4
D(:,1) %First column
D(:,end) %Last column
D(2,:) %Second row
D(end-1,:)%Second last row
D(:) %D unspooled as a column vector. 

D+1 %Add one to each matrix element
D+A %Add row vector A to each row
D+A' %Add column vector A' to each column
D+C %Elementwise addition of matrices

D*A' %Matrix multiplication of D with column vector A'
A*D %Matrix multiplication of D with row vector A
D.*A %Elementwise multiplication of row vector A with each row
D\A'

D*C %Matrix multiplication of D and C
D.*C %Elementwise multiplication of D and C
D.^C %Each element of D is raised to the power of the corresponding C element (notice that elements much smaller than the maximum of the resulting matrix print as zero)

%%
E = zeros(5) %Creates a 5x5 matrix of zeros
E = zeros(1,12) %Creates a 12 element row vector of zeros
E = zeros(5,3) %Creates a 5x3 matrix of zeros
E = ones(3,4) %Creates a 3x4 matirx of ones
E = rand(7,3) %Creates a 7x3 matrix of uniformally distributed numbers between 0 and 1
E = randn(5) %Creates a 5x5 matrix of normally distributed numbers with mean = 1 and standard deviation = 1

E\B' %Solves the system Ex = B' for x

size(E) %number of rows and columns in E
[a,b] = size(E) %a becomes number of row, b number of columns
length(E) %longest dimension of E
F = zeros(size(E)) %Creates a matrix of zeros with the dimension of E
F = zeros(length(E))% Creates a square matrix of zeros with a number of rows and columns equal to the longest dimension of E

%%
abs(E) %Takes absolute value of each entry in E
min(E) %Finds the minimum of each column of E
min(E,[],1) %Finds the minimum of each column of E
min(E,[],2) %Finds the minimum of each row of E
[a,b] = min(E) %a becomes minimum of each column of E, b becomes the index of that minimum in each row
min(min(E)) %Minimum of E

(2>3) || (4>3) %2 greater than 3 or 4 greater than 3?
(2>3) && (4>3) %2 greater than 3 and 4 greater than 3?
2==3 %2 equal to 3?
~(2==3) %Not 2 equal to 3?
2~=3 %2 not equal to 3?


%% Let's sum random numbers from randn until the magnitude of the largest number exceeds 100
randomsum = zeros(20,1);
n = 0;
finished = 0;
while finished == 0
    randomsum = randomsum + randn(size(randomsum));
    n = n+1; %Count iteration in a while loop to be safe, abort if it gets too high
    if (n>20000) || (max(abs(randomsum))>100) %Stopping condition: satisfy goal or take too many iterations
        finished = 1;
    end
end
% Now let's plot the result to check
figure %Opens new figure
subplot(2,1,1) %We will plot another plot within the same image later
plot(randomsum,'.','MarkerSize',30) %Makes scatter plot, but many different options exist. Try 'edit plot' to see more

%Let's generate a vector runsum where the nth element is the sum of first n
%terms of randomsum

runsum = zeros(size(randomsum));
for n = 1:length(randomsum)
    runsum(n) = sum(randomsum(1:n));
end
%Again, let's plot the result
subplot(2,1,2) %We will plot another plot within the same image later
plot(runsum,'LineWidth',3) %Now we are making a line graph
