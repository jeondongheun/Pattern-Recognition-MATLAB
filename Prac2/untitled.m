clear; close all; clc;

load EMG_data_example.mat;

x=1:1:length(data);
fs = 1000;
x=x/fs;

figure;
plot(x,data);

%% 필링 50hz 이하 성분만 가져옴
%% fir1(a,b,c) a: 필터 계수의 개수, b: 내가 자르고 싶은 주파수 대역 , c:필터의 특성
h=fir1(50,50/(fs/2), 'low');
fdata = filtfilt(h,1,data);

figure;
subplot(211); plot(x, data);
subplot(212); plot(x, fdata);

result = zeros(1, length(fdata));
idx = find(fdata > 0.08);
result(idx) = 1;

figure;
subplot(211); plot(x, fdata); hold on; plot(x, 0.08*ones(1, length(fdata)));
subplot(212); bar(x, result);

%%절대값 취하기
adata = abs(fdata);

figure;
subplot(211); plot(x, fdata);
subplot(212); plot(x, adata);

%%이동창 평균 (smooth함수로 moving average 사용)
mdata = smooth(adata,0.5*fs,'moving');
%%0.5 * fs 샘플링주파수 500hz로 하라는 뜻 500 써도 똑같지만 코드 재사용성을 위해서
figure;
subplot(311); plot(x, fdata);
subplot(312); plot(x, mdata);
subplot(313); plot(x, adata);

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