%Script to plot Temp vs Alt
clear;
load Temp_vs_Time_Data
T=T-273.15;
T_OPC=T_OPC-273.15;
T_min_opc=linspace(-10,-10,length(t));
plot(t,T,'Blue');
hold on;
xlabel("Flight Time");
ylabel("Temperature (Celsius)")
title("Temp vs Flight Time");
plot(t,T_OPC,'Red');
plot(t,T_min_opc,'Green');
legend("Battery Temp","Alphasense OPC Temp");
hold off;
