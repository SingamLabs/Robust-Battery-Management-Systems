function [xkk, Pkk, NIS] = KF(x0, P0, F, Q, H, R, zk)
    %state prediction
    x_pred = F*x0; 
    %state prediction covariance
    P_pred = F*P0*transpose(F) + Q ;   
    %measurement prediction
    z_hat = H*x_pred;    
    %innovation
    inov = zk - z_hat;   
    %innovation covariance
    S = R + H*P_pred*transpose(H);
    %kalman gain
    G = P_pred*transpose(H)*inv(S); 
    %state update
    xkk = x_pred + G*inov; 
    %covariance update
    Pkk = P_pred - G*S*transpose(G); 
    % NIS
    NIS = transpose(inov)*inv(S)*inov; 
end

