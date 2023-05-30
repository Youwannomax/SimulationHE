function dT = odefoncHE(A, T, heatExchanger)
%% Properties of the HE

rho = heatExchanger.FluidObj.Density;
Cp = heatExchanger.FluidObj.Cp;
W = heatExchanger.FluidObj.MassFlowRate;
d = heatExchanger.DiameterPipe;
e = heatExchanger.ThicknessPipe;
Kp = heatExchanger.ThermalConductivityPipe;
n = heatExchanger.NumberPipe;
heatExchanger.FluidObj.Temperature = T;         % use the setter function

%% Calculation

% Reynolds
Re = (rho * heatExchanger.CalcVelocity * d) / heatExchanger.FluidObj.CalcViscosity;

% Prandt
Pr = Cp * heatExchanger.FluidObj.CalcViscosity / heatExchanger.FluidObj.ThermalConductivity;

% Nusselt

Nu = 0.023 * Re ^ 0.8 * Pr ^ 0.4;

% Heat transfert coefficient
%local
hi = Nu * d / heatExchanger.FluidObj.ThermalConductivity;

%global
invU = 1 / hi + e / Kp;
psi = -1/ (W * Cp);


T_f = 50 + 273; %External fluid temperature(°C)

%Thermic balance       dT/dA
    dT =  - n * psi * (invU ^ (-1)) * (T_f - T );     % /dA

end