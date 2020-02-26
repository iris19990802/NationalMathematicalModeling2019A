function [ans] = cacu_S(end_time) % 输入：此时刻，在100ms的周期内的位置
% 计算当前周期内的面积
if end_time <= 0.2 % 0.2 毫秒  % 三角形
    ans = end_time * (end_time * 100)/2;
    
elseif end_time>0.2 & end_time<=2.2   % 三角形 + 矩形
    ans = 0.2*20/2 + 20*(end_time - 0.2);
    
elseif end_time>2.2 & end_time<=2.4 % 三角形 + 矩形 + 梯形
    ans = 0.2*20/2 + 20*(2.2-0.2) + (20 + (2.4-end_time)*100)/2 * (end_time-2.2);
    
elseif end_time>2.4 & end_time<=100 % 全体面积
    ans = 0.2*20/2*2 + (2.2-0.2)*20;

end

