sim_length=1000; % [ms]
Poisson_rate=1000; % [Hz] for all external Poisson input
for EgAMPA=0:0.125:0.25 % conductance range for external AMPA input to pyramidal neurons
    for EgGABAA=0:0.125:0.25 % conductance range for external GABAA input to pyramidal neurons
        for IgAMPA=0:0.125:0.25 % conductance range for external AMPA input to interneurons
            for IgGABAA=0:0.125:0.25 % conductance range for external GABAA input to interneurons
                sPING_network_iPoisson(sim_length,Poisson_rate,EgAMPA,Poisson_rate,...
                    EgGABAA,Poisson_rate,IgAMPA,Poisson_rate,IgGABAA)
                
                clear data eqns s
                load(['sPING_' num2str(sim_length) 'ms_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rAMPA_' num2str(EgAMPA) '_' ...
                    num2str(IgAMPA) 'gAMPA_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rGABAA_' num2str(EgGABAA) '_' ...
                    num2str(IgGABAA) 'gGABAA.mat'])
                [f,P]=power_spectrum(mean(data.E_I_iGABAa_ISYN(10001:end,:)'));
                fitstats=regstats(log10(P(37:46)),log10(f(37:46)),'linear',{'yhat','rsquare','beta'});
                figure;loglog(f,P)
                hold on;plot(f(37:46),fitstats.yhat,'r','linewidth',2)
                title({['E:I ratio (to pyramidal neurons): ' ...
                    num2str(mean(data.E_iPoissonAMPA_gPoissonAMPA)/mean(data.E_iPoissonGABAA_gPoissonGABAA))] ...
                    ['30-50 Hz slope: ' num2str(fitstats.beta(2))]})
                xlabel('frequency [Hz]')
                ylabel('power')
%                 xlim([0 500])
                print(['sPING_' num2str(sim_length) 'ms_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rAMPA_' num2str(EgAMPA) '_' ...
                    num2str(IgAMPA) 'gAMPA_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rGABAA_' num2str(EgGABAA) '_' ...
                    num2str(IgGABAA) 'gGABAA.png'],'-dpng')
                close all
            end
        end
    end
end