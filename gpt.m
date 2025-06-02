% Diabetic Retinopathy Detection in MATLAB
clc; clear; close all;

% Step 1: Load the Retinal Image
[filename, pathname] = uigetfile({'*.jpg;*.png;*.tif', 'Image Files'});
if isequal(filename, 0)
    disp('No file selected. Exiting.');
    return;
end
imagePath = fullfile(pathname, filename);
retinaImg = imread(imagePath);
imshow(retinaImg);
title('Original Retinal Image');

% Step 2: Convert to Grayscale
if size(retinaImg, 3) == 3
    grayImg = rgb2gray(retinaImg);
else
    grayImg = retinaImg;
end
figure; imshow(grayImg);
title('Grayscale Image');

% Step 3: Enhance Contrast
contrastEnhancedImg = adapthisteq(grayImg);
figure; imshow(contrastEnhancedImg);
title('Contrast Enhanced Image');

% Step 4: Extract Blood Vessels Using Morphology
% Apply a morphological opening operation to extract vessels
se = strel('disk', 12); % Structural element for morphology
background = imopen(contrastEnhancedImg, se);
vessels = contrastEnhancedImg - background;
vessels = imadjust(vessels);

figure; imshow(vessels);
title('Extracted Blood Vessels');

% Step 5: Binary Thresholding
binaryVessels = imbinarize(vessels, 'adaptive', 'Sensitivity', 0.4);
figure; imshow(binaryVessels);
title('Binary Blood Vessel Map');

% Step 6: Optional - Detect Lesions or Bright Spots (Hard Exudates)
% Bright spots detection (optional for initial analysis)
brightSpots = imbinarize(contrastEnhancedImg, 'adaptive', 'Sensitivity', 0.7);
figure; imshow(brightSpots);
title('Bright Spots (Possible Lesions)');

% Final Step: Combine Information for Detection (Basic Visualization)
combinedImg = imoverlay(grayImg, binaryVessels, [1 0 0]); % Red for vessels
combinedImg = imoverlay(combinedImg, brightSpots, [0 1 0]); % Green for bright spots
figure; imshow(combinedImg);
title('Diabetic Retinopathy Detection (Overlay)');
