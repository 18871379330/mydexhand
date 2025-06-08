% MATLAB 程序：读取 PDF 文件名开头的浮点数（以_结束）并求和
clear all; clc;

% 设置文件夹路径（请修改为你的文件夹路径）
folderPath = 'D:\mygitfile\mydexhand\报销\毕设'; % 替换为实际文件夹路径

% 获取文件夹中所有 PDF 文件
pdfFiles = dir(fullfile(folderPath, '*.pdf'));

% 初始化求和变量
totalSum = 0;

% 遍历每个 PDF 文件
for i = 1:length(pdfFiles)
    % 获取文件名
    fileName = pdfFiles(i).name;
    
    % 提取文件名开头的浮点数（以_结束）
    % 使用正则表达式匹配开头的数字（支持小数点），直到遇到_
    numberMatch = regexp(fileName, '^\d+\.?\d*_', 'match');
    
    % 检查是否匹配到数字
    if ~isempty(numberMatch)
        % 去掉末尾的_并转换为数字
        numberStr = strrep(numberMatch{1}, '_', '');
        number = str2double(numberStr);
        
        % 检查转换是否成功
        if ~isnan(number)
            % 累加到总和
            totalSum = totalSum + number;
            fprintf('文件: %s, 提取的数字: %.2f\n', fileName, number);
        else
            fprintf('文件: %s, 数字转换失败\n', fileName);
        end
    else
        fprintf('文件: %s, 未找到符合条件的数字\n', fileName);
    end
end

% 输出总和
fprintf('所有文件开头数字的总和: %.2f\n', totalSum);

% 输出总和
fprintf('所有文件开头数字的总和: %d\n', totalSum);