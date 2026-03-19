clear all; close all;

%% Read two traffic frames
I1 = imread('assets/traffic_1.jpg');
I2 = imread('assets/traffic_2.jpg');
f1 = im2gray(I1);
f2 = im2gray(I2);

Nbest = 100;

%% ===== SIFT Matching =====
points1_sift = detectSIFTFeatures(f1);
points2_sift = detectSIFTFeatures(f2);

best1_sift = points1_sift.selectStrongest(Nbest);
best2_sift = points2_sift.selectStrongest(Nbest);

[feat1_sift, vp1_sift] = extractFeatures(f1, best1_sift);
[feat2_sift, vp2_sift] = extractFeatures(f2, best2_sift);

pairs_sift = matchFeatures(feat1_sift, feat2_sift, 'Unique', true);

mp1_sift = vp1_sift(pairs_sift(:,1),:);
mp2_sift = vp2_sift(pairs_sift(:,2),:);

fprintf('SIFT matches: %d\n', size(pairs_sift,1));

figure(1);
showMatchedFeatures(I1, I2, mp1_sift, mp2_sift, 'montage');
title(sprintf('SIFT Matching — %d matches', size(pairs_sift,1)));

%% ===== SURF Matching =====
points1_surf = detectSURFFeatures(f1);
points2_surf = detectSURFFeatures(f2);

best1_surf = points1_surf.selectStrongest(Nbest);
best2_surf = points2_surf.selectStrongest(Nbest);

[feat1_surf, vp1_surf] = extractFeatures(f1, best1_surf);
[feat2_surf, vp2_surf] = extractFeatures(f2, best2_surf);

pairs_surf = matchFeatures(feat1_surf, feat2_surf, 'Unique', true);

mp1_surf = vp1_surf(pairs_surf(:,1),:);
mp2_surf = vp2_surf(pairs_surf(:,2),:);

fprintf('SURF matches: %d\n', size(pairs_surf,1));

figure(2);
showMatchedFeatures(I1, I2, mp1_surf, mp2_surf, 'montage');
title(sprintf('SURF Matching — %d matches', size(pairs_surf,1)));

%% ===== Side by side comparison =====
figure(3);
subplot(1,2,1);
showMatchedFeatures(f1, f2, mp1_sift, mp2_sift, 'montage');
title(sprintf('SIFT: %d matches', size(pairs_sift,1)));

subplot(1,2,2);
showMatchedFeatures(f1, f2, mp1_surf, mp2_surf, 'montage');
title(sprintf('SURF: %d matches', size(pairs_surf,1)));