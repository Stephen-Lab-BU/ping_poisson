function [f,P12]=power_spectrum(signal)
% Signal should be t x n 

dt=0.00001;
SR=1/dt;
L = length(signal);

T = L*dt; % duration of signal in S
W = 2; % half-bandwith in Hz

params.tapers = [ceil(T*W) ceil(min(2*T*W-1,8))];
params.Fs = SR;
params.fpass = [0 500];

[P12,f] = mtspectrumc(signal-mean(signal,1),params);