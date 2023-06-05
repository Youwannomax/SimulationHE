T0 = 273+35;
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
HEs2 = [HE1, HE3];        % array of heat exchangers

CalcHE = @CalcHE;
[X1, T1] = CalcHE(HEs);
[X2, T2] = CalcHE(HEs2);


% Tube without any heat exchanger
options_noHE = odeset('MaxStep', 1e-1);
[x_noHE, T_noHE] = ode15s(@(x, T) odefoncHE(x, T, Tube), [0 xf], T0, options_noHE);

plot(xResult, TResult, 'b');

hold on;

plot(x_noHE, T_noHE, 'black--')
plot(xResult, (50 + 273)*ones(1, length(TResult)), 'r')

% Vertical for each HE

plot(x_noHE, T_noHE, 'black--');

hold on;

plot(xResult, (50 + 273)*ones(1, length(TResult)), 'r')
plot(X1, T1, 'blue')
plot(X2, T2, 'black')

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

for i = 1:length(HEs2)
    x_start = HEs2(i).Position;
    x_end = HEs2(i).Position + HEs2(i).Length;
    y_start = min(TResult);
    y_end = max(TResult);
    plot([x_start, x_start], [y_start, y_end], 'k-', 'LineWidth', 1.5);
    plot([x_end, x_end], [y_start, y_end], 'k-', 'LineWidth', 1.5);
    text(x_start, y_end, 'Start', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(x_end, y_end, 'End', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

hold off;


xlabel('Area (m²)');%
ylabel('Temperature (K)');
