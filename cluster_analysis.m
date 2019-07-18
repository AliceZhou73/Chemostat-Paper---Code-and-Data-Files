%% Hierarchical cluster analysis of relative GDGT abundances for all chemostat samples
% ----------------------------------------------------------------------
% Created by: Alice Zhou (Alice.Zhou.GR@dartmouth.edu)
% Version: 1.0 (Last modified 7/9/19)
% Date: 7/9/19 

% Dependencies: Requires data file 'Saci Chemostat Data Compilation' to be
% in same file directory as script. If file is in different directory, must
% designate full path to file below. 

%% Loading in data, computing normalized lipid abundances
% Loads in data file
clc;clear;close all
filename = 'Saci Chemostat Data Compilation.xlsx' % enter path to file in single quotes
sheet = 2;
[numeric,text_only,all_data] = xlsread(filename,sheet,'','basic'); % loads data as cell array
all_data

% Reformats data
data_no_headers = all_data;
headers = [1,2]; % enter row numbers of text headers in an array
data_no_headers(headers,:) = []; % removes rows with text headers

GDGT_start = 4; % enter column number where GDGT data starts (GDGT-0, usually)
GDGT_end = 13; % enter column number where GDGT data ends
all_GDGTs = data_no_headers(:,GDGT_start:GDGT_end) % returns GDGT data
all_GDGTs = cell2mat(all_GDGTs);

% Create normalized GDGT values.
% For normalization loop, assumes data is formatted as follows: 

%            GDGT0 GDGT1 GDGT2 GDGT3 ..... indexed by j
%   Sample 1
%   Sample 2
%   Sample 3
%   Sample 4
%      .
%      .
%      .
%   Sample(length_all_GDGTs)            
%      ^
%      indexed by i
normalized_GDGTs = []; 


for i = 1:length(all_GDGTs) % for all samples
    for j = 1:(GDGT_end - GDGT_start + 1); % for all GDGT species 
        normalized_GDGTs(i,j) = all_GDGTs(i,j)/(sum(all_GDGTs(i,:))) 
        % relative abundance of each GDGT species is the value divided by
        % the sum of all GDGTs for that particular sample (sum across the
        % row)
    end
end
normalized_GDGTs
if rem((normalized_GDGTs(randi(length(normalized_GDGTs)),:)),1) == 0
 % checks that remainder after sum of a random row divided by 1 is zero
    disp('CHECK NORMALIZATION SCRIPT -- PERCENTAGES DO NOT ADD TO 1.')
else
    disp('Normalization routine successful.')
end

%% Cluster analysis using Euclidean distance metric

eucD = pdist(normalized_GDGTs, 'euclidean');
clustTreeEuc = linkage(eucD,'average'); % the average method computes unweighted average distances between clusters
coph_dist = cophenet(clustTreeEuc,eucD); % runs cophenetic correlation to verify that cluster tree is consistent with original distances.
% large values indicate that the tree fits the distances well, in the sense
% that pairwise distances between observations correlate with their actual
% pairwise distances
if coph_dist < 0.85
    disp('Cluster tree correlates poorly with Euclidean distances. Consider using a different clustering method.')
else
    disp('Cluster tree correlates well with Euclidean distances (cophenetic correlation >= 0.85)')
end

figure(1)
% Plotting a dendrogram to visualize the hierarchy of clusters:
labels = [{'BR1S11','BR2S11','BR3S11','BR1S16','BR2S16','BR3S16','BR1S17','BR2S17','BR3S17','BR1S19','BR2S19','BR3S19',...
    'BR1S20','BR2S20','BR3S20','BR1S22','BR2S22','BR3S22','BR2S4A','BR3S4A','BR1S4B','BR3S4B','BR2S4B','BR1S4A','BR1S4E','BR2S4F',...
    'BR1S4F','BR3S4E','BR3S4F','BR2S4E'}] % in order of appearance in data sheet

[h, nodes] = dendrogram(clustTreeEuc,0,'ColorThreshold','default','Orientation','left','Labels',labels);

set(h,'Linewidth',2.4)
h_gca = gca;
h_gca.TickDir = 'out';
h_gca.TickLength = [.002 0];
h_gca.XTickLabel = [];

%% Heatmap of Euclidean distances
figure(2)
inv_hot_colormap = flipud(hot);
heatmap(squareform(eucD),'XData',[{'BR1S11','BR2S11','BR3S11','BR1S16','BR2S16','BR3S16','BR1S17','BR2S17','BR3S17','BR1S19','BR2S19','BR3S19',...
    'BR1S20','BR2S20','BR3S20','BR1S22','BR2S22','BR3S22','BR2S4A','BR3S4A','BR1S4B','BR3S4B','BR2S4B','BR1S4A','BR1S4E','BR2S4F',...
    'BR1S4F','BR3S4E','BR3S4F','BR2S4E'}],...
    'YData',[{'BR1S11','BR2S11','BR3S11','BR1S16','BR2S16','BR3S16','BR1S17','BR2S17','BR3S17','BR1S19','BR2S19','BR3S19',...
    'BR1S20','BR2S20','BR3S20','BR1S22','BR2S22','BR3S22','BR2S4A','BR3S4A','BR1S4B','BR3S4B','BR2S4B','BR1S4A','BR1S4E','BR2S4F',...
    'BR1S4F','BR3S4E','BR3S4F','BR2S4E'}],'colormap',inv_hot_colormap,'ColorMethod','mean'); 
title('Euclidean distances between pairs of samples');
links = linkage(eucD,'average'); % first two columns identify samples that have been linked, while the third displays separation distance
% Default = single-linkage (nearest-neighbor) clustering, 
% 'Average' uses mean distances between all pairs of objects in any two clusters
figure(3)
[dend_settings, nodes] = dendrogram(links,0,'ColorThreshold','default','Orientation','left','Labels',labels);
title('Hierarchical Cluster Analysis (Average-Link Clustering)')
xlabel('Distance') % I think distance is calculated as D = 1-C (where C is correlation between compound clusters)
set(dend_settings,'Linewidth',2.4)