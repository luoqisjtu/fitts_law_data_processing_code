%%
% 注意时间起始点：(1)以pressure大于0为时间起始点；(2)以go signal(目标出现)为时间起始点
%% 遍历文件夹
clear; clc;                                                                      %% MT-movement time   CT-completion time 
%%
cd D:\Luoqi\fitts_law\local_fitts_law_data_processing_code\data_analysis;
%%
g = 2; %model 1 2 3 4
Q = 8;%test重复次数 
level = 6;   % 设置ID等级的数量     每个test文件夹里的csv文件个数 
resa_num = 200;%重采样后数据点数
mat_new_ct = cell(8,4);
mat_new_pv = cell(8,6);
mat_new_pv_re = cell(8,6);
mat_new_pv_resa = cell(8,6); 
force_mm_resa_stor = cell(1,6);
force_mm_resa_aver = zeros(resa_num,level);
SR = zeros(Q,4);
break_rate = zeros(Q,4);
MT_aver = zeros(1,level);
CT_aver = zeros(1,level);
fail_nu = zeros(1,level);
completion_time_ct = zeros(Q,level);
completion_time_nonfail = zeros(Q,level);
force_sm_std = zeros(Q,level);
force_sm_std_aver = zeros(1,level);
force_sm_std_err = zeros(1,level);
force_sm_rms = zeros(Q,level);
force_sm_rms_aver = zeros(1,level);
force_sm_rms_err = zeros(1,level);
RMSE_force = zeros(Q,level);
RMSE_force_aver = zeros(1,level);
RMSE_force_err = zeros(1,level);
Rcor_force = zeros(Q,level);
Rcor_force_aver = zeros(1,level);
Rcor_force_err = zeros(1,level);
TP = zeros(Q,2);
force_diffaver = zeros(Q,level);
force_diffaver_re = zeros(1,level);
force_entropy = zeros(Q,level);
force_entropy_aver = zeros(1,level);
force_entropy_err = zeros(1,level);
datasave1 = zeros(Q,4);
datasave2 = zeros(Q,4);
color=[1 0 0;0 1 0;0 0 1;0.5 0.8 0.9;0 0 0;0 1 1;1 0 1;0.5 0.5 0.5];%定义一个颜色矩阵
%%  
% for g = 1:G
   
