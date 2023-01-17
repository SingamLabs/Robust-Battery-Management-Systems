function [xkk, Pkk, NIS] = EKF(xkk, Pkk, Q, R, zk, k)
    % state prediction
    x_pred = xkk/2 + 25*xkk/(1+power(xkk,2)) + 8*cos(1.2*k);
    % Linearization to obtain F:
    F = 25/(power(xkk,2) + 1) - ...
        (50*power(xkk,2))/power((power(xkk,2) + 1),2) + 1/2; 
    % Covariance of state-prediction error
    P_pred = F*Pkk*transpose(F) + Q;  
    % Measurement prediction
    z_hat = (power(x_pred,2))/(20);
    % Measurement prediction error (innovation/residual)
    inov = zk - z_hat;
    % Linearization to obtain H 
    H = x_pred/10; 
    % Covariance of the innovation/residual 
    S = R + H*P_pred*transpose(H); 
    % Filter gain
    G = (P_pred*transpose(H))/S;
    % State-update
    xkk = x_pred + G*inov ;
    % Covariance of the state-update error 
    Pkk = (1-G*H)*P_pred*(transpose(1- G*H)) + G*R*transpose(G);
    % Normalized Innovation Squares (NIS)
    NIS = (power(inov,2))/S;
end