%% 遍历文件夹
clear; clc;                                                                      %% MT-movement time   CT-completion time 
%%
path = pwd;
%%
G = 2; %model PD+linear feedback;  pilot model;  full model; human hand
Q = 6;%test重复次数  8
level = 6;   % 设置ID等级的数量     每个test文件夹里的csv文件个数

mat_new_ct = cell(8,4);
SR = zeros(Q,4);
break_rate = zeros(Q,4);
MT_aver = zeros(Q,4);
TP = zeros(Q,4);
TP_correction = zeros(Q,4);
datasave1 = zeros(Q,4);
datasave2 = zeros(Q,4);
%%  
for g = 1:G
    
%     cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/full_model_fitts/grip_force_control_task/S3_all_data/outcome_data/model_',num2str(g)]));  %single_finger_force_control_task  grip_force_control_task
    cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/pilot_model_fitts/S3_all_data/outcome_data/model_',num2str(g)]));      %JNE！！！
    
    for q = 1:Q

%         cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/full_model_fitts/grip_force_control_task/S3_all_data/outcome_data/model_',num2str(g),'/model',num2str(g),'_test',num2str(q)]));
        cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/pilot_model_fitts/S3_all_data/outcome_data/model_',num2str(g),'/model',num2str(g),'_ba_test_',num2str(q)]));   %JNE！！！
        %     files = dir([foldername '\*.csv']);                                      
        
        %% 读取力的大小值
        filename1 = 'D:/Luoqi/fitts_law/ID_6_single_finger_force_Fmin_Fmax.csv';   %%% ID_6_single_finger_force_Fmin_Fmax       ID_6_grip_force_Fmin_Fmax.csv
        file = csvread(filename1,1,0);
        fmin = file(1:level,4);
        fmax = file(1:level,5);
        %%
        ID_number=zeros(level,1);
        ID=zeros(level,1);
        completion_time=zeros(level,1);
        completion_time_re=zeros(level,1);
        movement_time=zeros(level,1);
        collision_p=zeros(level,1);
        
%         IDs =[5.17;4.37;3.59;5.95;4.17;4.95];   %IDs =[5.17;4.37;3.59;4.95;4.17;5.95];  当在实验设置中改变不同ID的task顺序时，此处也要相应调整顺序！！！！！！    
         IDs =[5.17;4.37;3.59;4.95;4.17;5.95];  %JNE！！！
        
        for k=1:level
            
            ID(k)=IDs(k,1);         
            
            fname_read = ['Force_bar', num2str(k),'.csv'];   %起始ID这组数据不读进去 —— 把k-1改为k     JNE——有些是k-1，有些是k！！！
            force_val = csvread(fname_read,1,0);
            %  F= csvread(list(k+2).name,1,0);
            
            Tim = force_val(:,1);
            [n,m] = size(Tim);
            max_t = 0.01*n - 0.01;
            t_ = 0: 0.01:max_t;
            t = t_';
            
            %统计力条上升的时间，从力条开始移动的时间算起 %%%%起始的压力值根据实际的情况可以调整
            for m=1:length(force_val(:,2))
                if(force_val(m,2)>0.1)
                    start_time=m;
                    break;
                end
            end
            
            ID_number(k)=k;
            completion_time(k)=t(length(t)-300)-t(start_time);   %500    full model-500   JNE——300！！！
            completion_time_re(k)=t(length(t)-300);      %0.2s-在unity中设置，目标出现0.2s后，task开始  completion_time_re(k)=t(length(t)-300)-0.2;
            movement_time(k) = completion_time_re(k)-completion_time(k);
            
            
            %统计每组task碰到禁止区域的次数(0-没有碰到，1-碰到)
            collision = force_val(:,6);
            collision_p(k) = sum(collision == 1);
            cp_t = sum(collision_p~=0);   %碰到禁止区域次数
            
            
            if(completion_time_re(k)>=13||collision_p(k)~=0||movement_time(k)<=0)            %%t>13或碰到禁止区域或没有从起始位置出发对应的trial记为fail   full model-14.8   JNE——13！！！
                  completion_time(k)=100;  %ID_time(k)=[];
