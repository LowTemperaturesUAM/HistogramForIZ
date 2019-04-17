clear all; clc; close all;
% Files=dir(fullfile( 'IZ\','*.blq'));

% Change the Bias voltge here if it's different.
Bias=0.1; % En V
count = 0;

% Change the filename once inside the folder that contains the .blq file
FileNames='2019-04-13-1';

data = ReducedblqreaderV6([FileNames '.blq']);

%  d=0.004; %Bias=0.01V
d=0.000788;  %Good value for Bias=0.1 V
edge=[0:d:4.5];
M=floor(4.5/d);

% Initialize the count vector: Ntotal for the histogram with the whole data
% set; Ngood for the histogram only for the selected data
for i = 1:M
    Ntotal(i)=0;
    Ngood(i)=0;
end

for i = 1:length(data)
    if mod(i,2)        
        current(1:2048)=(data(i).data(:,2) - data(i).data(1,2))/(7.748091E-5*Bias);
    else
        current(1:2048)=(data(i).data(:,2) - data(i).data(2048,2))/(7.748091E-5*Bias);
   %     current = fliplr(current);
    end
    N=histcounts(current,edge);
    N(1)=0;
    Ntotal=Ntotal+N;
    if sum(N(3000:3850))>1 
    % Criteria for selecting the curves that contain finite number of
    % points between 2.4 and 3 G0, in order to rule out the curves where we
    % did not reach contact.
       Ngood=Ngood+N;
       count=count+1;
    end
end    

% hold on
% plot(edge(1:M),Ntotal)
% axis([1.6,2.2,0,2.5e4])
% axis([0,4.5,0,15e4])
% hold off

%indice=[1:M].';
conductance=edge(1:M).';
Ntotal=Ntotal.';
Ngood=Ngood.';

hold on;

plot(conductance,Ntotal)
plot(conductance,Ngood)

T = table(conductance,Ntotal,Ngood);

%Change the .txt file where you want to write the histogram data here (you
%might need to create a fold named 'histogram' in the current folder)
writetable(T,strcat('histogram\histogram_19T_100mV_',FileNames,'.txt'),'Delimiter','\t'); 

