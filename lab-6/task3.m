clear all; close all;

%% ===== Salvador Dali =====
I1 = imread('assets/salvador.tif');
f1 = im2gray(I1);

% SIFT feature detection
points1 = detectSIFTFeatures(f1);

% Display top 100 strongest points
figure(1);
imshow(I1); hold on;
plot(points1.selectStrongest(100));
title(sprintf('SIFT Features - Salvador (top 100 of %d)', points1.Count));

% Explore points data structure
fprintf('=== points data structure ===\n');
fprintf('Total SIFT points detected: %d\n', points1.Count);
fprintf('First point Location: (%.1f, %.1f)\n', points1.Location(1,1), points1.Location(1,2));
fprintf('First point Scale: %.4f\n', points1.Scale(1));
fprintf('First point Metric (strength): %.4f\n', points1.Metric(1));

% Show all points
figure(2);
imshow(I1); hold on;
plot(points1);
title(sprintf('SIFT Features - Salvador (all %d points)', points1.Count));

%% ===== Cafe Van Gogh =====
I2 = imread('assets/cafe_van_gogh.jpg');
f2 = im2gray(I2);

points2 = detectSIFTFeatures(f2);

figure(3);
imshow(I2); hold on;
plot(points2.selectStrongest(100));
title(sprintf('SIFT Features - Cafe Van Gogh (top 100 of %d)', points2.Count));

%% ===== Other feature detection methods =====

% SURF
pointsSURF = detectSURFFeatures(f1);
figure(4);
imshow(I1); hold on;
plot(pointsSURF.selectStrongest(100));
title(sprintf('SURF Features - Salvador (top 100 of %d)', pointsSURF.Count));

% HARRIS
pointsHarris = detectHarrisFeatures(f1);
figure(5);
imshow(I1); hold on;
plot(pointsHarris.selectStrongest(100));
title(sprintf('Harris Features - Salvador (top 100 of %d)', pointsHarris.Count));

% ORB
pointsORB = detectORBFeatures(f1);
figure(6);
imshow(I1); hold on;
plot(pointsORB.selectStrongest(100));
title(sprintf('ORB Features - Salvador (top 100 of %d)', pointsORB.Count));