% Script to plot OPC data vs time
% Based on true story Concentration_vs_Alt_Plot.m by Garret Ailts
%
% Last edited: 10/17/2018
% By: Jack Stutler
clear all
close all

samplePeriod=1.389;
mToFt=3.2808399;
flightNum = 'HASP_2018';
dustFile = 'OPC2_000.CSV';
flightLog = 'MURI_Data.csv';
opc_tOffset = 60;
n=2;
fPath1 = strcat('../data/',flightNum,'/');
fPath2 = strcat('../figs/',flightNum,'/');
addpath(genpath(fPath2));
addpath(genpath(fPath1));
load Calibration
%% Get dust data
opcData = csvread(dustFile,17,0);
Bin0 = opcData(:,1); Bin1 = opcData(:,2); Bin2 = opcData(:,3);
Bin3 = opcData(:,4); Bin4 = opcData(:,5); Bin5 = opcData(:,6);
Bin6 = opcData(:,7); Bin7 = opcData(:,8); Bin8 = opcData(:,9);
Bin9 = opcData(:,10); Bin10 = opcData(:,11); Bin11 = opcData(:,12);
Bin12 = opcData(:,13); Bin13 = opcData(:,14); Bin14 = opcData(:,15);
Bin15 = opcData(:,16); SFR = opcData(:,21);
dust_Array=[Bin0 Bin1 Bin2 Bin3 Bin4 Bin5 Bin6 Bin7 Bin8 Bin9 Bin10 Bin11 Bin12 Bin13 Bin14 Bin15];
size=[0.38 0.54 0.78 1.0 1.3 1.6 2.1 3.0 4.0 5.0 6.5 8.0 10.0 12.0 14.0 16.0 25];
%% Get flight data
fData = csvread(flightLog);
alt = (fData(opc_tOffset:end,6).*mToFt)/1000;
indA = find(alt>80);
tDay = fData(opc_tOffset:end,1);
indT = find(tDay<5,1,'last');
tHour = fData(opc_tOffset:end,2);
tHour(indT+1:end) = tHour(indT+1:end)+24;
tMin = fData(opc_tOffset:end,3);
tSec = fData(opc_tOffset:end,4);
time = tHour.*60+tMin+tSec./60;
time = time-time(1);
%%  Get OPC time data
tSensor = samplePeriod.*(linspace(0,length(Bin0),length(Bin0)));
tFlight = linspace(0,length(time),length(time));
tFlight = tFlight';
%% Get time indices
start = time(indA(1));
nStarts = time(end)/start;
n = round(nStarts);
idx = zeros(329,n);
num = length(find(time>start & time<start*2));
idx(1:num,1) = find(time>start & time<start*2);
for l = 2:n(end)-1
    num = length(find(time>=start*l & time<start*(l+1)));
    idx(1:num,l) = find(time>=start*l & time<start*(l+1));
end
num = length(find(time>start*n & time<start*(n+1)));
idx(1:num,n) = find(time>=start*n & time<start*(n+1));
%for k = 1:length(time)
% Crank the machine
for i = 1:1
    dust = dust_Array(:,i);
    sizeRange = size(i:i+1);
    dust = interp1(tSensor,dust,tFlight);
    for j = 1:n
        in = find(idx(:,j));
        array = idx(in,j);
        for k = 1:length(array)
            counts(k) = dust(array(k));
            flowrate(k) = SFR(array(k));
        end
        avgCounts = sum(counts)/length(counts);
        avgSFR = sum(flowrate)/length(flowrate);
        dustSets(j) = (avgCounts/avgSFR)/(log10(sizeRange(2))-log10(sizeRange(1)));
    end
    dustSets = dustSets .* linearCal_400(i)';
    %dustSets(find(dustSets==0)) = NaN;
    dusty(:,i) = dustSets';
    cTime = linspace(0,time(end)-start,n);
    plot(cTime,dustSets,'-*')%'MarkerIndices',1:1:length(cTime))
    hold on
end
ylabel('Particle Concentration (dN/dlog(D))')
xlabel('Time [min]')
title('Concentration vs Time (elapsed after Alt = 24.384 km, 0.35 to 0.54 um)')
%set(gca, 'YScale','log');
%legend('0.35-0.54um','0.54-0.78um','0.78-1.0um','1.0-1.3um','1.3-1.6um','1.6-2.1um','2.1-3.0um','3.0-4.0um','4.0-5.0um','5.0-6.5um','6.5-8.0um','8.0-10.0um','10.0-12.0um','12.0-14.0um','14.0-16.0um','16.0-Max','Location','north');
fig=sprintf('_Concentration_vs_Time_Calibrated.png');
strFigure=strcat(fPath2,flightNum,fig);
strFigure2=strcat(fPath2,flightNum);
%xlswrite(fullfile(strFigure2, 'HASP_2018.xlsx'), T)
saveas(gcf, strFigure); %automatically save a figure each time the script is run