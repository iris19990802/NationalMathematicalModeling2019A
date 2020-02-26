clear;clc;
data_P_rou = xlsread('../附件3-弹性模量与压力的副本.xlsx');
data_tulun = xlsread('../附件1-凸轮边缘曲线.xlsx');
data_zhenfa_row = load('../data_zhenfa_row');
data_zhenfa = data_zhenfa_row.data_zhenfa;
clear data_zhenfa_row

delta_t = 0.0000001*1000;  % 单位转化为ms(1e-4 秒)
% 输入时间(100ms以内，0.1s以内)
% 根据delta_t,转为：它是列表中的第几个下标
% 直接返回列表中的值：升程d

% 插值针阀运动轨迹（delta_t = 1e-4）
t = data_zhenfa(1:250,1);
d = data_zhenfa(1:250,2);

t_1 = data_zhenfa(1:46,1);
d_1 = data_zhenfa(1:46,2);
t_3 = data_zhenfa(201:246,1);
d_3 = data_zhenfa(201:246,2);


xx_1 = [0:delta_t:0.45]';
yy_1 = interp1(t_1,d_1,xx_1,'pchip');

xx_3 = [2:delta_t:2.45]';
yy_3 = interp1(t_3,d_3,xx_3,'pchip');

%% 
t_st = 0;
t_ed = 100;

index_size = floor((t_ed-t_st)/delta_t+3); % 预分配数组空间大小

h_history = zeros(index_size,1);
t_history = zeros(index_size,1);

cnt = 0;
for time=0:delta_t:0.45
    cnt = cnt+1;
    t_history(cnt,1) = time;
    this_h = yy_1(cnt,1);
    h_history(cnt,1) = this_h;
end


for time=0.45+delta_t:delta_t:2
    cnt = cnt+1;
    t_history(cnt,1) = time;
    h_history(cnt,1) = 2;
end

cntx = 0;
for time = 2+delta_t:delta_t:2.45
    cnt = cnt+1;
    cntx = cntx + 1;
    t_history(cnt,1) = time;
    this_h = yy_3(cntx,1);
    h_history(cnt,1) = this_h;
end


for time = 2.45+delta_t:delta_t:100
    cnt = cnt+1;
    t_history(cnt,1) = time;
    h_history(cnt,1) = 0;
end
%plot(t_history,h_history)
zhenfa_h = h_history;
zhenfa_t = t_history;
clear t_history h_history xx_1 xx_3 yy_1 yy_3 t_1 t_3 d_1 d_3 cnt t d this_h data_zhenfa time delta_t index_size t_ed t_st