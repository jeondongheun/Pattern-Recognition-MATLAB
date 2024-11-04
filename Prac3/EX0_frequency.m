%% 주파수변환 실습 해보기 #1
clear; close all; clc;

fs = 250;
t = 1/fs:1/fs:10;
y = 3*sin(2*pi*2*t) + sin(2*pi*3*t) + 0.5*sin(2*pi*7*t);

% 시간 영영에서 그려보기
figure;
plot(t, y);

% 주파수 변환
[pxx, f] = periodogram(y, [], length(y), fs);

% 주파수 영역에서 그려보기
figure;
plot(f, pxx); xlim([0 15])

%% 주파수변환 실습 해보기 #2
clear; close all; clc;

load ECG_data_1;

t = 1/Fs:1/Fs:length(data)/Fs;

% 시간 영영에서 그려보기
figure;
plot(t, data);

% 주파수 변환
[pxx, f] = periodogram(data, [], length(data), Fs);

% 주파수 영역에서 그려보기
figure;
plot(f, pxx); 

%% 시간영역 주파수 영역에서 필터이해해보기
clear; close all; clc;

% 지난 시간에 만들어 봤던 필터 (50Hz 이하만 통과시키는 필터)
fs = 250;

h = fir1(50, 50/(fs/2), 'low');

% 시간 영역에서 그려보기
figure; 
subplot(1, 2, 1); plot(h);
subplot(1, 2, 2); stem(h);

% 주파수 영역에서 그려보기
[out,f] = freqz(h, 1, 100, fs);

figure;
plot(f, abs(out));

