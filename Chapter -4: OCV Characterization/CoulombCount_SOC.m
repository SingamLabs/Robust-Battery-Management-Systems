function [SOC, Time, I] = CoulombCount_SOC(Time, I)

        cid = find(I>0);
        did = find(I<0);
        
        Time_to_charge    = Time(cid(end))-Time(cid(1));
        Time_to_discharge = Time(did(end))-Time(did(1));

        I_to_charge       = mean(abs(I(cid(1):cid(end))));
        I_to_discharge    = mean(abs(I(did(1):did(end))));

        Charge_capacity    = Time_to_charge*I_to_charge;            % Ampere-hour
        Discharge_capacity = Time_to_discharge*I_to_discharge;      % Ampere-hour
 
        SOC           = zeros(length(I),1);
        SOC(1)        = 1;

        for iter = 2:length(I)

            delta  = Time(iter) - Time(iter-1);
            
            if(I(iter))<0
                SOC(iter)  = SOC(iter-1) + (delta*I(iter))/Discharge_capacity;
            else
                SOC(iter)  = SOC(iter-1) + (delta*I(iter))/Charge_capacity;
            end

        end

        
end
