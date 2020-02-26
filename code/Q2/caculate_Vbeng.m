function [this_Vbeng] = caculate_Vbeng(du)

% 输入角度值（0～360），给出对应柱塞容积
du = mod(du,360); % 去掉360周期
rad = du/360*2*pi; % 角度值转化为rad值
D_this = fun_rad_h(rad); % 得到当前角度对应的升程（极径）

D_max = 7.239; % 上极点极径(mm)
D_min = 2.413; % 下极点极径
d = 5; % 柱塞直径

this_Vbeng = (D_max-D_this)*(d/2)^2 * pi + 20;

end

