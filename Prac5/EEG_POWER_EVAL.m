%% 데이터 불러오기
clear all; close all; clc;


ALL_EEG_alpha_deep = [];
ALL_EEG_alpha_light = [];
ALL_EEG_alpha_wake = [];
ALL_EEG_alpha_REM = [];

ALL_EEG_theta_deep = [];
ALL_EEG_theta_light = [];
ALL_EEG_theta_wake = [];
ALL_EEG_theta_REM = [];

ALL_EEG_delta_deep = [];
ALL_EEG_delta_light = [];
ALL_EEG_delta_wake = [];
ALL_EEG_delta_REM = [];

ALL_EEG_swa_deep = [];
ALL_EEG_swa_light = [];
ALL_EEG_swa_wake = [];
ALL_EEG_swa_REM = [];

for k=1:1:5 %데이터 새로 열 때 하나하나 수정할 필요 없이 루프 사용
    folder_name = [];
    folder_name = ['/Users/mac/Desktop/pattern/실습5_SLEEP_EEG/Subject' num2str(k)];
    cd(folder_name);

    load SLEEP_EEG_POWER.mat
    ALL_EEG_alpha_deep = [ALL_EEG_alpha_deep; EEG_alpha_deep];
    ALL_EEG_alpha_light = [ALL_EEG_alpha_light; EEG_alpha_light];
    ALL_EEG_alpha_wake = [ALL_EEG_alpha_wake; EEG_alpha_wake];
    ALL_EEG_alpha_REM = [ALL_EEG_alpha_REM; EEG_alpha_REM];

    ALL_EEG_theta_deep = [ALL_EEG_theta_deep; EEG_theta_deep];
    ALL_EEG_theta_light = [ALL_EEG_theta_light; EEG_theta_light];
    ALL_EEG_theta_wake = [ALL_EEG_theta_wake; EEG_theta_wake];
    ALL_EEG_theta_REM = [ALL_EEG_theta_REM; EEG_theta_REM];

    ALL_EEG_delta_deep = [ALL_EEG_delta_deep; EEG_delta_deep];
    ALL_EEG_delta_light = [ALL_EEG_delta_light; EEG_delta_light];
    ALL_EEG_delta_wake = [ALL_EEG_delta_wake; EEG_delta_wake];
    ALL_EEG_delta_REM = [ALL_EEG_delta_REM; EEG_delta_REM];

    ALL_EEG_swa_deep = [ALL_EEG_swa_deep; EEG_swa_deep];
    ALL_EEG_swa_light = [ALL_EEG_swa_light; EEG_swa_light];
    ALL_EEG_swa_wake = [ALL_EEG_swa_wake; EEG_swa_wake];
    ALL_EEG_swa_REM = [ALL_EEG_swa_REM; EEG_swa_REM];
    
end

%% 얕음 깊음 깼을때 램 순서
mean_alpha = [mean(ALL_EEG_alpha_deep) mean(ALL_EEG_alpha_light) mean(ALL_EEG_alpha_wake) mean(ALL_EEG_alpha_REM)];
mean_theta = [mean(ALL_EEG_theta_deep) mean(ALL_EEG_theta_light) mean(ALL_EEG_theta_wake) mean(ALL_EEG_theta_REM)];
mean_delta = [mean(ALL_EEG_delta_deep) mean(ALL_EEG_delta_light) mean(ALL_EEG_delta_wake) mean(ALL_EEG_delta_REM)];
mean_swa= [mean(ALL_EEG_swa_deep) mean(ALL_EEG_swa_light) mean(ALL_EEG_swa_wake) mean(ALL_EEG_swa_REM)];

close all;
figure;
bar(mean_alpha); title('relative alpha power'); 
xticks([1 2 3 4]);
xticklabels({'DS','LS','W','RS'});

figure;
bar(mean_theta); title('relative theta power');
xticks([1 2 3 4]);
xticklabels({'DS','LS','W','RS'});

figure;
bar(mean_delta); title('relative delta power');
xticks([1 2 3 4]);
xticklabels({'DS','LS','W','RS'});

figure;
bar(mean_swa); title('relative swa power');
xticks([1 2 3 4]);
xticklabels({'DS','LS','W','RS'});