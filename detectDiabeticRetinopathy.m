% File: detectDiabeticRetinopathy.m
function severityGrade = detectDiabeticRetinopathy(imagePath)
    % Load the image
    retinaImg = imread(imagePath);

    % Convert to grayscale
    grayImg = rgb2gray(retinaImg);

    % Enhance contrast
    contrastEnhancedImg = adapthisteq(grayImg);

    % Extract blood vessels
    se = strel('disk', 12); % Structural element
    background = imopen(contrastEnhancedImg, se);
    vessels = contrastEnhancedImg - background;

    % Binary threshold for vessels
    vesselsBinary = imbinarize(vessels, 'adaptive', 'Sensitivity', 0.4);

    % Detect bright lesions
    brightLesions = imbinarize(contrastEnhancedImg, 'adaptive', 'Sensitivity', 0.7);

    % Compute features
    vesselArea = sum(vesselsBinary(:));
    lesionArea = sum(brightLesions(:));

    % Grading
    if lesionArea > 5000 || vesselArea > 10000
        severityGrade = 'Severe';
    elseif lesionArea > 2000 || vesselArea > 5000
        severityGrade = 'Moderate';
    elseif lesionArea > 500 || vesselArea > 2000
        severityGrade = 'Mild';
    else
        severityGrade = 'No Diabetic Retinopathy';
    end
end
