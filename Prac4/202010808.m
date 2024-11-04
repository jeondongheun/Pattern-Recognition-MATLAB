clear; close all; clc;

load data_for_template_5;

x = 1/Fs:1/Fs:length(data)/Fs;
rpeak_in_time = rpeak_i/Fs;

figure;
plot(x, data); hold on;
plot(rpeak_in_time, data(rpeak_i), 'ro'); axis tight; %피크 값에 따라 그래프 출력

TEMPLATE = zeros((Fs)/2+1, 1); % 피크를 기준으로 앞 90개 뒤 90개 총 181개 데이터가 됨

% 혹시 마지막 피크 뒤에 90개 데이터가 없을 수도 있으므로, 마지막 피크는 계산하지 않았음
for kk=1:1:length(rpeak_i)-1 
    % 피크를 기준으로 앞 90개 뒤 90개 총 181개 데이터를 가져옴
    tmp = data(rpeak_i(kk)-Fs/4:rpeak_i(kk)+Fs/4); %112번 부터220번째

    % 누적해서 더함
    TEMPLATE = TEMPLATE + tmp;

end

% 더한 횟수 만큼 나눠줌
TEMPLATE = TEMPLATE/(length(rpeak_i)-1);

figure;
plot(TEMPLATE); axis tight; %템플릿(대표 파형) 출력

%% 분석할 데이터를 불러옴
load data_for_arrhythmia_5; %데이터를 불러와 유사도 평가

x = 1/Fs:1/Fs:length(data)/Fs;
rpeak_in_time = rpeak_i/Fs;

figure;
plot(x, data); hold on;
plot(rpeak_in_time, data(rpeak_i), 'ro'); axis tight;


% 상관계수를 이용한 유사도 평가
SIMILARITY_CORR = zeros(1, length(rpeak_i));
 
for kk=1:1:length(rpeak_i)
    tmp = data(rpeak_i(kk)-Fs/4:rpeak_i(kk)+Fs/4);

    [r, p] = corrcoef(tmp, TEMPLATE); %ans 4개 값 나옴(1,4는 첫번쨰와 첫번쨰,두번쨰와 두번쨰 비교 , 즉 같은값 비교)

    SIMILARITY_CORR(kk) = r(1,2);
end

figure;
plot(SIMILARITY_CORR); %출력하면 상관 계수가 훅 떨어지는 지점이 있음 
                        %떨어지는 지점 실제 arr_id 데이터 값과 비교해보면
                           %어떤 지점이 부정맥인지 확인 가능 

EST_OUT_CORR = zeros(1, length(rpeak_i));
for kk=1:1:length(rpeak_i)
    if SIMILARITY_CORR(kk) < 0.7 %0.95보다 낮은 점을 부정맥으로 하겠다.수정해가며 출력

        EST_OUT_CORR(kk) = 1;
    end
end

Accuracy_Corr = 0;

for kk=1:1:length(EST_OUT_CORR)
    if EST_OUT_CORR(kk) == Arr_ID(kk)
        Accuracy_Corr = Accuracy_Corr + 1;
    end
end
Accuracy_Corr = 100* (Accuracy_Corr / length(EST_OUT_CORR)); %정답/측정*100,100에 가까울수록 좋음
Accuracy_Corr

figure;
subplot(211); bar(Arr_ID); axis tight; %실제 부정맥 출력
subplot(212); bar(EST_OUT_CORR); axis tight; %내가 평가한 그래프 출력
                                            %기준값을 높이거나 낮춰서 같게 만들어야함


% 절대 차이를 이용한 유사도 평가
SIMILARITY_DIFF = zeros(1, length(rpeak_i));

for kk=1:1:length(rpeak_i)
    tmp = data(rpeak_i(kk)-Fs/4:rpeak_i(kk)+Fs/4);
    SIMILARITY_DIFF(kk) = mean(abs(tmp-TEMPLATE));
end

figure;
plot(SIMILARITY_DIFF);

EST_OUT_DIFF = zeros(1, length(rpeak_i));
for kk=1:1:length(rpeak_i)
    if SIMILARITY_DIFF(kk) > 30 %이 부분을 수정해가며 정확도 올리기
        EST_OUT_DIFF(kk) = 1;
    end
end

Accuracy_Diff = 0;

for kk=1:1:length(EST_OUT_DIFF)
    if EST_OUT_DIFF(kk) == Arr_ID(kk)
        Accuracy_Diff = Accuracy_Diff + 1;
    end
end
Accuracy_Diff = 100* (Accuracy_Diff / length(EST_OUT_DIFF));
Accuracy_Diff

figure;
subplot(211); bar(Arr_ID); axis tight;
subplot(212); bar(EST_OUT_DIFF); axis tight;

%1. 상관계수, 절대차이를 이용하여 기준점 찾기
%2.실제와 비교
%3.정확도 평가
%4. 기준값 수정 

%과제 : 값을 조절해가며 정확도 맞춰가보기 

%       상관계수                        절대차이
%   1   SIMILARITY_CORR(kk) < 0.6     SIMILARITY_DIFF(kk) > 25
%   2   SIMILARITY_CORR(kk) < 0.8     SIMILARITY_DIFF(kk) > 50
%   3   SIMILARITY_CORR(kk) < 0.7     SIMILARITY_DIFF(kk) > 80
%   4   SIMILARITY_CORR(kk) < 0.9     SIMILARITY_DIFF(kk) > 40
%   5   SIMILARITY_CORR(kk) < 0.7     SIMILARITY_DIFF(kk) > 30
