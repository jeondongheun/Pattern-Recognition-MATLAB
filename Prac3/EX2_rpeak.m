clear; close all; clc;

load ECG_data_2; %example_ECG_data_2에 적용


[bh, ah] = butter(5, 1/(Fs/2), 'high');
[bl, al] = butter(5, 35/(Fs/2), 'low');

f_data = filtfilt(bh, ah, data);
f_data = filtfilt(bl, al, f_data);

x = 1/Fs:1/Fs:length(data)/Fs;

figure;
subplot(211); plot(x, data);  xlim([20 30]);
subplot(212);  plot(x, f_data);  xlim([20 30]);

% 미분
d_data = diff(f_data);
d_data = [d_data(1); d_data]; % 개수가 한 개 줄어들어 편의상 데이터 한 샘플을 추가 

% 절대값
abs_data = abs(d_data);

% 이동평균: 여러번 사용하는 것이 좋음
mwa_data = smooth(abs_data, 0.2*Fs, 'moving');
mwa_data = smooth(mwa_data, 0.2*Fs, 'moving');

% 처리된 신호에서 피크 찾기
[peak_value, peak_idx] = findpeaks(mwa_data);
peak_in_time = peak_idx/Fs;

figure; 
subplot(411); plot(x, f_data, 'LineWidth', 1);  xlim([20 30]); title('ECG');
subplot(412); plot(x, d_data, 'LineWidth', 1);  xlim([20 30]); title('diff');
subplot(413); plot(x, abs_data, 'LineWidth', 1); xlim([20 30]); title('abs');
subplot(414); plot(x, mwa_data, 'LineWidth', 1); hold on; plot(peak_in_time, peak_value, 'ro', 'LineWidth', 1); hold off; xlim([20 30]); title('mwa'); xlabel('Time (s)');


% 심전도 R피크 위치 찾기
R_PEAK_LOC = []; % r피크의 위치 (샘플관점)
R_PEAK_AMP = []; % r피크의 크기

st_win = floor(Fs/2);

for kk=2:1:length(peak_idx)-1
    tmp = f_data(peak_idx(kk)-st_win + 1 : peak_idx(kk));
    [m_v, m_i] = max(tmp);

    t_idx = peak_idx(kk) - st_win + m_i;

    R_PEAK_LOC = [R_PEAK_LOC t_idx];
    R_PEAK_AMP = [R_PEAK_AMP f_data(t_idx)];
end

R_PEAK_IN_SEC = R_PEAK_LOC/Fs;

figure;
plot(x, f_data); hold on;
plot(R_PEAK_IN_SEC, R_PEAK_AMP, 'ro'); hold off; xlabel('Time (s)');

% 심박 간격 계산
hearbeat_interval = diff(R_PEAK_LOC);
hearbeat_interval = hearbeat_interval/Fs;

figure;
subplot(211); plot(x, f_data); hold on; plot(R_PEAK_IN_SEC, R_PEAK_AMP, 'ro'); hold off;
subplot(212); plot(R_PEAK_IN_SEC(2:end), hearbeat_interval, 'ro--'); xlabel('Time (s)'); ylabel('hearbeat interval (s)');


%%윈도우 사이즈를 계속 바꿔가며 오류 최소화 윈도우 사이즈 외에 방법이 있을 수도 있음
load RESULT_ECG_2;

peak_ref_in_sec = ecg_peak_ref/Fs;

ref_rri = diff(ecg_peak_ref)/Fs;

figure;
plot(peak_ref_in_sec(2:end), ref_rri, 'ko--'); hold on;
plot(R_PEAK_IN_SEC(2:end), hearbeat_interval, 'ro--'); hold off;
%%빨간색과 검정색이 똑같이 나와야함 
figure;
plot(hearbeat_interval(:) - ref_rri(:));









