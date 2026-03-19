clear all; close all;

I1 = imread('assets/cafe_van_gogh.jpg');
I2 = imresize(I1, 0.5);
f1 = im2gray(I1);
f2 = im2gray(I2);

points1 = detectSIFTFeatures(f1);
points2 = detectSIFTFeatures(f2);

Nbest = 100;
bestFeatures1 = points1.selectStrongest(Nbest);
bestFeatures2 = points2.selectStrongest(Nbest);

%% Part 1: Match using ALL points
[features1, valid_points1] = extractFeatures(f1, points1);
[features2, valid_points2] = extractFeatures(f2, points2);

indexPairs = matchFeatures(features1, features2, 'Unique', true);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure(1);
showMatchedFeatures(f1, f2, matchedPoints1, matchedPoints2);
title(sprintf('Matched using ALL points — %d matches', size(indexPairs,1)));

%% Part 2: Match using only top 100 (bestFeatures)
[features1, valid_points1] = extractFeatures(f1, bestFeatures1);
[features2, valid_points2] = extractFeatures(f2, points2.selectStrongest(Nbest));

indexPairs2 = matchFeatures(features1, features2, 'Unique', true);

matchedPoints1b = valid_points1(indexPairs2(:,1),:);
matchedPoints2b = valid_points2(indexPairs2(:,2),:);

figure(2);
showMatchedFeatures(f1, f2, matchedPoints1b, matchedPoints2b);
title(sprintf('Matched using top 100 points — %d matches', size(indexPairs2,1)));

%% Part 3: Rotate smaller image by 20 degrees, then match
I2_rot = imrotate(I2, 20);
f2_rot = im2gray(I2_rot);

points2_rot = detectSIFTFeatures(f2_rot);

[features1r, valid_points1r] = extractFeatures(f1, bestFeatures1);
[features2r, valid_points2r] = extractFeatures(f2_rot, points2_rot.selectStrongest(Nbest));

indexPairs3 = matchFeatures(features1r, features2r, 'Unique', true);

matchedPoints1r = valid_points1r(indexPairs3(:,1),:);
matchedPoints2r = valid_points2r(indexPairs3(:,2),:);

figure(3);
showMatchedFeatures(f1, f2_rot, matchedPoints1r, matchedPoints2r);
title(sprintf('Matched after 20 degree rotation — %d matches', size(indexPairs3,1)));