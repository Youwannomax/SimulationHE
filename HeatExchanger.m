classdef HeatExchanger
    %Class Heat Exchanger
    properties
        %% Pipe
        NumberPipe
        ThicknessPipe
        DiameterPipe
        ThermalConductivityPipe
        Length
        Position
        
        %% Internal Fluid
        FluidObj %Fluid object
        FluidCoeff %Heat transfer coeffcient for the fluid 
        Velocity
       
    end
    
    methods

        % Constructor

        function obj = HeatExchanger(NumberPipe, ThicknessPipe, DiameterPipe, ThermalConductivityPipe, Length, Position, MassFlowRate, Temperature, Density, ThermalConductivity, Cp)
            obj.NumberPipe = NumberPipe;
            obj.ThicknessPipe = ThicknessPipe;
            obj.DiameterPipe = DiameterPipe;
            obj.ThermalConductivityPipe = ThermalConductivityPipe;
            obj.Length = Length;
            obj.Position = Position;
            
            % Create an instance of the Fluid class
            obj.FluidObj = Fluid(MassFlowRate, Temperature, Density, ThermalConductivity, Cp);
        end
        
        % Setter

        function obj = set.Length(obj, newLength)  
            obj.Length = newLength;
        end

        % Function

        function Velocity = CalcVelocity(obj)
            %Calculate the velocity of the fluide throught a pipe of a HE

            n = obj.NumberPipe;
            d = obj.DiameterPipe;
            W = obj.FluidObj.MassFlowRate;
            rho = obj.FluidObj.Density;

            S = pi * d ^ 2;
            Wp = W / n;         %Mass flow rate throught a pipe

            Velocity  = Wp / (rho * S);

        end

    end
end