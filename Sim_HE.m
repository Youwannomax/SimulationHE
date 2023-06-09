clear; clc; close all;

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

%% List of heat exchangers

HE1 = HeatExchanger(30, 0.1, 0.05, 20, ...
                    200, ...
                    250, ...
                    0.5, T0, ...
                    1000, ...
                    0.6, 4000);

HE2 = HeatExchanger(9, 0.1, 0.05, 400, ...
                    10, ...
                    80, ...
                    0.5, T0, 1000, 0.6, 1000);

HE3 = HeatExchanger(18, 0.1, 0.05, 400, ...
                    600, ...
                    500, ...
                    0.5, T0, 1000, 0.6, 1000);

HEs = [HE1];        % array of heat exchangers
HEs2 = [HE1, HE3];  % array of heat exchangers

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

options = odeset('Events', @(t, T) event(t, T, HEs), 'MaxStep', 1e-1); 

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
        if mod(ie(1), 2) == 1                       %Position of a HE
            currentHe = HEs((ie(1) + 1) / 2);       %Set to the HE
            remainingLength = remainingLength - (xe(end) - currentHe.Position);
            if remainingLength < 0
                remainingLength = 0;                %Avoiding negative number
            end
            currentHe.Length = remainingLength;
        else                        %End of a HE
            currentHe = Tube;       %Set to the tube
            remainingLength = remainingLength - HEs(ie(1) / 2).Length;
            if remainingLength < 0
                remainingLength = 0;                %Avoiding negative number
            end
            Tube.Length = remainingLength;          %Set remain length of the tube
        end
    end

    % Update the position for the next integration
    x = xe(end);
    xspan = [xe(end) xf];

end

% Tube without any heat exchanger
options_noHE = odeset('MaxStep', 1e-1);
[x_noHE, T_noHE] = ode15s(@(x, T) odefoncHE(x, T, Tube), [0 xf], T0, options_noHE);


%% Plot and figure

% Plot temperature vs position

plot(xResult, TResult, 'b');

hold on;

plot(x_noHE, T_noHE, 'black--')
plot(xResult, (50 + 273)*ones(1, length(TResult)), 'r')

% Vertical for each HE
for i = 1:length(HEs)
    x_start = HEs(i).Position;
    x_end = HEs(i).Position + HEs(i).Length;
    y_start = min(TResult);
    y_end = max(TResult);
    plot([x_start, x_start], [y_start, y_end], 'k-', 'LineWidth', 1.5);
    plot([x_end, x_end], [y_start, y_end], 'k-', 'LineWidth', 1.5);
    text(x_start, y_end, 'Start', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(x_end, y_end, 'End', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

hold off;

legend('Temperature of the cold fluid with Heat Exchanger','Temperature of the cold fluid without Heat Exchanger', 'Temperature of the hot fluid')

xlabel('Area (m²)');%
ylabel('Temperature (K)');


