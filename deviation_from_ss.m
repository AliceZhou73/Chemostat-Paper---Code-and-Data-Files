%% Plots volume-corrected deviation from steady-state for chemostat experiments
% ----------------------------------------------------------------------
% Created by: Alice Zhou (Alice.Zhou.GR@dartmouth.edu)
% Version: 1.0 (Last modified 4/22/19)
% Date: 4/22/19 

% Dependencies: Requires data file 'cumulative elapsed time.xlsx' to be
% in the same file directory as script. If file is in different directory, must
% designate full path to file below. 

clc;clear;close all

filename = '\cumulative elapsed time.xlsx'
sheet = 2  ; % 18h/10h/30h experiments 
[numeric,text_only,all_data] = xlsread(filename,sheet,'','basic'); % loads data as cell array

data_no_headers = all_data;
headers = [1]; % enter row numbers of text headers in an array
data_no_headers(headers,:) = []; % removes rows with text headers

all_data = data_no_headers;
time_elapsed = all_data(:,4); time_elapsed = cell2mat(time_elapsed);
BR1_deviation = all_data(:,5); BR1_deviation = cell2mat(BR1_deviation);
BR2_deviation = all_data(:,6); BR2_deviation = cell2mat(BR2_deviation);
BR3_deviation = all_data(:,7); BR3_deviation = cell2mat(BR3_deviation);

BR1_deviation = BR1_deviation.*100;
BR2_deviation = BR2_deviation.*100;
BR3_deviation = BR3_deviation.*100;
figure(1)
hold on
grid on
plot(time_elapsed,BR1_deviation,'ro','Linewidth',2)
plot(time_elapsed,BR2_deviation,'ko','Linewidth',2)
plot(time_elapsed,BR3_deviation,'bo','Linewidth',2)
ylim([-100 150]);

legend('Bioreactor 1','Bioreactor 2','Bioreactor 3')
xlabel('Time elapsed (h)'); ylabel('Percent deviation from steady state (%)')
gridxy([670.62 819.83 826.35 1009.92 1021.13 1055.92],'Linewidth',1.5) % sampling intervals for 10/18/30h experiments