%                   ID_number(k)=0;
                  ID(k)=0;
                  movement_time(k)=0;
            end
                                 

          %%             
            
            figure(k),
            plot(t(1:length(t)-300),force_val(1:length(force_val)-300,2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;     % 横纵坐标都要去掉最后的5s的数据，也就是300个数  % 3s  300
            %plot(t(1:length(t)),F(1:length(F),2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;
            
            xlim=get(gca,'Xlim'); % 获取当前图形的纵轴的范围
            
            plot(xlim,[fmax(k)-0.002,fmax(k)-0.002],'--','linewidth',1.5,'color',[0,1,0]);hold on
            plot(xlim,[fmin(k)-0.002,fmin(k)-0.002],'--','linewidth',1.5,'color',[1,0,0]); hold off
            
            pressure =  force_val(:,2);
            if max(pressure)>=fmax(k)
                y_max=max(pressure);
            else
                y_max=fmax(k);
            end
            
            
            axis([0 max_t 0 y_max+1]);
            xlabel('Time(s)');
            ylabel('Grip force(N)');     %Grip force(N)  Pressure
            title(['ID =',num2str(k)]);
            set(gca,'FontSize',16);%只能同时改变x y轴显示的字体大小；
            set(get(gca,'YLabel'),'Fontsize',19);% 是针对标注的而不是坐标刻度
            set(get(gca,'XLabel'),'Fontsize',19);% 是针对标注的而不是坐标刻度
            h_i=legend ( 'Force', 'Fmax',' Fmin', 'Location' ,'SouthEast');  %Grip force  Pressure
            set(h_i,'Box','off');
            % 保存图片到当前目录
%             fmm=sprintf('task_%d.png',k);
%             fnn=sprintf('task_%d.eps',k);
%             saveas(figure(k),fmm);
%             saveas(figure(k),fnn);      
            
        end
        
        %% 绘制ID与time的曲线
        %ID_true=[3.32 3.7 3.74 4.12 4.17 4.32 4.39 4.52 4.58 4.64 4.7 4.81 4.94 5.06 5.17 5.39 5.52 5.64];
        % ID=[4.32,4.12,4.64,5.17,3.32,4.7,4.39,3.7,4.58,5.39,4.17,4.81,5.64,5.52,3.74,4.94,5.06,4.52];
%         ID=[5.17,4.37,3.59,4.95,4.17,5.95];
%         figure(level+1)
%         plot(ID(1:level),completion_time,'.','Markersize',15);
%         xlabel('ID');
%         ylabel('Time(s)')
%         %title('Hand group5')
%         png=sprintf('time_ID.png');
%         saveas(figure(level+1),png);
         
        %% 计算每组sucess rate及平均movement time
          fail_nu = sum(completion_time == 100);  %CT被置为100的task个数（每组失败的task个数）
          SR(q,g) = 1 - fail_nu/6;
          
          break_rate(q,g) = cp_t/6;
          
%           MT_aver(q,g) = mean(movement_time);
          MT_aver(q,g) = sum(movement_time)/(6-fail_nu);       
          
        %% 计算throughput(TP): TP= (ID1/CT1 + ID2/CT2 +...+ IDi/CTi )/N
         TP(q,g)=sum(ID./completion_time)/(6-fail_nu); 
         TP_correction(q,g) = SR(q,g)*TP(q,g);
       %%
          mat_new_ct{q,g}(:,4)= movement_time;
          mat_new_ct{q,g}(:,3)= completion_time;   
          mat_new_ct{q,g}(:,2)= ID;
          mat_new_ct{q,g}(:,1)= ID_number;
          %aaaaa=sum(completion_time == 0);  aaaaa=find(completion_time == 0);        
          
%           csvwrite('S3_para2_1_',num2str(q),'.csv',mat_new_ct{q,1});
%           csvwrite('S3_para2_2_',num2str(q),'.csv',mat_new_ct{q,2});
%           csvwrite('S3_para2_1.csv',mat_new_ct{q,1});
%           csvwrite('S3_para2_2.csv',mat_new_ct{q,2});   
%      csvwrite('S3_para2_1.csv',mat_new_ct{q,1},((q-1)*6+1):((q-1)*6+6),0);  %csvwrite不接受输入矩阵M的元胞数组。要导出仅包含数值数据的元胞数组，在调用 csvwrite 之前使用 cell2mat 将元胞数组转换为数值矩阵
%      csvwrite('S3_para2_2.csv',mat_new_ct{q,2},((q-1)*6+1):((q-1)*6+6),0); 

    end      
            
end   
%%   Data Save
% % % % % % cd('D:\Luoqi\fitts_law\fitts_all_result_analysis\full_model_fitts\grip_force_control_task\S3_all_data\outcome_data');  %single_finger_force_control_task   grip_force_control_task
% % % % % %         [row,col]=size(mat_new_ct);
% % % % % %         filename1='mode1.csv';%.csv可以更改为.txt等
% % % % % %         filename2='mode2.csv';
% % % % % %         filename3='mode3.csv';
% % % % % %         filename4='mode4.csv';
% % % % % %         fid1=fopen(filename1,'w');
% % % % % %         fid2=fopen(filename2,'w');
% % % % % %         fid3=fopen(filename3,'w');
% % % % % %         fid4=fopen(filename4,'w');
% % % % % %         count=0;
% % % % % %         for index=1:row
% % % % % %             bbx1=mat_new_ct{index,1};
% % % % % %             bbx2=mat_new_ct{index,2};
% % % % % %             bbx3=mat_new_ct{index,3};
% % % % % %             bbx4=mat_new_ct{index,4};
% % % % % %             [a,b]=size(bbx1);
% % % % % %             for i=1:a
% % % % % %                 count=count+1;
% % % % % %                 fprintf(fid1,'%f,%f,%f, %f ,%f\n',count,bbx1(i,:));
% % % % % %                 fprintf(fid2,'%f,%f,%f, %f ,%f\n',count,bbx2(i,:));
% % % % % %                 fprintf(fid3,'%f,%f,%f, %f ,%f\n',count,bbx3(i,:));
% % % % % %                 fprintf(fid4,'%f,%f,%f, %f ,%f\n',count,bbx4(i,:));
% % % % % %             end
% % % % % %         end

%     cd(path)
%     str1 = {'Number','ID','CT','MT'}
%     numcell = num2cell(mat_new_ct{q,g});      %将矩阵的每个数单独做一个cell小单元，matalb版本低可能不支持这个函数
%     celldata = [numcell;str1];
%     cell2csv('testdata.csv',celldata)
%%  结果保存为.mat文件
% save('S3_pilot_model_fitts_data.mat');    % S3_single_finger_fitts_data    S3_grip_fitts_data
%cd \
