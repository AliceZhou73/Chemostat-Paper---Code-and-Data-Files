%% Plots ring index against measured volume-corrected turnover times from chemostat experiments
% ----------------------------------------------------------------------
% Created by: Alice Zhou (Alice.Zhou.GR@dartmouth.edu)
% Version: 1.0 (Last modified 4/22/19)
% Date: 4/22/19 

% Dependencies: Requires data file 'Chemostat Turnover and Deviation from Steady State.xlsx' to be
% in the same file directory as script. If file is in different directory, user must
% designate full path to file below. 

clc;clear;close all

% Loads in data file
filename = 'Chemostat Turnover and Deviation from Steady State.xlsx'
sheet = 5;
[numeric,text_only,all_data] = xlsread(filename,sheet,'','basic'); % loads data as cell array
all_data


data_no_headers = all_data;
headers = [1]; % enter row numbers of text headers in an array
data_no_headers(headers,:) = []; % removes rows with text headers

all_data = data_no_headers;

BR1_turnover = all_data(:,2); BR1_turnover = cell2mat(BR1_turnover);
BR1_ringindex = all_data(:,5); BR1_ringindex = cell2mat(BR1_ringindex);
BR1_sampleindex = ~isnan(BR1_ringindex);  BR1_sampleindex = (find(BR1_sampleindex))
BR1_searchlength = 5;
BR1_lowend = []; BR1_highend = [];

for i = 1:length(BR1_sampleindex)
    index = BR1_sampleindex(i)
    BR1ttrange = BR1_turnover(index-BR1_searchlength:index) % gives range of preceding measured turnover times
    BR1_lowend(i) = min(BR1ttrange); BR1_highend(i) = max(BR1ttrange);
end
BR1_sampletts = BR1_turnover(BR1_sampleindex)
BR1xneg = abs(BR1_sampletts - BR1_lowend'); BR1xpos = abs(BR1_sampletts - BR1_highend');


BR2_turnover = all_data(:,6); BR2_turnover = cell2mat(BR2_turnover)
BR2_ringindex = all_data(:,9); BR2_ringindex = cell2mat(BR2_ringindex)
BR2_sampleindex = ~isnan(BR2_ringindex);  BR2_sampleindex = (find(BR2_sampleindex))
BR2_searchlength = 5;
BR2_lowend = []; BR2_highend = [];

for i = 1:length(BR2_sampleindex)
    index = BR2_sampleindex(i)
    BR2ttrange = BR2_turnover(index-BR2_searchlength:index) % gives range of preceding measured turnover times
    BR2_lowend(i) = min(BR2ttrange); BR2_highend(i) = max(BR2ttrange);
end
BR2_sampletts = BR2_turnover(BR2_sampleindex)
BR2xneg = abs(BR2_sampletts - BR2_lowend'); BR2xpos = abs(BR2_sampletts - BR2_highend');


BR3_turnover = all_data(:,10); BR3_turnover = cell2mat(BR3_turnover)
BR3_ringindex = all_data(:,13); BR3_ringindex = cell2mat(BR3_ringindex)
BR3_sampleindex = ~isnan(BR3_ringindex);  BR3_sampleindex = (find(BR3_sampleindex))
BR3_searchlength = 5;
BR3_lowend = []; BR3_highend = [];

for i = 1:length(BR3_sampleindex)
    index = BR3_sampleindex(i)
    BR3ttrange = BR3_turnover(index-BR3_searchlength:index) % gives range of preceding measured turnover times
    BR3_lowend(i) = min(BR3ttrange); BR3_highend(i) = max(BR3ttrange);
end
BR3_sampletts = BR3_turnover(BR3_sampleindex);
BR3xneg = abs(BR3_sampletts - BR3_lowend'); BR3xpos = abs(BR3_sampletts - BR3_highend');

figure(1)
hold on

