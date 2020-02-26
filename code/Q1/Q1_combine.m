% ���� + ©��
clear;clc;
load_data;
P_up = 160;     % ��λ��MPa
P_in_0 = 100;   % ���ڳ�ʼѹǿ
C = 0.85; % ����ϵ��
d_up = 1.4; % С��ֱ����mm��
S_up = pi * (d_up/2)^2;  % С�����
L = 500; % ��ǻ���ȣ�mm��
d_pip = 10; % ��ֱ��(mm)
V = pi * (d_pip/2)^2 * L; % �����(*pi)
this_P_in = 100; % ��¼��ǰʱ�̵Ĺ���ѹǿ
delta_t = 0.001; % ����
p_history = [P_in_0]; % ��¼ÿһʱ�̹���ѹǿ
time_history = [0]; % ��¼ʱ��
delta_p_history = []; % ÿһʱ�̵ı仯P
Ts=0.723*(10^-3);   %% ������0��4��1
TT=Ts+0.01;

% ģ��1s�ڵ����,��1msΪ����
for time = 0+delta_t:delta_t:20
    
    minus_p = P_up - this_P_in; % ��ǰʱ��ѹǿ��
    
    this_row = fun_P_row(this_P_in); % ���ݵ�ǰʱ�̹���ѹǿP����������ܶ�rou
    
    this_E = fun_P_E(this_P_in); % ���ݵ�ǰʱ�̹���ѹǿP���������ϵ��E
    
    this_Q_in = C*S_up*sqrt(2*minus_p/this_row); % �˴�С�׵��͵�����
    
    this_T_in = mod(time,TT);
    if this_T_in > Ts
        this_Q_in = 0;
    end
    
    this_Q_leak = -fun_Q_leak(time+2.5,delta_t);  % �˴ε��͹ܵ�"©����"
    
    this_delta_Q = this_Q_in + this_Q_leak; % ����˴ε�Q�仯��( ������ & ©����)
    
    delta_p = this_delta_Q * this_E/V;
    
    delta_p_history = [delta_p_history delta_p];
    
    this_P_in = this_P_in + delta_p; % ���¹���ѹǿ
    
    p_history = [p_history this_P_in];
    time_history = [time_history time];
end

plot(time_history,p_history)

xlabel("ʱ��/s")
ylabel("ѹǿ/MPa")
sum(p_history(1,1:5*1000))/5/1000-100;
