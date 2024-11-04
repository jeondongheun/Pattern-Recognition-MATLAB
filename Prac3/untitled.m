clear; close all; clc;

fs = 250;
t = 1/fs:1/fs:10;
y = 3*sin(3*pi*5*t) + sin(2*pi*3*t) + 0.5*sin(2*pi*8*t);

figure;
plot(t,y);
[pxx, f] = periodogram(y, [], length(y), fs);

figure;
plot(f, pxx); xlim([0 15])

clear; close all; clc;

load ECG_data_1;

t = 1/Fs:1/Fs:length(data)/Fs;

% 시간 영영에서 그려보기
figure;
plot(t, data);

[pxx, f] = periodogram(data, [], length(data), Fs);

% 주파수 영역에서 그려보기
figure;
plot(f, pxx);

clear; close all; clc;
fs=250;
h = fir1(10, 50/(fs/2), 'low'); %fir1() ??
% 처음 오는 인자가 클수록 구형파에 가까움
% 성능은 좋아지지만 , 연산 시간이 커짐 

% 시간 영역에서 그려보기
figure; 
subplot(1, 2, 1); plot(h);
subplot(1, 2, 2); stem(h);

% 주파수 영역에서 그려보기
[out,f] = freqz(h, 1, 100, fs); %freqz () 인자??

figure;
plot(f, abs(out));

clear; close all; clc;

load resp_data_1;

x=1:1:length(data);
x=x/Fs;

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
