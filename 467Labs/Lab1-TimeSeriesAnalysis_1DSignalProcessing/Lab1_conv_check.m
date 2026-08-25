
miss1 = 0; %Count number of cases with disagreement between conv and conv_517
miss2 = 0;
for n = 1:100 % Do 1000 trials
    a = rand(ceil(1000*rand),1); %Random vector length up to 1000
    b = rand(ceil(1000*rand),1); 
    c1 = conv(a,b); %Built-in result
    c2 = conv_467(a,b); %Our result 1
    c3 = convo(a,b); %Our result 2
    %Add to error if they disagree. sameish(c1,c2) is a more tolerant, 
    %vector friendly version of c1==c2
    miss1 = miss1 + (1 - sameish(c1,c2',1e-14)); 
    miss2 = miss2 + (1 - sameish(c1,c3',1e-14)); 
end
fprintf("method1: ")
if miss1 == 0
    fprintf('No discrepancies detected \n')
else
    fprintf('%i discrepancies detected \n', miss1)
end

fprintf("method2: ")
if miss2 == 0
    fprintf('No discrepancies detected \n')
else
    fprintf('%i discrepancies detected \n', miss2)
end