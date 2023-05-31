# SimulationHE

 My first repository. About simulation of a heat exchanger in geothermal energy
 
 ## Projet description
 
 This project try to simulate a network of heat exchanger for geothermy in order to see the impact of different configuration of HE.
 
 Hypothesis :
 Steady state
 No convection for the external fluid
 Temperature of the external fluid is constant
 
 Here is the final equation
 
 
 ## Next
 
 There is still a lot to do :
 Relation between Area and Distance
 making it more user friendly
 modifying the external temperature or having variation in it
 
 ## How to run it
 
 This is a basic MatLab code, everything should be inside the same path.
 The function CalcHE give T(Area) , the temperature against the Area 
 The script is of one application
 
 ### How to create an HE
 
 To create a HE, you need those information
 
 Pipe
 
    NumberPipe
    ThicknessPipe
    DiameterPipe
    ThermalConductivityPipe
    Length
    Position
        
  Internal Fluid
  
    FluidObj
    FluidCoeff
    Velocity
        
 And enter them as following :
 obj = HeatExchanger(NumberPipe, ThicknessPipe, DiameterPipe, ThermalConductivityPipe, Length, Position, MassFlowRate, Temperature, Density, ThermalConductivity, Cp)
 
 ### Modelisation
 
 
 
 #### Examples
 
 here are examples of what it can do :
 
 ### First example
![Exemple](https://github.com/Youwannomax/SimulationHE/assets/107356192/639f86c1-c722-46f0-9b73-0e95ef99e9c6)
Only one heat exchangers and compare without any HE

 ### Second example
 
 ![exemple2](https://github.com/Youwannomax/SimulationHE/assets/107356192/18ffeef9-d180-4006-9ed6-302fcf8c38c4)
We can compare the benefit of adding HE along the tube


