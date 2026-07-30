% Reflectivity Forward and Inverse Process with Plots
% For teaching/demo purposes

clear; close all; clc;

%% Step 1: Define known interface reflection coefficients (forward problem)
% Three layers → 2 interfaces → R1, R2
R = [0.3, -0.2];         % Reflection coefficients at interfaces
T = sqrt(1 - R.^2);      % Transmission coefficients

% Reflectivity series: will be centered around t=0
N = 5;                        % Output reflectivity series length
r = zeros(1, N);              % Reflectivity series
mid = ceil(N/2);              % Center (t=0)

% Primary reflections
r(mid)   = R(1);              % Time 0: R1
r(mid+1) = T(1)^2 * R(2);     % Time 1: R2 through R1

% First-order multiple: R2 → R1 → R2
r(mid+2) = R(1) * R(2) * T(1)^2;

disp('--- Forward Process ---');
disp('Computed reflectivity series r (with multiples):');
disp(r);

%% Step 2: Inverse process — recover R1 and R2 from r
R1_rec = r(mid);
T1_rec = sqrt(1 - R1_rec^2);
R2_rec = r(mid+1) / (T1_rec^2);
multiple_pred = R1_rec * R2_rec * T1_rec^2;
multiple_obs = r(mid+2);

disp('--- Inverse Process ---');
disp(['Recovered R1: ', num2str(R1_rec)]);
disp(['Recovered R2: ', num2str(R2_rec)]);
disp(['Predicted multiple (t=2): ', num2str(multiple_pred)]);
disp(['Observed multiple  (t=2): ', num2str(multiple_obs)]);

%% Plotting

figure;

% Plot 1: Reflectivity series r (includes multiples)
subplot(2,1,1);
stem(-2:2, r, 'filled', 'LineWidth', 1.5);
title('Reflectivity Series r (including multiples)');
xlabel('Time sample');
ylabel('Amplitude');
grid on;
xlim([-2.5 2.5]);
ylim([-0.25 0.35]);

% Plot 2: Interface reflection coefficients R
subplot(2,1,2);
stem(1:length(R), R, 'filled', 'LineWidth', 1.5);
title('Interface Reflection Coefficients R');
xlabel('Interface index');
ylabel('R_i');
grid on;
xlim([0.5 length(R)+0.5]);
ylim([-0.25 0.35]);

sgtitle('Forward and Inverse Reflectivity Demonstration');
