# PTT_BloodPressure
This project is a comprehensive hardware and software development endeavor, primarily aimed at using a non-cuff method for continuous real-time monitoring of ECG and PPG signals. The program for the hardware acquisition front-end was compiled using STM32CubeMX and the HAL library. Signals are initially collected and integrated by the hardware front-end, then wirelessly transmitted via Bluetooth to a host computer, which ultimately displays physiological information such as ECG, PPG, heart rate, blood oxygen level, systolic, and diastolic pressures.

On the hardware front, the STM32F103C8T6 is used as the main control chip, with a 3.7V lithium battery as the primary power supply. The ECG signal is acquired using the AD8232 cardiac amplifier front-end, adopting a three-lead method (attached to the left hand, right hand, and right leg), with the signal being sampled through the ADC of the STM32. For the PPG signal, a MAX30102 digital sensor is employed, which uses a time-division dual-wavelength method for acquisition and transmits the signal to the main control chip via a high-speed I2C bus. Upon receiving the PPG and ECG signals, the main controller performs synchronous sampling and transmits the signals to the host computer via the HC-05 Bluetooth module.

The “BloodPressure_PCB-ProgramDownload.zip” archive contains the programming files for the main control chip. Due to the large number of files, they have been uploaded in a compressed package. The “BloodPressure_UpperCP-matlabAppdesigner” folder contains the host computer program, which is developed in the Matlab 2021a AppDesigner & Windows 10 environment.

The compressed file “BloodPressure_PCB-ProgramDownload.zip” contains the programming files for the main control chip. Due to the large number of files, they have been uploaded in a compressed package. The folder “BloodPressure_UpperCP-matlabAppdesigner” contains the host computer program, which is developed in the Matlab 2021a AppDesigner & Windows 10 environment.
--
The detailed information for the hardware PCB has been open-sourced on the JLCPCB platform. The open-source link is as follows:
https://oshwhub.com/dingzhen_zhenzhu/ji-yu-stm32f103c8t6-yi-ji-ecg-yu-ppg-lian-he-ce-liang-xue-ya-she-ji-_20240916

For a demonstration of the finished product and specific operation videos, please refer to the following link:
https://www.bilibili.com/video/BV1GKxHezEDL/?spm_id_from=333.999.0.0

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
该项目是一个完整的硬件和软件开发项目，其主要功能在于使用非气压式血压测量方法来连续实时监测ECG和PPG信号。硬件采集前端的程序编译借助了STM32CUBEMX以及HAL库。信号先由硬件前端采集并整合，再通过无线蓝牙传输到上位机，最终由上位机显示包括ECG、PPG、心率、血氧、高压和低压等生理信息。

在硬件前端，使用STM32F103C8T6作为主控芯片，主供电电源为3.7V锂电池。ECG信号的采集通过AD8232心电放大器前端，采用三导联法（连接于左手、右手和右腿），并利用STM32的ADC进行信号采样。对于PPG信号，则使用MAX30102数字传感器，通过时分双波长方法进行采集，并通过高速I2C总线将信号传递给主控芯片。主控在接收到PPG和ECG信号后，进行同步采样，并通过无线蓝牙模块HC-05将信号发送至上位机。

上位机是基于Matlab的App Designer设计的。在接收到来自硬件前端的信号后，上位机能够实时显示ECG和PPG信号。在对这两种信号进行数字滤波后，利用算法计算心率、血氧、高压和低压值，最终显示上述生理信息。

其中“BloodPressure_PCB-ProgramDownload.zip”压缩文件内为主控芯片的烧录程序，由于文件过多因此通过压缩包上传；“BloodPressure_UpperCP-matlabAppdesigner”文件夹内的是上位机程序，上位机的编译环境是matlab2021a AppDesigner & Windows 10
--
硬件PCB的具体信息已在嘉立创平台开源，开源链接如下：

https://oshwhub.com/dingzhen_zhenzhu/ji-yu-stm32f103c8t6-yi-ji-ecg-yu-ppg-lian-he-ce-liang-xue-ya-she-ji-_20240916

成品展示以及实物操作的具体视频，链接如下：

https://www.bilibili.com/video/BV1GKxHezEDL/?spm_id_from=333.999.0.0

