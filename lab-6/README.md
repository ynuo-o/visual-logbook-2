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
