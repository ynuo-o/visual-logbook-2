clear all; close all; clc;

%% Step 1: Read image
f = imread('assets/yeast-cells.tif');
figure(1);
imshow(f);
title('Original Image');

%% Step 2: Otsu's method - global thresholding
T = graythresh(f);                    % Otsu's threshold
g_otsu = imbinarize(f, T);           % apply threshold
figure(2);
montage({f, g_otsu});
title(sprintf('Original | Otsu Segmentation (T = %.3f)', T));

%% Step 3: Show limitation - touching cells are merged
% Use bwlabel to count separated regions
g_otsu_inv = ~g_otsu;                % invert if cells are dark
cc = bwconncomp(g_otsu_inv);
fprintf('Number of detected regions (Otsu): %d\n', cc.NumObjects);

%% Step 4: Alternative method - Watershed segmentation
% Distance transform on binary image
g_bin = ~g_otsu;                     % cells should be white
D = bwdist(~g_bin);                  % distance transform
D = -D;                              % invert for watershed
D(~g_bin) = Inf;                     % suppress background

% Apply watershed
L = watershed(D);
g_bin(L == 0) = 0;                   % mark watershed boundaries

figure(3);
montage({f, g_otsu, g_bin});
title('Original | Otsu | Watershed Segmentation');

%% Step 5: Overlay watershed result on original
figure(4);
imshow(f); hold on;
boundaries = bwperim(g_bin);
visboundaries(bwlabel(g_bin), 'Color', 'red');
title('Watershed: Detected Cell Boundaries');