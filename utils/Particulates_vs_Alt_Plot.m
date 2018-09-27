% Script that plots OPC particle data vs GPS altitude from the MURI SHADOM
% payload
% MURI Ballooning
% 7/30/2018
% Written by Garrett Ailts
clear all
close all
flightNum = 'HASP_2018';
dustFile = 'OPC2_000.CSV';
flightLog = 'MURI_Data.csv';
opc_tOffset = 60;
n=2;
fPath1 = strcat('../data/',flightNum,'/');
fPath2 = strcat('../figs/',flightNum,'/');
addpath(genpath(fPath2));
addpath(genpath(fPath1));
%% Parameters
mTOft=3.2808399;
%% Import Data
[Bin0,Bin1,Bin2,Bin3,Bin4,Bin5,Bin6,Bin7,Bin8,Bin9,Bin10,Bin11,Bin12,Bin13,Bin14,Bin15] = import_Dust_Data(dustFile, 17, inf);
dust_Array=[Bin0 Bin1 Bin2 Bin3 Bin4 Bin5 Bin6 Bin7 Bin8 Bin9 Bin10 Bin11 Bin12 Bin13 Bin14 Bin15];
Alt = import_HASP_Alt(flightLog, 1, inf);
Alt=Alt(1:end-opc_tOffset).*mTOft;

% for i=1:1:length(Alt)
%     if(Fix(i)=='No Fix')
%         Alt(i)=NaN;
%     end
%     [Y, M, D, H, MN, S] = datevec(t(i));
%     t_Altd(i)=H*3600+MN*60+S;
% end
%Alt=fillmissing(Alt,'linear');
%Alt=Alt';

%% Obtain OPC Time Vector
t_sensor = linspace(0,length(Bin0),length(Bin0));
t_alt = linspace(0,length(Alt),length(Alt));
t_sensor = (1.4 * t_sensor);
parfor s=1:1:16
%% Define Dust Dataset
dust = dust_Array(:,s);
%% Interpolate Alt Data
Alt_normalized=interp1(t_alt,Alt,t_sensor);
Alt_normalized = (Alt_normalized')/1000;
%% Split Datasets Into Ascent and Descent
[~,max_index]=max(Alt_normalized);
Alt_ascent=Alt_normalized(1:max_index);
dust_ascent=dust(1:max_index);
Alt_descent=Alt_normalized(max_index+1:end);
dust_descent=dust(max_index+1:end);
%% Plot 
%P=polyfit(dust,Alt_normalized,n);
%y=polyval(P,dust);
subplot(1,2,1);
scatter(dust_ascent,Alt_ascent,'Blue');
hold on;
ylabel("Altitude (kft)");
xlabel("Particulate Counts");
a=" vs Altitude (Ascent)";
titl = sprintf('Bin%d',s-1);
Title=strcat(titl,a);
title(Title);
hold off;
subplot(1,2,2);
scatter(dust_descent,Alt_descent,'Red');
ylabel("Altitude (kft)");
xlabel("Particulate Counts");
a=" vs Altitude (Descent)";
titl = sprintf('Bin%d',s-1);
Title=strcat(titl,a);
title(Title);
%% Save figure
fig=sprintf('_Particulates_vs_Altitude%d.png',s-1);
strFigure=strcat(fPath2,flightNum,fig);
saveas(gcf, strFigure); %automatically save a figure each time the script is run
end