%     cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/full_model_fitts/grip_force_control_task/S3_all_data/outcome_data/model_',num2str(g)]));  
     
    for q = 1:Q
        
        cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/full_model_fitts/grip_force_control_task/S3_all_data/outcome_data/model_',num2str(g),'/model',num2str(g),'_test',num2str(q)]));  %single_finger_force_control_task   grip_force_control_task                            
        
        %% 读取目标力的大小值
        filename1 = 'D:/Luoqi/fitts_law/ID_6_grip_force_Fmin_Fmax.csv';   %%% ID_6_single_finger_force_Fmin_Fmax    ID_6_grip_force_Fmin_Fmax
        file1 = csvread(filename1,1,0);
        fmin = file1(1:level,4);
        fmax = file1(1:level,5);
        
        if(g ~= 4)
        %% 读取参考压力(model4-human hand)
        filename2 = 'D:/Luoqi/fitts_law/fitts_all_result_analysis/full_model_fitts/grip_force_control_task/S3_all_data/outcome_data/force_ref_model4.csv';  
        file2 = csvread(filename2,0,0);
        end  
        
        %%
        ID_number=zeros(level,1);
        ID=zeros(level,1);
        completion_time=zeros(level,1); %
        completion_time_re=zeros(level,1);
        movement_time=zeros(level,1);
        collision_p=zeros(level,1);        
        IDs =[5.17;4.37;3.59;5.95;4.17;4.95];   %IDs =[5.17;4.37;3.59;4.95;4.17;5.95];  当在实验设置中改变不同ID的task顺序时，此处也要相应调整顺序！！！！！！ 352614
        
        for k=1:level
               
            ID(k)=IDs(k,1);         
            
            fname_read = ['Force_bar', num2str(k),'.csv'];   %起始ID这组数据不读进去 —— 把k-1改为k
            force_val = csvread(fname_read,1,0);
            %  F= csvread(list(k+2).name,1,0);
            
            Tim = force_val(:,1);
            [n,m] = size(Tim);
            max_t = 0.01*n - 0.01;
            t_ = 0: 0.01:max_t;
            t = t_';
            
            Data_force = abs(force_val(1:(length(force_val)-500),2)); %有效压力数据—去掉最后的5s的数据，也就是500个数  % 3s  300     %根据unity中设置的延时时间调整时，此处也要相应调整顺序！！！！！！   
            mat_new_pv{q,k} = Data_force; %force_val(:,2)
            
            %统计力条上升的时间，从力条开始移动的时间算起 %%%%起始的压力值根据实际的情况可以调整
            for m=1:length(force_val(:,2))
                if(force_val(m,2)>0.1)
                    start_time=m;
                    break;
                end
            end
 %%           
            ID_number(k)=k;
            completion_time(k)=t(length(t)-500)-t(start_time);            
            completion_time_re(k)=t(length(t)-500);      %0.2s-在unity中设置，目标出现0.2s后，task开始     completion_time_re(k)=t(length(t)-500)-0.2; 
            movement_time(k) = completion_time_re(k)-completion_time(k);
            
            %统计每组task碰到禁止区域的次数(0-没有碰到，1-碰到)
            collision = force_val(:,6);
            collision_p(k) = sum(collision == 1);
            cp_t = sum(collision_p~=0);   %碰到禁止区域次数      
                       
%             if(completion_time_re(k)>13||collision_p(k)~=0||movement_time(k)<0)            %%t>13或碰到禁止区域或没有从起始位置出发对应的trial记为fail  
            if(completion_time_re(k)>=14.8||collision_p(k)~=0||movement_time(k)<=0)
                  completion_time(k)=0;  %completion_time(k)=[];
%                   ID_number(k)=0;
                  ID(k)=0;
                  movement_time(k)=0;
%                   force_val(:,2)=0;   %%绘图去掉failed trial
            end

%% 计算平均完成时间CT_aver——average completion time         
           
           completion_time_ct(q,k) = completion_time(k);            
           fail_nu(1,k) = sum(completion_time_ct(:,k) == 0);  %CT被置为100的task个数（每个ID中失败的task个数）
           CT_aver(1,k)=sum(completion_time_ct(:,k))/(q-fail_nu(1,k));            %把failed trial去掉后计算平均值

%            completion_time_nonfail(:,k) = completion_time_ct(:,k)(completion_time_ct(:,k)~=0);  %a(a==0) = []; a(find(a==0)) = [];  b = a(a ~= 0);  b = a(find(a ~= 0));
 %% 计算压力曲线平滑度（光滑度smoothness）——求离散曲线一阶导数的均值           
            force_diff = diff(Data_force); %求一阶导(一阶差分)
            
            force_diffaver(q,k)=mean(force_diff);   %每条曲线的一阶导数均值
            force_diffaver_re(k) = mean(force_diffaver(:,k));
            
       %===================================================================================           
            force_sm_rms(q,k) = rms(force_diff);       
%             force_sm_rms_aver(k)=mean(force_sm_rms(:,k));

            if(force_sm_rms(q,k)>2)  %————————去掉两个异常值(model1)
                force_sm_rms(q,k) = 0;                          
                force_sm_rms_aver(k) = sum(force_sm_rms(:,k))/(Q-1);
            else
                force_sm_rms_aver(k) = mean(force_sm_rms(:,k));  
            end 
            
            force_sm_rms_err(k) = std(force_sm_rms(:,k));   
            
            force_sm_rms_row(((q-1)*level+1):((q-1)*level+level),1) = IDs(:,1);
            force_sm_rms_row(((q-1)*level+1):((q-1)*level+level),2) = force_sm_rms(q,:);
            csvwrite(['Force_rms_smoothness_model',num2str(g),'.csv'],force_sm_rms_row,0,0); 
       %===================================================================================
