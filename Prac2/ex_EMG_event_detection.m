clear; close all; clc;

load EMG_data_example;

x = 1:1:length(data);
fs = 1000;
x = x/fs;

figure;
plot(x, data);

%% 필터링 50Hz 이하 성분만 가져옴
h = fir1(50, 50/(fs/2), 'low');
fdata = filtfilt(h, 1, data);

figure;
subplot(211); plot(x, data);
subplot(212); plot(x, fdata);
%% 데이터에서 0.08 이상인 구간을 찾아서 1로 마킹
result = zeros(1, length(fdata));
idx = find(fdata > 0.08);
result(idx) = 1;

figure;
subplot(211); plot(x, fdata); hold on; plot(x, 0.08*ones(1, length(fdata)));
subplot(212); bar(x, result);

%% 절대값 취해보기
adata = abs(fdata);

figure;
subplot(211); plot(x, fdata);
subplot(212); plot(x, adata);
%% 이동창평균 
mdata = smooth(adata, 0.5*fs, 'moving');
figure;
subplot(311); plot(x, fdata);
subplot(312); plot(x, adata);
subplot(313); plot(x, mdata);

%% 기준값 세워보기
threshold = 0.03*ones(1, length(mdata));
figure;
plot(x, mdata); hold on; plot(x, threshold);

%% 데이터에서 0.03 이상인 구간을 찾아서 1로 마킹
result2 = zeros(1, length(mdata));
idx = find(mdata > 0.03);
result2(idx) = 1;

figure;
subplot(311); plot(x, fdata);
subplot(312); plot(x, mdata);
subplot(313); bar(x, result2);

