% Script: robotic_hand_segmentation.m
% Purpose: Segment the robotic hand from the background and set the background to black

% Read the image
img = imread('zhaohaoran.png');

% Convert to grayscale
gray_img = rgb2gray(img);

% Enhance contrast
gray_img = imadjust(gray_img);

% Apply Gaussian smoothing to reduce noise
gray_img = imgaussfilt(gray_img, 1.5);

% Use region growing to create an initial mask
% Seed point: Manually select a point inside the hand (adjust based on your image)
seed_row = 300; % Adjust this value (e.g., row coordinate of hand center)
seed_col = 300; % Adjust this value (e.g., column coordinate of hand center)
initial_mask = false(size(gray_img));
initial_mask(seed_row, seed_col) = true;

% Region growing function
mask = regiongrowing(gray_img, initial_mask, 0.2); % Threshold set to 0.2

% Refine the mask using active contours
iterations = 100; % Number of iterations for active contours
mask = activecontour(gray_img, mask, iterations, 'Chan-Vese');

% Fill holes in the mask
mask = imfill(mask, 'holes');

% Remove small noise
mask = bwareaopen(mask, 500);

% Dilate to capture thin wires
se = strel('disk', 3);
mask = imdilate(mask, se);

% Smooth the mask
mask = imopen(mask, strel('disk', 2));

% Create a new image with a black background
output_img = zeros(size(img), 'like', img);

% Copy the hand region from the original image to the output
for channel = 1:3
    output_img(:, :, channel) = img(:, :, channel) .* uint8(mask);
end

% Display the result
figure;
subplot(1, 2, 1); imshow(img); title('Original Image');
subplot(1, 2, 2); imshow(output_img); title('Black Background Image');

% Save the result
imwrite(output_img, 'zhaohaoran。jpg');

% Helper function for region growing
function mask = regiongrowing(img, initial_mask, threshold)
    % Initialize the output mask
    mask = initial_mask;
    [rows, cols] = size(img);
    
    % Stack for region growing
    stack = find(initial_mask);
    
    % Normalize image to [0, 1]
    img = double(img) / 255;
    
    while ~isempty(stack)
        % Pop a pixel from the stack
        pixel = stack(1);
        stack(1) = [];
        
        % Get row and column
        [r, c] = ind2sub([rows, cols], pixel);
        
        % Check 8-connected neighbors
        for dr = -1:1
            for dc = -1:1
                nr = r + dr;
                nc = c + dc;
                
                % Skip if out of bounds or already processed
                if nr < 1 || nr > rows || nc < 1 || nc > cols || mask(nr, nc)
                    continue;
                end
                
                % Check intensity difference
                if abs(img(nr, nc) - img(r, c)) <= threshold
                    mask(nr, nc) = true;
                    stack(end+1) = sub2ind([rows, cols], nr, nc);
                end
            end
        end
    end
end