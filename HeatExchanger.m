classdef HeatExchanger
    properties
        %% Pipe
        NumberPipe
        ThicknessPipe
        DiameterPipe
        ThermalConductivityPipe
        
        %% Internal Fluid
        FluidObj %Fluid object
        FluidCoeff %Heat transfer coeffcient for the fluid 
        Velocity
    end
    
    methods
        % Constructor
        function obj = HeatExchanger(NumberPipe, ThicknessPipe, DiameterPipe, ThermalConductivityPipe, MassFlowRate, Temperature, Density)
            obj.NumberPipe = NumberPipe;
            obj.ThicknessPipe = ThicknessPipe;
            obj.DiameterPipe = DiameterPipe;
            obj.ThermalConductivityPipe = ThermalConductivityPipe;
            
            % Create an instance of the Fluid class
            obj.FluidObj = Fluid(MassFlowRate, Temperature, Density);
        end
        
        function Velocity = CalculV(obj)

            % Perform calculations to determine the velocity (v)

            %% Properties

            n = obj.NumberPipe;
            diameter = obj.DiameterPipe;
            W = obj.FluidObj.MassFlowRate;
            rho = obj.FluidCoeff.Density;

            %% Calculation

            SurfacePipe =  pi * ( diameter / 2 )^2;
            Wpipe = W / n;

            Velocity = Wpipe / (rho * SurfacePipe);
            
        end


        function FluidCoeff = calculateU(obj)

            % Perform calculations to determine hi

            %% Properties
            % Access properties of the HeatExchanger to use in the calculation
            diameter = obj.DiameterPipe;
            e = obj.ThicknessPipe;
            TherCondPipe = obj.ThermalConductivityPipe;

            % Access properties of the FluidObj to use in the calculation
            Velocity = obj.FluidObj.Velocity;
            density = obj.FluidObj.Density;
            Cp = obj.FluidObj.Cp;
            ThermalConductivityFluid = obj.FluidObj.ThermalConductivity;
            viscosity = obj.FluidObj.CalcViscosity;

            
            %% Calculation

            %Reynolds
            Re = density*Velocity*diameter/viscosity;

            %Prandtl
            Pr = Cp*viscosity/ThermalConductivityFluid;

            %Nusselt correlation
            Nucorr = 0.0023 * Re^0.8 * Pr^0.4;  %Dittus-Boelter equation

            %Heat transfer coeffcient for the internal fluid 
            FluidCoeff = Nucorr * ThermalConductivityFluid / diameter;

            
        end
    end
end
