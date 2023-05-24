function dTdx = odefoncHE(T, x, heatExchanger)

%Properties of the current heat exchanger


T_f = 70; %External fluid temperature(°C)
%Thermic balance
    dTdx = T_f-T;
end