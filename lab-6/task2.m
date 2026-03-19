clear all; close all;

%% ===== Template 1 =====
f = imread('assets/salvador_grayscale.tif');
w = imread('assets/template1.tif');

% Step 1: Compute NCC
c = normxcorr2(w, f);

% Step 2: 3D surface plot of NCC
figure(1);
surf(c);
shading interp;
title('NCC Surface Plot - Template 1');
xlabel('X'); ylabel('Y'); zlabel('NCC value');
colormap hot;
colorbar;

% Step 3: Find peak location automatically
[ypeak, xpeak] = find(c == max(c(:)));
yoffSet = ypeak - size(w, 1);
xoffSet = xpeak - size(w, 2);

fprintf('Template 1 found at: x=%d, y=%d\n', xoffSet, yoffSet);
fprintf('Peak NCC value: %.4f\n', max(c(:)));

% Step 4: Draw rectangle on image at match location
figure(2);
imshow(f);
title('Template 1 Match Location');
drawrectangle(gca, 'Position', ...
    [xoffSet, yoffSet, size(w,2), size(w,1)], 'FaceAlpha', 0);

%% ===== Template 2 =====
w2 = imread('assets/template2.tif');

% Step 1: Compute NCC
c2 = normxcorr2(w2, f);

% Step 2: 3D surface plot of NCC
figure(3);
surf(c2);
shading interp;
title('NCC Surface Plot - Template 2');
xlabel('X'); ylabel('Y'); zlabel('NCC value');
colormap hot;
colorbar;

% Step 3: Find peak location
[ypeak2, xpeak2] = find(c2 == max(c2(:)));
yoffSet2 = ypeak2 - size(w2, 1);
xoffSet2 = xpeak2 - size(w2, 2);

fprintf('Template 2 found at: x=%d, y=%d\n', xoffSet2, yoffSet2);
fprintf('Peak NCC value: %.4f\n', max(c2(:)));

% Step 4: Draw rectangle on image
figure(4);
imshow(f);
title('Template 2 Match Location');
drawrectangle(gca, 'Position', ...
    [xoffSet2, yoffSet2, size(w2,2), size(w2,1)], 'FaceAlpha', 0);