function dTdx = odefoncHE(x, T, heatExchanger)
%% Properties of the HE

rho = heatExchanger.FluidObj.Density;
Cp = heatExchanger.FluidObj.Cp;
W = heatExchanger.FluidObj.MassFlowRate;
d = heatExchanger.DiameterPipe;
e = heatExchanger.ThicknessPipe;
Kp = heatExchanger.ThermalConductivityPipe;
heatExchanger.FluidObj.Temperature = T;         %use the setter function

%% Calculation

% Reynolds
Re = (rho * heatExchanger.CalcVelocity * d) / heatExchanger.FluidObj.CalcViscosity;

% Prandt
Pr = Cp * heatExchanger.FluidObj.CalcViscosity / heatExchanger.FluidObj.ThermalConductivity;

% Nusselt

Nu = 0.023 * Re ^ 0.8 * Pr ^ 0.4;

% Heat transfert coefficient

hi = Nu * d / heatExchanger.FluidObj.ThermalConductivity;

T_f = 50; %External fluid temperature(°C)

%Thermic balance
    dTdx = (T_f-T) * d^2 * pi / ((hi ^-1 + e/Kp) * W * Cp);

end