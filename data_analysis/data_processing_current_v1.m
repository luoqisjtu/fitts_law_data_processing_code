%% 遍历文件夹
clear; clc;
% cd('D:/Luoqi/fitts_law/able-bodied_subject_data/S3_liujiayue_2018_12_10/neuromorphic_on/S3_test5_brittleness_neuromorphic')
cd('D:/Luoqi/fitts_law/able-bodied_subject_data_and_results/data_analysis/Pressure-Lce/n_ba_off_1')

% PathRoot='E:/fitts_law_experiment/unity_project/Current_Force_test_success/Fitts_law_data/YF_with_fragile_1';
% list=dir(fullfile(PathRoot));
% fileNum=size(list,1)-2; 
% 
% mat_new = cell(length(fileNum),1);
% 
% for k=3:size(list,1)
% 	mat_new{k-2}=csvread(list(k).name,1,0);  % 这就是文件名，如果有子文件夹，则也包含在里面。
% end
% mat_CSV = cell(length(fileNum),1);
% 
% for i=1:fileNum
%     mat_CSV{i}=mat_new{i}(1:size(mat_new{i},1)-300,:);   % 去掉最后300帧的数据
% end
% 
% 
% mat_time = cell(length(fileNum),1);

%% 设置ID等级的数量

level = 6;

%% 读取力的大小值
filename1 = 'D:/Luoqi/fitts_law/ID_6_force_Fmin_Fmax.csv';
file = csvread(filename1,1,0);  
fmin = file(1:level,4); 
fmax = file(1:level,5);

%%
ID_time=zeros(level,1);
ID_time_re=zeros(level,1);
reaction_time=zeros(level,1);
collision_p=zeros(level,1);

for k=1:level
    
     fname_read = ['Force_bar', num2str(k),'.csv'];
     F = csvread(fname_read,1,0);
  %  F= csvread(list(k+2).name,1,0);

    T = F(:,1); 
    [n,m] = size(T);
    max_t = 0.01*n - 0.01;
    t_ = 0: 0.01:max_t;
    t = t_';
    
    %统计力条上升的时间，从力条开始移动的时间算起 %%%%起始的压力值根据实际的情况可以调整？？？？？没有考虑到
    for m=1:length(F(:,2))
        if(F(m,2)>0.1)    
            start_time=m;
            break;
        end     
    end
    
    ID_time(k)=t(length(t)-300)-t(start_time);    
    ID_time_re(k)=t(length(t)-300)-0.2;
    reaction_time(k) = ID_time_re(k)-ID_time(k);
    
    
    %统计每组task碰到禁止区域的次数(0-没有碰到，1-碰到)
    collision =  F(:,6);
    collision_p(k) = sum(collision == 1);
    cp_t = sum(collision_p~=0);   %碰到禁止区域次数
    
    figure(k),
    plot(t(1:length(t)-300),F(1:length(F)-300,2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;     % 横纵坐标都要去掉最后的3s的数据，也就是300个数
  %plot(t(1:length(t)),F(1:length(F),2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;     
  
    xlim=get(gca,'Xlim'); % 获取当前图形的纵轴的范围
  
    plot(xlim,[fmax(k)-0.002,fmax(k)-0.002],'--','linewidth',1.5,'color',[0,1,0]);hold on
    plot(xlim,[fmin(k)-0.002,fmin(k)-0.002],'--','linewidth',1.5,'color',[1,0,0]); hold off
  
    pressure =  F(:,2);
    if max(pressure)>=fmax(k)
        y_max=max(pressure);
    else
        y_max=fmax(k);
    end
    
    axis([0 max_t 0 y_max+1]);   
    xlabel('Time(s)');
    ylabel('Pressure(N)');
    title(['ID =',num2str(k)]);
    set(gca,'FontSize',16);%只能同时改变x y轴显示的字体大小；
    set(get(gca,'YLabel'),'Fontsize',19);% 是针对标注的而不是坐标刻度
    set(get(gca,'XLabel'),'Fontsize',19);% 是针对标注的而不是坐标刻度
    h=legend ( 'Pressure', 'Fmax',' Fmin', 'Location' ,'SouthEast');
    set(h,'Box','off');
    % 保存图片到当前目录
     m=sprintf('task_%d.png',k);
     n=sprintf('task_%d.eps',k);
     saveas(figure(k),m);
     saveas(figure(k),n);
%      
%      
    figure(k),
    plot(t(1:length(t)-300),F(1:length(F)-300,8),'linewidth',1.5,'color',[0,0,1]); hold on;
    axis([0 max_t 1 2.5]);   
    xlabel('Time(s)');
    ylabel('Lce');
    title(['ID =',num2str(k)]);
    m_1=sprintf('lce_%d.png',k);
    n_1=sprintf('lce_%d.eps',k);
    saveas(figure(k),m_1);
    saveas(figure(k),n_1); 
     
end

%% 绘制ID与time的曲线
%ID_true=[3.32 3.7 3.74 4.12 4.17 4.32 4.39 4.52 4.58 4.64 4.7 4.81 4.94 5.06 5.17 5.39 5.52 5.64];
% ID=[4.32,4.12,4.64,5.17,3.32,4.7,4.39,3.7,4.58,5.39,4.17,4.81,5.64,5.52,3.74,4.94,5.06,4.52];
% % % ID=[5.17,3.74,4.64,4.32,4.17,5.64,4.58,3.32,5.06];
% % % figure(level+1)
% % % plot(ID(1:level),ID_time,'.','Markersize',15);
% % % xlabel('ID');
% % % ylabel('Time(s)')
% % % %title('Hand group5')
% % % png=sprintf('time_ID.png');
% % % saveas(figure(level+1),png);

%% 计算throughput(TP): TP= (ID1/MT1 + ID2/MT2 +...+ IDi/MTi )/N
% X=(ID)'./ID_time;
% TP=mean(X);



%cd \
cd ..
cd ..
cd ..
cd ..