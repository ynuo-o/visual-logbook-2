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
