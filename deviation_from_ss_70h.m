%% Plots volume-corrected deviation from steady-state for 70h chemostat experiments
% ----------------------------------------------------------------------
% Created by: Alice Zhou (Alice.Zhou.GR@dartmouth.edu)
% Version: 1.0 (Last modified 6/25/19)
% Date: 6/25/19 

% Dependencies: Requires data file 'cumulative elapsed time.xlsx' to be
% in the same file directory as script. If file is in different directory, must
% designate full path to file below. 

clc;clear;close all

filename = 'cumulative elapsed time.xlsx'
sheet = 3  ; % 70h experiments 
[numeric,text_only,all_data] = xlsread(filename,sheet,'','basic'); % loads data as cell array

data_no_headers = all_data;
headers = [1]; % enter row numbers of text headers in an array
data_no_headers(headers,:) = []; % removes rows with text headers

all_data = data_no_headers;
time_elapsed = all_data(:,4); time_elapsed = cell2mat(time_elapsed);
BR1_deviation = all_data(:,5); BR1_deviation = cell2mat(BR1_deviation);
BR2_deviation = all_data(:,6); BR2_deviation = cell2mat(BR2_deviation);
BR3_deviation = all_data(:,7); BR3_deviation = cell2mat(BR3_deviation);

figure(1)
hold on
grid on
plot(time_elapsed,BR1_deviation,'ro','Linewidth',2)
plot(time_elapsed,BR2_deviation,'ko','Linewidth',2)
plot(time_elapsed,BR3_deviation,'bo','Linewidth',2)
ylim([-70 70]); xlim([0 1300]);

legend('Bioreactor 1','Bioreactor 2','Bioreactor 3')
xlabel('Time elapsed (h)'); ylabel('Percent deviation from steady state (%)')
gridxy([1195],'Linewidth',1.5) % sampling interval for 70h experiment (S4 only)

