clear; close all; clc;

for subj = 1:1:5
    subj
    folder_name = [];
    folder_name = ['/Users/mac/Desktop/pattern/실습6_HRV/Subject' num2str(subj)];
    cd(folder_name);
    
    load ECG_PEAK;
    
    SDNN   = zeros(1, length(stg));
    RMSSD  = zeros(1, length(stg));
    pNN50  = zeros(1, length(stg));
    M_HR   = zeros(1, length(stg));
    for k=1:1:length(stg)
        % 30초에 해당하는 심박 위치를 불러옴 
        % Fs = 250 (초당 250개의 데이터를 얻었다 = 1초에 데이터가 250개씩)
        % 30초라면? Fs*30 = 7500
        % 따라서, k = 1이면, 1 ~ 7500 (30*FS)
        % k = 2이면, 7501 ~15000 (30*Fs + 1 ~ 60*Fs)
        % k = 2이면, 15001 ~22500 (60*Fs + 1 ~ 90*Fs)
        % ...
        % 너무나 중요하므로 꼭 기억 하시길..

        % 해당 구간에 존재하는 심박 위치를 가져와라!
        idx     = find(ECG_PEAK > (k-1)*Fs*30+1 & ECG_PEAK <= (k)*Fs*30);
        local_rpeak = ECG_PEAK(idx);
        
        % 시간영역 심박변이율 지표를 계산
        [SDNN(k), RMSSD(k), pNN50(k), M_HR(k)]  =  SM_TD_HRV(Fs, local_rpeak);
    end

    figure;
    subplot(211); plot(M_HR); axis tight;
    subplot(212); plot(stg); axis tight;
    
    save TimeDomainHRV SDNN RMSSD pNN50 M_HR stg;  
end
%%여기까지가 시간영역 
%%여기부터 주파수 영역
clear all; close all; clc;

for subj = 1:1:5
    
    folder_name = [];
    folder_name = ['D:\상명대학교\수업\2024_2\영상패턴인식\실습\실습6_HRV\Subject' num2str(subj)];
    cd(folder_name);
    
    load ECG_PEAK;
    
    LF    = zeros(1, length(stg));
    HF    = zeros(1, length(stg));
    TF    = zeros(1, length(stg));
    VLF   = zeros(1, length(stg));
    nLF   = zeros(1, length(stg));
    nHF   = zeros(1, length(stg));
    LFHF  = zeros(1, length(stg));
    
    for k=1:1:length(stg)-9 % 10번째부터 
        [subj k]
        % 300초에 해당하는 심박 위치를 불러옴. 단, 30초씩 이동시킬 것임
        % Fs = 250이므로, 300초동안 수집한 데이터의 개수는 300*Fs
        % k = 1이면, 0 ~ 300초 구간 = 샘플 관점에서 1 ~ 300*Fs
        % k = 2이면, 30 ~ 330초 구간 = 샘플 관점에서 30*Fs + 1 ~ 330*Fs

        idx     = find(ECG_PEAK > (k-1)*Fs*30+1 & ECG_PEAK <= (k+9)*Fs*30);
        local_rpeak = ECG_PEAK(idx);
        
        % 주파수영역 심박변이율 지표를 계산
        [LF(k+9), HF(k+9), TF(k+9), VLF(k+9), nLF(k+9), nHF(k+9), LFHF(k+9)]  =  SM_FD_HRV(Fs, local_rpeak);
    end


    figure;
    subplot(211); plot(nHF); axis tight;
    subplot(212); plot(stg); axis tight;
    
    
    save FrequencyDomainHRV LF HF TF VLF nLF nHF LFHF stg;
     
end

