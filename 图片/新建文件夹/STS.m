% MATLAB 技术图纸清晰度增强与水印去除
% 功能：增强舵机技术图纸的线条清晰度，并尝试移除背景水印

clear all;
close all;
clc;

% 读取图片（请将图片保存到本地并替换路径）
% 例如：img = imread('servo_drawing.jpg');
img = imread('STS.png'); % 替换为您的图片路径
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
img_sharpen = imsharpen(img_gray, 'Radius', 1.5, 'Amount', 2); % 锐化半径1.5，强度2
subplot(2, 2, 2);
imshow(img_sharpen);
title('锐化后');

% 步骤 2：对比度增强
img_enhanced = imadjust(img_sharpen, [0.2 0.8], []); % 调整对比度，压缩灰度范围
subplot(2, 2, 3);
imshow(img_enhanced);
title('对比度增强后');

% 步骤 3：水印去除（基于背景分离和滤波）
% 使用自适应阈值分割突出线条，减少水印影响
img_binary = imbinarize(img_enhanced, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.4);
% 应用中值滤波平滑水印纹理
img_cleaned = medfilt2(img_binary, [3 3]); % 3x3中值滤波
% 转换为灰度图以保留部分细节
img_cleaned_gray = im2uint8(img_cleaned) .* uint8(img_enhanced > 0);
subplot(2, 2, 4);
imshow(img_cleaned_gray);
title('水印去除后');

% 保存结果
imwrite(img_cleaned_gray, 'enhanced_servo_drawing_cleaned.jpg');
disp('增强并去除水印后的图片已保存为 enhanced_servo_drawing_cleaned.jpg');