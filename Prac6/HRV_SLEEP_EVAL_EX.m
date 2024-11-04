clear all; close all; clc;

%nHF 예시
nHF_Wake   = [];
nHF_Light   = [];
nHF_Deep   = [];
nHF_REM   = [];


for subj = 1:1:5
    folder_name = [];
    folder_name = ['D:\상명대학교\수업\2024_2\영상패턴인식\실습\실습6_HRV\Subject' num2str(subj)];
    cd(folder_name);
    
    load FrequencyDomainHRV;
    
    refstg = stg;

    for k=10:1:length(refstg)    
        if refstg(k) == 1 % 깊은수면이면
            nHF_Deep = [nHF_Deep; nHF(k)];     
           
        elseif refstg(k) == 2 % 얕은수면이면
            nHF_Light = [nHF_Light; nHF(k)];     
            
        elseif  refstg(k) == 3 % 깸이면
            nHF_Wake = [nHF_Wake; nHF(k)];     
            
        else % 렘수면이면
            nHF_REM = [nHF_REM; nHF(k)];     
        end   
    end
end
% 그림 그려보기

