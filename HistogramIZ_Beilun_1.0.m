clear all; clc; close all

% Change the Bias voltge here if it's different.
Bias=0.1; % En V
count = 0;

% You need to put yourself inside the folder that directly contain the .blq
% file. Put here the name of the file name which is to be treated.
FileNames='2019-04-10-1';

data = ReducedblqreaderV6([FileNames '.blq']);

%  d=0.004; %Bias=0.01V
d=0.000788;  % Good value of the bin size for Bias=0.1 V
edge=[0:d:4.5];
M=floor(4.5/d);

% Initialize the counts
for i = 1:M
    Ntotal(i)=0;
end

for i = 1:length(data)
    current(1:2048)=(data(i).data(:,2) - data(i).data(1,2))/(7.748091E-5*Bias); 
    % An error here in the old version, which leads to an offset of 13G_0 for the pair curves.
    N=histcounts(current,edge);
    N(1)=0;
    Ntotal=Ntotal+N;
    count=count+1;
end

% hold on
% plot(edge(1:M),Ntotal)
% axis([1.6,2.2,0,2.5e4])
% axis([0,4.5,0,15e4])
% hold off

%indice=[1:M].';
conductance=edge(1:M).';
Ntotal=Ntotal.';

%T = table(indice,conductance,Ntotal);
T = table(conductance,Ntotal);
plot(conductance,Ntotal)

%Change the .txt file where you want to write the histogram data here (you
%might need to create a fold named 'histogram' in the current folder)
writetable(T,strcat('histogram\histogram_10T_100mV_',FileNames,'.txt'),'Delimiter','\t');
