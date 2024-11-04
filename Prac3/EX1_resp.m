clear; close all; clc;

load resp_data_1;

% 그림 그리기
x = 1:1:length(data);
x = x/Fs;

figure;
plot(x, data, 'LineWidth', 1);

% 호흡신호 주파수 변환
[pxx, f] = periodogram(data, [], length(data), Fs);

% 주파수 영역에서 그려보기
figure;
plot(f, pxx);

% 필터를 만드는 또다른 함수 (0.1 ~ 1Hz)
[bh, ah] = butter(5, 0.1/(Fs/2), 'high');
f_data = filtfilt(bh, ah, data);

[bl, al] = butter(5, 1/(Fs/2), 'low');
f_data = filtfilt(bl, al, f_data);

figure;
plot(x, f_data, 'LineWidth', 1);

% 시간영역에서 분당 심박수 계산
[peak_value, peak_idx] = findpeaks(f_data);
% 피그 찾는 코드
peak_time = peak_idx/Fs;

figure;
plot(x, f_data, 'LineWidth', 1); hold on; 
%hold on을 안하면 앞에 내용 지우고 그림

plot(peak_time, peak_value, 'ro', 'LineWidth', 1);

resp_interval = diff(peak_time); %diff() 뒤에서 앞 빼주는 함수
mr_intv = mean(resp_interval);
t_breathing_per_min = 60 / mr_intv

% 주파수 영역에서
[pxx, f] = periodogram(f_data, [], length(f_data), Fs);

figure;
plot(f, pxx, 'LineWidth', 1); xlim([0 1])

[max_value, max_idx] = max(pxx); %max 값 출력 함수 

resp_freq = f(max_idx);
resp_intv = 1/resp_freq;
f_breathing_per_min = 60 / resp_intv

%%
clear; close all; clc;

load resp_data_2;

x = 1:1:length(data);
x = x/Fs;

figure;
plot(x, data, 'LineWidth', 1);

[bh, ah] = butter(5, 0.1/(Fs/2), 'high');
[bl, al] = butter(5, 1/(Fs/2), 'low');

f_data = filtfilt(bh, ah, data);
f_data = filtfilt(bl, al, f_data);

figure;
plot(x, f_data, 'LineWidth', 1);

% 20초 윈도우, 1초에 1번씩 출력하기
% 전체 데이터 길이: 22500/250 = 90초
% 20초, 21초, 22초, ..., 90초 때 호흡수가 출력되어야 함 for loop를 몇번 돌아야 하는가?
% 전체 데이터가 25초라고 가정하면, 20, 21, 22, 23, 24, 25초 때 총 6번 호흡수 출력
% 즉, 전체 데이터 길이 (초) - 윈도우 길이 (초) + 1로 결정 

data_len_in_sec = length(f_data)/Fs;
window_len_in_sec = 20;
loop_len = data_len_in_sec - window_len_in_sec + 1;

breathing_per_min = zeros(1, loop_len);

for kk=1:1:loop_len
    % 20초 데이터를 1초씩 이동시키며 가져오기
    % 0~20초, 1~21, 2~22, ..., 71~90초 데이터를 가져와야함
    % 샘플 관점에서는 1 (0*Fs+1)~ 5000 (20*Fs), 251 (1*Fs+1) ~ 5250(21*Fs), ... 가 됨 
    st_idx = (kk-1)*Fs+1;
    end_idx = (kk+19)*Fs;

    tmp = f_data(st_idx:end_idx);

    [pxx, f] = periodogram(tmp, [], length(tmp), Fs);
    
    [max_value, max_idx] = max(pxx);
    
    resp_freq = f(max_idx);
    resp_intv = 1/resp_freq;
    f_breathing_per_min(kk) = 60 / resp_intv;
end

t = 20:1:90;
figure;
plot(t, f_breathing_per_min, 'LineWidth', 1);


