clear; close all; clc;

load EOG_data_example;

up_down = data(:,1);
right_left = data(:,2);
x = 1/fs:1/fs:length(up_down)/fs;

figure;
subplot(211); plot(x, up_down);
subplot(212); plot(x, right_left);

%% 기준선 만들어보기
th_p_ud = 0.4*ones(1, length(up_down));
th_n_ud = -0.5*ones(1, length(up_down));

th_p_rl = 0.6*ones(1, length(right_left));
th_n_rl = -0.4*ones(1, length(right_left));

figure;
subplot(211); plot(x, up_down); hold on; plot(x, th_p_ud);  hold on; plot(x, th_n_ud); 
subplot(212); plot(x, right_left); hold on; plot(x, th_p_rl);  hold on; plot(x, th_n_rl); 

%% 기준선에 따라 마킹해보기
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

figure;
subplot(311); plot(x, up_down);
subplot(312); plot(x, right_left);
subplot(313); bar(x, POS);

%% 뒤에서 앞의 데이터를 빼서, 변화구간 찾기
rePOS = POS;
dPOS = diff(rePOS);

figure; 
subplot(211); bar(x, POS);
subplot(212); plot(dPOS)

idx1 = find(dPOS > 0);
idx2 = find(dPOS < 0);

loc_set(1,:) = idx1+1; %%변화가 생긴 인덱스에 +1 해줘야함 
loc_set(2,:) = idx2;

%% 종료시점 - 시작시점의 차이가 0.2초보다 짧으면, 해당이벤트는 지움
for k=1:1:length(loc_set)
    if (loc_set(2,k) - loc_set(1,k)) < 0.2*fs
        rePOS(loc_set(1,k):loc_set(2,k)) = 0;
    end
end

figure;
subplot(411); plot(x, up_down);
subplot(412); plot(x, right_left);
subplot(413); bar(x, POS);
subplot(414); bar(x, rePOS);


