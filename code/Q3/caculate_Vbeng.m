function [this_Vbeng] = caculate_Vbeng(du)

% ����Ƕ�ֵ��0��360����������Ӧ�����ݻ�
du = mod(du,360); % ȥ��360����
rad = du/360*2*pi; % �Ƕ�ֵת��Ϊradֵ
D_this = fun_rad_h(rad); % �õ���ǰ�Ƕȶ�Ӧ�����̣�������

D_max = 7.239; % �ϼ��㼫��(mm)
D_min = 2.413; % �¼��㼫��
d = 5; % ����ֱ��

this_Vbeng = (D_max-D_this)*(d/2)^2 * pi + 20;

end

