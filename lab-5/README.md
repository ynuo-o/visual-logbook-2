## Task 1: Point Detection — Crab Nebula Star Isolation

### Objective
The goal of this task is to isolate the surrounding stars in an image of the Crab Nebula (`crabpulsar.tif`) by removing the dominant nebular region using a point detection filter combined with morphological processing.



### Code
```matlab
clear all
close all
f = imread('assets/crabpulsar.tif');
w = [-1 -1 -1;
     -1  8 -1;
     -1 -1 -1];
g1 = abs(imfilter(f, w));      % point detected
se = strel("disk", 1);
g2 = imerode(g1, se);          % eroded
threshold = 100;
g3 = uint8((g2 >= threshold)*255); % thresholded
montage({f, g1, g2, g3});
```



### Result

<img src="task1.png" width="400">



### Analysis

**Top-left — Original Image (`f`)**

The original grayscale image shows the Crab Nebula, with a large diffuse bright region in the centre representing the nebula, and a number of small isolated bright points (stars) scattered around it.

**Top-right — After Point Detection Filter (`g1`)**

A Laplacian point detection kernel was applied:
```matlab
w = [-1 -1 -1;
     -1  8 -1;
     -1 -1 -1]
```

This filter strongly responds to pixels that are significantly brighter than their neighbours. Isolated stars appear as bright white dots, while the nebula produces a low response and appears dark. The `abs()` function ensures all values remain positive.

**Bottom-left — After Erosion (`g2`)**

Morphological erosion was applied using a disk-shaped structuring element of radius 1. This removes small noise pixels that were falsely detected, retaining only the more prominent and reliable star detections.

**Bottom-right — After Thresholding (`g3`)**

A threshold of 100 was applied to binarise the image. Pixels with a response value ≥ 100 are set to white (255), and all others to black (0). The nebula is almost entirely removed, with surrounding stars clearly highlighted as white dots.



### Conclusion

The combination of a Laplacian point detection filter, morphological erosion, and thresholding successfully isolates the surrounding stars from the Crab Nebula image. The filter responds strongly to isolated bright points but weakly to large uniform bright regions, making it effective for this type of feature extraction.



### What I Learnt & Reflections

- The Laplacian kernel detects isolated bright points by computing the difference between a pixel and its surroundings — effective for stars but not for diffuse regions like nebulae.
- Morphological erosion is a useful post-processing step to remove noise after filtering.
- Threshold selection involves a trade-off: too high misses faint stars, too low retains noise.
- This task showed how combining simple operations (filtering → erosion → thresholding) can produce meaningful results in astronomical image analysis.


## Task 2: Edge Detection

### Objective
The goal of this task is to apply three edge detection methods — Sobel, LoG (Laplacian of Gaussian), and Canny — to two images: a chip micrograph (`circuits.tif`) and a brain MRI scan (`brain_tumor.jpg`). The task also involves tuning the threshold parameters to achieve the best possible edge detection results.



### Code
```matlab
clear all
close all

f1 = imread('assets/circuits.tif');
f2 = imread('assets/brain_tumor.jpg');

if size(f2, 3) == 3
    f2 = rgb2gray(f2);
end

%% circuits.tif - default thresholds
[g1_sobel, t1_sobel] = edge(f1, 'Sobel');
[g1_log, t1_log]     = edge(f1, 'log');
[g1_canny, t1_canny] = edge(f1, 'Canny');

figure;
montage({f1, g1_sobel, g1_log, g1_canny});
title('circuits.tif: Original | Sobel | LoG | Canny');

%% brain_tumor.jpg - default thresholds
[g2_sobel, t2_sobel] = edge(f2, 'Sobel');
[g2_log, t2_log]     = edge(f2, 'log');
[g2_canny, t2_canny] = edge(f2, 'Canny');

figure;
montage({f2, g2_sobel, g2_log, g2_canny});
title('brain_tumor.jpg: Original | Sobel | LoG | Canny');

%% circuits.tif - tuned thresholds
g1_sobel_tuned = edge(f1, 'Sobel', 0.05);
g1_log_tuned   = edge(f1, 'log', 0.003);
g1_canny_tuned = edge(f1, 'Canny', [0.05 0.15]);

figure;
montage({g1_sobel_tuned, g1_log_tuned, g1_canny_tuned});
title('circuits.tif Tuned: Sobel | LoG | Canny');

%% brain_tumor.jpg - tuned thresholds
g2_sobel_tuned = edge(f2, 'Sobel', 0.02);
g2_log_tuned   = edge(f2, 'log', 0.001);
g2_canny_tuned = edge(f2, 'Canny', [0.03 0.1]);

figure;
montage({g2_sobel_tuned, g2_log_tuned, g2_canny_tuned});
title('brain_tumor.jpg Tuned: Sobel | LoG | Canny');
```



