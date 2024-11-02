function [R_pos,R_peak] = Find_Rpeaks_tompkins(ecg_filtered,fs)
    Fs = fs;
    % 4. 信号差分
    signal_diff = diff(ecg_filtered);
    figure(4)
    plot( signal_diff );
    xlabel('t(s)')
    ylabel('A(mV)')
    title('差分后心电信号')
    % 5. 差分信号平方
    signal_sqred = zeros(length(ecg_filtered),1);
    signal_sqred(1:length(ecg_filtered)-1) = signal_diff.^2;
    % figure(5)
    plot(signal_sqred);
    xlabel('t(s)')
    ylabel('A(mV)')
    title('平方后心电信号')
    % 6. 差分信号平滑
    signal_sqred_int = zeros(length(ecg_filtered),1);
    for i = 30:length(signal_sqred) %平滑窗宽 55
        section_avg = sum(signal_sqred(i-29:i))/30;
        signal_sqred_int(i) = section_avg;
    end
    figure;
    plot(signal_sqred_int);
    xlabel('t(s)')
    ylabel('A(mV)')
    title('平滑后心电信号')

    % 7. 设定检出阈值
    lvl_sig_F = max(ecg_filtered(1:2*Fs))*0.75; %滤波信号的信号水平
    lvl_noise_F = mean(ecg_filtered(1:2*Fs)); %滤波信号的噪声水平
    lvl_sig_I = max(signal_sqred_int(1:2*Fs))*0.75;
    lvl_noise_I = mean(signal_sqred_int(1:2*Fs));
    % 滤波信号的初始阈值
    Thr_F = lvl_noise_F + 0.25*(lvl_sig_F-lvl_noise_F);
    % 移动积分后差分信号的初始阈值
    Thr_I = lvl_noise_I + 0.25*(lvl_sig_I-lvl_noise_I);
    % 8. 检出 R 波位置
    % 8. 1 方法 1：在移动移动积分后差分信号中寻找峰值，定位 QRS 位置
    p = 1;
    Peak_pos = [];
    Peak_mag = [];
    lastPeak = 0;
    % R 波位置信息
    r = 1;
    R_pos = []; %R 波位置
    R_peak = []; %R 波幅值
    lastR = 0; %上一处 R 波位置
    m_SMALL = 0;
    for m = 2:length(signal_sqred_int)-1
        %检测积分信号所有峰值位置
        if signal_sqred_int(m-1)<signal_sqred_int(m) && signal_sqred_int(m+1)<signal_sqred_int(m)
            % if 积分信号幅值>阈值 && 两次峰值间隔>0. 2s
            % 此时可以认为是一处峰值，表示有一处可能的 QRS 波
            if signal_sqred_int(m)>Thr_I && m-lastPeak>0.2*Fs
                if m_SMALL ~= 0
                    m_SMALL = m - 1;
                end
                %记录峰值位置
                Peak_pos(p) = m;
                Peak_mag(p) = signal_sqred_int(m);
                p = p+1;
                %更新信号水平
                lvl_sig_I = 0.125*signal_sqred_int(m) + 0.875*lvl_sig_I;
                %更新积分信号阈值
                Thr_I = lvl_noise_I + 0.25*(lvl_sig_I-lvl_noise_I);
                %记录该峰值位置，与下次位置比较
                lastPeak = m;
                %%==检测可能的 QRS 波范围内的 R 波==%%
                %在 m 表示的 QRS 波范围内寻找 R 峰位置
                for k=m-50:m+20
                    %检测所有峰值位置
                    if (ecg_filtered(k-1) < ecg_filtered(k)) && (ecg_filtered(k+1) < ecg_filtered(k))
                        % 信号幅值>阈值 && 两次峰值间隔>0. 2s
                        % 此时可以认为是 R 波
                        if ecg_filtered(k)>Thr_F && k-lastR>0.15*Fs
                            %记录 R 波位置
                            R_pos(r) = k;
                            R_peak(r) = ecg_filtered(k);
                            r = r+1;
                            %更新信号水平
                            lvl_sig_F = 0.125*ecg_filtered(k) + 0.875*lvl_sig_F;
                            %更新阈值
                            Thr_F = lvl_noise_F + 0.25*(lvl_sig_F-lvl_noise_F);
                            %记录该 R 波位置
                            lastR = k;
                            break
                        else
                            %认为该峰值是噪声
                            %更新噪声水平
                            lvl_noise_F = 0.125*ecg_filtered(k) + 0.875*lvl_noise_F;
                            %更新阈值
                        Thr_F = lvl_noise_F + 0.25*(lvl_sig_F-lvl_noise_F);
                        end
                    end
                end
                %%==============================%%
            else
                %认为该峰值是积分信号噪声
                %更新积分信号噪声水平
                lvl_noise_I = 0.125*signal_sqred_int(m) + 0.875*lvl_noise_I;
                %更新积分信号阈值
                Thr_I = lvl_noise_I + 0.25*(lvl_sig_I-lvl_noise_I);
            end
        end
    end



    % 显示标注结果
    figure(7)
    plot(signal_sqred_int);
    hold on; grid on
    plot(Peak_pos,Peak_mag,'ro', 'MarkerSize', 4);
    xlabel('Time (sec)'); ylabel('mV');
    legend('V1','QRS 波位置');
    figure(8)
    plot(ecg_filtered);
    hold on; grid on
    plot(R_pos,R_peak,'ro', 'MarkerSize', 4);
    xlabel('Time (sec)'); ylabel('mV');
    legend('V1','R 波标定');


end