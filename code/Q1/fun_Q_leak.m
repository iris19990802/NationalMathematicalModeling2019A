function [ans] = fun_Q_leak(end_time,duration) % start_time ��λΪ(s)
% ���㣺�ӵ�ǰʱ��(end_time)��ǰ��һ��ʱ���(duration)�ڵĵ�����
% ������ǣ���ʵʱ�������������ڵ�ʱ��
% ��λȫ��ת��Ϊ����

end_time = end_time * 1000;
duration = duration * 1000; 
start_time = end_time - duration; % �������ʱ��

% �󣺽�ֹ����ǰʱ��ģ�ȫ����©����
S_start_all = cacu_all_S(start_time);
S_end_all = cacu_all_S(end_time);
ans = S_end_all - S_start_all;

end

