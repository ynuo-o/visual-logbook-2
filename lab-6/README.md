## Task 1: Image Pyramid

### Objective
Build an image pyramid of `cafe_van_gogh.jpg` at scales 1/2, 1/4, 1/8, 1/16, and 1/32 using two methods: (1) decimation by dropping every other rows/columns, and (2) resizing with `imresize`. Compare the two approaches and their visual differences.



### Code
```matlab
% Lab 6 Task 1 - Image Pyramid
clear all; close all;
f0 = imread('assets/cafe_van_gogh.jpg');

%% Method 1: Decimation by dropping every other rows and columns
f1 = f0(1:2:end, 1:2:end, :);   % 1/2
f2 = f1(1:2:end, 1:2:end, :);   % 1/4
f3 = f2(1:2:end, 1:2:end, :);   % 1/8
f4 = f3(1:2:end, 1:2:end, :);   % 1/16
f5 = f4(1:2:end, 1:2:end, :);   % 1/32

figure(1);
montage({f0, f1, f2, f3, f4, f5}, 'Size', [2 3]);
title('Method 1: Drop every other rows/columns (no pre-filter)', 'FontSize', 14);

%% Method 2: Proper resizing with imresize
f_1 = imresize(f0, 0.5);   % 1/2
f_2 = imresize(f_1, 0.5);  % 1/4
f_3 = imresize(f_2, 0.5);  % 1/8
f_4 = imresize(f_3, 0.5);  % 1/16
f_5 = imresize(f_4, 0.5);  % 1/32

figure(2);
montage({f0, f_1, f_2, f_3, f_4, f_5}, 'Size', [2 3]);
title('Method 2: imresize (lowpass filter + subsampling)', 'FontSize', 14);

%% Compare 1/8 images from both methods
figure(3); imshow(f0);  title('Original Image', 'FontSize', 14);
figure(4); imshow(f_3); title('1/8 image (imresize - filtered)', 'FontSize', 11);
figure(5); imshow(f3);  title('1/8 image (drop samples - no filter)', 'FontSize', 11);
```



### Results & Analysis

**Figure 1 — Method 1: Drop every other rows/columns (no pre-filter)**

<img src="task1_1.png" width="500">

The montage was built by repeatedly using `I(1:2:end, 1:2:end)` to halve resolution at each level. No low-pass filter is applied before subsampling. Because high-frequency details (e.g. brushstrokes, cobblestone texture) are not removed before the sampling rate is reduced, aliasing occurs — producing jagged edges, moiré patterns, and false structures in the smaller images.

**Figure 2 — Method 2: imresize (lowpass filter + subsampling)**

<img src="task1_2.png" width="500">

The montage was built by repeatedly calling `imresize(..., 0.5)`. Unlike Method 1, `imresize` applies a low-pass (Gaussian) filter before subsampling. High frequencies are removed first, so the images become progressively blurrier but remain smooth, and aliasing artefacts are largely avoided.

**Figure 3 — Original Image**

<img src="task1_3.png" width="400">

The original image provides the reference for comparing both methods.

**Figure 4 — 1/8 Scale (imresize)**

<img src="task1_4.png" width="400">

At 1/8 scale, the filtered image is blocky but smooth. Edges and textures are blurred rather than jagged, because high frequencies were removed before downsampling.

**Figure 5 — 1/8 Scale (drop samples)**

<img src="task1_5.png" width="400">

At 1/8 scale, the drop-sampling version shows clear aliasing: staircase edges, moiré-like patterns in cobblestones and other textures, and false structures. This clearly illustrates the consequence of subsampling without a pre-filter.



### Conclusion

Method 1 (drop rows/columns) is simple but causes aliasing because high frequencies are not removed before subsampling. Method 2 (`imresize`) uses a low-pass filter before subsampling, which avoids aliasing but introduces blur. For building image pyramids or any form of downsampling, pre-filtering with `imresize` is preferable to reduce artefacts. The side-by-side comparison at 1/8 scale clearly demonstrates the difference between the two approaches.



### What I Learnt & Reflections

- Subsampling without a low-pass filter leads to aliasing — visible as jaggies and moiré patterns in textured images.
- `imresize` applies Gaussian filtering before subsampling, which trades sharpness for correct representation at lower resolution.
- The `(1:2:end)` slicing syntax is a simple and efficient way to perform decimation in MATLAB, but must be paired with pre-filtering to avoid artefacts.
- This task demonstrated why the Nyquist theorem matters in practice: sampling below twice the highest frequency in the signal causes irreversible information loss and aliasing.


## Task 2: Pattern Matching with Normalized Cross Correlation

