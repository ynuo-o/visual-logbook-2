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

## Task 3: Hough Transform for Line Detection

### Objective
Use the Hough Transform to detect straight line segments in a rotated circuit image (`circuit_rotated.tif`). The pipeline consists of four steps: (1) detect edge points using Canny, (2) map those edge points into Hough space, (3) find prominent peaks in the accumulator, and (4) use `houghlines` to draw the detected line segments back on the original image.



### Code
```matlab
clear all; close all; clc;

%% Step 1: Read image and find edge points
f = imread('assets/circuit_rotated.tif');
fEdge = edge(f, 'Canny');
figure(1);
montage({f, fEdge});
title('Original vs Canny edge');

%% Step 2: Hough Transform and display accumulator
[H, theta, rho] = hough(fEdge);
figure(2);
imshow(H, [], 'XData', theta, 'YData', rho, ...
       'InitialMagnification', 'fit');
xlabel('\theta (degrees)');
ylabel('\rho (pixels)');
title('Hough Transform accumulator');
axis on; axis normal; hold on;

%% Step 3: Find peaks in Hough space and overlay on H
numPeaks = 5;
peaks = houghpeaks(H, numPeaks);
x = theta(peaks(:,2));
y = rho(peaks(:,1));
plot(x, y, 'o', 'Color', 'red', ...
     'MarkerSize', 10, 'LineWidth', 1);

%% Step 4: Visualise Hough space as 3D surface
figure(3);
surf(theta, rho, H);
xlabel('\theta (degrees)', 'FontSize', 12);
ylabel('\rho (pixels)', 'FontSize', 12);
zlabel('Hough counts', 'FontSize', 12);
title('Hough Transform (3D surface)');
shading interp;
colormap hot;
colorbar;

%% Step 5: Use houghlines to detect and draw line segments
lines = houghlines(fEdge, theta, rho, peaks, ...
                   'FillGap', 5, 'MinLength', 7);
figure(4);
imshow(f); hold on;
title('Detected line segments using Hough transform');
max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
    plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
    plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');
    len = norm(lines(k).point1 - lines(k).point2);
    if len > max_len
        max_len = len;
        longest_xy = xy;
    end
end
if exist('longest_xy', 'var')
    plot(longest_xy(:,1), longest_xy(:,2), 'LineWidth', 2, 'Color', 'cyan');
end
```



### Results & Analysis

**Figure 1 — Original vs Canny Edge**

<img src="task3_1.png" width="500">

The Canny result highlights the strongest boundaries in the rotated circuit image. These edge pixels serve as the input to the Hough Transform, since straight lines in the image produce consistent votes in Hough space.

**Figure 2 — Hough Transform Accumulator with Peaks**

<img src="task3_2.png" width="500">

In the accumulator plot, the dominant structure appears as a curved or elongated ridge, where many combinations of θ and ρ receive votes. The red peak markers correspond to the strongest parameter bins, meaning there are many edge pixels aligned along particular straight-line directions.

**Figure 3 — Hough Transform 3D Surface**

<img src="task3_3.png" width="500">

The 3D surface view makes the accumulator peaks clearer. High "mountain" regions correspond to strong line evidence. The surface shows multiple elevated areas, indicating the circuit contains several line segments and possibly multiple near-parallel lines that generate comparable votes.

**Figure 4 — Detected Line Segments on Original Image**

<img src="task3_4.png" width="500">

`houghlines` draws multiple green line segments across the circuit layout. The number of detected segments is not necessarily equal to `numPeaks = 5`, for the following reasons:

- A single Hough peak bin may correspond to more than one physical line segment in the image.
- Edge points on the same ideal line can be fragmented into several shorter segments; `FillGap` and `MinLength` control whether nearby fragments are merged or discarded.
- The circuit contains repeated parallel traces and right-angle patterns, which can create several strong local maxima or produce multiple valid segments around the same parameter peak.

The longest detected segment is highlighted in cyan.



### Conclusion

The Hough Transform pipeline successfully detected straight-line structures in the rotated circuit image. Canny extracted reliable edge points, and the Hough accumulator concentrated the evidence of lines into strong parameter regions. Using `houghpeaks` and `houghlines`, the algorithm returned line segments that match the circuit traces, demonstrating that the Hough Transform is effective for detecting global linear patterns even when the image is rotated.



### What I Learnt & Reflections

- The Hough Transform works by converting each edge point into a sinusoidal curve in (θ, ρ) space — where multiple curves intersecting at the same point indicate a common straight line.
- `houghpeaks` finds the strongest bins in the accumulator, but a single peak can correspond to multiple physical line segments in the image.
- Parameters like `FillGap` and `MinLength` in `houghlines` are important for controlling output quality — small gaps between fragments can be bridged, and very short segments can be filtered out.
- The 3D surface plot was a helpful way to visualise the accumulator and understand why multiple peaks emerge from a structured image like a circuit.


