% Pan-Tompkins算法检测ECG信号R波的函数
function [peaks, locs] = pan_tompkins_detector(ecg_signal, fs)
    % Pan-Tompkins算法步骤

    % 1. 带通滤波
%     [b, a] = butter(2, [5 15]/(fs/2), 'bandpass');
%     ecg_bandpassed = filtfilt(b, a, ecg_signal);
    ecg_bandpassed = ecg_signal;
    figure;
    plot(ecg_bandpassed);
    % 2. 导数滤波器
    diff_ecg = diff(ecg_bandpassed);

    % 3. 平方
    squared_ecg = diff_ecg .^ 2;

    % 4. 移动积分
    window_size = round(0.150 * fs); % 150 ms的窗口大小
    integrated_ecg = movmean(squared_ecg, window_size);
    figure;
    plot(integrated_ecg);
    % 5. 使用findpeaks函数检测R波峰值
    [peaks, locs] = findpeaks(integrated_ecg, 'MinPeakHeight', 0.6 * max(integrated_ecg), 'MinPeakDistance', 0.6 * fs);

    % 调整R波峰值位置
    locs = locs + round(window_size / 2); % 补偿移动积分的延迟
end