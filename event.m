function [position, isterminal, direction] = event(A, T, HEs, DiamT)
    numEvents = 2 * length(HEs);
    position = zeros(1, numEvents);      % Preallocate memory for position
    isterminal = ones(1, numEvents);     % The integration halts at these events
    direction = zeros(1, numEvents);     % The zero approached either direction

    % For each heat exchanger set up 2 events
    for i = 1:length(HEs)
        % Convert position to area
        AreaStart = pi * DiamT * HEs(i).Position;
        AreaEnd = AreaStart + HEs(i).NumberPipe * pi * HEs(i).DiameterPipe * HEs(i).Length;

        position(2 * i - 1) = A - AreaStart;               % Event triggered when reaching the start of the heat exchanger
        position(2 * i) = A - AreaEnd;                      % Event triggered when reaching the end of the heat exchanger
    end
    
    % Set the direction of the events to detect only the first event
    direction(1:2:numEvents) = 1;   % Only trigger the event when approaching from below (increasing A)
end
