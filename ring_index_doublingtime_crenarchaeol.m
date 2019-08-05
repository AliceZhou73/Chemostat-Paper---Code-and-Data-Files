%% Plots ring index against inferred volume-corrected doubling times from chemostat experiments 
%% (Fig. 2 includes Hurley N. maritimus data --> RI calculated using total GDGTs, including crenarchaeol)
% ----------------------------------------------------------------------
% Created by: Alice Zhou (Alice.Zhou.GR@dartmouth.edu)
% Version: 1.0 (Last modified 8/5/19)
% Date: 8/5/19 

% Dependencies: Requires data file 'Chemostat Turnover and Deviation from Steady State.xlsx' to be
% in the same file directory as script. If file is in different directory, user must
% designate full path to file below. 

clc;clear;close all

% Loads in data file
filename = 'Chemostat Turnover and Deviation from Steady State.xlsx'
sheet = 6 ;
[numeric,text_only,all_data] = xlsread(filename,sheet,'','basic'); % loads data as cell array
all_data


data_no_headers = all_data;
headers = [1]; % enter row numbers of text headers in an array
data_no_headers(headers,:) = []; % removes rows with text headers

all_data = data_no_headers;

% Extracts relevant doubling time and ring index values for Bioreactor 1
BR1_doublingtime = all_data(:,5); BR1_doublingtime = cell2mat(BR1_doublingtime);
BR1_ringindex = all_data(:,7); BR1_ringindex = cell2mat(BR1_ringindex);
BR1_sampleindex = ~isnan(BR1_ringindex);  BR1_sampleindex = (find(BR1_sampleindex))
BR1_searchlength = 5; 
BR1_lowend = []; BR1_highend = [];

% Extracts range of preceding inferred doubling times (calculated from mu)
for i = 1:length(BR1_sampleindex)
    index = BR1_sampleindex(i)
    BR1dtrange = BR1_doublingtime(index-BR1_searchlength:index) 
    BR1_lowend(i) = min(BR1dtrange); BR1_highend(i) = max(BR1dtrange); 
end
BR1_sampletts = BR1_doublingtime(BR1_sampleindex)
BR1xneg = abs(BR1_sampletts - BR1_lowend'); BR1xpos = abs(BR1_sampletts - BR1_highend');

% Extracts relevant doubling time and ring index values for Bioreactor 2
BR2_doublingtime = all_data(:,11); BR2_doublingtime = cell2mat(BR2_doublingtime)
BR2_ringindex = all_data(:,13); BR2_ringindex = cell2mat(BR2_ringindex)
BR2_sampleindex = ~isnan(BR2_ringindex);  BR2_sampleindex = (find(BR2_sampleindex))
BR2_searchlength = 3;
BR2_lowend = []; BR2_highend = [];

% Extracts range of preceding inferred doubling times (calculated from mu)
for i = 1:length(BR2_sampleindex)
    index = BR2_sampleindex(i)
    BR2dtrange = BR2_doublingtime(index-BR2_searchlength:index)
    BR2_lowend(i) = min(BR2dtrange); BR2_highend(i) = max(BR2dtrange);
end
BR2_sampletts = BR2_doublingtime(BR2_sampleindex)
BR2xneg = abs(BR2_sampletts - BR2_lowend'); BR2xpos = abs(BR2_sampletts - BR2_highend');

% Extracts relevant doubling time and ring index values for Bioreactor 3
BR3_doublingtime = all_data(:,17); BR3_doublingtime = cell2mat(BR3_doublingtime)
BR3_ringindex = all_data(:,19); BR3_ringindex = cell2mat(BR3_ringindex)
BR3_sampleindex = ~isnan(BR3_ringindex);  BR3_sampleindex = (find(BR3_sampleindex))
BR3_searchlength = 5;
BR3_lowend = []; BR3_highend = [];

% Extracts range of preceding inferred doubling times (calculated from mu)
for i = 1:length(BR3_sampleindex)
    index = BR3_sampleindex(i)
    BR3dtrange = BR3_doublingtime(index-BR3_searchlength:index) % % gives range of preceding inferred doubling times (calculated from mu)
    BR3_lowend(i) = min(BR3dtrange); BR3_highend(i) = max(BR3dtrange);
end
BR3_sampletts = BR3_doublingtime(BR3_sampleindex);
BR3xneg = abs(BR3_sampletts - BR3_lowend'); BR3xpos = abs(BR3_sampletts - BR3_highend');

