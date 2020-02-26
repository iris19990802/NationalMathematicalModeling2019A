
clear;clc;
load_data;
load('zhenfa_h.mat');

%% ��ά����
% ���ߣ�P_open_ce��step_du_ms

% ����ָ�꣺
% ÿ���������ѹǿ��ƽ��
% ƽ��ƫ��ֵ���������ڣ�this_ralate_delta_p


% �䲽���ֲ�����
% ed_ans_ce = 100.4;
% st_ans_ce = 100;
% step_ans_ce = 0.05;
% index_ans_size_ce = floor((ed_ans_ce-st_ans_ce)/step_ans_ce) + 1;
% 
% ed_ans_du = 4;
% st_ans_du = 3.4;
% step_ans_du = 0.06;
% index_ans_size_du = floor((ed_ans_du-st_ans_du)/step_ans_du) + 1;
% 
% cnt_ans_du = 0;
% 
% history_ralate_delta_p = zeros(index_ans_size_du,index_ans_size_ce); % ע������ά���Ⱥ�
% 
% 
% for step_du_ms = st_ans_du:step_ans_du:ed_ans_du % �ڸ�����P_open_ce�У���������͹�ֽ��ٶ�
%     cnt_ans_du = cnt_ans_du + 1;
%     cnt_ans_ce = 0;
% for P_open_ce = st_ans_ce:step_ans_ce:ed_ans_ce
%     cnt_ans_ce = cnt_ans_ce + 1;
%% ����

d_ce = 1.4;  % ���ֱ����1.4mm

P_open_ce = 100.5;  % ����ѹǿ���ڴ�ֵ���ʹ򿪲෧

% ͹�ֽ��ٶȣ�ÿ����1.5��
step_du_ms = 3.7; 

C = 0.85; % ����ϵ��

d_up = 1.4; % С��ֱ����mm��
S_up = pi * (d_up/2)^2;  % С�����

L = 500; % ��ǻ���ȣ�mm��
d_pip = 10; % ��ֱ��(mm)
V_guan = pi * (d_pip/2)^2 * L; % �����(*pi)

P_in_0 = 100;   % ���ڳ�ʼѹǿ
P_down = 6.5; % �¶��ⲿѹǿ����Զ��6.5Mpa
%% ��ʱ����

this_P_beng = 0.5;     % ��¼��ǰʱ�̱���ѹǿ
                       % ��ʼ����ֹ�㣬ѹ��λ0.5Mpa

this_du = 180;  % ��¼��ǰ�Ƕȣ���ʼΪ180������ֹ�㣩
this_V_beng = caculate_Vbeng(this_du); % ��ǰʱ�̱������

this_delta_sum = 0; % ��������ֵ
% ��¼��ǰʱ�̵Ĺ���ѹǿ
this_P_in = P_in_0;

%% ѭ��
t_st = 0;
T = 360/step_du_ms/1000;
t_ed = T * 10;
delta_t = 0.0000001; % ����

index_size = floor((t_ed-t_st)/delta_t+1); % Ԥ��������ռ��С



%% ��¼��ʷ��Ϣ
history_P_beng = zeros(index_size,1);
history_P_beng(1,1) = 0.5;
history_time = zeros(index_size,1);
history_time(1,1) = 0;
history_P_in = zeros(index_size,1);
history_P_in(1,1) = 0;
history_minus_p = zeros(index_size,1);
history_minus_p(1,1) = 0;
history_Q_leak_up = zeros(index_size,1);
history_Q_leak_up(1,1) = 0;
history_Q_leak_down = zeros(index_size,1);
history_Q_leak_down(1,1) = 0;
history_Q_leak_ce = zeros(index_size,1);
history_Q_leak_ce(1,1) = 0;

% ģ��0.1s�ڵ����,��1msΪ����

