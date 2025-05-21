% 三维连杆灵巧手指设计与仿真
% 功能：模拟电机驱动线传动欠驱动手指，实现3D弯曲和摇摆自由度
% 设计：两指节欠驱动弯曲 + 基座旋转摇摆（三维）

clear all;
close all;
clc;

% 参数定义
L1 = 30; % 近端指节长度 (mm)
L2 = 20; % 远端指节长度 (mm)
tendon_length_max = 8; % 线传动最大拉伸距离 (mm)
swing_angle_max = 20; % 最大摇摆角度 (度)

% 时间和步长
t = 0:0.05:2; % 仿真时间 2秒
n = length(t);
tendon_pull = linspace(0, tendon_length_max, n); % 线传动拉伸距离
swing_angle = swing_angle_max * sin(2 * pi * t); % 摇摆角度随时间正弦变化

% 初始化存储数组
x = zeros(3, n); % 节点x坐标 (基点、近端、远端)
y = zeros(3, n); % 节点y坐标
z = zeros(3, n); % 节点z坐标

% 运动学计算与三维可视化
figure('Name', '三维连杆灵巧手指运动仿真');
for i = 1:n
    % 计算欠驱动弯曲角度（在YZ平面内）
    total_angle = tendon_pull(i) * 10; % 线拉伸到角度的线性映射 (每mm约10度)
    theta1 = deg2rad(total_angle * 0.6); % 近端关节角度
    theta2 = deg2rad(total_angle * 0.4); % 远端关节角度
    
    % 节点坐标（初始在YZ平面，x=0）
    x(1, i) = 0; % 基点
    y(1, i) = 0;
    z(1, i) = 0;
    x(2, i) = 0; % 近端指节末端
    y(2, i) = L1 * cos(theta1);
    z(2, i) = L1 * sin(theta1);
    x(3, i) = 0; % 远端指节末端
    y(3, i) = y(2, i) + L2 * cos(theta1 + theta2);
    z(3, i) = z(2, i) + L2 * sin(theta1 + theta2);
    
    % 应用摇摆自由度（绕Z轴旋转，引入X方向位移）
    swing_rad = deg2rad(swing_angle(i));
    [x_rot, y_rot, z_rot] = rotate_around_z(x(:, i), y(:, i), z(:, i), swing_rad);
    
    % 绘制3D手指
    clf;
    plot3([x_rot(1) x_rot(2)], [y_rot(1) y_rot(2)], [z_rot(1) z_rot(2)], 'b-', 'LineWidth', 2); % 近端指节
    hold on;
    plot3([x_rot(2) x_rot(3)], [y_rot(2) y_rot(3)], [z_rot(2) z_rot(3)], 'r-', 'LineWidth', 2); % 远端指节
    plot3(x_rot, y_rot, z_rot, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k'); % 关节节点
    axis equal;
    axis([-30 30 0 60 -10 50]);
    xlabel('X (mm)');
    ylabel('Y (mm)');
    zlabel('Z (mm)');
    title('三维连杆灵巧手指运动仿真');
    grid on;
    view(45, 30); % 设置3D视角
    drawnow;
    pause(0.01);
end

% 绕Z轴旋转函数（摇摆自由度）
function [x_rot, y_rot, z_rot] = rotate_around_z(x, y, z, swing_rad)
    % 绕Z轴旋转，模拟三维摇摆
    R = [cos(swing_rad) -sin(swing_rad) 0; 
         sin(swing_rad) cos(swing_rad) 0; 
         0 0 1];
    coords = [x y z] * R';
    x_rot = coords(:, 1);
    y_rot = coords(:, 2);
    z_rot = coords(:, 3);
end