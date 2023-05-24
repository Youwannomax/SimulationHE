function [value, isterminal, direction] = event(t, y, heatExchangers)
    % EVENT Event function for the heat exchanger system

    x = y(1);  % Position of fluid in the tube

    % Initialize event values
    value = zeros(2 * size(heatExchangers));
    isterminal = zeros(2 * size(heatExchangers));
    direction = zeros(2 * size(heatExchangers));

    % Check if fluid is at the location of each heat exchanger
    for i = 1:numel(heatExchangers)
        %Start
        value(i) = x - heatExchangers(i).Position;
        isterminal(i) = 1;          % Stop integration when fluid reaches a heat exchanger
        direction(i) = 1;           % Detect when fluid is moving towards a heat exchanger
        %end
        value(i+1) = x - (heatExchangers(i).Position + heatExchangers(i).Length);
        isterminal(i+1) = 1;        % Stop integration when fluid reaches the end
        direction(i+1) = 1;         % Detect when fluid is moving towards the end
        
    end
end