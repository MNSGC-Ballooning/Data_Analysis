%=========================================================================%
%                          fdata_parse.m              
%              Flight data parsing script for MURI
%
% Summary:
%      The purpose of this script is to extract the altitude and time data
%      from the flight log. The script should result in a .mat file to be
%      used in MURI_post_process.m
%
% Written by: Joseph Habeck
% Last modified: 1/19/18
%=========================================================================%
clear
clc
close all

%% Important: 
% Do not just click Run button at the top of the screen.
% Import data first (next section), then use the Run and Advance button at
% the top of the screen to execute the rest!

%% Import data
% First use the 'Import Data' option to import altitude data from flight
% log... the column vector should be named "Altitudeft" by default. Make
% sure to import as a column vector!

%% Compile data
% Have the flight log file open to look at...

% rename altitude data
f_h = Altitudeft; 

% number of samples
N = length(f_h);        

% prompt for last time stamp to determine total flight time
prompt = 'Enter hour of last time stamp: ';
hr = input(prompt);
prompt = 'Enter minute of last time stamp: ';
min = input(prompt);
prompt = 'Enter second of last time stamp: ';
sec = input(prompt);

% convert final time stamp to seconds
t_total = hr*3600 + min*60 + sec;

% flight time vector
f_t = linspace(0,t_total,N)';

save('fdata.mat','f_t','f_h');
clear

%% Clean up and reload data
clear
close all
clc
load fdata.mat

%% USER EDITS
% This section is for the user to make edits to the data parsing. Most
% often these edits will be specific to the data it was written for. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{

%% Interpolate missing altitude data
% written for GL134

% last stamp before missing
n1 = 231;

% first stamp after missing
n2 = 565;

% number of missing stamps
Nmiss = (n2-1)-(n1+1)+1;

% sampling frequency
samp_freq = 5;

% altitude and time at upper and lower bounds
htemp = [f_h(n1),f_h(n2)];
ttemp = [f_t(n1),f_t(n2)];

% query of points to be interpolated
missing = linspace(f_t(n1+1),f_t(n2-1),Nmiss);

% interpolation
vq = interp1(ttemp,htemp,missing);

% fill in missing values
n=1;
for i=n1+1:n2-1
    f_h(i)=vq(n);
    n=n+1
end


%% END OF USER EDITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}
%% Finish

% plot
figure('name','Flight profile');
plot(f_t,f_h);
xlabel('time (s)')
ylabel('altitude (ft)')
grid on


disp('Done.')



        
