clear; clc; close all;

%% Initialisation

% Define the tube's length
L = 140;  % Length of the tube

% Initialize the result
xResult = [];
TResult = [];

% Initial temperature of fluid
T0 = 35;


%The tube is considered as a heat exchanger
Tube = HeatExchanger(1, 0.1, 0.05, 400, ...
                    L, ...                      %Lenght L
                    0, ...                      %Position 0
                    0.5, T0, 1000, 0.6, 1000);

%start with tube as a heat exchanger
currentHe = Tube; 

%% List of heat exchanger 

HE1 = HeatExchanger(6, 0.1, 0.05, 400, ...
                    40, ...
                    20, ...
                    0.5, T0, 1000, 0.6, 1000);

HE2 = HeatExchanger(9, 0.1, 0.05, 400, ...
                    40, ...
                    20, ...
                    0.5, T0, 1000, 0.6, 1000);

%HE2
%HE3
%...

HEs = [HE1];        %array of heat exchanger

%%

remainingLength = L - sum([HEs.Length]);  % calculate remaining length after all heat exchangers


options = odeset('Events',@(t, T) event(t, T, HEs),'MaxStep',1e-2);

% Initial position
xe = 0;
xf = L;
y0 = T0;
xspan = [0 xf];

while xe < xf
    
    %xe :   position at the event
    %ye :   temperature at the event
    %ie :   "id" of the event

    [x, T, xe, ye, ie] = ode45(@(x, T) odefoncHE(x, T, currentHe), xspan, y0, options);
    xspan = [xe(end) xf];
    y0 = T(end);

    % Store the results
    xResult = [xResult; x];
    TResult = [TResult; T];

    remainingLength = remainingLength - currentHe.Length;  % update remaining length
    Tube.Length = remainingLength;                         % update length of the tube
    
    %% Change configuration to the heat exchanger

    if length(ie) > 1

        warning('Multiple events occurred. Taking the first one.');
        ie = ie(1);

    end

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