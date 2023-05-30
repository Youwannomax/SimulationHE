function [X, T] = CalcHE (HEs)

%% Initialisation of Heat Exchanger

% Define the tube's length
L = 2000;   % Length of the tube


% Initial temperature of fluid
T0 = 35 + 273;


% The tube is considered as a heat exchanger
Tube = HeatExchanger(1, 0.1, 0.05, 400, ...
                    L, ...                      % Lenght L
                    0, ...                      % Position 0
                    0.5, ...
                    T0, ...                     % Temperature
                    1000, 0.6, 4000);

%start with tube as a heat exchanger
currentHe = Tube; 

%% Initialisation of the integration

% Initialize the result

xResult = [];
TResult = [];


% Initial position (Area)
xe = 0;
xf = L;
y0 = T0;
xspan = [0 xf];

% Calculate remaining length
remainingLength = L - sum([HEs.Length]);

%% Integration

options = odeset('Events', @(t, T) event(t, T, HEs), 'MaxStep', 1e-1);  % Adjust 'MaxStep' accordingly


while xe < xf
    
    % xe :   position at the event
    % ye :   temperature at the event
    % ie :   "id" of the event

    [x, T, xe, ye, ie] = ode45(@(x, T) odefoncHE(x, T, currentHe), xspan, y0, options);
    
    

    % debug
    disp("Event(s) trigerred : " + ie);
    disp("Position :" + x(end))
    disp("Position of the event :" + xe)
    y0 = T(end);
 
    % Store the results
    xResult = [xResult; x];
    TResult = [TResult; T];

    if x(end) >= xf
        break;
    end
    
    %% Change configuration to the heat exchanger

    if length(ie) > 1

        warning('Multiple events occurred. Taking the last one.');
        ie = ie(end);

    end

    if isempty(ie)
        currentHe = Tube;
        remainingLength = remainingLength - (xf - xe(end));
        if remainingLength < 0
            remainingLength = 0;
        end
        Tube.Length = remainingLength;
    else
        if mod(ie(1), 2) == 1
            currentHe = HEs((ie(1) + 1) / 2);
            remainingLength = remainingLength - (xe(end) - currentHe.Position);
            if remainingLength < 0
                remainingLength = 0;
            end
            currentHe.Length = remainingLength;
        else
            currentHe = Tube;
            remainingLength = remainingLength - HEs(ie(1) / 2).Length;
            if remainingLength < 0
                remainingLength = 0;
            end
            Tube.Length = remainingLength;
        end
    end

    % Update the position for the next integration
    x = xe(end);
    xspan = [xe(end) xf];

end

X = xResult;
T = TResult;

end