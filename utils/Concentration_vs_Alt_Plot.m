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
samplePeriod=1.389;
%% Import Data
[Bin0,Bin1,Bin2,Bin3,Bin4,Bin5,Bin6,Bin7,Bin8,Bin9,Bin10,Bin11,Bin12,Bin13,Bin14,Bin15,SFR,~] = import_Dust_Data(dustFile, 17, inf);
dust_Array=[Bin0 Bin1 Bin2 Bin3 Bin4 Bin5 Bin6 Bin7 Bin8 Bin9 Bin10 Bin11 Bin12 Bin13 Bin14 Bin15];
size=[0.38 0.54 0.78 1.0 1.3 1.6 2.1 3.0 4.0 5.0 6.5 8.0 10.0 12.0 14.0 16.0 25];
Alt = import_HASP_Alt(flightLog, 1, inf);
Alt=(Alt(opc_tOffset:end).*mTOft)/1000;


%% Obtain OPC Time Vector
t_sensor = samplePeriod.*(linspace(0,length(Bin0),length(Bin0)));
t_alt=linspace(0,length(Alt),length(Alt));
for s=1:1:16
%% Define Dust Dataset
dust = dust_Array(:,s);
sizeRange=size(s:s+1);
%% Interpolate Alt Data
dust=interp1(t_sensor,dust,t_alt);
%% Split Data Sets into Ranges
[idx1, ~]=find(Alt>80 & Alt<82.500);
[idx2, ~]=find(Alt>=82.500 & Alt<85.000);
[idx3, ~]=find(Alt>=85.000 & Alt<87.500);
[idx4, ~]=find(Alt>=87.500 & Alt<90.000);
[idx5, ~]=find(Alt>=90/000 & Alt<92500);
[idx6, ~]=find(Alt>=92500 & Alt<95.000);
[idx7, ~]=find(Alt>=95.000 & Alt<97.500);
[idx8, ~]=find(Alt>=97.500 & Alt<100.000);
[idx9, ~]=find(Alt>100.000 & Alt<102.500);
[idx10, ~]=find(Alt>102.500 & Alt<105.000);
[idx11, ~]=find(Alt>=105.000 & Alt<107.500);
[idx12, ~]=find(Alt>=107.500 & Alt<110.000);
[idx13, ~]=find(Alt>=110.000 & Alt<112.500);
[idx14, ~]=find(Alt>=112.500 & Alt<115.000);
[idx15, ~]=find(Alt>=115.000 & Alt<117.500);
[idx16, ~]=find(Alt>=117.500 & Alt<120.000);
[idx17, ~]=find(Alt>=120.000 & Alt<122.500);

sets={idx1, idx2, idx3, idx4, idx5, idx6, idx7, idx8, idx9, idx10, idx11, idx12, idx13, idx14, idx15, idx16, idx17};
for i=1:17
    array=sets{i};
    for j=1:length(array)
        counts(j)=dust(array(j));
        flowrate(j)=SFR(array(j));
    end
    avgCounts=sum(counts)/length(counts);
    avgSFR=sum(flowrate)/length(flowrate); %Sample flow rate in cm^3/s
    dustSets(i)=(avgCounts/avgSFR)/(log10(sizeRange(2))-log10(sizeRange(1)));
end
dusty(:,s)=dustSets';
cdAlt=linspace(81.25,121.25,17);
%cdAlt=[82.5 87.5, 92.5, 97.5, 102.5, 107.5, 112.5, 117.5, 122.5];
%% Plot 
%P=polyfit(dust,Alt_normalized,n);
%y=polyval(P,dust);
%scatter(dustSets,cdAlt,'color',rand(1,16));
plot(dustSets,cdAlt,'-*','MarkerIndices',1:1:length(cdAlt));
hold on
end
%% Format Plot
ylabel("Altitude (kft)");
xlabel("Particle Concentration (dN/dlog(D))");
Title = 'Particulate Concentration vs Altitude';
title(Title);
legend('0.35-0.54um','0.54-0.78um','0.78-1.0um','1.0-1.3um','1.3-1.6um','1.6-2.1um','2.1-3.0um','3.0-4.0um','4.0-5.0um','5.0-6.5um','6.5-8.0um','8.0-10.0um','10.0-12.0um','12.0-14.0um','14.0-16.0um','16.0-Max');
Altitude_Range_ft={'80000-82500';'82500-85000';'85000-87500';'87500-90000';'90000-92500';'92500-95000';'95000-97500';'97500-100000';'100000-102500';'102500-105000';'105000-107500';'107500-110000';'110000-112500';'112500-115000';'115000-117500';'117500-120000';'120000-122500'};
%columnNames={'Altitude_ft','0.35_to_0.54um','0.54_to_0.78um','0.78_to_1.0um','1.0_to_1.3um','1.3_to_1.6um','1.6_to_2.1um','2.1_to_3.0um','3.0_to_4.0um','4.0_to_5.0um','5.0_to_6.5um','6.5_to_8.0um','8.0_to_10.0um','10.0_to_12.0um','12.0_to_14.0um','14.0_to_16.0um','16.0_to_25um'};
T=table(Altitude_Range_ft,dusty(:,1),dusty(:,2),dusty(:,3),dusty(:,4),dusty(:,5),dusty(:,6),dusty(:,7),dusty(:,8),dusty(:,9),dusty(:,10),dusty(:,11),dusty(:,12),dusty(:,13),dusty(:,14),dusty(:,15),dusty(:,16));

%% Save figure
save('HASP_2018.mat', 'T')
fig=sprintf('_Concentration_vs_Altitude.png');
strFigure=strcat(fPath2,flightNum,fig);
strFigure2=strcat(fPath2,flightNum);
%xlswrite(fullfile(strFigure2, 'HASP_2018.xlsx'), T)
saveas(gcf, strFigure); %automatically save a figure each time the script is run

