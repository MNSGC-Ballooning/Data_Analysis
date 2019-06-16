function [time,bin1,bin2,bin3,bin4,bin5] = import_ptData()

%{ 
Summary:
This function imports the particle data from the Plantower OPC. It assumes
that the PT data was logged using the "plantower_v2.ino" Arduino code
(which is found on the MURI Google Drive). If it was not, this function
will need to be tweaked such that the correct rows and columns of the .csv
file are being imported. Note that the .csv file MUST
be in the current working directory. 

Inputs: 

Outputs:

Written by: Joseph Habeck (habec021@umn.edu)
Date: 1/4/18
%}

% load .csv file
file_type = '*.csv';
dialog_box = 'Select Plantower data';
pdatafile = uigetfile(file_type,dialog_box);

% read .csv file
pdata = csvread(pdatafile,1,3);

% number of data samples
N = length(pdata(:,1));

% store time data
time = pdata(:,1)./1000;

% store particle concentration data 
bin1 = pdata(:,2); % particles w/ diameter beyond 0.3um in 0.1L air
bin2 = pdata(:,3); % particles w/ diameter beyond 0.5um in 0.1L air
bin3 = pdata(:,4); % particles w/ diameter beyond 1.0um in 0.1L air
bin4 = pdata(:,5); % particles w/ diameter beyond 2.5um in 0.1L air
bin5 = pdata(:,6); % particles w/ diameter beyond 5.0um in 0.1L air
bin6 = pdata(:,7); % particles w/ diameter beyond 10um in 0.1L air

% redefine size bins
bin1 = bin1-bin2;  % 0.3-0.5um particles in 0.1L air
bin2 = bin2-bin3;  % 0.5-1.0um particles in 0.1L air
bin3 = bin3-bin4;  % 1.0-2.5um particles in 0.1L air
bin4 = bin4-bin5;  % 2.5-5.0um particles in 0.1L air
bin5 = bin5-bin6;  % 5.0-10um particles in 0.1L air

