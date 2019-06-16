%=========================================================================%
%                          MURI_post_process_Plantower.m              
%              Post-processing script for MURI particle data
%
% Summary: 
% MURI_post_process.m handles the data from the 
% Plantower OPC for the MURI balloon flights. By the end, 
% the user will have a dataset consisting of 
% particle concentration vs. altitude for each OPC. Note that before using
% this script, the user should run the script "fdata_parse.m", which will
% give altitude and time data from the GPS log.
% 
% Notes:
%       -- "flight data" corresponds to time and altitude data
%       -- units of time must be SECONDS
%       -- units of altitude must be in FEET
%       -- pt = plantower
%       -- be aware of which .mat you are loading
%       
% Written by: Joey Habeck
% Created: 1/4/19
% Last modified: 6/14/19
%=========================================================================%

%% Clean up

clear
close all
clc

%% Constants

m2ft = 3.281; % meters to feet conversion

%% Import flight data
% Load the data from fdata_parse.m.

load fdata.mat

%% Import Plantower OPC data
% Bins are particle count per 0.1 L (concentration)

% Parse and get data
disp('Select Plantower data from window.')
[pt1_t,pt1_bin1,pt1_bin2,pt1_bin3,pt1_bin4,pt1_bin5] = import_ptData();
[pt2_t,pt2_bin1,pt2_bin2,pt2_bin3,pt2_bin4,pt2_bin5] = import_ptData();

% Save data
save('pt1.mat','pt1_t','pt1_bin1','pt1_bin2','pt1_bin3','pt1_bin4','pt1_bin5');
save('pt2.mat','pt2_t','pt2_bin1','pt2_bin2','pt2_bin3','pt2_bin4','pt2_bin5');
disp('Plantower data saved to pt.mat.')


%% Clear and reload data

clear
clc

load fdata.mat
load pt1.mat
load pt2.mat
%load as.mat

%{
 At this point we have:
-- concentration per bin from Plantower
-- Plantower (based off sampling period)
-- altitude and time from flight data
%}

%% Trim data

% Flight log sampling freq. of our current logging sys.
f_sampFreq = f_t(2)-f_t(1);

% Find index corresponding to end of ascent (max altitude)
for i=1:length(f_h)
    if (f_h(i) == max(f_h))
        f_icutoff = i;
        break
    end
end

% Time at end of ascent using index found above
f_tcutoff = f_t(f_icutoff);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% manual look up if needed
%f_icutoff = 1758;  % index of topc where flight time ends (manually looked this up)
%f_tcutoff = 8793;  % time at f_icutoff index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find cutoff times for each OPC

% for plantower 1
for i=1:length(pt1_t)
    if (pt1_t(i) >= f_tcutoff)
        pt1_icutoff = i;
        break
    end
end

% for plantower 2
for i=1:length(pt2_t)
    if (pt2_t(i) >= f_tcutoff)
        pt2_icutoff = i;
        break
    end
end


%%
% Deleta data after ascent ends

% for flight data
f_t(f_icutoff:end)=[];                
f_h(f_icutoff:end)=[];

% for plantower 1
pt1_bin1(pt1_icutoff:end)=[];
pt1_bin2(pt1_icutoff:end)=[];
pt1_bin3(pt1_icutoff:end)=[];
pt1_bin4(pt1_icutoff:end)=[];
pt1_bin5(pt1_icutoff:end)=[];
pt1_t(pt1_icutoff:end)=[];
% for plantower 2
pt2_bin1(pt2_icutoff:end)=[];
pt2_bin2(pt2_icutoff:end)=[];
pt2_bin3(pt2_icutoff:end)=[];
pt2_bin4(pt2_icutoff:end)=[];
pt2_bin5(pt2_icutoff:end)=[];
pt2_t(pt2_icutoff:end)=[];


%% Sync opc and flight data

% plantower
pt1_h = interp1(f_t,f_h,pt1_t);
pt2_h = interp1(f_t,f_h,pt2_t);

% save data sets
save('pt1.mat','pt1_t','pt1_bin1','pt1_bin2','pt1_bin3','pt1_bin4','pt1_bin5','pt1_h');
save('pt2.mat','pt2_t','pt2_bin1','pt2_bin2','pt2_bin3','pt2_bin4','pt2_bin5','pt2_h');

%% Clean and reload

clear
clc

load fdata.mat
load pt1.mat
load pt2.mat

%% Split altitude into Ranges

% Altitude is in kilo-feet!
% Take average concentration over section of altitude

% max altitude (rounded down to nearest 1000th ft)
temp = round(max(f_h));
maxA = round(max(f_h),3,'significant');
if (maxA > temp)
    maxA = maxA - 1000
end
maxA = maxA/1000;

