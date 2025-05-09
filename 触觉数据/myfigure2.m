% 读取数据文件
data = readtable('backup_4.txt', 'Delimiter', '\t', 'HeaderLines', 0);
time = data{:, 1}; % 第一列为时间
sensor_data = data{:, 2:end}; % 其余列为传感器数据

% 确定传感器数量
num_sensors = size(sensor_data, 2);

% 设置窗口大小和波动阈值
window_size = 20; % 滑动窗口大小
std_threshold = 0.005; % 标准差阈值，用于判断波动大小

% 创建一个图形窗口，按照 4 行 2 列布局
figure('Name', 'Touch Sensor Data with High Fluctuations');
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

% 为每个传感器绘制子图，只显示波动较大的部分
for i = 1:num_sensors
    % 计算滑动窗口的标准差
    sensor_values = sensor_data(:, i);
    moving_std = zeros(length(sensor_values) - window_size + 1, 1);
    for j = 1:(length(sensor_values) - window_size + 1)
        moving_std(j) = std(sensor_values(j:j+window_size-1));
    end
    
    % 扩展标准差数组以匹配时间长度
    moving_std = [moving_std; repmat(moving_std(end), window_size-1, 1)];
    
    % 筛选波动较大的部分
    significant_indices = moving_std > std_threshold;
    significant_time = time(significant_indices);
    significant_data = sensor_values(significant_indices);
    
    % 绘制子图
    subplot(rows, cols, i);
    if ~isempty(significant_time)
        plot(significant_time, significant_data, 'b-', 'LineWidth', 1.5);
    else
        % 使用半透明颜色绘制淡化效果
        plot(time, sensor_values, 'Color', [0 0 1 0.3], 'LineWidth', 0.5); % 蓝色半透明
        text(0.5, 0.5, 'No Significant Fluctuations', 'HorizontalAlignment', 'center', ...
            'Units', 'normalized', 'Color', 'red');
    end
    
    % 添加标题和标签
    title(['Sensor ' num2str(i)]);
    xlabel('Time (s)');
    ylabel('Sensor Value');
    
    % 添加网格
    grid on;
end

% 调整子图间距
sgtitle('Touch Sensor Data with High Fluctuations');