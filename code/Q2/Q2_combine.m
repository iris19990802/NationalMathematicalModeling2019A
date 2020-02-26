
clear;clc;
load_data;
load('zhenfa_h.mat');
%% 常数

step_du_ms = 1.526;  % 角速度：每毫秒1度

C = 0.85; % 流量系数

d_up = 1.4; % 小孔直径（mm）
S_up = pi * (d_up/2)^2;  % 小孔面积

L = 500; % 管腔长度（mm）
d_pip = 10; % 内直径(mm)
V_guan = pi * (d_pip/2)^2 * L; % 管体积(*pi)

P_in_0 = 100;   % 管内初始压强
P_down = 6.5; % 下端外部压强，永远是6.5Mpa
%% 临时变量

this_P_beng = 0.5;     % 记录当前时刻泵内压强
                       % 初始在下止点，压力位0.5Mpa

this_du = 180;  % 记录当前角度（初始为180，在下止点）
this_V_beng = caculate_Vbeng(this_du); % 当前时刻泵内体积

this_delta_sum = 0; % 相对误差总值
% 记录当前时刻的管内压强
this_P_in = P_in_0;

%% 循环
t_st = 0;
T = 360/step_du_ms/1000;
t_ed = T * 10;
delta_t = 0.0000001; % 步长

index_size = floor((t_ed-t_st)/delta_t+1); % 预分配数组空间大小



%% 记录历史信息
history_P_beng = zeros(index_size,1);
history_P_beng(1,1) = 0.5;
history_time = zeros(index_size,1);
history_time(1,1) = 0;
history_P_in = zeros(index_size,1);
history_P_in(1,1) = 0;
history_minus_p = zeros(index_size,1);
history_minus_p(1,1) = 0;
history_Q_leak_up = zeros(index_size,1);
history_Q_leak_up(1,1) = 0;

history_V_beng = [];
history_delta_V_beng = [];
history_delta_P_beng = [];
history_du = [];
history_E_beng = [];



% 模拟0.1s内的情况,以1ms为步长

cnt = 0;
for time = t_st:delta_t:t_ed
    cnt = cnt+1;
    history_time(cnt) = time;

    
    % 计算柱塞运动造成的"油泵"体积变化
    this_V_beng = caculate_Vbeng(this_du);
    next_V_beng = caculate_Vbeng(this_du + step_du_ms*(delta_t*1000));
    %history_V_beng = [history_V_beng;this_V_beng];
    
    delta_V_beng = next_V_beng - this_V_beng;
    %history_delta_V_beng = [history_delta_V_beng;delta_V_beng];
    
    % 计算上孔的漏油量（仅当泵内压强 > 管内压强时）
    minus_p = this_P_beng - this_P_in; % 当前时刻压强差
    history_minus_p(cnt) = minus_p;
    
    if minus_p > 0
        this_row = fun_P_row(this_P_beng); % rou取高压处P(泵内P)计算
        Q_leak_up = C*S_up*sqrt(2*minus_p/this_row); % 上孔漏油量
    else
        Q_leak_up = 0;
    end
    history_Q_leak_up(cnt) = Q_leak_up;
    
    
    %% 计算下孔的漏油量
    % 计算当前时刻time下，圆台的侧面积，存到this_S 中

    d_zhenfa = 2.5; % 针阀直径(2.5mm)
    d_dizuo = 1.4;  % 底座直径(1.4mm)
    
    % 计算当前时间下，针阀的升程，存到h_t中

    h_t = zhenfa_h(mod(cnt,10^6)+1);   % 提高极径为1.2倍
    % h_t算完
    
    S_bs = pi * h_t * sind(9)*(d_zhenfa + h_t*sind(9)*cosd(9));
    S_ba = pi * (d_dizuo/2)^2;

    this_S = min(S_bs,S_ba);
    % this_S 算完
    
    % 算得下孔的漏油量
    this_row_down = fun_P_row(this_P_in);
    minus_p_down = this_P_in - P_down;
    this_Q_leak = C*this_S*sqrt(2*minus_p_down/this_row_down);  % 这个rou，还是P_in算得rou
    
    %% 移动到下一时刻，计算下一时刻P
    % 油泵和油管，压强变化量，都要计算
    
    % 油泵的压强变化
    delta_Q_beng = -Q_leak_up;
    this_E_beng = fun_P_E(this_P_beng);
    delta_p_beng = (delta_Q_beng - delta_V_beng)*this_E_beng/this_V_beng;
    this_P_beng = this_P_beng + delta_p_beng;
     if this_P_beng<0.5
         this_P_beng = 0.5;
     end

     
    if isnan(this_P_beng)
        break;
    end
    history_P_beng(cnt) = this_P_beng;
    
    % 管内的压强变化
    delta_Q_pip = Q_leak_up; 
    this_E_pip = fun_P_E(this_P_in); % 根据管内压强P，求出弹性系数E
    % 由上端加油带来的压强变化
    delta_p_pip = delta_Q_pip * this_E_pip/V_guan;
    % 由下端漏油带来的压强变化
    delta_p_pip = delta_p_pip - this_Q_leak * this_E_pip/V_guan * delta_t * 10^3;
    
    this_P_in = this_P_in + delta_p_pip;
    history_P_in(cnt) = this_P_in;
    this_delta_sum = this_delta_sum + abs(this_P_in-100)*delta_t;
    
    this_du = this_du + step_du_ms*(delta_t*1000); % step_du_ms为每"毫秒"的变化值
end
this_ralate_delta_p = this_delta_sum/T;
disp("finish")
%plot(time_history,delta_p_history)
%plot(history_time,history_delta_V_beng)
figure()
plot(history_time(1:4359108),history_P_beng(1:4359108))
figure()
plot(history_time,history_P_in)