%             force_sm_std(q,k) = std(force_diff);  %每条曲线一阶导数的标准差standard deviation
%             
%             if(force_sm_std(q,k)>2)  %————————去掉两个异常值(model1)
%                 force_sm_std(q,k) = 0;                          
%                 force_sm_std_aver(k) = sum(force_sm_std(:,k))/(Q-1);
%             else
%                 force_sm_std_aver(k) = mean(force_sm_std(:,k));  
%             end 
            
%             force_sm_std_err(k) = std(force_sm_std(:,k)); %SD   
% %             force_sm_std_err(k) = std(force_sm_std(:,k))/sqrt(length(force_sm_std(:,k)));  %SE
            
%             force_sm_std_row(((q-1)*level+1):((q-1)*level+level),1) = force_sm_std(q,:);
%             csvwrite(['Force_std_smoothness_model',num2str(g),'.csv'],force_sm_std_row,0,0); 
            
%% 熵值法——求压力熵entropy
            force_entropy(q,k) = entropy(Data_force);
            force_entropy_aver(k) = mean(force_entropy(:,k));
            force_entropy_err(k) = std(force_entropy(:,k));
            
            force_entropy_row(((q-1)*level+1):((q-1)*level+level),1) = IDs(:,1);
            force_entropy_row(((q-1)*level+1):((q-1)*level+level),1) = force_entropy(q,:);              
            csvwrite(['Force_entropy_model',num2str(g),'.csv'],force_entropy_row,0,0); 
            
 %% 频谱分析frequency spectrum analysis——force data  
 %===========================================================================================
% % %             N=length(Data_force);%数据长度
% % %             fs=100;%采样频率
% % %             i=0:N-1;
% % %             t_f=i/fs;
% % %             f=(0:N-1)*fs/N;%横坐标频率的表达式为f=(0:M-1)*Fs/M;
% % %             yy=fft(Data_force,2),N);%进行fft变换
% % %             mag=abs(yy);%求振幅(幅值)
% % %             power=mag.^2;%功率
% % %             
% % %             figure(k),
% % %             
% % %             if(completion_time_re_re(k)>=14.8||collision_p(k)~=0||movement_time(k)<=0)
% % %                  semilogx(f,power,'linewidth',1.5,'color',[1,0,0]);hold on; % x、y都取对数
% % %             else
% % %                  semilogx(f,power,'linewidth',1.5,'color',[0,0,1]);hold on; % x、y都取半对数
% % %             end
% % %             loglog(f,power);hold on; % x、y都取对数
% % %             semilogx(f,power);hold on; % x、y都取半对数
 %===========================================================================================
% %             rng default
% % 
% %             figure(k),
% %             N=length(Data_force);%数据长度
% %             fs=100;%采样频率
% %             i=0:N-1;
% %             t_f=i/fs;
% %             window = hamming(N); noverlap = N/2; nff = max(256,2^nextpow2(N));
% %             [pxx,f] = pwelch(Data_force,window,noverlap,nff,fs);  %[pxx,f] = pwelch(Data_force,N,[],N,fs);        
% %             if(completion_time_re(k)>=14.8||collision_p(k)~=0||movement_time(k)<=0)
% %                  plot(f,10*log10(pxx),'color',[1,0,0]);hold on; %log10
% %             else
% %                  plot(f,10*log10(pxx),'color',[0,0,1]);hold on;
% %             end
% %             
% %             title('Power spectral density'); %功率谱密度
% %             xlabel('Frequency (Hz)');
% %             ylabel('PSD');  
 %===========================================================================================
