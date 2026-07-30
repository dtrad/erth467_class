%% Q1
Mat = zeros(500, 500);
for i = 1:500
    offset = i - 1;
    vec = [zeros(offset, 1); linspace(1, 500 - offset, 500 - offset)'];
    Mat(i, :) = vec;
end
imagesc(Mat');
colormap('jet');

%% Q2
Ele_V = zeros(1000, 1);
rand_pos = randi([1, 1000], 200, 1);
while length(unique(rand_pos)) < size(rand_pos, 1)
    [C, IA, IC] = unique(rand_pos);
    rand_pos = [C; randi([1, 1000], length(rand_pos) - length(C), 1)];
end
Ele_V_modified = Ele_V;
Ele_V_modified(rand_pos) = normrnd(2.0, 3.0, size(rand_pos));
plot(Ele_V_modified, '.');

%% Q3
% Ax^3 + Bx^2 + Cx + D = 0;
X = [-1.2, -0.5, 0.3, 0.9];
Y = [6, 1, 4, 7];
P = polyfit(X, Y, 3);
x = -1.5:0.05:1.5;
y = P(1) * x.^3 + P(2) .* x.^2 + P(3) * x + P(4);
figure();
hold on;
plot(x, y);
scatter(X, Y);