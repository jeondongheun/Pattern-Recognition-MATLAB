clear all; close all; clc;

% x데이터의 합, 평균을 구하는 코드
x = 1:1:10;

out1 = 0;
out2 = 0;

%%1부터 1개씩 x길이만큼 반복 
for k=1:1:length(x)
    out1 = out1 + x(k);
    out2 = out2 + x(k)/length(x);
end
out1
out2

% 내장함수 사용
out11 = sum(x) %합
out22 = mean(x) %평균
out33 = std(x) %표준편차
%%
% x데이터 중 2의 배수, 3의 배수, 5의 배수의 합을 구하는 코드

out2 = 0;
out3 = 0;
out5 = 0;

out2_set = [];
out3_set = [];
out5_set = [];

x= 1:1:100;

for k=1:1:length(x)
    if mod(x(k), 2) == 0 % mod(a, b) a를 b로 나눈 나머지를 반환 하는 내장함수
        out2 = out2 + x(k);
        out2_set = [out2_set x(k)];
    elseif mod(x(k), 3) == 0
        out3 = out3 + x(k);
        out3_set = [out3_set x(k)];
    elseif mod(x(k), 5) == 0
        x(k)
        out5 = out5 + x(k);
        out5_set = [out5_set x(k)];
    end
end
out2
out3
out5
%%
out2 = 0;
out3 = 0;
out5 = 0;

out2_set = [];
out3_set = [];
out5_set = [];

x= 1:1:100;

for k=1:1:length(x)
    if mod(x(k), 2) == 0 % mod(a, b) a를 b로 나눈 나머지를 반환 하는 내장함수
        out2 = out2 + x(k); %2로 나누어 떨어지는 수들의 합 
        out2_set = [out2_set x(k)];
    end
    if mod(x(k), 3) == 0
        out3 = out3 + x(k);
        out3_set = [out3_set x(k)];
    end
    if mod(x(k), 5) == 0
        x(k)
        out5 = out5 + x(k);
        out5_set = [out5_set x(k)];
    end
end
out2
out3
out5

%%
x= 1:1:100;

idx2 = find(mod(x, 2) == 0); %%2롤 나누어 떨어지는 수를 찾아서 idx2 에 저장 
idx3 = find(mod(x, 3) == 0);
idx4 = find(mod(x, 5) == 0);

out22 = sum(x(idx2)); %%idx2의 합 
out33 = sum(x(idx3));
out55 = sum(x(idx4));
