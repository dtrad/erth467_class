% ============================================================
% Cost surface J(f1,f2) = || X*[f1; f2] - y ||^2  and its 3D plot
% Model: y_hat[n] = f1*x[n] + f2*x[n-1], n = 2..N
% ============================================================

% ---------- synthetic data (you can replace by your own x,y)
N = 200;
x = randn(N,1);
f_true = [0.6; -0.3];
y = f_true(1)*x(2:end) + f_true(2)*x(1:end-1) + 0.1*randn(N-1,1);

% ---------- design matrix X for the 2-tap FIR
% rows correspond to n = 2..N
X = [x(2:end)  x(1:end-1)];   % size (N-1) x 2

% ---------- quadratic form components
Q = X.'*X;         % 2x2
b = X.'*y;         % 2x1
c = y.'*y;         % scalar

% ---------- grid of filter coefficients (axes: f1, f2)
f1v = linspace(-1.2, 1.2, 201);
f2v = linspace(-1.2, 1.2, 201);
[F1,F2] = meshgrid(f1v,f2v);

% Cost surface via quadratic form: J = f'Qf - 2 b'f + c
J = Q(1,1)*F1.^2 + 2*Q(1,2)*F1.*F2 + Q(2,2)*F2.^2 ...
    - 2*b(1)*F1 - 2*b(2)*F2 + c;

% ---------- LS minimizer (marks the bottom of the bowl)
f_star = Q \ b;     % (X'X)\(X'y)
f1s = f_star(1);  f2s = f_star(2);
Js  = f_star.'*Q*f_star - 2*b.'*f_star + c;

% ---------- 3D surface plot
figure('Name','Cost Surface: J(f1,f2)'); clf
surf(F1, F2, J, 'EdgeColor', 'none'); hold on
plot3(f1s, f2s, Js, 'r.', 'MarkerSize', 28);   % optimum marker
xlabel('f_1'); ylabel('f_2'); zlabel('J = E^T E');
title('Least-squares cost surface for a 2-tap FIR')
colorbar; grid on; view([-35 30])

% ---------- contour plot (optional, nice for slides)
figure('Name','Contours of J(f1,f2)'); clf
contourf(F1, F2, J, 30, 'LineColor','none'); hold on
plot(f1s, f2s, 'r.', 'MarkerSize', 28);
xlabel('f_1'); ylabel('f_2');
title('Contours of J(f_1,f_2) with LS minimizer')
colorbar; axis equal tight