% min altitude 
minA = 1;   % minimum altitude in kft

% plantower
[pt1_bin1_av,pt_bin1_std,pt1_h_mid] = A_sections(pt1_h,pt1_bin1,maxA,minA,1000); 
[pt1_bin2_av,pt_bin2_std,pt_h_mid] = A_sections(pt1_h,pt1_bin2,maxA,minA);
[pt1_bin3_av,pt_bin3_std,pt_h_mid] = A_sections(pt1_h,pt1_bin3,maxA,minA);
[pt1_bin4_av,pt_bin4_std,pt_h_mid] = A_sections(pt1_h,pt1_bin4,maxA,minA);
[pt1_bin5_av,pt_bin5_std,pt_h_mid] = A_sections(pt1_h,pt1_bin5,maxA,minA);

% plantower
[pt2_bin1_av,pt_bin1_std,pt2_h_mid] = A_sections(pt2_h,pt2_bin1,maxA,minA); 
[pt2_bin2_av,pt_bin2_std,pt_h_mid] = A_sections(pt2_h,pt2_bin2,maxA,minA);
[pt2_bin3_av,pt_bin3_std,pt_h_mid] = A_sections(pt2_h,pt2_bin3,maxA,minA);
[pt2_bin4_av,pt_bin4_std,pt_h_mid] = A_sections(pt2_h,pt2_bin4,maxA,minA);
[pt2_bin5_av,pt_bin5_std,pt_h_mid] = A_sections(pt2_h,pt2_bin5,maxA,minA);

 
%% Converting pt data to particles per mL
% pt data is "concentration per 0.1 L", so multiplying by 0.1L/100mL 
conv = 0.1/100 %[L/mL]

pt1_bin1_av = pt1_bin1_av.*conv;
pt1_bin2_av = pt1_bin2_av.*conv;
pt1_bin3_av = pt1_bin3_av.*conv;
pt1_bin4_av = pt1_bin4_av.*conv;
pt1_bin5_av = pt1_bin5_av.*conv;


pt2_bin1_av = pt2_bin1_av.*conv;
pt2_bin2_av = pt2_bin2_av.*conv;
pt2_bin3_av = pt2_bin3_av.*conv;
pt2_bin4_av = pt2_bin4_av.*conv;
pt2_bin5_av = pt2_bin5_av.*conv;

%% Save data

save('particulates.mat','pt1_bin1_av','pt1_bin2_av','pt1_bin3_av',...
        'pt1_bin4_av','pt1_bin5_av','pt2_bin1_av','pt2_bin2_av','pt2_bin3_av',...
        'pt2_bin4_av','pt2_bin5_av')
    
%% Plotting

figure('name','Plantower1')
title('Particles concentration vs. altitude')
xlabel('Number concentration, #/mL')
ylabel('Altitude (kft)')
grid on
plot(pt1_bin1_av,pt_h_mid)
hold on
plot(pt1_bin2_av,pt_h_mid)
plot(pt1_bin3_av,pt_h_mid)
plot(pt1_bin4_av,pt_h_mid)
plot(pt1_bin5_av,pt_h_mid)

legend('0.3-0.5 um','0.5-1.0 um','1.0-2.5 um','2.5-5.0 um','5.0-10 um')

figure('name','Plantower2')
title('Particles concentration vs. altitude')
xlabel('Number concentration, #/mL')
ylabel('Altitude (kft)')
grid on
plot(pt2_bin1_av,pt_h_mid)
hold on
plot(pt2_bin2_av,pt_h_mid)
plot(pt2_bin3_av,pt_h_mid)
plot(pt2_bin4_av,pt_h_mid)
plot(pt2_bin5_av,pt_h_mid)

legend('0.3-0.5 um','0.5-1.0 um','1.0-2.5 um','2.5-5.0 um','5.0-10 um')


%% Write data to Tecplot file
% n = length(pt1_h_mid);
% f='particulates.dat'
% fileID = fopen(f,'w');
% fprintf(fileID,'VARIABLES =  pt1_bin1 pt1_bin2 pt1_bin3 pt1_bin4 pt1_bin5 pt2_bin1 pt2_bin2 pt2_bin3 pt2_bin4 pt2_bin5 h\n');
% fprintf(fileID,'ZONE i=412 DATAPACKING=block\n')
% 
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt1_bin1_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt1_bin2_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt1_bin3_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt1_bin4_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt1_bin5_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt2_bin1_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt2_bin2_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt2_bin3_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt2_bin4_av(i));
% end
% fprintf(fileID,'\n')
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt2_bin5_av(i));
% end
% fprintf(fileID,'\n')
% 
% for i=1:n
%     fprintf(fileID,'%12.10f\n',pt2_h_mid(i));
% end
% 
% disp('Data written to tecplot file.')