plot(BR1_turnover,BR1_ringindex,'s','Markersize',10,'MarkerEdgecolor','red','MarkerFaceColor',[1 .4 .4])
plot(BR2_turnover,BR2_ringindex,'d','Markersize',10,'MarkerEdgeColor','black','MarkerFaceColor',[.4 .4 .4])
plot(BR3_turnover,BR3_ringindex,'^','Markersize',10,'MarkerEdgeColor','blue','MarkerFaceColor',[.4 .4 1])

% Attenuated error bars below
errorbar(BR1_turnover(BR1_sampleindex),BR1_ringindex(BR1_sampleindex),zeros([1 10]),zeros([1 10]), BR1xneg'*.3, BR1xpos','k.','Linewidth',1.5)
errorbar(BR2_turnover(BR2_sampleindex),BR2_ringindex(BR2_sampleindex),zeros([1 10]),zeros([1 10]), BR2xneg'*.3, BR2xpos','k.','Linewidth',1.5)
errorbar(BR3_turnover(BR3_sampleindex),BR3_ringindex(BR3_sampleindex),zeros([1 10]),zeros([1 10]), BR3xneg'*.3, BR3xpos','k.','Linewidth',1.5)
xlabel('Reactor Turnover Time (h)'); ylabel('Ring Index (GDGTs 0-6)'); legend('Bioreactor 1','Bioreactor 2','Bioreactor 3')

% Linear regression statistics using Matlab fitlm ('Fit linear regression model')
BR1_linreg = fitlm(BR1_turnover, BR1_ringindex)
BR1_slope = BR1_linreg.Coefficients.Estimate(2)

BR2_linreg = fitlm(BR2_turnover, BR2_ringindex)
BR2_slope = BR2_linreg.Coefficients.Estimate(2)

BR3_linreg = fitlm(BR3_turnover, BR3_ringindex)
BR3_slope = BR3_linreg.Coefficients.Estimate(2)


%% S.aci vs. N.maritimus comparison using all available data points
figure(2)
hold on
title('S. acidocaldarius R.I. (GDGTs 0-6) and N. maritimus R.I. (GDGTs 0-4)')
hurley_tts = [22 30 71]; % doubling times, in hours
hurley_RI = [1.56 1.64 1.84]; % Total GDGTs, Ring index 0-4

yyaxis left
plot(BR1_turnover,BR1_ringindex,'s','Markersize',10,'MarkerEdgecolor','red','MarkerFaceColor',[1 .4 .4])
plot(BR2_turnover,BR2_ringindex,'d','Markersize',10,'MarkerEdgeColor','black','MarkerFaceColor',[.4 .4 .4])
plot(BR3_turnover,BR3_ringindex,'^','Markersize',10,'MarkerEdgeColor','blue','MarkerFaceColor',[.6 .6 1])

errorbar(BR1_turnover(BR1_sampleindex),BR1_ringindex(BR1_sampleindex),zeros([1 10]),zeros([1 10]), BR1xneg'*.3, BR1xpos','k.','Linewidth',1.5)
errorbar(BR2_turnover(BR2_sampleindex),BR2_ringindex(BR2_sampleindex),zeros([1 10]),zeros([1 10]), BR2xneg'*.3, BR2xpos','k.','Linewidth',1.5)
errorbar(BR3_turnover(BR3_sampleindex),BR3_ringindex(BR3_sampleindex),zeros([1 10]),zeros([1 10]), BR3xneg'*.3, BR3xpos','k.','Linewidth',1.5)

yyaxis right
ylim([1 3])
plot(hurley_tts, hurley_RI,'v','Markersize',10,'MarkerEdgeColor','black','MarkerFaceColor', [.6 1 .6])
plt = gca;
plt.YAxis(2).Color = 'm'

% CURRENTLY PLOTTING ATTENUATED ERROR BARS

legend('Saci Bioreactor 1','Saci Bioreactor 2','Saci Bioreactor 3','Hurley N. maritimus')
xlabel('Reactor Turnover Time (h)'); ylabel('Ring Index'); legend('Bioreactor 1','Bioreactor 2','Bioreactor 3','N. maritimus Data')
