function [value, isterminal, direction] = event(t, y, heatExchangers)
    % EVENT Event function for the heat exchanger system

    x = y;  % Position of fluid in the tube

    % Initialize event values
    n = numel(heatExchangers);  % Number of heat exchangers
    value = zeros(1, 2 * n);
    isterminal = ones(1, 2 * n);
    direction = ones(1, 2 * n);

    % Check if fluid is at the location of each heat exchanger
    for i = 1:n
        % Start of heat exchanger
        idxStart = 2 * (i - 1) + 1;
        value(idxStart) = x - heatExchangers(i).Position;

        % End of heat exchanger
        idxEnd = 2 * i;
        value(idxEnd) = x - (heatExchangers(i).Position + heatExchangers(i).Length);
    end
end
