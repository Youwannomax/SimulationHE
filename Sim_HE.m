clear; clc; close all;

%% Initialisation of Heat Exchanger

% Define parameters for the internal fluid

Density = 1000;
ThermalConduc = 0.6;
Cp = 4000;

% Define parameters for the Tube
nT = 1;
nThick = 0.05;
DiamT = 0.70;
ThermalT = 40;
LT = 70;   % Length of the tube
PositionT = 0;
MassFlowRate = 0.5;




% Initial temperature of fluid
T0 = 35 + 273;


% The tube is considered as a heat exchanger
Tube = HeatExchanger(nT, nThick, DiamT, ThermalT, ...
                    LT, ...                     % Lenght L
                    PositionT, ...                      % Position 0
                    MassFlowRate, ...
                    T0, ...                     % Temperature
                    Density, ThermalConduc, Cp);

A = LT * pi * DiamT ;

%start with tube as a heat exchanger
currentHe = Tube; 

%% List of heat exchangers

HE1 = HeatExchanger(18, 0.05, 0.07, 400, ...
                    1, ...
                    2, ...
                    0.5, T0, ...
                    1000, ...
                    0.6, 4000);

HE2 = HeatExchanger(18, 0.1, 0.05, 400, ...
                    10, ...
                    80, ...
                    0.5, T0, 1000, 0.6, 1000);

HE3 = HeatExchanger(18, 0.1, 0.05, 400, ...
                    600, ...
                    500, ...
                    0.5, T0, 1000, 0.6, 1000);


HEs = [Tube];        % array of heat exchangers
HEs2 = [HE1, HE2];  % array of heat exchangers

%% Initialisation of the integration

% Initialize the result

AResult = [];
TResult = [];


% Initial position (Area)
Ae = 0;
Af = A;     %Maximum Area
y0 = T0;
xspan = [0 Af];

% Calculate remaining length
remainingArea = LT - sum([HEs.Length]);


%% Integration

options = odeset('Events', @(t, T) event(t, T, HEs, DiamT), 'MaxStep',0.1); 

while Ae < Af
    
    % Ae :   position at the event
    % ye :   temperature at the event
    % ie :   "id" of the event

    [A, T, Ae, ye, ie] = ode45(@(x, T) odefoncHE(A, T, currentHe), xspan, y0, options);
    
    

    % debug
    disp("Event(s) trigerred : " + ie);
    disp("Position :" + A(end))
    disp("Position of the event :" + Ae)
    y0 = T(end);
 
    % Store the results
    AResult = [AResult; A];
    TResult = [TResult; T];

    if A(end) >= Af
        break;
    end
    
    %% Change configuration to the heat exchanger

    if length(ie) > 1

        warning('Multiple events occurred. Taking the last one.');
        ie = ie(end);

    end

    if isempty(ie)
        currentHe = Tube;
        remainingArea = remainingArea - (Af - Ae(end));
        if remainingArea < 0
            remainingArea = 0;
        end
        Tube.Length = remainingArea;
    else
        if mod(ie(1), 2) == 1                       %Position of a HE
            currentHe = HEs((ie(1) + 1) / 2);       %Set to the HE
            remainingArea = remainingArea - (Ae(end) - currentHe.Position);
            if remainingArea < 0
                remainingArea = 0;                %Avoiding negative number
            end
            currentHe.Length = remainingArea;
        else                        %End of a HE
            currentHe = Tube;       %Set to the tube
            remainingArea = remainingArea - HEs(ie(1) / 2).Length;
            if remainingArea < 0
                remainingArea = 0;                %Avoiding negative number
            end
            Tube.Length = remainingArea;          %Set remain length of the tube
        end
    end

    % Update the position for the next integration
    A = Ae(end);
    xspan = [Ae(end) Af];

end

% Tube without any heat exchanger
options_noHE = odeset('MaxStep', 1e-1);
[x_noHE, T_noHE] = ode15s(@(x, T) odefoncHE(x, T, Tube), [0 Af], T0);


%% Plot and figure

% Plot temperature vs position

plot(AResult, TResult, 'b');

hold on;

plot(x_noHE, T_noHE, 'black--')
plot(AResult, (50 + 273)*ones(1, length(TResult)), 'r')

% Vertical for each HE
for i = 1:length(HEs)
    x_start = pi * DiamT * HEs(i).Position;
    x_end = x_start + HEs(i).NumberPipe * pi * HEs(i).DiameterPipe * HEs(i).Length;
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


