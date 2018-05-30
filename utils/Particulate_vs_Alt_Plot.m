%Script to normalize dust sensor data and altitude data to same time scale
%and plot results
for i=1:1:16
%% Import Data
number="002";
filename=strcat('OPC2_',number,'.CSV');
[Bin0,Bin1,Bin2,Bin3,Bin4,Bin5,Bin6,Bin7,Bin8,Bin9,Bin10,Bin11,Bin12,Bin13,Bin14,Bin15] = import_Dust_Data(filename, 17, inf);
dust_Array=[Bin0 Bin1 Bin2 Bin3 Bin4 Bin5 Bin6 Bin7 Bin8 Bin9 Bin10 Bin11 Bin12 Bin13 Bin14 Bin15];
clear dust_normalized dust_ascent dust_descent strFigure;
addpath(genpath('../figs/'));
addpath(genpath('../data/'));
bin=sprintf("Bin%d",i-1);
Flight_name=sprintf('GL124_Bin%d',i-1);
dust=dust_Array(:,i);
load GL_124_Aprs_Alt_Data

%% Create time vectors for data sets
t_alt=linspace(0,length(Alt),length(Alt));
t_sensor=linspace(0,length(dust),length(dust));
t_sensor=t_sensor*1.4;
t_alt=(t_alt*60)+271.71;
%% Interpolate altitude data
dust_normalized=interp1(t_sensor,dust,t_alt);
dust_normalized=dust_normalized';
%% Split datasets into ascent and descent
[~,max_index]=max(Alt);
Alt_ascent=Alt(1:max_index);
dust_ascent=dust_normalized(1:max_index);
Alt_descent=Alt(max_index+1:end);
dust_descent=dust_normalized(max_index+1:end);
%% Plot 
scatter(dust_ascent,Alt_ascent,'Blue');
hold on;
scatter(dust_descent,Alt_descent,'Red');
ylabel("Altitude (ft)");
xlabel("Particulate Counts");
a=" vs Altitude";
Title=strcat(bin,a);
title(Title);
legend("Ascent","Descent");
hold off;
%% Save figure
strFigure=strcat('../figs/',Flight_name,'_Particulates_vs_Altitude.png');
saveas(gcf, strFigure); %automatically save a figure each time the script is run
end
