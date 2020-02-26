% 滴油 + 漏油
clear;clc;
load_data;
P_up = 160;     % 单位：MPa
P_in_0 = 100;   % 管内初始压强
C = 0.85; % 流量系数
d_up = 1.4; % 小孔直径（mm）
S_up = pi * (d_up/2)^2;  % 小孔面积
L = 500; % 管腔长度（mm）
d_pip = 10; % 内直径(mm)
V = pi * (d_pip/2)^2 * L; % 管体积(*pi)
this_P_in = 100; % 记录当前时刻的管内压强
delta_t = 0.001; % 步长
p_history = [P_in_0]; % 记录每一时刻管内压强
time_history = [0]; % 记录时刻
delta_p_history = []; % 每一时刻的变化P
Ts=0.723*(10^-3);   %% 调整，0。4，1
TT=Ts+0.01;

% 模拟1s内的情况,以1ms为步长
for time = 0+delta_t:delta_t:20
    
    minus_p = P_up - this_P_in; % 当前时刻压强差
    
    this_row = fun_P_row(this_P_in); % 根据当前时刻管内压强P，求出管内密度rou
    
    this_E = fun_P_E(this_P_in); % 根据当前时刻管内压强P，求出弹性系数E
    
    this_Q_in = C*S_up*sqrt(2*minus_p/this_row); % 此次小孔滴油的流量
    
    this_T_in = mod(time,TT);
    if this_T_in > Ts
        this_Q_in = 0;
    end
    
    this_Q_leak = -fun_Q_leak(time+2.5,delta_t);  % 此次滴油管的"漏出量"
    
    this_delta_Q = this_Q_in + this_Q_leak; % 求出此次的Q变化量( 滴油量 & 漏出量)
    
    delta_p = this_delta_Q * this_E/V;
    
    delta_p_history = [delta_p_history delta_p];
    
    this_P_in = this_P_in + delta_p; % 更新管内压强
    
    p_history = [p_history this_P_in];
    time_history = [time_history time];
end

plot(time_history,p_history)

xlabel("时间/s")
ylabel("压强/MPa")
sum(p_history(1,1:5*1000))/5/1000-100;