% plots ring index as function of inferred doubling time, with horizontal
% error bars
figure(1)
hold on

plot(BR1_doublingtime,BR1_ringindex,'s','Markersize',15,'MarkerEdgecolor','red','MarkerFaceColor',[1 .4 .4])
plot(BR2_doublingtime,BR2_ringindex,'d','Markersize',15,'MarkerEdgeColor','black','MarkerFaceColor',[.4 .4 .4])
plot(BR3_doublingtime,BR3_ringindex,'^','Markersize',15,'MarkerEdgeColor','blue','MarkerFaceColor',[.4 .4 1])

% Attenuated error bars below
errorbar(BR1_doublingtime(BR1_sampleindex),BR1_ringindex(BR1_sampleindex),zeros([1 10]),zeros([1 10]), BR1xneg'*.3, BR1xpos','r.','Linewidth',1.5)
errorbar(BR2_doublingtime(BR2_sampleindex),BR2_ringindex(BR2_sampleindex),zeros([1 10]),zeros([1 10]), BR2xneg'*.3, BR2xpos','k.','Linewidth',1.5)
errorbar(BR3_doublingtime(BR3_sampleindex),BR3_ringindex(BR3_sampleindex),zeros([1 10]),zeros([1 10]), BR3xneg'*.3, BR3xpos','b.','Linewidth',1.5)
xlabel('Inferred Doubling Time (h)'); ylabel('Ring Index (GDGTs 0-6)'); legend('Bioreactor 1','Bioreactor 2','Bioreactor 3')

% Linear regression statistics using Matlab fitlm ('Fit linear regression model')
BR1_linreg = fitlm(BR1_doublingtime, BR1_ringindex)
BR1_slope = BR1_linreg.Coefficients.Estimate(2)

BR2_linreg = fitlm(BR2_doublingtime, BR2_ringindex)
BR2_slope = BR2_linreg.Coefficients.Estimate(2)

BR3_linreg = fitlm(BR3_doublingtime, BR3_ringindex)
BR3_slope = BR3_linreg.Coefficients.Estimate(2)


%% S.aci vs. N.maritimus comparison using all available data points
% figure(2)
% hold on
% title('S. acidocaldarius R.I. (GDGTs 0-6) and N. maritimus R.I. (GDGTs 0-4)')
% hurley_dts = [22 30 71]; % doubling times, in hours
% hurley_RI = [3.09 3.17 3.48]; % Total GDGTs, Ring index of all GDGTs, including crenarchaeol (from Hurley et al. 2016)
% 
% yyaxis left
% plot(BR1_doublingtime,BR1_ringindex,'s','Markersize',15,'MarkerEdgecolor','red','MarkerFaceColor',[1 .4 .4])
% plot(BR2_doublingtime,BR2_ringindex,'d','Markersize',15,'MarkerEdgeColor','black','MarkerFaceColor',[.4 .4 .4])
% plot(BR3_doublingtime,BR3_ringindex,'^','Markersize',15,'MarkerEdgeColor','blue','MarkerFaceColor',[.6 .6 1])
% 
% errorbar(BR1_doublingtime(BR1_sampleindex),BR1_ringindex(BR1_sampleindex),zeros([1 10]),zeros([1 10]), BR1xneg'*.3, BR1xpos','k.','Linewidth',1.5)
% errorbar(BR2_doublingtime(BR2_sampleindex),BR2_ringindex(BR2_sampleindex),zeros([1 10]),zeros([1 10]), BR2xneg'*.3, BR2xpos','k.','Linewidth',1.5)
% errorbar(BR3_doublingtime(BR3_sampleindex),BR3_ringindex(BR3_sampleindex),zeros([1 10]),zeros([1 10]), BR3xneg'*.3, BR3xpos','k.','Linewidth',1.5)
% ylabel('Ring Index (GDGTs 0-6)')
% 
% yyaxis right
% ylim([1 2.8]) % same absolute scale as our data, shifted down
% plot(hurley_dts, hurley_RI,'v','Markersize',10,'MarkerEdgeColor','black','MarkerFaceColor', [.6 1 .6])
% plt = gca;
% plt.YAxis(2).Color = 'm';
% legend('Saci Bioreactor 1','Saci Bioreactor 2','Saci Bioreactor 3','Hurley N. maritimus')
% xlabel('Doubling Time (h)'); ylabel('Ring Index (GDGTs 0-4)');


