%% Import data
clear;
addpath(genpath('../figs/'));
addpath(genpath('../data/'));
filename="TEMPLOG.CSV";
[T_Bat,T_OPC,t] = import_Temp_Data(filename, 2, inf);
load GL_124_APRS_Alt_Data
T_Bat=T_Bat-273.15;
T_OPC=T_OPC-273.15;
%% Create time vectors for data sets
t_alt=linspace(0,length(Alt),length(Alt));
for i=1:1:length(t)
    
[Y, M, D, H, MN, S] = datevec(t(i));
t(i)= H*3600+MN*60+S;
t(i)=t(i)-57600;
end
t_temp=t;
t_alt=(t_alt*60)+271.71;
%% Interpolate altitude data
dust_normalized=interp1(t_alt,Alt,t_temp);
Alt_normalized=Alt_normalized';
%% Split datasets into ascent and descent
[~,max_index]=max(Alt);
T_Bat_ascent=T_Bat(1:max_index);
Alt_ascent=Alt_normalized(1:max_index);
Alt_descent=Alt_normalized(max_index+1:end);
T_Bat_descent=dust_normalized(max_index+1:end);
%% Plot 
scatter(T_Bat_aescent,Alt_ascent,'Blue');
hold on;
scatter(T_Bat_descent,Alt_descent,'Red');
ylabel("Altitude (ft)");
xlabel("Temperature");
title("Temp vs Altitude");
legend("Ascent","Descent");
hold off;