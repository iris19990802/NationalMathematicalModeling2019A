function [ans] = cacu_all_S(endtime)  % 计算：此时刻的总漏油量
S_whole = 0.2*20/2*2 + (2.2-0.2)*20;
% 给定开始时间、持续时长，求漏油量
t_in_T = mod((endtime),100);
S_in_T = cacu_S(t_in_T);
S_pre = floor(endtime/100);
ans = S_in_T +  S_whole * S_pre;

end

