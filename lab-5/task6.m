% Watershed segmentation with Distance Transform
clear all; close all;

%% Step 1: Read and binarize image
I = imread('assets/dowels.tif');
f = im2bw(I, graythresh(I));        % Otsu threshold
g = bwmorph(f, "close", 1);         % morphological close - fill small holes
g = bwmorph(g, "open", 1);          % morphological open - remove small noise

figure(1)
montage({I, g});
title('Original & binarized cleaned image')

%% Step 2: Distance Transform
% We complement g because bwdist measures distance to nearest WHITE pixel
% We want distance to nearest background pixel (i.e. nearest 0)
gc = imcomplement(g);
D = bwdist(gc);
figure(2)
imshow(D, [min(D(:)) max(D(:))])
title('Distance Transform')

%% Step 3: Watershed on complement of distance transform
% Watershed finds "valleys" - so we invert D to find peaks (centres of dowels)
L = watershed(imcomplement(D));
figure(3)
imshow(L, [0 max(L(:))])
title('Watershed Segmented Label')

%% Step 4: Merge everything to show final segmentation
W = (L==0);         % watershed boundary lines (where L=0)
g2 = g | W;         % overlay boundaries onto binary image

figure(4)
montage({I, g, W, g2}, 'size', [2 2]);
title('Original Image - Binarized Image - Watershed regions - Merged dowels and segmented boundaries')