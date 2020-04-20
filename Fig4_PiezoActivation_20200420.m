%% Piezo - Random Activation modelling actual behavior
% Arduino is connected to BNC-cable (yellow bin on D9, black pin on
% ground). The arduino board is connected to the laptop via a USB 2.0 to
% USB-a cable. 
% BNC goes into Tektronix AFG 3102 Input. The frequency generator
% is programmed with the following settings on CH2: Burst (70 Hz), 5.0 Vpp
% Amplitude, source: external, TrigDelay 0 ns, Polarity positive, Cycle
% Gate (Gatter). 
%% clear workspace
clear all
%% interbout-interval distribution:
pd_ibi = makedist('Loglogistic','mu',-0.27,'sigma',0.21);
pd_bout = makedist('Normal', 0.15, 0.1);

%% create arduino object
a = arduino;
a.configurePin('D9', 'Unset');
a.configurePin('D9', 'DigitalOutput');
%% draw ibi and bout from distributions
rng('default');
IBI_dist = [];
bout_dist = [];

totalTime = 0;
boutProfile = [0 1];

while totalTime < (3.1*3600) % will run for at least 3.1 hours
    bout = abs(random(pd_bout));
 %   a.writeDigitalPin('D9',1);
 %   pause(bout);
    totalTime = totalTime + bout;
    boutProfile = [boutProfile; totalTime 0];
  %  a.writeDigitalPin('D9',0);
    ibi = abs(random(pd_ibi));
  %  pause(ibi);
    IBI_dist = [IBI_dist, ibi];
    bout_dist = [bout_dist, bout];

    totalTime = totalTime + ibi;
    boutProfile = [boutProfile; totalTime 1];
    
end
    
clear a