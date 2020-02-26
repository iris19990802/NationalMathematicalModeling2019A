clear;clc;
data_P_rou = xlsread('../����3-����ģ����ѹ���ĸ���.xlsx');
data_tulun = xlsread('../����1-͹�ֱ�Ե����.xlsx');
data_zhenfa_row = load('../data_zhenfa_row');
data_zhenfa = data_zhenfa_row.data_zhenfa;
clear data_zhenfa_row

delta_t = 0.0000001*1000;  % ��λת��Ϊms(1e-4 ��)
% ����ʱ��(100ms���ڣ�0.1s����)
% ����delta_t,תΪ�������б��еĵڼ����±�
% ֱ�ӷ����б��е�ֵ������d

% ��ֵ�뷧�˶��켣��delta_t = 1e-4��
t = data_zhenfa(1:250,1);
d = data_zhenfa(1:250,2);

t_1 = data_zhenfa(1:46,1);
d_1 = data_zhenfa(1:46,2);
t_3 = data_zhenfa(201:246,1);
d_3 = data_zhenfa(201:246,2);


xx_1 = [0:delta_t:0.45]';
yy_1 = interp1(t_1,d_1,xx_1,'pchip');

xx_3 = [2:delta_t:2.45]';
yy_3 = interp1(t_3,d_3,xx_3,'pchip');

%% 
t_st = 0;
t_ed = 100;

index_size = floor((t_ed-t_st)/delta_t+3); % Ԥ��������ռ��С

h_history = zeros(index_size,1);
t_history = zeros(index_size,1);

cnt = 0;
for time=0:delta_t:0.45
    cnt = cnt+1;
    t_history(cnt,1) = time;
    this_h = yy_1(cnt,1);
    h_history(cnt,1) = this_h;
end


for time=0.45+delta_t:delta_t:2
    cnt = cnt+1;
    t_history(cnt,1) = time;
    h_history(cnt,1) = 2;
end

cntx = 0;
for time = 2+delta_t:delta_t:2.45
    cnt = cnt+1;
    cntx = cntx + 1;
    t_history(cnt,1) = time;
    this_h = yy_3(cntx,1);
    h_history(cnt,1) = this_h;
end


for time = 2.45+delta_t:delta_t:100
    cnt = cnt+1;
    t_history(cnt,1) = time;
    h_history(cnt,1) = 0;
end
%plot(t_history,h_history)
zhenfa_h = h_history;
zhenfa_t = t_history;
clear t_history h_history xx_1 xx_3 yy_1 yy_3 t_1 t_3 d_1 d_3 cnt t d this_h data_zhenfa time delta_t index_size t_ed t_st