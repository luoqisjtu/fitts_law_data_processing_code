%% 遍历文件夹
clear; clc;                                                                         %把t>=14s和碰到禁止区域对应的trial的MT去掉
%%
G = 2; %model 1-off  2-on
Fi = 2; %filter 1-ba  2-bw
Q = 8;%test重复次数 
level = 6;   % 设置ID等级的数量     每个test文件夹里的csv文件个数

mat_new_mt = cell(8,2);
mat_new_sr = cell(8,2);
%%  
for g = 1:G
    
    cd(strcat(['D:/Luoqi/fitts_law/able-bodied_subject_data_and_results/data_analysis/S3_able-bodied_zhuyongfa_force_data_2019_1_16/model_',num2str(g)]));
    
  for fi = 1:Fi  
      
       cd(strcat(['D:/Luoqi/fitts_law/able-bodied_subject_data_and_results/data_analysis/S3_able-bodied_zhuyongfa_force_data_2019_1_16/model_',num2str(g),'/filter_',num2str(fi)]));
       
    for q = 1:Q

        cd(strcat(['D:/Luoqi/fitts_law/able-bodied_subject_data_and_results/data_analysis/S3_able-bodied_zhuyongfa_force_data_2019_1_16/model_',num2str(g),'/model',num2str(g),'_bw_test_',num2str(q)]));
        %     files = dir([foldername '\*.csv']);                              % _n_bw_test_/_y_bw_test_/_n_ba_test_/_y_ba_test_          
        
        %% 读取力的大小值
        filename1 = 'D:/Luoqi/fitts_law/ID_6_force_Fmin_Fmax.csv';
        file = csvread(filename1,1,0);
        fmin = file(1:level,4);
        fmax = file(1:level,5);
        %%
        ID_number=zeros(level,1);
        ID=zeros(level,1);
        ID_time=zeros(level,1);
        ID_time_re=zeros(level,1);
        reaction_time=zeros(level,1);
        collision_p=zeros(level,1);
        
        IDs =[5.17;4.37;3.59;4.95;4.17;5.95];
        
        for k=1:level
            
            ID(k)=IDs(k,1);         
            
            fname_read = ['Force_bar', num2str(k),'.csv'];   %起始ID这组数据不读进去 —— 把k-1改为k
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
            
            ID_number(k)=k;
            ID_time(k)=t(length(t)-300)-t(start_time);
            ID_time_re(k)=t(length(t)-300)-0.2;
            reaction_time(k) = ID_time_re(k)-ID_time(k);
            
            
            %统计每组task碰到禁止区域的次数(0-没有碰到，1-碰到)
            collision = F(:,6);
            collision_p(k) = sum(collision == 1);
            cp_t = sum(collision_p~=0);   %碰到禁止区域次数
            
            
            if(ID_time(k)>13||collision_p(k)~=0)
                  ID_time(k)=0;  %ID_time(k)=[];
%                   ID_number(k)=0;
                  ID(k)=0;
                  reaction_time(k)=0;
            end
            
            
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
            h_i=legend ( 'Pressure', 'Fmax',' Fmin', 'Location' ,'SouthEast');
            set(h_i,'Box','off');
            % 保存图片到当前目录
            m=sprintf('task_%d.png',k);
            n=sprintf('task_%d.eps',k);
            saveas(figure(k),m);
            saveas(figure(k),n);
            
        end
        
        %% 绘制ID与time的曲线
        %ID_true=[3.32 3.7 3.74 4.12 4.17 4.32 4.39 4.52 4.58 4.64 4.7 4.81 4.94 5.06 5.17 5.39 5.52 5.64];
        % ID=[4.32,4.12,4.64,5.17,3.32,4.7,4.39,3.7,4.58,5.39,4.17,4.81,5.64,5.52,3.74,4.94,5.06,4.52];
%         ID=[5.17,4.37,3.59,4.95,4.17,5.95];
%         figure(level+1)
%         plot(ID(1:level),ID_time,'.','Markersize',15);
%         xlabel('ID');
%         ylabel('Time(s)')
%         %title('Hand group5')
%         png=sprintf('time_ID.png');
%         saveas(figure(level+1),png);

         %% 计算sucess rate  
          fail_nu = sum(ID_time == 0);  %MT被置为0的task个数（每组失败的task个数）
          SR = 1 - fail_nu/6;
        
        %% 计算throughput(TP): TP= (ID1/MT1 + ID2/MT2 +...+ IDi/MTi )/N
%         X=(ID)'./ID_time;
%         TP=mean(X);
          mat_new_mt{q,g}(:,4)= reaction_time;
          mat_new_mt{q,g}(:,3)= ID_time;   
          mat_new_mt{q,g}(:,2)= ID;
          mat_new_mt{q,g}(:,1)= ID_number;
          %aaaaa=sum(ID_time == 0);  aaaaa=find(ID_time == 0);  cell2mat
          
%           output_data_q = mat_new_mt{q,1};
%           csvwrite('S1_y_ba_',num2str(q), '.csv',output_data_q);

          output_data_1_1 = mat_new_mt{1,1};
          output_data_1_2 = mat_new_mt{2,1};
          output_data_1_3 = mat_new_mt{3,1};
          output_data_1_4 = mat_new_mt{4,1};
          output_data_1_5 = mat_new_mt{5,1};
          output_data_1_6 = mat_new_mt{6,1};
          output_data_1_7 = mat_new_mt{7,1};
          output_data_1_8 = mat_new_mt{8,1};
          
          output_data_2_1 = mat_new_mt{1,2};
          output_data_2_2 = mat_new_mt{2,2};
          output_data_2_3 = mat_new_mt{3,2};
          output_data_2_4 = mat_new_mt{4,2};
          output_data_2_5 = mat_new_mt{5,2};
          output_data_2_6 = mat_new_mt{6,2};
          output_data_2_7 = mat_new_mt{7,2};
          output_data_2_8 = mat_new_mt{8,2};
          
          csvwrite('S3_bw_1_1.csv',output_data_1_1);
          csvwrite('S3_bw_1_2.csv',output_data_1_2);
          csvwrite('S3_bw_1_3.csv',output_data_1_3);
          csvwrite('S3_bw_1_4.csv',output_data_1_4);
          csvwrite('S3_bw_1_5.csv',output_data_1_5);
          csvwrite('S3_bw_1_6.csv',output_data_1_6);
          csvwrite('S3_bw_1_7.csv',output_data_1_7);
          csvwrite('S3_bw_1_8.csv',output_data_1_8);
          
          csvwrite('S3_bw_2_1.csv',output_data_2_1);
          csvwrite('S3_bw_2_2.csv',output_data_2_2);
          csvwrite('S3_bw_2_3.csv',output_data_2_3);
          csvwrite('S3_bw_2_4.csv',output_data_2_4);
          csvwrite('S3_bw_2_5.csv',output_data_2_5);
          csvwrite('S3_bw_2_6.csv',output_data_2_6);
          csvwrite('S3_bw_2_7.csv',output_data_2_7);
          csvwrite('S3_bw_2_8.csv',output_data_2_8);
    end         
   end       
end   


%%  结果保存为.mat文件
cd('D:\Luoqi\fitts_law\able-bodied_subject_data_and_results\data_analysis\S3_able-bodied_zhuyongfa_force_data_2019_1_16');
save(['S3_able-bodied_zhuyongfa_bw.mat']);    
%cd \
