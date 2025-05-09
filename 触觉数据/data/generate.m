% 读取原始数据
data = readtable('PVDF.txt', 'Delimiter', '\t', 'HeaderLines', 0);
time = data{:, 1}; % 第一列为时间
sensor_data = data{:, 2:end}; % 其余列为传感器数据

% 获取时间步长和数据长度
time_step = time(2) - time(1); % 时间间隔
num_samples = length(time); % 数据点数量

% 计算每列传感器数据的统计特性
means = mean(sensor_data); % 均值
stds = std(sensor_data);   % 标准差

% 生成新的时间列
new_time = (time(1):time_step:time(1)+(num_samples-1)*time_step)';

% 生成随机传感器数据
num_sensors = size(sensor_data, 2);
new_sensor_data = zeros(num_samples, num_sensors);
for i = 1:num_sensors
    % 使用正态分布生成随机数据，基于原始数据的均值和标准差
    new_sensor_data(:, i) = means(i) + stds(i) * randn(num_samples, 1);
end

% 合并时间和传感器数据
new_data = [new_time, new_sensor_data];

% 保存到新文件
writematrix(new_data, 'generated_data.txt', 'Delimiter', '\t');

% 绘制原始数据和生成数据的对比图
figure('Name', 'Original vs Generated Sensor Data');
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
    % 绘制原始数据
    plot(time, sensor_data(:, i), 'b-', 'DisplayName', 'Original');
    hold on;
    % 绘制生成数据
    plot(new_time, new_sensor_data(:, i), 'r--', 'DisplayName', 'Generated');
    hold off;
    
    % 添加标题和标签
    title(['Sensor ' num2str(i)]);
    xlabel('Time (s)');
    ylabel('Sensor Value');
    
    % 添加网格和图例
    grid on;
    legend('Location', 'best');
end

% 调整子图间距
sgtitle('Original vs Generated Sensor Data');