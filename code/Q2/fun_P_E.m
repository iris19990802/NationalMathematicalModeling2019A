function [this_E] = fun_P_E(this_P)
% 根据当前压强P，计算对应的弹性系数E
this_E = 0.02893*(this_P.*this_P) + 3.077*this_P + 1572;

end