%% Plot S.acidocaldarius vs. N.maritimus comparisons using average ring index values across all bioreactors
figure(3)
hold on
title('S. acidocaldarius R.I. (GDGTs 0-6) and N. maritimus R.I. (GDGTs 0-4 + crenarchaeol)')

hurley_dts = [22 30 71]; % doubling times, in hours
hurley_RI = [3.09 3.17 3.48]; % Total GDGTs, Ring index 0-4
hurley_RI_errors = [0.06 0.06 0.01]; % [22h Td, 30h Td, 70h Td]

average_BR_ringindex = [2.12 2.04 2.31 3.35]; % ring indices for each dilution rate averaged across all bioreactors
std_error_RI = [0.06290 0.05537 0.24456 0.14258]; % standard errors of averaged RI for 18h, 10h, 30h, and 70h experiments, respectively
average_doublingtime = [(11.96 + 9.37 + 11.86)/3 (6.87 + 8.67 + 6.98)/3 (20.31 + 20.40 + 21.27)/3 (51.63 + 41.35 + 39.97)/3];
error_doublingtimes = [7.12 3.31 3.34 4.25];

% co-plotting our averaged data vs. Hurley's
ylim([1.8 3.6])
ylabel('Total Ring Index');

plot(average_doublingtime, average_BR_ringindex,'s','Markersize',15,'MarkerEdgecolor','black','MarkerFaceColor',[.4 .4 .4])
ylabel('Ring Index (0-6)')
xlabel('Doubling Time (h)')

plot(hurley_dts, hurley_RI,'v','Markersize',15,'MarkerEdgeColor','black')

ylabel('Ring Index (0-6)')
xlabel('Doubling Time (h)');
legend('{\it S. acidocaldarius}','{\it N. maritimus}')


%FORMAT: errorbar(x,y,yneg,ypos,xneg,xpos)
errorbar(average_doublingtime,average_BR_ringindex, std_error_RI./2, std_error_RI./2,...
   error_doublingtimes./2, error_doublingtimes./2,'k.','Linewidth',1.5); % x vector, y vector, y +- error, x+- error
errorbar(hurley_dts, hurley_RI, hurley_RI_errors, hurley_RI_errors, [], [], 'k.','Linewidth',1.5); % x errors unknown


saci_model = fitlm(average_doublingtime, average_BR_ringindex);
saci_fitline = plot(saci_model);
set(saci_fitline(2),'Color','k','Linewidth',2); % sets properties of regression line
set(saci_fitline(3),'Color','k','Linewidth',2); % sets properties of first confidence bound
set(saci_fitline(4),'Color','k','Linewidth',2); % sets properties of second confidence bound


hurley_model = fitlm(hurley_dts, hurley_RI);
hurley_fitline = plot(hurley_model);
set(hurley_fitline(2),'Color','k','Linewidth',2);
set(hurley_fitline(3),'Color','k','Linewidth',2);
set(hurley_fitline(4),'Color','k','Linewidth',2);

%% Literally just generating a legend
%% Plot S.acidocaldarius vs. N.maritimus comparisons using average ring index values across all bioreactors
figure(2)
hold on
title('S. acidocaldarius R.I. (GDGTs 0-6) and N. maritimus R.I. (GDGTs 0-4 + crenarchaeol)')

hurley_dts = [22 30 71]; % doubling times, in hours
hurley_RI = [3.09 3.17 3.48]; % Total GDGTs, Ring index 0-4
hurley_RI_errors = [0.06 0.06 0.01]; % [22h Td, 30h Td, 70h Td]

average_BR_ringindex = [2.12 2.04 2.31 3.35]; % ring indices for each dilution rate averaged across all bioreactors
average_doublingtime = [(11.96 + 9.37 + 11.86)/3 (6.87 + 8.67 + 6.98)/3 (20.31 + 20.40 + 21.27)/3 (51.63 + 41.35 + 39.97)/3];


% co-plotting our averaged data vs. Hurley's
ylim([1.8 3.6])
ylabel('Total Ring Index');

plot(average_doublingtime, average_BR_ringindex,'s','Markersize',15,'MarkerEdgecolor','black','MarkerFaceColor',[.4 .4 .4])
ylabel('Ring Index (0-6)')
xlabel('Doubling Time (h)')

plot(hurley_dts, hurley_RI,'v','Markersize',15,'MarkerEdgeColor','black')

ylabel('Ring Index (0-6)')
xlabel('Doubling Time (h)');
legend('{\it S. acidocaldarius}','{\it N. maritimus}')
