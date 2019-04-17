clear all; clc; close all;
% Files=dir(fullfile( 'IZ\','*.blq'));

% Change the Bias voltge here if it's different.
Bias=0.1; % En V
count = 0;

% Change the filename once inside the folder that contains the .blq file
FileNames='2019-04-13-2';

data = ReducedblqreaderV6([FileNames '.blq']);

%  d=0.004; %Bias=0.01V
d=0.000788;  %Good value for Bias=0.1 V
edge=[0:d:4.5];
M=floor(4.5/d);

% x-axis vector for the IZ curves, when it was taken at 2048 points, and
% 100mV for the Z voltage
z_position = -1024:1:1023;
z_position = z_position/1024*100;

% Initialize the count vector, in case needed
for i = 1:M
    Ntotal(i)=0;
    Ngood(i)=0;
end

fig = figure;
fig.WindowKeyPressFcn = @saveEasy;

for i = 1:length(data)
    if mod(i,2)        
        current(1:2048)=(data(i).data(:,2) - data(i).data(1,2))/(7.748091E-5*Bias);
    else
        current(1:2048)=(data(i).data(:,2) - data(i).data(2048,2))/(7.748091E-5*Bias);
        current = fliplr(current);
    end
    N=histcounts(current,edge);
    N(1)=0;
    
    if sum(N(573:700))>30 && sum(N(3000:3850))>1 % Criteria for selecting only the curves that that contain a finite half quantum conductance step.
       i 
       Ntotal=Ntotal+N;
       count=count+1;
       % Put here the fold and the files name for saving the selected data
       fig.UserData = strcat('Half_quantum_curves\',FileNames,'_curve(',num2str(i),').txt'); 
       
       %In the plot window, press 'enter' to save a curve in a .txt file,
       %press 'right' to skip to the next one.
       plot(z_position,current)
       hold on
       plot([-100 100], [0.5 0.5]) % One line corresponding the 1/2 G_0
       plot([-100 100], [1 1]) %One line corresponding to 1 G_0
       hold off
       fig.Children.YLim = [0 5];
       fig.Children.XLim = [-100 100];
       uiwait(fig)
    end
end    

close all; % Close the graph when you have seen all

'finished' %and you see this mesage

%indice=[1:M].';
conductance=edge(1:M).';
Ntotal=Ntotal.';

T = table(conductance,Ntotal);

%writetable(T,strcat('IZ\',FileNames,'_histogram.txt'),'Delimiter','\t'); % Output: file for the histogram of all the selected files
% 
% Tcurvas = table(Curves.');
% 
% writetable(Tcurvas,strcat('IZ\',FileNames,'_curves.txt'),'Delimiter','\t'); % Output: list of the selected

