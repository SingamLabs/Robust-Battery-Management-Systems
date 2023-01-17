function [xkk, Pkk, NIS] = EKFmm(xkk, Pkk, Q, R, zk, k)
    % state predication
    x_pred =  xkk/2 + 25*xkk/(1+xkk^2) + 8*cos(1.3*k);
    % Linearization to obtain F:
    F = 25/(xkk^2 + 1) - (50*xkk^2)/(xkk^2 + 1)^2 + 1/2; 
    % Covariance of state-prediction error:
    P_pred = F*Pkk*F' + Q;  
    % Measurement prediction:
    z_hat = (x_pred^2)/(20);
    % Measurement prediction error (innovation/residual)
    inov  = zk - z_hat;
    % Linearization to obtain H :
    H = x_pred/10; 
    % Covariance of the innovation/residual: 
    S   = R + H*P_pred*H'; 
    % Filter gain:
    G  = (P_pred*H')/S;
    % State-update:
    xkk  = x_pred + G*inov ;
    % Covariance of the state-update error: 
    Pkk  = (1-G*H)*P_pred*(1- G*H)' + G*R*G';
    % Normalized Innovation Squares (NIS)
    NIS   = (inov^2)/S;
end