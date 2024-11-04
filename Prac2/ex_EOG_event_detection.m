%눈 깜빡이는 순간 검출
%샘플링 줒파수 250hz
%눈깜빡임은 찰나의 순간
%한 샘플 뒤 데이터 - 한 샘플 앞 데이터가 양수면 이벤트 시작(감았다 뜸), 음수면 이벤트 종료 (떴다 감음)

clear; close all; clc;

load EOG_data_example.mat %이 데이터는 2열로 구성

up_down = data(:,1); %첫번째 열은 수직 움직임에 대한 데이터
right_left = data(:,2); %두번째 열은 수평 움직임에 대한 데이터
x = 1/fs:1/fs:length(up_down)/fs; %x축 정의. up_down 대신 right_left 들어가도 똑같음

figure;
subplot(211); plot(x, up_down);
subplot(212); plot(x, right_left);

%% 기준선 만들어보기
th_p_ud = 0.4*ones(1, length(up_down)); 
%up_down 데이터 개수만큼의 1 * 0.4 데이터 생성 
th_n_ud = -0.5*ones(1, length(up_down));
th_p_rl = 0.6*ones(1, length(right_left));
th_n_rl = -0.4*ones(1, length(right_left));

figure;
subplot(211); plot(x, up_down); hold on; plot(x, th_p_ud);  hold on; plot(x, th_n_ud); 
%저장된 값을 토대로 그래프 생성 th_p_ud는 y= 0.4 인 그래프 
subplot(212); plot(x, right_left); hold on; plot(x, th_p_rl);  hold on; plot(x, th_n_rl); 

%% 기준선에 따라 마킹해보기
%특정 기준 충족하는 데이터에만 1 채워넣어서 마킹 
up_data = zeros(1, length(up_down));
idx_u = find(up_down > 0.4);
up_data(idx_u) = 1; %%0.4보다 큰 값에 다 1 채워넣기

down_data = zeros(1, length(up_down));
idx_d = find(up_down < -0.5);
down_data(idx_d) = 1;

right_data = zeros(1, length(right_left));
idx_r = find(right_left > 0.6);
right_data(idx_r) = 1;

left_data = zeros(1, length(right_left));
idx_l = find(right_left < -0.4);
left_data(idx_l) = 1;

figure;
subplot(811); plot(x, up_down);
subplot(812); bar(x, up_data);
subplot(813); plot(x, up_down);
subplot(814); bar(x, down_data);
subplot(815); plot(x, right_left);
subplot(816); bar(x, right_data);
subplot(817); plot(x, right_left);
subplot(818); bar(x, left_data);

%% U: 1, D: 2, R: 3, L: 4
POS = zeros(1, length(up_down));
POS(idx_u) = 1;
POS(idx_d) = 2;
POS(idx_r) = 3;
POS(idx_l) = 4;
%위로 움직이면 1 , 아래로 움직이면 2, 오른쪽 3 , 왼쪽 4로 매핑 
figure;
subplot(311); plot(x, up_down);
subplot(312); plot(x, right_left);
subplot(313); bar(x, POS);

%% 뒤에서 앞의 데이터를 빼서, 변화구간 찾기
rePOS = POS;
dPOS = diff(rePOS);
%차분 계산

figure; 
subplot(211); bar(x, POS);
subplot(212); plot(dPOS)

idx1 = find(dPOS > 0);
idx2 = find(dPOS < 0);
%음수인지 양수 분류

loc_set(1,:) = idx1+1;
loc_set(2,:) = idx2;
loc_set(1,:) = idx1 + 1;
%idx1의 각 인덱스에 1을 더하여 loc_set의 첫 번째 행에 저장합니다.
%여기에 +1을 하는 이유는, dPOS의 차분 연산으로 인해 눈의 위치 변화가 발생한 지점이 
% dPOS에서 나타나기 때문입니다. 실제 위치 변화는 POS의 해당 인덱스보다 하나 뒤의 인덱스에 해당합니다.
% 예를 들어, dPOS의 1이 발생하면, POS의 인덱스 idx1에서 위치 변화가 발생한 것이므로,
% 실제로는 idx1 + 1 인덱스에서 시작됩니다.
%loc_set(2,:) = idx2;: idx2의 인덱스를 loc_set의 두 번째 행에 저장합니다. 
% 이 인덱스는 이벤트가 종료된 위치를 나타내며, dPOS의 종료 인덱스는 그 자체로 적합합니다.

%% 종료시점 - 시작시점의 차이가 0.2초보다 짧으면, 해당이벤트는 지움
for k=1:1:length(loc_set)
    if (loc_set(2,k) - loc_set(1,k)) < 0.2*fs %0.2*fs는 이벤트 최소 지속 시간
        rePOS(loc_set(1,k):loc_set(2,k)) = 0;
        %이벤트가 기준보다 짧을 시 무의미하다고 간주하고 제거
    end
end

figure;
subplot(411); plot(x, up_down);
subplot(412); plot(x, right_left);
subplot(413); bar(x, POS);
subplot(414); bar(x, rePOS);


