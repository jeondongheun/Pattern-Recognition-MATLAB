clear all; close all; clc;

%%심전도 그리기 (샘플링 주파수 256hz)
load ECG_data_example;

figure;
plot(data);

fs = 256;
x = 1:1:length(data); 
x = x/fs; 

