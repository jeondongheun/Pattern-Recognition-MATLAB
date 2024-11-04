function [LF, HF, TF, VLF, nLF, nHF, LFHF]=SM_FD_HRV(SR, R_PEAK_IDX)

RRI=diff(R_PEAK_IDX)/SR;
RRI(end+1)=RRI(end-1);


%Frequency domain
t=R_PEAK_IDX(1)/SR:1/SR:R_PEAK_IDX(end)/SR;
t_i=R_PEAK_IDX/SR;

% 보간법 적용
RRI_INTERPOL=interp1(t_i, RRI, t, 'PCHIP');

[p,f]=periodogram(RRI_INTERPOL,[],length(RRI_INTERPOL),SR);

vlf_1=2;
vlf_2=length(find(f<0.04));
lf_1=vlf_2+1;
lf_2=length(find(f<0.15));
hf_1=lf_2+1;
hf_2=length(find(f<0.4));

LF=SM_simpson_int(p(lf_1:lf_2), f(2))*1e6;
HF=SM_simpson_int(p(hf_1:hf_2), f(2))*1e6;
TF=SM_simpson_int(p(2:hf_2), f(2))*1e6;
VLF=TF-(LF+HF);

nLF=LF./(LF+HF);
nHF=HF./(LF+HF);
LFHF=LF./HF;