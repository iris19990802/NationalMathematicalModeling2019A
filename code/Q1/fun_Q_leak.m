function [ans] = fun_Q_leak(end_time,duration) % start_time 单位为(s)
% 计算：从当前时间(end_time)往前的一定时间段(duration)内的滴油量
% 输入的是：真实时长，而非周期内的时长
% 单位全部转化为毫秒

end_time = end_time * 1000;
duration = duration * 1000; 
start_time = end_time - duration; % 求出结束时间

% 求：截止到当前时间的，全程总漏油量
S_start_all = cacu_all_S(start_time);
S_end_all = cacu_all_S(end_time);
ans = S_end_all - S_start_all;

end

