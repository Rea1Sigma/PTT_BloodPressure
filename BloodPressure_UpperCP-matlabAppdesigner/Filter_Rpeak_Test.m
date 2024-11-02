clc;
clear all;
close all;

% 加载ECG信号和脉搏波信号
ecg_signal = load('E:\医学电子仪器设计\Part_Year\Pressure_Delay\DataBase\ecg_1.mat'); % 假设ECG信号存储在MAT文件中
ppg_signal = load('E:\医学电子仪器设计\Part_Year\Pressure_Delay\DataBase\ppg_1.mat'); % 假设脉搏波信号存储在MAT文件中

% 如果数据是结构体，从中提取信号向量
ecg_signal = ecg_signal.ecg;
ppg_signal = ppg_signal.ppg;
% 估算的原始采样率
fs_original = 256; 

% 目标采样率
fs_target = 256;

% 重采样
ppg_resampled = resample(ppg_signal, fs_target, fs_original);
ecg_resampled = resample(ecg_signal, fs_target, fs_original);


% 设置采样频率（如果不确定，可尝试不同值，假设为1000 Hz）
fs = fs_target;


% 数据预处理：移除非有限值
ppg_resampled = ppg_resampled(isfinite(ppg_resampled));
ecg_resampled = ecg_resampled(isfinite(ecg_resampled));
            
 Fs = fs;
    % 2. 巴特沃斯滤波器设计
    %频带设置
    ws_d = 0.05; %阻带设置
    ws_s = 50;
    wp_d = 2; %通带设置
    wp_s = 30;
    Ws = [ws_d ws_s]*2/Fs;
    Wp = [wp_d wp_s]*2/Fs;
    Ap = 1; %通带衰减
    As = 5; %阻带衰减

    Nn = length(ecg_resampled); %采样点数

    [N,wn] = buttord(Wp,Ws,Ap,As);
    [b,a] = butter(N,wn,'bandpass');
    [mag, w] = freqz(b,a);
    % 3. 信号滤波
    ecg_filtered = filtfilt(b, a, ecg_resampled);

    Nn = length(ppg_resampled); %采样点数

    [N,wn] = buttord(Wp,Ws,Ap,As);
    [b,a] = butter(N,wn,'bandpass');
    [mag, w] = freqz(b,a);
    % 3. 信号滤波
    ppg_filtered = filtfilt(b, a, ppg_resampled);
    % figure(2)
    % plot(w*Fs/(2*pi)，20*log10(abs(mag)));
    % title('巴特沃兹带通滤波器幅频响应')
    % xlabel('f/Hz'); ylabel('幅值/dB')
    % axis([0 30 -20 2])

    figure;
    subplot(2, 1, 1);
    plot((1:length(ecg_filtered)) / fs, ecg_filtered);
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('ECG Signal');
    % 绘制脉搏波信号及其峰值
    subplot(2, 1, 2);
    plot((1:length(ppg_filtered)) / fs, ppg_filtered);
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('PPG Signal');

% 使用Pan-Tompkins算法检测ECG信号的R波
% [ecg_peaks, ecg_locs] = pan_tompkins_detector(ecg_filtered, fs);
[ecg_locs,ecg_peaks] = Find_Rpeaks_tompkins(ecg_filtered,fs);
% 使用findpeaks函数检测脉搏波信号的峰值
[ppg_peaks, ppg_locs] = findpeaks(ppg_filtered, 'MinPeakHeight', 1 * mean(ppg_filtered), 'MinPeakDistance', 0.2 * fs);

% 计算ECG信号的R波与脉搏波峰值之间的时间差
time_diff = (ppg_locs - ecg_locs(1:length(ppg_locs))) / fs;

% 绘制ECG信号及其R波
figure;
subplot(3, 1, 1);
plot((1:length(ecg_filtered)) / fs, ecg_filtered);
hold on;
plot(ecg_locs / fs, ecg_peaks, 'ro');
title('Filtered ECG Signal with R Peaks');
xlabel('Time (s)');
ylabel('Amplitude');
legend('ECG Signal', 'R Peaks');

% 绘制脉搏波信号及其峰值
subplot(3, 1, 2);
plot((1:length(ppg_filtered)) / fs, ppg_filtered);
hold on;
plot(ppg_locs / fs, ppg_peaks, 'ro');
title('Filtered PPG Signal with Peaks');
xlabel('Time (s)');
ylabel('Amplitude');
legend('PPG Signal', 'Peaks');

% 绘制ECG信号的R波与脉搏波峰值之间的时间差
subplot(3, 1, 3);
plot(ecg_locs(1:length(time_diff)) / fs, time_diff, 'b-o');
title('Time Difference between ECG R Peaks and PPG Peaks');
xlabel('Time (s)');
ylabel('Time Difference (s)');
legend('Time Difference');

% 打印峰的位置和时间差信息
disp('ECG R峰位置（样本点）：');
disp(ecg_locs);
disp('脉搏波峰位置（样本点）：');
disp(ppg_locs);
disp('时间差（秒）：');
disp(time_diff);