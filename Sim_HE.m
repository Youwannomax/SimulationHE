clear; clc; close all;

%% Initialisation

% Define the tube's length
L = 100;  % Length of the tube
xf = L;

% Initialize the result and the domain
xspan = [0 xf];
Yf = [];
xResult = [];
TResult = [];

% Initial temperature of fluid
T0 = 35;
y0 = T0;


%The tube is considered as a heat exchanger
Tube = HeatExchanger(1, 0.1, 0.05, 400, ...
                    L, ...                      %Lenght L
                    0, ...                      %Position 0
                    0.5, 300, 1000, 0.6, 1000);

%start with tube as a heat exchanger
currentHe = Tube; 

%% List of heat exchanger 

HE1 = HeatExchanger(6, 0.1, 0.05, 400, ...
                    40, 20, ...
                    0.5, 300, 1000, 0.6, 1000);

%HE2
%HE3
%...

HEs = [HE1];        %array of heat exchanger

%%


options = odeset('Events',@(t, T) event(t, T, HEs),'MaxStep',1e-2);

% Initial position
x = 0;

while x < xf
    
    %xe :   position at the event
    %ye :   temperature at the event
    %ie :   "id" of the event

    [x, T, xe, ye, ie] = ode45(@(x, T) odefoncHE(x, T, currentHe), xspan, y0, options);
    xspan = [xe xf];
    y0 = T(end);

    % Store the results
    xResult = [xResult; x];
    TResult = [TResult; T];
    
    %% Change configuration to the heat exchanger
    if mod(ie, 2) == 1                         % If event number is odd, we are at the start of a heat exchanger
        currentHe = HEs((ie + 1)/2);           % Change to the corresponding heat exchanger
    else                                       % If event number is even, we are at the end of a heat exchanger
        currentHe = Tube;                      % Change back to the tube
    end
    
    % Update the position for the next integration
    x = xe;
end

% Plot temperature vs position
plot(xResult, TResult);
xlabel('Position (m)');
ylabel('Temperature (°C)');