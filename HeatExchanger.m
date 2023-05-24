classdef HeatExchanger
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
        % The rest of your methods here...
    end
end
