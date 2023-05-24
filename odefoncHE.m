function dydt = odefoncHE(t, y, heatExchangers)
    % ODEFONCHE ODE function for the heat exchanger system

    % Preallocate arrays for heat transfer rates and temperatures
    Q = zeros(size(heatExchangers));
    Tin = zeros(size(heatExchangers));
    Tout = zeros(size(heatExchangers));

    % Calculate the heat transfer rates and temperatures for each heat exchanger
    for i = 1:numel(heatExchangers)
        U = heatExchangers(i).calculateU();
        Tin(i) = y(i);
        Tout(i) = y(numel(heatExchangers) + i);
        Q(i) = U * (Tin(i) - Tout(i));
    end

    % Calculate the temperature derivatives for each heat exchanger
    dydt = zeros(2 * numel(heatExchangers), 1);
    for i = 1:numel(heatExchangers)
        m_dot = heatExchangers(i).FluidObj.MassFlowRate;
        Cp = heatExchangers(i).FluidObj.Cp;

        dTin_dt = (m_dot * Cp * (Tout(i) - Tin(i)) + Q(i)) / (m_dot * Cp);
        dTout_dt = (Q(i) - U * (Tout(i) - Tin(mod(i, numel(heatExchangers)) + 1))) / (m_dot * Cp);

        dydt(i) = dTin_dt;
        dydt(numel(heatExchangers) + i) = dTout_dt;
    end
end
