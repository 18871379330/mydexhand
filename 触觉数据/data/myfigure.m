% 读取数据文件
data = readtable('generated_data.txt', 'Delimiter', '\t', 'HeaderLines', 0);
time = data{:, 1}; % 第一列为时间
sensor_data = data{:, 2:end}; % 其余列为传感器数据

% 标准化时间（从 0 开始）
time = time - time(1);

% 确定传感器数量
num_sensors = size(sensor_data, 2);

% 创建一个图形窗口，按照 4 行 2 列布局（共 8 个传感器）
figure('Name', 'Touch Sensor Data');
rows = 4;
cols = 2;

% 获取屏幕分辨率
screen_size = get(0, 'ScreenSize');
screen_width = screen_size(3);
screen_height = screen_size(4);

% 设置窗口大小和位置（居中显示）
window_width = 1200;
window_height = 800;
x_pos = (screen_width - window_width) / 2;
y_pos = (screen_height - window_height) / 2;
set(gcf, 'Position', [x_pos, y_pos, window_width, window_height]);

% 为每个传感器绘制子图
for i = 1:num_sensors
    subplot(rows, cols, i); % 创建子图
    plot(time, sensor_data(:, i), 'b-');
    
    % 添加标题和标签
    title(['Sensor ' num2str(i)]);
    xlabel('Time (s)');
    ylabel('Sensor Value');
    
    % 添加网格
    grid on;
end

% 调整子图间距
sgtitle('Touch Sensor Data Over Time'); % 添加整体标题