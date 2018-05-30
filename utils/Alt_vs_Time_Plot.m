%Script to generate Altitude vs Time data for HAB flight
L=length(Alt);
time=linspace(0,L,L);
t=time;
plot(t,Alt);
xlabel("Time in minutes");
ylabel("Altitude in feet");
title("MURI Altitude vs Time");
