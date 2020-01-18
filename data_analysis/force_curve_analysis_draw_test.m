
%% 遍历文件夹
clear; clc;  

G = 4; %model 1 2 3 4
Q = 8; 
level = 6; 

mat_new_force_var = cell(8,4);

aaa = zeros(100,100);
force_sm_rms_aver = zeros(1,level);
force_sm_rms_err = zeros(1,level);

      cd(strcat('D:/Luoqi/fitts_law/fitts_all_result_analysis/full_model_fitts/grip_force_control_task/S2_all_data/outcome_data'));

 for g = 1:G
        
        
        
        
        fname_read = ['Force_rms_smoothness_model', num2str(g),'.csv'];   
        force_sm_rms = csvread(fname_read,0,0);
        
        
%         mat_new_force_var{g,1} = force_sm_rms;
        
        IDs=[5.17,4.37,3.59,5.95,4.17,4.95];
        
      
        
%        for q=1:Q  
           
        for k = 1:level 
            
            
            aaa=force_sm_rms(force_sm_rms(:,1)==IDs(k),:);
            
            force_sm_rms_aver(k) = mean(aaa(:,2)); 
            
            force_sm_rms_err(k) = std(aaa(:,2));   

%             aaa(:,((g-1)*2+1:2*g))=mat_new_force_var{g,1}(mat_new_force_var{g,1}(:,1)==IDs(k),:);
%             
%             force_sm_rms_aver(k) = mean(aaa(:,2)); 
%             
%             force_sm_rms_err(k) = std(aaa(:,2));  

            
        %% 绘制force smoothness与ID的曲线
        figure(level+1),
%         plot(IDs(1:level),force_sm_std_aver,'o','color',[1,0,0]);hold on;
        errorbar(IDs(1:level),force_sm_rms_aver,force_sm_rms_err,'*r','LineWidth',1','MarkerSize',8);hold on;    
        errorbar(IDs(1:level),force_sm_rms_aver,force_sm_rms_err,'*b','LineWidth',1','MarkerSize',8);hold on;  
        errorbar(IDs(1:level),force_sm_rms_aver,force_sm_rms_err,'*y','LineWidth',1','MarkerSize',8);hold on;  
        errorbar(IDs(1:level),force_sm_rms_aver,force_sm_rms_err,'*r','LineWidth',1','MarkerSize',8);hold on;  
        
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
%         png=sprintf('Force_smoothness-ID.png');
%         saveas(figure(level+1),png);    
% %% 绘制force corrcoef与ID的曲线
%         figure(2*level+2),
%         errorbar(IDs(1:level),Rcor_force_aver,Rcor_force_err,'vb','LineWidth',1','MarkerSize',8);hold on; % *  vb   o 
%         plot([IDs(3);IDs(5)],[Rcor_force_aver(3);Rcor_force_aver(5)],'b');hold on;
%         plot([IDs(5);IDs(2)],[Rcor_force_aver(5);Rcor_force_aver(2)],'b');hold on;
%         plot([IDs(2);IDs(6)],[Rcor_force_aver(2);Rcor_force_aver(6)],'b');hold on;
%         plot([IDs(6);IDs(1)],[Rcor_force_aver(6);Rcor_force_aver(1)],'b');hold on;
%         plot([IDs(1);IDs(4)],[Rcor_force_aver(1);Rcor_force_aver(4)],'b');hold on;
%         xlabel('ID');
%         ylabel('Corrcoef of force');
%         title('Force corrcoef — ID');
%         hhh_i=legend ('Model',num2str(g),'Location','NorthEast');  %Pilot
%         set(hhh_i,'Box','off');
%         axis([3.5 6 -1 1.5]);
% %         png=sprintf('Force_corrcoef-ID.png');
% %         saveas(figure(level+1),png);  
% %% 绘制force RMSE与ID的曲线
%         figure(2*level+3),
%         errorbar(IDs(1:level),RMSE_force_aver,RMSE_force_err,'vb','LineWidth',1','MarkerSize',8);hold on; % *  v   o 
%         plot([IDs(3);IDs(5)],[RMSE_force_aver(3);RMSE_force_aver(5)],'b');hold on;
%         plot([IDs(5);IDs(2)],[RMSE_force_aver(5);RMSE_force_aver(2)],'b');hold on;
%         plot([IDs(2);IDs(6)],[RMSE_force_aver(2);RMSE_force_aver(6)],'b');hold on;
%         plot([IDs(6);IDs(1)],[RMSE_force_aver(6);RMSE_force_aver(1)],'b');hold on;
%         plot([IDs(1);IDs(4)],[RMSE_force_aver(1);RMSE_force_aver(4)],'b');hold on;
%         xlabel('ID');
%         ylabel('RMSE of force');
%         title('Force RMSE — ID');
%         hhh_i=legend ('Model',num2str(g),'Location','NorthEast');  %Pilot
%         set(hhh_i,'Box','off');
%         axis([3.5 6 0 6]);
% %         png=sprintf('Force_RMSE-ID.png');
% %         saveas(figure(level+1),png);  
% %% 绘制force_entropy与ID的曲线
%         figure(2*level+4),
%         errorbar(IDs(1:level),force_entropy_aver,force_entropy_err,'*r');hold on;
%         plot([IDs(3);IDs(5)],[force_entropy_aver(3);force_entropy_aver(5)],'r');hold on;
%         plot([IDs(5);IDs(2)],[force_entropy_aver(5);force_entropy_aver(2)],'r');hold on;
%         plot([IDs(2);IDs(6)],[force_entropy_aver(2);force_entropy_aver(6)],'r');hold on;
%         plot([IDs(6);IDs(1)],[force_entropy_aver(6);force_entropy_aver(1)],'r');hold on;
%         plot([IDs(1);IDs(4)],[force_entropy_aver(1);force_entropy_aver(4)],'r');hold on;
%         xlabel('ID');
%         ylabel('Entropy of force');
%         title('Force entropy — ID');
%         hhh_i=legend ('Model',num2str(g),'Location','NorthEast');  %Pilot
%         set(hhh_i,'Box','off');
%         axis([3.5 6 0 3]);
% %         png=sprintf('Force_entropy-ID.png');
% %         saveas(figure(level+1),png);
       end

 end