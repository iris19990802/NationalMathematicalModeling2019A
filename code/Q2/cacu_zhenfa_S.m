function [ans] = cacu_zhenfa_S(time)

% 返回：当前时刻time下，圆台的侧面积
d_zhenfa = 2.5; % 针阀直径(2.5mm)
d_dizuo = 1.4;  % 底座直径(1.4mm)
h_t = fun_zhenfa_t_h(time); % 当前时间下，针阀的升程
% time以1s为单位
S_bs = pi * h_t * sind(9)*(d_zhenfa + h_t*sind(9)*cosd(9));
S_ba = pi * (d_dizuo/2)^2;

ans = min(S_bs,S_ba);

end
