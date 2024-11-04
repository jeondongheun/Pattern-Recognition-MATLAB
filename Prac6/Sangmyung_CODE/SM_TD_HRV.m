function [SDNN, RMSSD, pNN50, M_HR]=SM_TD_HRV(SR, R_PEAK_IDX)

RRI=diff(R_PEAK_IDX)/SR;


% Time domain
SDNN=std(RRI)*1000; % ms로 표시하기 위한 1000을 곱합
RMSSD=sqrt(mean(diff(RRI).^2))*1000;  % ms로 표시하기 위한 1000을 곱합

dRRI=diff(RRI);
NN50=find(dRRI > 0.05); % 50ms 이상 차이나는 것을 찾아라
pNN50=length(NN50)/length(dRRI)*100;

HR=60./RRI;
M_HR=mean(HR);
