function [ans] = cacu_zhenfa_S(time)

% ���أ���ǰʱ��time�£�Բ̨�Ĳ����
d_zhenfa = 2.5; % �뷧ֱ��(2.5mm)
d_dizuo = 1.4;  % ����ֱ��(1.4mm)
h_t = fun_zhenfa_t_h(time); % ��ǰʱ���£��뷧������
% time��1sΪ��λ
S_bs = pi * h_t * sind(9)*(d_zhenfa + h_t*sind(9)*cosd(9));
S_ba = pi * (d_dizuo/2)^2;

ans = min(S_bs,S_ba);

end
