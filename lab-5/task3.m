clear all; close all; clc;

%% Step 1: Read image and find edge points
f = imread('assets/circuit_rotated.tif');   % make sure file name matches your assets
fEdge = edge(f, 'Canny');

figure(1);
montage({f, fEdge});
title('Original vs Canny edge');

%% Step 2: Hough Transform and display accumulator
[H, theta, rho] = hough(fEdge);

figure(2);
imshow(H, [], 'XData', theta, 'YData', rho, ...
       'InitialMagnification', 'fit');
xlabel('\theta (degrees)');
ylabel('\rho (pixels)');
title('Hough Transform accumulator');
axis on; axis normal; hold on;

%% Step 3: Find peaks in Hough space and overlay on H
numPeaks = 8;                      % try 8, 10, ... to see differences
peaks = houghpeaks(H, numPeaks); 
% Alternative with threshold:
% peaks = houghpeaks(H, numPeaks, 'Threshold', ceil(0.3*max(H(:))));

x = theta(peaks(:,2));
y = rho(peaks(:,1));

plot(x, y, 'o', 'Color', 'red', ...
     'MarkerSize', 10, 'LineWidth', 1);

%% Step 4: Visualize Hough space as 3D surface
figure(3);
surf(theta, rho, H);
xlabel('\theta (degrees)', 'FontSize', 12);
ylabel('\rho (pixels)', 'FontSize', 12);
zlabel('Hough counts', 'FontSize', 12);
title('Hough Transform (3D surface)');
shading interp;
colormap hot;
colorbar;

%% Step 5: Use houghlines to detect and draw line segments
lines = houghlines(fEdge, theta, rho, peaks, ...
                   'FillGap', 5, 'MinLength', 7);

figure(4);
imshow(f); hold on;
title('Detected line segments using Hough transform');

max_len = 0;
for k = 1:length(lines)
    % Endpoints of this line segment
    xy = [lines(k).point1; lines(k).point2];

    % Plot the line segment
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');

    % Mark the endpoints
    plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
    plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');

    % Track the longest line segment (optional)
    len = norm(lines(k).point1 - lines(k).point2);
    if len > max_len
        max_len = len;
        longest_xy = xy;
    end
end

% Highlight the longest line segment (optional)
if exist('longest_xy', 'var')
    plot(longest_xy(:,1), longest_xy(:,2), ...
         'LineWidth', 2, 'Color', 'cyan');
end