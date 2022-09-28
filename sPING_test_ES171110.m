% Emily Stephen 2017
clear variables
close all

sim_length=2000; % [ms]
Poisson_rate=2000; % [Hz] for all external Poisson input
EgAMPA = 0.25;
EgGABAA = 0.25x;
IgAMPA = 0;
IgGABAA = 0;

sPING_network_iPoisson(sim_length,Poisson_rate,EgAMPA,Poisson_rate,...
    EgGABAA,Poisson_rate,IgAMPA,Poisson_rate,IgGABAA,'debug_flag',1,'verbose_flag',1)

load(['sPING_' num2str(sim_length) 'ms_' num2str(Poisson_rate) '_' ...
    num2str(Poisson_rate) 'rAMPA_' num2str(EgAMPA) '_' ...
    num2str(IgAMPA) 'gAMPA_' num2str(Poisson_rate) '_' ...
    num2str(Poisson_rate) 'rGABAA_' num2str(EgGABAA) '_' ...
    num2str(IgGABAA) 'gGABAA.mat'])

print('Computing power spectrum...')
[f,P]=power_spectrum(mean(data.E_I_iGABAa_ISYN(data.time>=100,:),2));
slope_inds = f>=45 & f<65;
fitstats=regstats(log10(P(slope_inds)),log10(f(slope_inds)),'linear',{'yhat','rsquare','beta'});
figure;loglog(f,P)
hold on;plot(f(slope_inds),10.^fitstats.yhat,'r','linewidth',2)
title({['E:I ratio (to pyramidal neurons): ' ...
    num2str(mean(data.E_iPoissonAMPA_gPoissonAMPA)/mean(data.E_iPoissonGABAA_gPoissonGABAA))] ...
    ['45-65 Hz slope: ' num2str(fitstats.beta(2))]})
xlabel('frequency [Hz]')
ylabel('power')
%                 xlim([0 500])
print(['sPING_' num2str(sim_length) 'ms_' num2str(Poisson_rate) '_' ...
    num2str(Poisson_rate) 'rAMPA_' num2str(EgAMPA) '_' ...
    num2str(IgAMPA) 'gAMPA_' num2str(Poisson_rate) '_' ...
    num2str(Poisson_rate) 'rGABAA_' num2str(EgGABAA) '_' ...
    num2str(IgGABAA) 'gGABAA.png'],'-dpng')

%%
tinds = data.time>=100;
dt=0.00001;
SR=1/dt;
L = sum(tinds);

T = L*dt; % duration of signal in S
W = 1; % half-bandwith in Hz

params.tapers = [ceil(T*W) ceil(min(2*T*W-1,8))];
params.Fs = SR;
params.fpass = [0 500];

IPoisson = cat(2,mean(data.E_iPoissonAMPA_IPoissonAMPA(tinds,:),2),...
                 mean(data.E_iPoissonGABAA_IPoissonGABAA(tinds,:),2),...
                 mean(data.I_iPoissonAMPA_IPoissonAMPA(tinds,:),2),...
                 mean(data.I_iPoissonGABAA_IPoissonGABAA(tinds,:),2));

names = {'E_AMPA','E_GABA','I_AMPA','I_GABA'};
IPoisson = bsxfun(@minus,IPoisson,mean(IPoisson,1));
[P12_IPoisson,f] = mtspectrumc(IPoisson,params);


figure
for i=1:4,
    subplot(2,2,i)
    plot(f,log10(P12_IPoisson(:,i)))
end
