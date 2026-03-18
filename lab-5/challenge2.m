clear all; close all;

%% Step 1: Read image
I = imread('assets/f14.png');
figure(1);
imshow(I);
title('Original F14 Image');

%% Step 2: Grayscale
if size(I, 3) == 3
    Igray = rgb2gray(I);
else
    Igray = I;
end

%% Step 3: Threshold and INVERT - jet is darker than background
T = graythresh(Igray);
bw = ~imbinarize(Igray, T);   % invert! jet = white, sky = black

figure(2);
imshow(bw);
title('After invert');

%% Step 4: Morphological cleaning
bw = imfill(bw, 'holes');
bw = bwareaopen(bw, 500);

%% Step 5: Keep largest region (the jet)
L = bwlabel(bw);
stats = regionprops(L, 'Area');
areas = [stats.Area];
[~, largest] = max(areas);
bw_jet = (L == largest);

%% Step 6: Display
figure(3);
montage({Igray, uint8(bw_jet * 255)});
title('Original | F14 Binary Mask');