cnt = 0;
for time = t_st:delta_t:t_ed
    cnt = cnt+1;
    history_time(cnt) = time;
    
    % ���������˶���ɵ�"�ͱ�"����仯
    this_V_beng = caculate_Vbeng(this_du);
    next_V_beng = caculate_Vbeng(this_du + step_du_ms*(delta_t*1000));
    
    delta_V_beng = next_V_beng - this_V_beng;
    
    %% �����Ͽ׵�©��������������ѹǿ > ����ѹǿʱ��
    minus_p = this_P_beng - this_P_in; % ��ǰʱ��ѹǿ��
    history_minus_p(cnt) = minus_p;
    
    if minus_p > 0
        this_row = fun_P_row(this_P_beng); % rouȡ��ѹ��P(����P)����
        Q_leak_up = C*S_up*sqrt(2*minus_p/this_row); % �Ͽ�©����
    else
        Q_leak_up = 0;
    end
    history_Q_leak_up(cnt) = Q_leak_up;
    
    %% �����¿׵�©����
    % ���㵱ǰʱ��time�£�Բ̨�Ĳ�������浽this_S ��
    d_zhenfa = 2.5; % �뷧ֱ��(2.5mm)
    d_dizuo = 1.4;  % ����ֱ��(1.4mm)
    % ���㵱ǰʱ���£��뷧�����̣��浽h_t��
    h_t = zhenfa_h(mod(cnt,10^6)+1);   % ��߼���Ϊ1.2��
    % h_t����
    S_bs = pi * h_t * sind(9)*(d_zhenfa + h_t*sind(9)*cosd(9));
    S_ba = pi * (d_dizuo/2)^2;
    this_S = min(S_bs,S_ba);
    % this_S ����
    % ����¿׵�©����
    this_row_down = fun_P_row(this_P_in);
    minus_p_down = this_P_in - P_down;
    this_Q_leak = C*this_S*sqrt(2*minus_p_down/this_row_down);  % ���rou������P_in���rou
    history_Q_leak_down(cnt) = this_Q_leak;
     %% �����׵�©����
     Q_leak_ce = 0;
     if this_P_in > P_open_ce  %  ��������ѹǿ>P_open_ce,�ײſ���
         minus_p_ce = this_P_in - P_down; % ���ѹǿ��
         S_ce = (d_ce/2)^2*pi; %������
         this_rou_ce = fun_P_row(this_P_in);
         Q_leak_ce = C * S_ce * sqrt(2*minus_p_ce/this_rou_ce);
     end
     history_Q_leak_ce(cnt) = Q_leak_ce;
    
    %% �ƶ�����һʱ�̣�������һʱ��P
    % �ͱú��͹ܣ�ѹǿ�仯������Ҫ����
    % �ͱõ�ѹǿ�仯
    delta_Q_beng = -Q_leak_up;
    this_E_beng = fun_P_E(this_P_beng);
    delta_p_beng = (delta_Q_beng - delta_V_beng)*this_E_beng/this_V_beng;
    this_P_beng = this_P_beng + delta_p_beng;
    if this_P_beng<0.5
        this_P_beng = 0.5;
    end
    history_P_beng(cnt) = this_P_beng;
    % ���ڵ�ѹǿ�仯
    delta_Q_pip = Q_leak_up; 
    this_E_pip = fun_P_E(this_P_in); % ���ݹ���ѹǿP���������ϵ��E
    % ���϶˼��ʹ�����ѹǿ�仯
    delta_p_pip = delta_Q_pip * this_E_pip/V_guan;
    % ���¶�©�ʹ�����ѹǿ�仯
    delta_p_pip = delta_p_pip - this_Q_leak * this_E_pip/V_guan * delta_t * 10^3;
    % �ɲ���©�ʹ�����ѹǿ�仯
    delta_p_pip = delta_p_pip - Q_leak_ce * this_E_pip/V_guan * delta_t * 10^3;
    
    this_P_in = this_P_in + delta_p_pip;
    history_P_in(cnt) = this_P_in;
    this_delta_sum = this_delta_sum + abs(this_P_in-100)*delta_t;
    this_du = this_du + step_du_ms*(delta_t*1000); % step_du_msΪÿ"����"�ı仯ֵ
end

this_ralate_delta_p = this_delta_sum/(T*10);

% history_ralate_delta_p(cnt_ans_du,cnt_ans_ce) = this_ralate_delta_p; % ��ά��¼
% disp(P_open_ce)
% end
% disp(step_du_ms)
% end
disp("finish")
%plot(time_history,delta_p_history)
%plot(history_time,history_delta_V_beng)
%plot(history_time,history_P_beng)
figure();
plot(history_time,history_P_in)


load('fittedmodel.mat')
fun=@(x,y)feval (fittedmodel,x,y);
ed_ans_du = 4;
st_ans_du = 1;
step_ans_du = 0.3;
xx_ori = [];
for step_du_ms = st_ans_du:step_ans_du:ed_ans_du
    xx_ori = [xx_ori step_du_ms];
end

ed_ans_ce = 102;
st_ans_ce = 100;
step_ans_ce = 0.2;
yy_ori = [];
for step_ce_ms = st_ans_ce:step_ans_ce:ed_ans_ce
    yy_ori = [yy_ori step_ce_ms];
end



ed_ans_du = 4;
st_ans_du = 1;
step_ans_du = 0.1;
xx_draw = [];
for step_du_ms = st_ans_du:step_ans_du:ed_ans_du
    xx_draw = [xx_draw step_du_ms];
end

ed_ans_ce = 102;
st_ans_ce = 100;
step_ans_ce = 0.07;
yy_draw = [];
for step_ce_ms = st_ans_ce:step_ans_ce:ed_ans_ce
    yy_draw = [yy_draw step_ce_ms];
end

cnt_xx = 0;
cnt_yy = 0;
for step_du_ms = st_ans_du:step_ans_du:ed_ans_du
    cnt_xx = cnt_xx + 1;
    cnt_yy = 0;
    for step_ce_ms = st_ans_ce:step_ans_ce:ed_ans_ce
        cnt_yy = cnt_yy + 1;
        Z_draw(cnt_xx,cnt_yy) = fun(step_du_ms,step_ce_ms);
    end
end
ed_ans_du = 4;
st_ans_du = 1;
step_ans_du = 0.1;
xx_draw = [];
for step_du_ms = ed_ans_du:-step_ans_du:st_ans_du
    xx_draw = [xx_draw step_du_ms];
end


ed_ans_ce = 102;
st_ans_ce = 100;
step_ans_ce = 0.07;
yy_draw = [];
for step_ce_ms = ed_ans_ce:-step_ans_ce:st_ans_ce
    yy_draw = [yy_draw step_ce_ms];
end
figure();
[X,Y] = meshgrid(xx_draw,yy_draw);
Z_draw = Z_draw';
mesh(X,Y,Z_draw)
