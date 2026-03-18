clear all
close all

% Read images
f1 = imread('assets/circuit.tif');
f2 = imread('assets/brain_tumor.jpg');

% Convert to grayscale if needed
if size(f2, 3) == 3
    f2 = rgb2gray(f2);
end

%% --- circuits.tif ---

% Sobel
[g1_sobel, t1_sobel] = edge(f1, 'Sobel');

% LoG
[g1_log, t1_log] = edge(f1, 'log');

% Canny
[g1_canny, t1_canny] = edge(f1, 'Canny');

figure;
montage({f1, g1_sobel, g1_log, g1_canny});
title('circuits.tif: Original | Sobel | LoG | Canny');

%% --- brain_tumor.jpg ---

% Sobel
[g2_sobel, t2_sobel] = edge(f2, 'Sobel');

% LoG
[g2_log, t2_log] = edge(f2, 'log');

% Canny
[g2_canny, t2_canny] = edge(f2, 'Canny');

figure;
montage({f2, g2_sobel, g2_log, g2_canny});
title('brain_tumor.jpg: Original | Sobel | LoG | Canny');

%% --- Tune thresholds for best results ---

% circuits.tif - adjust thresholds
g1_sobel_tuned = edge(f1, 'Sobel', 0.05);
g1_log_tuned   = edge(f1, 'log', 0.003);
g1_canny_tuned = edge(f1, 'Canny', [0.05 0.15]);

figure;
montage({g1_sobel_tuned, g1_log_tuned, g1_canny_tuned});
title('circuits.tif Tuned: Sobel | LoG | Canny');

% brain_tumor.jpg - adjust thresholds
g2_sobel_tuned = edge(f2, 'Sobel', 0.02);
g2_log_tuned   = edge(f2, 'log', 0.001);
g2_canny_tuned = edge(f2, 'Canny', [0.03 0.1]);

figure;
montage({g2_sobel_tuned, g2_log_tuned, g2_canny_tuned});
title('brain_tumor.jpg Tuned: Sobel | LoG | Canny');