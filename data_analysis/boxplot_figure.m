%% 绘制箱式图
clc;
clear;

filename1 = 'D:/Luoqi/fitts_law/experiement_results/boxplot_data_luoqi.csv';
file = csvread(filename1,1,0);  
MT_nb = file(:,3:4); 


for i=1:18
    box_data(:,i) = MT_nb(i,:);
end
%boxplot(box_data);
% set(gca,'xticklabel',{'1' '3' '5'})   % 改变对应的x值


filename2 = 'D:/Luoqi/fitts_law/ID_18_task.csv';
file2 = csvread(filename2,1,0);  
ID_18_task = file2(1:18,1); 
% 将ID进行正序排列
[ID_sort index]=sort(ID_18_task);  

box_data_sort=box_data(:,index);
data = box_data_sort';
boxplot(box_data_sort);


% x1 = normrnd(5,1,100,1)';
% x2 = normrnd(6,1,200,1)';

% x1 = box_data(1:2,:); 
% x2 = box_data(3:4,:); 
% x3 = box_data(5:6,:); 
% X = [x1 x2 x3];
% G = [zeros(size(x1)) ones(size(x2)) 2*ones(size(x3))];
% boxplot(X, G); %如果组别非常多，建议用compact格式: boxplot(X, G,'plotstyle','compact');

% group = [zeros(1,length(x1_0)),ones(1,length(y1_0)),2*ones(1,length(x2_0)),3*ones(1,length(y2_0)),4*ones(1,length(x3_0)),5*ones(1,length(y3_0))];


% h = title('Able-bodied subject4 no brittleness');
xlabel('ID number');
ylabel('Time(s)')
% saveas(gcf,['D:\Luoqi\fitts_law\experiement_results\','amputee_no_brittlenss','.png']);

