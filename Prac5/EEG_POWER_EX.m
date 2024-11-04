%% 데이터 불러오기
clear all; close all; clc;

cd '/Users/mac/Desktop/pattern/실습5_SLEEP_EEG/Subject5';
load EEGdata;

% 뇌전도 그려보기
x = 1/Fs:1/Fs:length(data)/Fs;
figure;
plot(x, data); axis tight;

%수면단계 그려보기
figure;
plot(stg);  axis tight;
yticks([1 2 3 4]);
yticklabels({'DS','LS','W','RS'});
%% 기본 필터링
% 0.5Hz IIR HPF
[b, a] = butter(5, 0.5/(Fs/2), 'high');
fdata = filtfilt(b, a, data);

% 35Hz IIR LPF 
[b, a] = butter(5, 35/(Fs/2), 'low');
fdata = filtfilt(b, a, fdata);

%% 뇌전도의 주파수대역별 파워 계산
% 수면단계가 30초의 데이터를 이용하여 하나의 수면단계를 판독하므로, 30초에 한번씩 파워들을 계산한다
len_loop = length(data)/Fs/30; %데이터 개수랑똑같음
% len_loop = length(stg);

%수면은 4단계로 분리: DS, LS, W, RS
% 뇌전도 파워는 4개 추출: alpha, theta, delta, slow wave activity
EEG_alpha_deep = [];
EEG_alpha_light = [];
EEG_alpha_wake = [];
EEG_alpha_REM = [];

EEG_theta_deep = [];
EEG_theta_light = [];
EEG_theta_wake = [];
EEG_theta_REM = [];

EEG_delta_deep = [];
EEG_delta_light = [];
EEG_delta_wake = [];
EEG_delta_REM = [];

EEG_swa_deep = [];
EEG_swa_light = [];
EEG_swa_wake = [];
EEG_swa_REM = [];

for k=1:1:len_loop
    k
    %샘플링 주파수가 250Hz이므로, 30초 데이터는 250Hz*30초 = 7500개
    % 1~7500, 7501~15000, 15001~22500, ... 와 같이 데이터를 불러오면 됨
    tmpdata = fdata( (k-1)*Fs*30 + 1 : k*Fs*30);
    
    % 주파수 변환
    [pxx, f] = periodogram(tmpdata, [], length(tmpdata), Fs);
    
    % 대역 주파수 찾기
    idx_alpha = find(f >= 8 & f <= 13); % 알파파 대역
    idx_theta = find(f >= 4 & f <= 7); % 세타파 대역
    idx_delta = find(f >= 0.5 & f <= 4); % 델타파 대역
    idx_swa   = find(f >= 0.5 & f <= 2); % slow wave activity 대역
    
    % 주파수 대역 "비율" 계산
    % 사람마다 뇌전도의 파워는 다를 것이므로 해당구간의 전체 파워로 나눠줌
    alpha_tmp = sum(pxx(idx_alpha)) / (sum(pxx)); %알파 다 더한 것에서 전체 다 더한것으로 나눔
    theta_tmp = sum(pxx(idx_theta)) / (sum(pxx));
    delta_tmp = sum(pxx(idx_delta)) / (sum(pxx));
    swa_tmp = sum(pxx(idx_swa)) / (sum(pxx));
    
    % 수면단계별로 분리
    if stg(k) == 1 % 깊은수면이면
        EEG_alpha_deep = [EEG_alpha_deep; alpha_tmp];     
        EEG_theta_deep = [EEG_theta_deep; theta_tmp];      
        EEG_delta_deep = [EEG_delta_deep; delta_tmp];    
        EEG_swa_deep = [EEG_swa_deep; swa_tmp];
       
    elseif stg(k) == 2 % 얕은수면이면
        EEG_alpha_light = [EEG_alpha_light; alpha_tmp];   
        EEG_theta_light = [EEG_theta_light; theta_tmp];
        EEG_delta_light = [EEG_delta_light; delta_tmp];
        EEG_swa_light = [EEG_swa_light; swa_tmp];
        
    elseif  stg(k) == 3 % 깸이면
        EEG_alpha_wake = [EEG_alpha_wake; alpha_tmp];
        EEG_theta_wake = [EEG_theta_wake; theta_tmp];
        EEG_delta_wake = [EEG_delta_wake; delta_tmp];
        EEG_swa_wake = [EEG_swa_wake; swa_tmp];
        
    else % 렘수면이면
        EEG_alpha_REM = [EEG_alpha_REM; alpha_tmp];
        EEG_theta_REM = [EEG_theta_REM; theta_tmp];
        EEG_delta_REM = [EEG_delta_REM; delta_tmp];
        EEG_swa_REM = [EEG_swa_REM; swa_tmp];
    end
end
    
%%
save SLEEP_EEG_POWER EEG_alpha_deep EEG_alpha_light EEG_alpha_wake EEG_alpha_REM  ...
    EEG_theta_deep EEG_theta_light EEG_theta_wake EEG_theta_REM ...
    EEG_delta_deep EEG_delta_light EEG_delta_wake EEG_delta_REM ...
    EEG_swa_deep EEG_swa_light EEG_swa_wake EEG_swa_REM;
    

%%
mean_set = [];

mean_set = [mean(EEG_alpha_deep) mean(EEG_alpha_light) mean(EEG_alpha_wake) mean(EEG_alpha_REM)];

figure;
bar(mean_set); title('alpha power');
xticks([1 2 3 4]);
xticklabels({'DS','LS','W','RS'});