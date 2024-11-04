%%근전도 특징 추출 
%%근전도 신호에서 힘을 준 구간을 1, 아닌 구간을 0으로 표시
%%샘플링 주파수는 1000hz

clear; close all; clc;

load EMG_data_example;

%x축 시간으로 변경
x = 1:1:length(data);
fs = 1000;
x = x/fs;

figure;
plot(x, data);

%% 필터링 50Hz 이하 성분만 가져옴
h = fir1(50, 50/(fs/2), 'low'); %%필터에 대한 정의
fdata = filtfilt(h, 1, data);
%50: 필터의 차수입니다. 차수가 높을수록 필터의 성능이 개선되지만 계산량도 늘어납니다.
%50/(fs/2): 필터의 컷오프 주파수를 지정합니다. 이 값은 Nyquist 주파수에 대한 비율로, fs는 샘플링 주파수입니다. 따라서 50/(fs/2)는 필터가 통과할 주파수 범위를 정의합니다.
%'low': 이 옵션은 저역 통과 필터를 의미합니다. 즉, 지정된 컷오프 주파수 이하의 신호는 통과시키고, 그 이상은 감쇠시킵니다.
%filtfilt(h, 1, data): 이 함수는 데이터를 필터링합니다. 여기서는 h로 정의된 FIR 필터를 사용하여 data 신호를 처리합니다.
%h: 필터 계수입니다.
%1: 필터의 분모 계수입니다. FIR 필터의 경우 일반적으로 1로 설정합니다.
%data: 필터링할 신호입니다.
%filtfilt 함수는 신호를 필터링할 때 위상 지연을 제거하기 위해 데이터를 양쪽 방향으로 필터링합니다. 
%이로 인해 원래 신호의 위상이 유지되고 왜곡이 최소화됩니다.
figure;
subplot(211); plot(x, data); %필터링 전
subplot(212); plot(x, fdata); %필터링 후

%% 데이터에서 0.08 이상인 구간을 찾아서 1로 마킹
result = zeros(1, length(fdata)); %데이터 길이는 fdata와 같지만 모든 요소 0으로 초기화
idx = find(fdata > 0.08);
%find(fdata > 0.08): fdata의 값이 0.08보다 큰 인덱스를 찾아 idx에 저장합니다.
result(idx) = 1;
%앞서 찾은 인덱스 idx에 해당하는 result의 요소를 1로 설정합니다.
%즉, fdata의 값이 0.08을 초과하는 위치에 해당하는 result의 요소는 1로 바뀌게 됩니다.나머지 요소는 여전히 0입니다.
figure;
subplot(211); plot(x, fdata); hold on; plot(x, 0.08*ones(1, length(fdata)));
%subplot(211);: 2행 1열의 서브플롯을 만들고 첫 번째 위치를 선택합니다.
%hold on;: 현재 그래프에 추가적으로 데이터를 그릴 수 있도록 설정합니다.
%plot(x, 0.08*ones(1, length(fdata)));: 기준값 0.08을 나타내는 수평선을 fdata의 그래프에 추가합니다.
%이렇게 하면 기준값과 fdata의 비교가 가능합니다.
subplot(212); bar(x, result);
%subplot(212);: 2행 1열의 서브플롯에서 두 번째 위치를 선택합니다. 

%% 절대값 취해보기
adata = abs(fdata);
%잡음 영향 줄이기 위한 전처리
figure;
subplot(211); plot(x, fdata);
subplot(212); plot(x, adata);

%% 이동창평균 
mdata = smooth(adata, 0.5*fs, 'moving');
%0.5*fs: 스무딩 창의 크기를 설정합니다. fs는 샘플링 주파수(1000 Hz)로, 0.5*fs는 0.5초에 해당하는 창 크기를 의미합니다.
%500hz로 써도 되지만 코드 재사용성을 위해 0.5*fs로 작성
% 즉, 500개의 샘플에 대해 스무딩을 수행하게 됩니다.
%'moving': 이동 평균 방법을 지정합니다. 이동 평균은 지정된 창의 중앙 값 주변의 데이터 포인트를 평균 내어 신호를 부드럽게 만드는 기법 
% 이 방법은 고주파 잡음 제거에 효과적입니다.
figure;
subplot(311); plot(x, fdata);
subplot(312); plot(x, adata);
subplot(313); plot(x, mdata);

%% 기준값 세워보기
threshold = 0.03*ones(1, length(mdata));
figure;
plot(x, mdata); hold on; plot(x, threshold);
0.03 * ones(1, length(mdata));
%0.03: 설정하려는 임계값입니다. 이 값은 EMG 신호의 강도를 기준으로 하여 특정 조건(예: 힘을 주는 구간)을 평가하는 데 사용됩니다.
%ones(1, length(mdata)): mdata와 동일한 길이의 배열을 생성하며, 모든 요소가 1로 초기화된 벡터입니다.
%따라서, **0.03 * ones(1, length(mdata))**는 길이가 mdata와 같은 벡터를 생성하고
% 모든 요소가 0.03로 설정된 배열인 threshold를 생성합니다. 
%이렇게 하면 시각화 시 모든 지점에서 같은 값을 가지는 수평선으로 나타나게 됩니다.

%% 데이터에서 0.03 이상인 구간을 찾아서 1로 마킹
result2 = zeros(1, length(mdata));
idx = find(mdata > 0.03);
result2(idx) = 1;

figure;
subplot(311); plot(x, fdata);
subplot(312); plot(x, mdata);
subplot(313); bar(x, result2);