%             % frequency spectrum——hzx
%             figure(k),
%             N=length(Data_force); %样点个数
%             fs=100;%采样频率
%             df=fs/(N-1);%分辨率
%             f=(0:N-1)*df;%其中每点的频率
%             Y=fft(Data_force)/N*2;%真实的幅值
%             % Y=fftshift(Y);
%             x_axis = f(1:N/2);
%             y_axis = abs(Y(1:N/2));
%             if(completion_time_re(k)>=14.8||collision_p(k)~=0||movement_time(k)<=0)
%                 plot(x_axis,10*log10(y_axis),'r');hold on;
%             else
%                 plot(x_axis,10*log10(y_axis),'b');hold on;
%             end
% %             xlim([0,max(x_axis)]);
%             % title( 'frequency spectrum');      

            
%% 绘制压力曲线——force curve        
            figure(k),    %每个ID一个figure
%             plot(t(1:length(t)-500)-t(m)+2,Data_force-0.002,'linewidth',1.5,'color',color(q,:)); hold on;    % 以压力大于零时刻为基准点，对齐压力曲线起始点 

%             if(completion_time_re(k)>=14.8||collision_p(k)~=0||movement_time(k)<=0)
%                  plot(t(1:length(t)-500),Data_force-0.002,'linewidth',1.5,'color',[1,0,0]); hold on;   %以每个trial时间起始点绘图，不对齐压力曲线起始点
%             else
%                  plot(t(1:length(t)-500),Data_force-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;
%             end
            
            force_mm = Data_force(m:end,1)-0.001;  
            mat_new_pv_re{q,k} = force_mm;            
            
            if(completion_time_re(k)>=14.8||collision_p(k)~=0||movement_time(k)<=0)
                plot(0:1/(length(Data_force)-m):1,force_mm,'linewidth',1.5,'color',[1,0,0]); hold on; %横坐标时间归一化到(0,1)
            else
                plot(0:1/(length(Data_force)-m):1,force_mm,'linewidth',1.5,'color',[0,0,1]); hold on;  %横坐标时间归一化到(0,1)  
            end   
            
          %========================================================================================
           % 重采样插值——以健侧手压力曲线为参考
           
           if(g==4) 
               force_mm_resa = resample(force_mm,resa_num,length(force_mm));     %重采样插值   
               mat_new_pv_resa{q,k} = force_mm_resa;
               force_mm_resa_stor{1,k}(:,q) = mat_new_pv_resa{q,k}(:,1);                   
               force_mm_resa_aver(:,k) = mean(force_mm_resa_stor{1,k},2);  
            
               force_ref = force_mm_resa_aver(:,k);
               force_ref_resa = resample(force_ref,length(force_mm),length(force_ref));    
           else
               force_ref = file2(:,k);
               force_ref_resa = resample(force_ref,length(force_mm),length(force_ref));
           end    
           
           time_norm = 0:1/(length(Data_force)-m):1;%linspace(0,1)  
           plot(time_norm, force_ref_resa, 'Color', 'k', 'LineWidth', 2);hold on;
         %======================================================================================
                       
           % sigmoid曲线 ——以sigmoid拟合曲线为参考          
%             force_target = (fmin + fmax)/2;
%             time_norm = 0:1/(length(Data_force)-m):1;%linspace(0,1)   
                       
%             c =0.3;a=15;  %5 10 15 18 20 25  %0.8 0.5 0.3 0.25 0.2 0.1   cftool fminsearch  fmincon  
%             force_sigmoid = 1./(1 + exp(-a.*(time_norm - c))); %sigmoid
%             force_sigmoid = a*exp(b*x) + exp(d*x);
            
%             if(k==1)
%                  force_sigmoid = 2.629*exp(0.3396*time_norm) - 2.671*exp(-44.49*time_norm);
%             elseif(k==2)  
%                  force_sigmoid = 4.114*exp(0.3339*time_norm) - 4.311*exp(-21.88*time_norm);
%             elseif(k==3) 
%                  force_sigmoid = 3.938*exp(-0.1727*time_norm) - 4.18*exp(-13.57*time_norm);
%             elseif(k==4) 
%                  force_sigmoid = 5.293*exp(0.1298*time_norm) - 5.313*exp(-17.48*time_norm);
%             elseif(k==5) 
%                  force_sigmoid = 3.806*exp(-0.01416*time_norm) - 3.897*exp(-12.33*time_norm);
%             elseif(k==6) 
%                  force_sigmoid = 5.25*exp(0.08526*time_norm) - 5.251*exp(-11.03*time_norm);
%             end   
%             
%             plot(time_norm, force_sigmoid, 'Color', 'k', 'LineWidth', 2);hold on;
%             plot(time_norm, force_target(k,:)*force_sigmoid, 'Color', 'k', 'LineWidth', 2);hold on;
           %========================================================================================
                                
            xlim=get(gca,'Xlim'); % 获取当前图形的横轴的范围      
            a=plot(xlim,[fmax(k)-0.002,fmax(k)-0.002],'--','linewidth',1.5,'color',[1,0,0]);hold on
            b=plot(xlim,[fmin(k)-0.002,fmin(k)-0.002],'--','linewidth',1.5,'color',[0,1,0]); hold on
            
            pressure = Data_force(m:end,1); %force_val(m:length(force_val)-500,2)
            if max(pressure)>=fmax(k)
                y_max=max(pressure);
            else
                y_max=fmax(k);
            end         
            
%           axis([0 max_t-5 0 y_max+7]);
            axis([0 1 0 12]);
            xlabel('Normalized time');
            ylabel('Grip force(N)');     %Grip force(N)  Pressure  Fingertip force
            title(['ID =',num2str(k)]);
            set(gca,'FontSize',16);%只能同时改变x y轴显示的字体大小；
            set(get(gca,'YLabel'),'Fontsize',19);% 是针对标注的而不是坐标刻度
            set(get(gca,'XLabel'),'Fontsize',19);% 是针对标注的而不是坐标刻度
            h_i=legend ([a(1),b(1)],'Fmax',' Fmin','Location','NorthEast');  %Grip force  Pressure
            set(h_i,'Box','off');
            % 保存图片到当前目录
%             fm_m=sprintf('ID_%d.png',k);
%             fn_n=sprintf('ID_%d.epsc',k);  %eps——黑白； epsc——彩色
%             saveas(figure(k),fm_m);
%             saveas(figure(k),fn_n);         

%% 求压力曲线相对于sigmoid曲线的均方根误差Root Mean Squared Error    
            numel_force = length(Data_force)-m;
%             RMSE_force(q,k) = sqrt(sum((force_mm-force_sigmoid').^2)/numel_force);   
            RMSE_force(q,k) = sqrt(sum((force_mm-force_ref_resa).^2)/numel_force); 
            
            if(RMSE_force(q,k)>90)  %————————去掉异常值
                RMSE_force(q,k) = 0;                          
                RMSE_force_aver(k) = sum(RMSE_force(:,k))/(Q-1);
            else
                RMSE_force_aver(k) = mean(RMSE_force(:,k));  
            end           
            
%             RMSE_force_aver(k) = mean(RMSE_force(:,k));
            RMSE_force_err(k) = std(RMSE_force(:,k));    %SD
%             RMSE_force_err(k) = std(RMSE_force(:,k))/sqrt(length(RMSE_force(:,k)));  %SE
            
            RMSE_force_row(((q-1)*level+1):((q-1)*level+level),1) = IDs(:,1);
            RMSE_force_row(((q-1)*level+1):((q-1)*level+level),1) = RMSE_force(q,:);              
            csvwrite(['Force_RMSE_model',num2str(g),'.csv'],RMSE_force_row,0,0); 
            
%% 求压力曲线force curve与sigmoid curve的曲线相关性corrcoef            
%             Rcor_force_mat = corrcoef(force_mm,force_sigmoid'); %注意行列向量转换   
            Rcor_force_mat = corrcoef(force_mm,force_ref_resa);
            Rcor_force(q,k) = Rcor_force_mat(1,2);
            Rcor_force_aver(k) = mean(Rcor_force(:,k));
            Rcor_force_err(k) = std(Rcor_force(:,k));  
            
            Rcor_force_row(((q-1)*level+1):((q-1)*level+level),1) = IDs(:,1);
            Rcor_force_row(((q-1)*level+1):((q-1)*level+level),1) = Rcor_force(q,:);              
            csvwrite(['Force_corrcoef_model',num2str(g),'.csv'],Rcor_force_row,0,0); 
                                    
        end
        
          mat_new_ct{q,g}(:,4)= movement_time;
          mat_new_ct{q,g}(:,3)= completion_time;   
          mat_new_ct{q,g}(:,2)= ID;
          mat_new_ct{q,g}(:,1)= ID_number;
                         
    end 
     
%% 绘制force smoothness与ID的曲线
        figure(level+1),
%         plot(IDs(1:level),force_sm_std_aver,'o','color',[1,0,0]);hold on;
        errorbar(IDs(1:level),force_sm_rms_aver,force_sm_rms_err,'*r','LineWidth',1','MarkerSize',8);hold on;    %force_sm_std_aver
        plot([IDs(3);IDs(5)],[force_sm_rms_aver(3);force_sm_rms_aver(5)],'r');hold on;
        plot([IDs(5);IDs(2)],[force_sm_rms_aver(5);force_sm_rms_aver(2)],'r');hold on;
        plot([IDs(2);IDs(6)],[force_sm_rms_aver(2);force_sm_rms_aver(6)],'r');hold on;
        plot([IDs(6);IDs(1)],[force_sm_rms_aver(6);force_sm_rms_aver(1)],'r');hold on;
        plot([IDs(1);IDs(4)],[force_sm_rms_aver(1);force_sm_rms_aver(4)],'r');hold on;
        xlabel('ID');
        ylabel('Roughness of force');
        title('Force roughness — ID');
        hhh_i=legend ('Model',num2str(g),'Location','NorthEast');
        set(hhh_i,'Box','off');
        axis([3.5 6 0 0.3]);
        fs_eps=sprintf(['Force_smoothness_model',num2str(g),'.epsc']);
        saveas(figure(level+1),fs_eps);    
%% 绘制force corrcoef与ID的曲线
        figure(level+2),
        errorbar(IDs(1:level),Rcor_force_aver,Rcor_force_err,'vb','LineWidth',1','MarkerSize',8);hold on; % *  vb   o 
        plot([IDs(3);IDs(5)],[Rcor_force_aver(3);Rcor_force_aver(5)],'b');hold on;
        plot([IDs(5);IDs(2)],[Rcor_force_aver(5);Rcor_force_aver(2)],'b');hold on;
        plot([IDs(2);IDs(6)],[Rcor_force_aver(2);Rcor_force_aver(6)],'b');hold on;
        plot([IDs(6);IDs(1)],[Rcor_force_aver(6);Rcor_force_aver(1)],'b');hold on;
        plot([IDs(1);IDs(4)],[Rcor_force_aver(1);Rcor_force_aver(4)],'b');hold on;
        xlabel('ID');
        ylabel('Corrcoef of force');
        title('Force corrcoef — ID');
        hhh_i=legend ('Model',num2str(g),'Location','NorthEast');  %Pilot
        set(hhh_i,'Box','off');
        axis([3.5 6 -1 1.5]);
        fc_eps=sprintf(['Force_corrcoef_model',num2str(g),'.epsc']);
        saveas(figure(level+2),fc_eps);  
%% 绘制force RMSE与ID的曲线
        figure(level+3),
        errorbar(IDs(1:level),RMSE_force_aver,RMSE_force_err,'vb','LineWidth',1','MarkerSize',8);hold on; % *  v   o 
        plot([IDs(3);IDs(5)],[RMSE_force_aver(3);RMSE_force_aver(5)],'b');hold on;
        plot([IDs(5);IDs(2)],[RMSE_force_aver(5);RMSE_force_aver(2)],'b');hold on;
        plot([IDs(2);IDs(6)],[RMSE_force_aver(2);RMSE_force_aver(6)],'b');hold on;
        plot([IDs(6);IDs(1)],[RMSE_force_aver(6);RMSE_force_aver(1)],'b');hold on;
        plot([IDs(1);IDs(4)],[RMSE_force_aver(1);RMSE_force_aver(4)],'b');hold on;
        xlabel('ID');
        ylabel('RMSE of force');
        title('Force RMSE — ID');
        hhh_i=legend ('Model',num2str(g),'Location','NorthEast');  %Pilot
        set(hhh_i,'Box','off');
        axis([3.5 6 0 6]);
        fr_eps=sprintf(['Force_RMSE_model',num2str(g),'.epsc']);
        saveas(figure(level+3),fr_eps);  
%% 绘制force_entropy与ID的曲线
        figure(level+4),
        errorbar(IDs(1:level),force_entropy_aver,force_entropy_err,'*r');hold on;
        plot([IDs(3);IDs(5)],[force_entropy_aver(3);force_entropy_aver(5)],'r');hold on;
        plot([IDs(5);IDs(2)],[force_entropy_aver(5);force_entropy_aver(2)],'r');hold on;
        plot([IDs(2);IDs(6)],[force_entropy_aver(2);force_entropy_aver(6)],'r');hold on;
        plot([IDs(6);IDs(1)],[force_entropy_aver(6);force_entropy_aver(1)],'r');hold on;
        plot([IDs(1);IDs(4)],[force_entropy_aver(1);force_entropy_aver(4)],'r');hold on;
        xlabel('ID');
        ylabel('Entropy of force');
        title('Force entropy — ID');
        hhh_i=legend ('Model',num2str(g),'Location','NorthEast');  %Pilot
        set(hhh_i,'Box','off');
        axis([3.5 6 0 3]);
        fe_eps=sprintf(['Force_entropy_model',num2str(g),'.epsc']);
        saveas(figure(level+4),fe_eps);
%% 绘制average completion time与ID的曲线
        figure(level+5),
        plot(IDs(1:level),CT_aver,'*','color',[1,0,0]);hold on;
        plot([IDs(3);IDs(5)],[CT_aver(3);CT_aver(5)],'color',[0,0,1]);hold on; %   [1,0,0]——red;  [0,0,1]——blue
        plot([IDs(5);IDs(2)],[CT_aver(5);CT_aver(2)],'color',[0,0,1]);hold on;
        plot([IDs(2);IDs(6)],[CT_aver(2);CT_aver(6)],'color',[0,0,1]);hold on;
        plot([IDs(6);IDs(1)],[CT_aver(6);CT_aver(1)],'color',[0,0,1]);hold on;
        plot([IDs(1);IDs(4)],[CT_aver(1);CT_aver(4)],'color',[0,0,1]);hold on;
        xlabel('ID');
        ylabel('Average of completion time(s)');
        title('Averager completion time — ID');
%         axis([3.5 6 0 7]);
%         png=sprintf('Force_entropy-ID.png');
%         saveas(figure(level+1),png);
%%  结果保存为.mat文件  
cd('D:\Luoqi\fitts_law\fitts_all_result_analysis\full_model_fitts\grip_force_control_task\S3_all_data\outcome_data');  %single_finger_force_control_task   grip_force_control_task
save(['S3_grip_fitts_force_metrics_analysis_model_',num2str(g),'.mat']);    % S3_grip_fitts_force_metrics_analysis_model_    S3_single_finger_fitts_force_metrics_analysis_model_',num2str(g),'
csvwrite(['force_ref_model',num2str(g),'.csv'],force_mm_resa_aver,0,0); 
%%
% cd D:\Luoqi\fitts_law\local_fitts_law_data_processing_code\data_analysis;

