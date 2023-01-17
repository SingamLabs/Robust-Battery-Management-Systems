function [V, SOC, Vo] = battSIM(I, Batt, Delta)
    %% Reading battery ECM parameters
    Kbatt = Batt.Kbatt;
    Cbatt = Batt.Cbatt ;
    K0 = Kbatt(1); K1 = Kbatt(2); K2 = Kbatt(3);
    K3 = Kbatt(4); K4 = Kbatt(5); K5 = Kbatt(6);
    K6 = Kbatt(7); K7 = Kbatt(8);
    R0 = Batt.R0; R1 = Batt.R1; R2 = Batt.R2;
    C1 = Batt.C1; C2 = Batt.C2;
    ModelID = Batt.ModelID;
    E = Batt.SOCsf; % scaling factor
    alpha1=exp(-(Delta/(R1*C1)));
    alpha2=exp(-(Delta/(R2*C2)));
    %% Hysteresis model
    h = 0; 
    %% Determine of SOC (Coulomb counting)
    SOC=zeros(length(I),1); 
    SOC(1)=Batt.SOC; % initial SOC 
    for k=2:length(I)
        SOC(k)= SOC(k-1)+(1/(3600*Cbatt))...
            *I(k)*Delta;
        if SOC(k) < 0
            error('Battery is Empty!!')
        elseif SOC(k) > 1
            error('Battery is Full!!')
        end
    end
    %% Determination of OCV
    zs = (1 - 2*E)*SOC + E;
    Vo = K0+K1./zs + K2./(zs.^2) + ...
         K3./(zs.^3)+K4./(zs.^4) + ...
         K5*zs + K6*log(zs)+ K7*log(1-zs);
    %% Determine current through R1 and R2 
    x1=zeros(length(I),1); 
    x2=zeros(length(I),1);
    for k=1:length(I)
    x1(k+1)=alpha1*x1(k)+(1-alpha1)*I(k);
    x2(k+1)=alpha2*x2(k)+(1-alpha2)*I(k);
    end
    i1=zeros(length(I),1); 
    i2=zeros(length(I),1);
    for k=1:length(I)
        i1(k)=x1(k+1); i2(k)=x2(k+1);
    end
    %% Determination of terminal voltage 
    V=zeros(length(I),1);
    switch ModelID
        case 1
            V= I*R0;
        case 2
            V= I*R0+Vo+h;
        case 3
            V= I*R0+i1*R1+Vo+h;
        case 4
            V= I*R0+i1*R1+i2*R2+Vo+h;
    end  
end

