clear; clc; close all;

% Define the options for the ODE solver
options = odeset('Events', @event, 'MaxStep', 1e-1);

% Define the properties of the fluid
MassFlowRate = 0.05; % kg/s
Temperature = 25; % Initial temperature of the fluid (°C)
Density = 1000; % Density of the fluid (kg/m^3)
ThermalConductivity = 0.6; % Thermal conductivity of the fluid (W/(m*K))
Cp = 4186; % Specific heat capacity of the fluid (J/(kg*K))

% Create instances of the HeatExchanger class
HE1 = HeatExchanger(1, 0.001, 0.05, 40, MassFlowRate, Temperature, Density);
HE2 = HeatExchanger(2, 0.001, 0.05, 30, MassFlowRate, Temperature, Density);

% Initial conditions for the ODE solver
tspan = [0 10]; % Time span for the simulation
y0 = [Temperature, Temperature, Temperature, Temperature]; % Initial temperatures of the inlet and outlet fluids for both heat exchangers

% Initialize variables
Yf = [];
te = 0;

while te < 1000
    % Solve the ODE system
    [t, Y, te, ye, ie] = ode15s(@(t, y) odefoncHE(t, y, HE1, HE2), tspan, y0, options);
    
    % Handle events
    if ie == 1
        % Heat Exchanger 1 position event
        HE1.FluidObj.Cp = Cp; % Switch to two-phase state
        y0(1:2) = ye(1:2);
    elseif ie == 2
        % End of Heat Exchanger 1 event
        y0(1:2) = ye(1:2);
    elseif ie == 3
        % Heat Exchanger 2 position event
        HE2.FluidObj.Cp = Cp; % Switch to two-phase state
        y0(3:4) = ye(3:4);
    elseif ie == 4
        % End of Heat Exchanger 2 event
        y0(3:4) = ye(3:4);
    end
    
    Yf = [Yf Y'];
end