### Objective
Use MATLAB's `normxcorr2` function to perform template matching — locating a small template image within a larger image (`salvador_grayscale.tif`) by finding the position of maximum Normalized Cross Correlation (NCC) value.



### Code
```matlab
clear all; close all;

%% ===== Template 1 =====
f = imread('assets/salvador_grayscale.tif');
w = imread('assets/template1.tif');

c = normxcorr2(w, f);

figure(1);
surf(c);
shading interp;
title('NCC Surface Plot - Template 1');
xlabel('X'); ylabel('Y'); zlabel('NCC value');
colormap hot; colorbar;

[ypeak, xpeak] = find(c == max(c(:)));
yoffSet = ypeak - size(w, 1);
xoffSet = xpeak - size(w, 2);

fprintf('Template 1 found at: x=%d, y=%d\n', xoffSet, yoffSet);
fprintf('Peak NCC value: %.4f\n', max(c(:)));

figure(2);
imshow(f);
title('Template 1 Match Location');
drawrectangle(gca, 'Position', ...
    [xoffSet, yoffSet, size(w,2), size(w,1)], 'FaceAlpha', 0);

%% ===== Template 2 =====
w2 = imread('assets/template2.tif');

c2 = normxcorr2(w2, f);

figure(3);
surf(c2);
shading interp;
title('NCC Surface Plot - Template 2');
xlabel('X'); ylabel('Y'); zlabel('NCC value');
colormap hot; colorbar;

[ypeak2, xpeak2] = find(c2 == max(c2(:)));
yoffSet2 = ypeak2 - size(w2, 1);
xoffSet2 = xpeak2 - size(w2, 2);

fprintf('Template 2 found at: x=%d, y=%d\n', xoffSet2, yoffSet2);
fprintf('Peak NCC value: %.4f\n', max(c2(:)));

figure(4);
imshow(f);
title('Template 2 Match Location');
drawrectangle(gca, 'Position', ...
    [xoffSet2, yoffSet2, size(w2,2), size(w2,1)], 'FaceAlpha', 0);
```



### Results & Analysis

**Figure 1 — NCC Surface Plot: Template 1**

<img src="task2_1.png" width="500">

The NCC surface for Template 1 shows a relatively flat landscape with many moderate peaks across the image. There is no single sharp dominant spike, which suggests Template 1 contains features (such as texture or tone) that partially match many regions of the image. However, `find(c == max(c(:)))` correctly identifies the global maximum, which corresponds to the true match location.

**Figure 2 — Template 1 Match Location**

<img src="task2_2.png" width="500">

The blue dashed rectangle is drawn at the position of the peak NCC value. It correctly locates a small region on the left side of the painting, near the melting clock — confirming that Template 1 was extracted from that area of the image.

**Figure 3 — NCC Surface Plot: Template 2**

<img src="task2_3.png" width="500">

The NCC surface for Template 2 shows a much more prominent and isolated spike — a single tall peak that stands clearly above the rest of the surface. This indicates that Template 2 contains more distinctive features that match strongly at only one location in the image, making the peak easier to identify visually.

**Figure 4 — Template 2 Match Location**

<img src="task2_4.png" width="500">

The blue dashed rectangle correctly locates Template 2 on the right side of the painting, within the melting clock draped over the face-like figure. The match is precise and unambiguous.



### About `find()`

The MATLAB function `find()` returns the indices of non-zero elements in an array. In this context:
```matlab
[ypeak, xpeak] = find(c == max(c(:)));
```

`max(c(:))` flattens the NCC matrix and finds the maximum value. `find(c == max(c(:)))` then returns the row and column indices where that maximum value occurs — i.e. the (y, x) location of the best match. The offset calculation (`ypeak - size(w,1)`) converts from NCC output coordinates back to the original image coordinates.



### Conclusion

`normxcorr2` successfully located both templates within the painting. Template 2 produced a sharper and more isolated NCC peak than Template 1, suggesting it contains more distinctive local features. This demonstrates a key property of NCC-based template matching: it works best when the template has unique features that do not appear elsewhere in the image. NCC can only match a template if the match is exact or nearly exact — changes in scale, rotation, or illumination would cause the peak to drop significantly.



### What I Learnt & Reflections

- `normxcorr2` computes a normalised similarity score at every possible position of the template within the image — a score of 1.0 means a perfect match.
- The shape of the NCC surface reveals how distinctive the template is: a sharp isolated peak means a unique match; a flat noisy surface means many similar regions exist.
- `find()` is used to convert the peak location in the NCC output back to image coordinates, with an offset correction for the template size.
- NCC is sensitive to exact pixel matches — it would fail if the template were scaled, rotated, or had different lighting. More robust methods (e.g. SIFT, SURF) are needed for such cases.
















