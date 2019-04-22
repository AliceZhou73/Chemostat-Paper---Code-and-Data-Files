%% Plots optical density (OD) measurements taken throughought chemostat experiments
% ----------------------------------------------------------------------
% Created by: Alice Zhou (Alice.Zhou.GR@dartmouth.edu)
% Version: 1.0 (Last modified 4/22/19)
% Date: 4/22/19 

clc;clear;close all

% result = GetGoogleSpreadsheet(DOCID) 
% [DOCID] A value like '0AmQ013fj5234gSXFAWLK1REgwRW02hsd3c', which is found in your spreadsheet's url: 
% https://docs.google.com/spreadsheets/d/<DOCID HERE>/edit#gid=0.

% Select dataset to plot
dataset = input ('Enter 1 to select 10h/18h/30h growth rate experiments, or 2 to select the 70h rate experiment:  ')

if dataset == 1
alldata = GetGoogleSpreadsheet('10jTtQho6pYN00zE931AENabDrcYhxcwzUkp0veeDF7w') % 18h/10h/30h experiments starting 6-20-18
starttime = '20-Jun-2018 08:05:00'; % clock time when bioreactors were inoculated
start_time = datetime(starttime); 
end 

if dataset == 2 
alldata = GetGoogleSpreadsheet('14R8FcMG2NkScPkmBe8qj9uZlK1SJpnfA2gI28Jlih0k') % 70h experiment starting 9-26-18
starttime = '26-Sep-2018 18:40:00'; % clock time when bioreactors were inoculated
start_time = datetime(starttime); 
end

% Reformats raw data
data = alldata;

data(1,:) = []; % removes first row, which contains data headers
times = data(:,1);
data(:,1) = []; % removes first column, which is date/time strings
data = str2double(data); % converts remaining data to numbers
times = datetime(times);
bioreactor1 = data(:,1); 
bioreactor2 = data(:,2); 
bioreactor3 = data(:,3); 

elapsed_time = times - start_time; % elapsed time (between sampling and inoculation) in hours
elapsed_time = duration(elapsed_time,'Format','h') % converts to a duration array. 's','m','h','d' to change displayed time unit
elapsed_time = hours(elapsed_time);

% plots OD timeseries along with sampling intervals
figure(1)
hold on

plot(elapsed_time,bioreactor1,'ko','Linewidth',2)
plot(elapsed_time,bioreactor2,'ro','Linewidth',2)
plot(elapsed_time,bioreactor3,'bo','Linewidth',2)

xlabel('Time elapsed (h)'),ylabel('Absorbance at 600 nm')
legend('Bioreactor 1','Bioreactor 2','Bioreactor 3')
set(gcf,'color','w') % sets figure background to white

if dataset == 1 % sampling intervals for 10/18/30h experiment set
    gridxy([60 743 893 899 1083 1094 1129],'Linewidth',1.5) % sampling times only, units hours elapsed since inoculation
end

if dataset == 2 % sampling intervals for 70h experiment 
    gridxy([300 1002 1120 1171],'Linewidth',1.5)
end
