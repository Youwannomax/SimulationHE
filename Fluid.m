classdef Fluid
    properties
        MassFlowRate
        Viscosity
        Density
        Temperature
        ThermalConductivity
        Cp
    end
    
    methods
        % Constructor
        function obj = Fluid(MassFlowRate, Temperature, Density, ThermalConductivity,Cp)
            obj.MassFlowRate = MassFlowRate;
            obj.Temperature = Temperature;
            obj.Density = Density;
            obj.ThermalConductivity =ThermalConductivity;
            obj.Cp = Cp;
        end
        
        % Calculate viscosity
        function Viscosity = CalcViscosity(obj)
            A = 2.414 * 10^-5; % Pa.s
            B = 247.8; % K
            C = 140; % K
            Viscosity = A * 10 * B / (obj.Temperature - C);
        end
    end
end
