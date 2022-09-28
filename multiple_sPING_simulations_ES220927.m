% Emily Stephen 2022

sim_length=2000; % [ms]
% rates = 50:50:200;
rates = 500:500:2000;
% Poisson_rate=50; % [Hz] for all external Poisson input
for Poisson_rate=rates
% for EgAMPA=0:0.125:0.25 % conductance range for external AMPA input to pyramidal neurons
%     for EgGABAA=0:0.125:0.25 % conductance range for external GABAA input to pyramidal neurons
%         for IgAMPA=0:0.125:0.25 % conductance range for external AMPA input to interneurons
%             for IgGABAA=0:0.125:0.25 % conductance range for external GABAA input to interneurons


                EgAMPA = 0.25;
                EgGABAA = 0.25;
                IgAMPA = 0;
                IgGABAA = 0;

%                 EgAMPA = 0.25;
%                 EgGABAA = 0;%0.25;
%                 IgAMPA = 0.25; %0;
%                 IgGABAA = 0;

                sPING_network_iPoisson(sim_length,Poisson_rate,EgAMPA,Poisson_rate,...
                    EgGABAA,Poisson_rate,IgAMPA,Poisson_rate,IgGABAA,'debug_flag',1)
                
                clear data eqns s
                load(['sPING_' num2str(sim_length) 'ms_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rAMPA_' num2str(EgAMPA) '_' ...
                    num2str(IgAMPA) 'gAMPA_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rGABAA_' num2str(EgGABAA) '_' ...
                    num2str(IgGABAA) 'gGABAA.mat'])
                dsPlot(data);
                print(['sPING_' num2str(sim_length) 'ms_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rAMPA_' num2str(EgAMPA) '_' ...
                    num2str(IgAMPA) 'gAMPA_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rGABAA_' num2str(EgGABAA) '_' ...
                    num2str(IgGABAA) 'gGABAA_timeseries.png'],'-dpng')
                [f,P]=power_spectrum(mean(data.E_I_iGABAa_ISYN(10001:end,:),2));
                slope_inds = f>=45 & f<55;
%                 fitstats=regstats(log10(P(slope_inds)),log10(f(slope_inds)),'linear',{'yhat','rsquare','beta'});
                figure;plot(f,10*log(P))
%                 hold on;plot(f(slope_inds),10.^fitstats.yhat,'r','linewidth',2)
                title({['E:I ratio (to pyramidal neurons): ' ...
                    num2str(mean(data.E_iPoissonAMPA_gPoissonAMPA)/mean(data.E_iPoissonGABAA_gPoissonGABAA))]}) %...
%                     ['30-50 Hz slope: ' num2str(fitstats.beta(2))]})
                xlabel('frequency [Hz]')
                ylabel('power')
%                 xlim([0 500])
                print(['sPING_' num2str(sim_length) 'ms_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rAMPA_' num2str(EgAMPA) '_' ...
                    num2str(IgAMPA) 'gAMPA_' num2str(Poisson_rate) '_' ...
                    num2str(Poisson_rate) 'rGABAA_' num2str(EgGABAA) '_' ...
                    num2str(IgGABAA) 'gGABAA.png'],'-dpng')
                close all
%             end
%         end
%     end
end


%%

close all
figure;hold on
for Poisson_rate=rates
    load(['sPING_' num2str(sim_length) 'ms_' num2str(Poisson_rate) '_' ...
        num2str(Poisson_rate) 'rAMPA_' num2str(EgAMPA) '_' ...
        num2str(IgAMPA) 'gAMPA_' num2str(Poisson_rate) '_' ...
        num2str(Poisson_rate) 'rGABAA_' num2str(EgGABAA) '_' ...
        num2str(IgGABAA) 'gGABAA.mat'])
    
    [f,P]=power_spectrum(mean(data.E_I_iGABAa_ISYN(10001:end,:),2));
    plot(f,10*log(P))
end

xlabel('frequency [Hz]')
ylabel('power (dB)')
legend(arrayfun(@num2str, rates, 'UniformOutput', 0))

print(['sPING_' num2str(sim_length) 'ms_' mat2str(rates) '_' ...
    'rAMPA_' num2str(EgAMPA) '_' ...
    num2str(IgAMPA) 'gAMPA_' 'rGABAA_' num2str(EgGABAA) '_' ...
    num2str(IgGABAA) 'gGABAA_specSummary.png'],'-dpng')


