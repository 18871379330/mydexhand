% 读取数据文件
data = readtable('1save.txt', 'Delimiter', '\t', 'HeaderLines', 0);

% 提取第 1、2、5 列（时间、第 1 列传感器、第 4 列传感器）
filtered_data = data(:, [1, 4]);

% 保存到新文件
writetable(filtered_data, 'Strain.txt', 'Delimiter', '\t', 'WriteVariableNames', false);