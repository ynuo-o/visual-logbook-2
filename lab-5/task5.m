clear all; close all;

%% ===== BABOON =====

f = imread('assets/baboon.png');
[M N S] = size(f);
F = reshape(f, [M*N S]);          % reshape to 1D array of 3 colours
R = F(:,1); G = F(:,2); B = F(:,3);
C = double(F)/255;                % convert for plotting

% Figure 1: 3D scatter plot of pixel colours
figure(1);
scatter3(R, G, B, 1, C);
xlabel('RED', 'FontSize', 14);
ylabel('GREEN', 'FontSize', 14);
zlabel('BLUE', 'FontSize', 14);
title('Baboon - RGB colour space scatter plot');

% K-means clustering with k=10
k = 10;
[L, centers] = imsegkmeans(f, k);

% Overlay cluster centres on scatter plot
hold on;
scatter3(centers(:,1), centers(:,2), centers(:,3), ...
         100, 'black', 'fill');
title('Baboon - RGB scatter with k-means centres (k=10)');

% Figure 2: Original vs segmented image (k=10)
J = label2rgb(L, im2double(centers));
figure(2);
montage({f, J});
title('Baboon: Original | k-means Segmented (k=10)');

% Try different k values
figure(3);
results = {f};
for k = [2, 5, 10, 20]
    [L, centers] = imsegkmeans(f, k);
    J = label2rgb(L, im2double(centers));
    results{end+1} = J;
end
montage(results);
title('Baboon: Original | k=2 | k=5 | k=10 | k=20');

%% ===== PEPPERS =====

p = imread('assets/peppers.png');
[M N S] = size(p);
F = reshape(p, [M*N S]);
R = F(:,1); G = F(:,2); B = F(:,3);
C = double(F)/255;

% Figure 4: scatter plot for peppers
figure(4);
scatter3(R, G, B, 1, C);
xlabel('RED', 'FontSize', 14);
ylabel('GREEN', 'FontSize', 14);
zlabel('BLUE', 'FontSize', 14);
title('Peppers - RGB colour space scatter plot');

% Figure 5: segmentation with different k values
figure(5);
results2 = {p};
for k = [2, 5, 10, 20]
    [L, centers] = imsegkmeans(p, k);
    J = label2rgb(L, im2double(centers));
    results2{end+1} = J;
end
montage(results2);
title('Peppers: Original | k=2 | k=5 | k=10 | k=20');