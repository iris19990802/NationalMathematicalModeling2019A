function [ans] = cacu_all_S(endtime)  % ���㣺��ʱ�̵���©����
S_whole = 0.2*20/2*2 + (2.2-0.2)*20;
% ������ʼʱ�䡢����ʱ������©����
t_in_T = mod((endtime),100);
S_in_T = cacu_S(t_in_T);
S_pre = floor(endtime/100);
ans = S_in_T +  S_whole * S_pre;

end

