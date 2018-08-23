function [t,Lat,Long,Alt,Date,gps_t,Fix,a_x,a_y,a_z,IA_T,EA_T,bat_T,opc_T,opcHeat_Stat,batHeat_Stat,P] = import_FlightLog(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [T,LAT,LONG,ALT,DATE,GPS_T,FIX,A_X,A_Y,A_Z,IA_T,EA_T,BAT_T,OPC_T,OPCHEAT_STAT,BATHEAT_STAT,P]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [T,LAT,LONG,ALT,DATE,GPS_T,FIX,A_X,A_Y,A_Z,IA_T,EA_T,BAT_T,OPC_T,OPCHEAT_STAT,BATHEAT_STAT,P]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [t,Lat,Long,Alt,Date,gps_t,Fix,a_x,a_y,a_z,IA_T,EA_T,bat_T,opc_T,opcHeat_Stat,batHeat_Stat,P] = importfile('LOG01.CSV',2, 4229);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/07/30 08:01:46

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: datetimes (%{HH:mm:ss}D)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: categorical (%C)
%	column6: datetimes (%{HH:mm:ss}D)
%   column7: categorical (%C)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: categorical (%C)
%	column16: categorical (%C)
%   column17: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%{HH:mm:ss}D%f%f%f%C%{HH:mm:ss}D%C%f%f%f%f%f%f%f%C%C%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
t = dataArray{:, 1};
Lat = dataArray{:, 2};
Long = dataArray{:, 3};
Alt = dataArray{:, 4};
Date = dataArray{:, 5};
gps_t = dataArray{:, 6};
Fix = dataArray{:, 7};
a_x = dataArray{:, 8};
a_y = dataArray{:, 9};
a_z = dataArray{:, 10};
IA_T = dataArray{:, 11};
EA_T = dataArray{:, 12};
bat_T = dataArray{:, 13};
opc_T = dataArray{:, 14};
opcHeat_Stat = dataArray{:, 15};
batHeat_Stat = dataArray{:, 16};
P = dataArray{:, 17};

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

% t=datenum(t);
% gps_t=datenum(gps_t);

