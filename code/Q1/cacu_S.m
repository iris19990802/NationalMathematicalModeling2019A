function [ans] = cacu_S(end_time) % ���룺��ʱ�̣���100ms�������ڵ�λ��
% ���㵱ǰ�����ڵ����
if end_time <= 0.2 % 0.2 ����  % ������
    ans = end_time * (end_time * 100)/2;
    
elseif end_time>0.2 & end_time<=2.2   % ������ + ����
    ans = 0.2*20/2 + 20*(end_time - 0.2);
    
elseif end_time>2.2 & end_time<=2.4 % ������ + ���� + ����
    ans = 0.2*20/2 + 20*(2.2-0.2) + (20 + (2.4-end_time)*100)/2 * (end_time-2.2);
    
elseif end_time>2.4 & end_time<=100 % ȫ�����
    ans = 0.2*20/2*2 + (2.2-0.2)*20;

end

