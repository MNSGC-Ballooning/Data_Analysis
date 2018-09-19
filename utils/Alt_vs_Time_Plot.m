%Script to generate Altitude vs Time data for HAB flight
close all
clear all
flightNum = 'GL131';
flightLog = 'FLOG11.CSV';
opc_tOffset = 60;
n=2;
fPath1 = strcat('../data/',flightNum,'/');
fPath2 = strcat('../figs/',flightNum,'/');
addpath(genpath(fPath2));
addpath(genpath(fPath1));
%% Import Data
[t,~,~,Alt,~,~,Fix,~,~,~,~,~,~,~,~,~,~] = import_FlightLog(flightLog, 2, inf);
%% Process Data
for i=1:1:length(Alt)
    if(Fix(i)=='No Fix')
        Alt(i)=NaN;
    end
    [Y, M, D, H, MN, S] = datevec(t(i));
    t_Altd(i)=H*3600+MN*60+S;
end
Alt=fillmissing(Alt,'linear');
[~,max_idx]=max(Alt);
Alt_ascent = (Alt(1:max_idx))/1000;
t_ascent = (t_Altd(1:max_idx))/60;
Alt_descent = (Alt(max_idx+1:2200))/1000;
t_descent = (t_Altd(max_idx+1:2200))/60;
h_adot=(mean2(diff(Alt_ascent)./diff(t_ascent)))*1000;
h_ddot=(mean2(diff(Alt_descent)./diff(t_descent)))*1000;
aidx=length(t_ascent)-500;
didx=length(t_descent)-300;
ta=t_ascent(aidx);
Alta=Alt_ascent(aidx);
td=t_descent(didx);
Altd=Alt_descent(didx);
maxAlt=Alt_ascent(max_idx);
tmax=t_ascent(max_idx);


%% Plot Data
plot(t_Altd/60,Alt/1000);
xlabel("Time in minutes");
ylabel("Altitude in kft");
title("MURI Altitude vs Time");
hdot1=sprintf('Ascent Rate = %f ft/min', h_adot);
hdot2=sprintf('Descent Rate = %f ft/min', h_ddot);
MAX=sprintf('Max Alt = %f ft', floor(maxAlt*1000));
text(ta,Alta,hdot1,'HorizontalAlignment','Left');
text(td,Altd,hdot2,'HorizontalAlignment','Left');
text(tmax,maxAlt,MAX,'HorizontalAlignment','Left');
set(gca, 'FontSize', 14); %make font larger
strFigure=strcat(fPath2,flightNum,'_Time_vs_Alt.png');
saveas(gcf, strFigure); %automatically save a figure each time the script is run

