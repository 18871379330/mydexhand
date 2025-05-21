% MATLAB 技术图纸清晰度增强
% 功能：增强舵机技术图纸的线条锐利度和对比度

clear all;
close all;
clc;

% 读取图片（请将图片保存到本地并替换路径）
% 例如：img = imread('servo_drawing.jpg');
% 这里使用占位符，需替换为实际路径
img = imread('ES3352.png'); % 替换为您的图片路径
if size(img, 3) == 3
    img_gray = rgb2gray(img); % 转换为灰度图
else
    img_gray = img; % 已经是灰度图
end

% 显示原始图片
figure;
subplot(2, 2, 1);
imshow(img);
title('原始技术图纸');

% 步骤 1：锐化处理（增强线条边缘）
img_sharpen = imsharpen(img_gray, 'Radius', 2, 'Amount', 3); % 锐化半径1.5，强度2
subplot(2, 2, 2);
imshow(img_sharpen);
title('锐化后');

% 步骤 2：对比度增强
img_enhanced = imadjust(img_sharpen, [0.2 0.8], []); % 调整对比度，压缩灰度范围
subplot(2, 2, 3);
imshow(img_enhanced);
title('对比度增强后');

% 步骤 3：二值化（可选，突出线条）
img_binary = imbinarize(img_enhanced, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.5);
subplot(2, 2, 4);
imshow(img_binary);
title('二值化后（可选）');

% 保存结果
imwrite(img_enhanced, 'enhanced_servo_drawing.jpg');
disp('增强后的图片已保存为 enhanced_servo_drawing.jpg');