### Results

**Figure 1 — circuits.tif: Default Thresholds**

<img src="task2_1.png" width="500">

**Figure 2 — brain_tumor.jpg: Default Thresholds**

<img src="task2_2.png" width="500">

**Figure 3 — circuits.tif: Tuned Thresholds**

<img src="task2_3.png" width="500">

**Figure 4 — brain_tumor.jpg: Tuned Thresholds**

<img src="task2_4.png" width="500">



### Analysis

#### circuits.tif

**Top-left — Original Image**
A grayscale micrograph of an integrated circuit, featuring sharp geometric structures, straight lines, and high-contrast boundaries between components.

**Top-right — Sobel (default)**
The Sobel method detects edges by approximating image gradients. It successfully captures the major circuit boundaries and straight lines, producing clean and well-defined edges.

**Bottom-left — LoG (default)**
The Laplacian of Gaussian method first smooths the image with a Gaussian filter before applying the Laplacian. The result shows slightly thicker edges compared to Sobel, and also detects some finer internal structures within the circuit components.

**Bottom-right — Canny (default)**
The Canny method uses local gradient maxima with hysteresis thresholding. It produces the thinnest and most precise edges among the three methods, clearly capturing fine circuit details while suppressing noise effectively.

#### brain_tumor.jpg

**Top-left — Original Image**
A grayscale MRI scan showing a cross-section of a patient's brain. A bright region in the upper-left area indicates the tumour.

**Top-right — Sobel (default)**
Sobel detects the main structural boundaries of the brain, including the outer skull boundary and some internal tissue boundaries. However, finer internal details are less well captured.

**Bottom-left — LoG (default)**
LoG produces more detailed edge maps with closed contours, revealing more internal brain structures. The tumour region boundary is also visible.

**Bottom-right — Canny (default)**
Canny produces the most detailed result, capturing a large number of internal brain structures and clearly highlighting both the outer boundary and internal tissue transitions, including the tumour region.



### Threshold Tuning

After testing different threshold values, the tuned results show the following improvements:

- **circuits.tif**: Lowering the Sobel and LoG thresholds reveals more circuit detail. The Canny method with `[0.05 0.15]` provides a good balance between detail and noise suppression.
- **brain_tumor.jpg**: Lower thresholds for all three methods reveal more internal brain structures. The tuned Canny result with `[0.03 0.1]` captures the most anatomical detail, though it also picks up more noise.



### Conclusion

All three methods successfully detect edges in both images, but with different characteristics. Sobel is fast and simple but can miss fine details. LoG produces closed contours and is good for detecting blobs and boundaries. Canny generally gives the best results — thin, precise edges with good noise resistance — making it the most suitable method for detailed images like MRI scans and circuit micrographs.



### What I Learnt & Reflections

- Different edge detection methods suit different types of images — Canny performed best overall, but all three have valid use cases.
- Threshold selection significantly affects the output: lower thresholds detect more edges but also introduce noise.
- For Canny, using a two-value threshold `[low high]` allows finer control over which edges are preserved.
- In medical imaging (e.g. MRI), edge detection could help highlight anatomical boundaries, though careful tuning is needed to avoid false detections.



