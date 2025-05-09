% 读取数据文件
data = readtable('backup_20.txt', 'Delimiter', '\t', 'HeaderLines', 0);
time = data{:, 1}; % 第一列为时间
sensor_data = data{:, 2:end}; % 其余列为传感器数据

% 设置时间段（用户可以根据需要修改）
start_time = 175; % 开始时间
end_time = 177;   % 结束时间

% 提取指定时间段的数据
time_indices = (time >= start_time & time <= end_time);
filtered_time = time(time_indices);
filtered_data = sensor_data(time_indices, :);

% 标准化时间（从 0 开始）
filtered_time = filtered_time - filtered_time(1);

% 确定传感器数量
num_sensors = size(filtered_data, 2);

% 创建一个图形窗口，按照 4 行 2 列布局
figure('Name', 'Touch Sensor Data');
rows = 4;
cols = 2;

% 获取屏幕分辨率并居中显示
screen_size = get(0, 'ScreenSize');
screen_width = screen_size(3);
screen_height = screen_size(4);
window_width = 1200;
window_height = 800;
x_pos = (screen_width - window_width) / 2;
y_pos = (screen_height - window_height) / 2;
set(gcf, 'Position', [x_pos, y_pos, window_width, window_height]);

% 为每个传感器绘制子图
for i = 1:num_sensors
    subplot(rows, cols, i);
    plot(filtered_time, filtered_data(:, i), 'b-');
    
    % 添加标题和标签
    title(['Sensor ' num2str(i)]);
    xlabel('Time (s)');
    ylabel('Sensor Value');
    
    % 添加网格
    grid on;
end

% 调整子图间距
sgtitle(['Touch Sensor Data (', num2str(start_time), ' to ', num2str(end_time), ' s)']);