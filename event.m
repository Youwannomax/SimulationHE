function [position, isterminal, direction] = event(x, T, HEs)
    numEvents = 2 * length(HEs);
    position = zeros(1, numEvents);      % Preallocate memory for position
    isterminal = ones(1, numEvents);     % The integration halts at these events
    direction = zeros(1, numEvents);     % The zero approached either direction

    % For each heat exchanger set up 2 events
    for i = 1:length(HEs)
        position(2 * i - 1) = x - HEs(i).Position;               % Event triggered when reaching the start of the heat exchanger
        position(2 * i) = x - (HEs(i).Position + HEs(i).Length); % Event triggered when reaching the end of the heat exchanger
    end
    
    % Set the direction of the events to detect only the first event
    direction(1:2:numEvents) = 1;   % Only trigger the event when approaching from below (increasing x)
end
