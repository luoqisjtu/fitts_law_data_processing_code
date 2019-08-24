%% �����ļ���
clear; clc;                                                                      %% MT-movement time   CT-completion time 
%%
path = pwd;
%%
G = 2; %model off on
Q = 8;%test�ظ����� 
level = 6;   % ����ID�ȼ�������     ÿ��test�ļ������csv�ļ�����

mat_new_ct = cell(8,2);
SR = zeros(Q,2);
break_rate = zeros(Q,2);
MT_aver = zeros(Q,2);
TP = zeros(Q,2);
datasave1 = zeros(Q,4);
datasave2 = zeros(Q,4);
%%  
for g = 1:G
    
    cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/full_model_fitts/grip_force_control_task/S1_all_data/outcome_data/model_',num2str(g)]));  
    
    for q = 1:Q

        cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/full_model_fitts/grip_force_control_task/S1_all_data/outcome_data/model_',num2str(g),'/model',num2str(g),'_test',num2str(q)]));
        %     files = dir([foldername '\*.csv']);                                      
        
        %% ��ȡ���Ĵ�Сֵ
        filename1 = 'D:/Luoqi/fitts_law/ID_6_grip_force_Fmin_Fmax.csv';   %%% ID_6_single_finger_force_Fmin_Fmax
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
        
        IDs =[5.17;4.37;3.59;5.95;4.17;4.95];   %IDs =[5.17;4.37;3.59;4.95;4.17;5.95];  ����ʵ�������иı䲻ͬID��task˳��ʱ���˴�ҲҪ��Ӧ����˳�򣡣���������
        
        for k=1:level
            
            ID(k)=IDs(k,1);         
            
            fname_read = ['Force_bar', num2str(k),'.csv'];   %��ʼID�������ݲ�����ȥ ���� ��k-1��Ϊk
            force_val = csvread(fname_read,1,0);
            %  F= csvread(list(k+2).name,1,0);
            
            Tim = force_val(:,1);
            [n,m] = size(Tim);
            max_t = 0.01*n - 0.01;
            t_ = 0: 0.01:max_t;
            t = t_';
            
            %ͳ������������ʱ�䣬��������ʼ�ƶ���ʱ������ %%%%��ʼ��ѹ��ֵ����ʵ�ʵ�������Ե���
            for m=1:length(force_val(:,2))
                if(force_val(m,2)>0.1)
                    start_time=m;
                    break;
                end
            end
            
            ID_number(k)=k;
            completion_time(k)=t(length(t)-500)-t(start_time);   %300
            completion_time_re(k)=t(length(t)-500);      %0.2s-��unity�����ã�Ŀ�����0.2s��task��ʼ  completion_time_re(k)=t(length(t)-500)-0.2;
            movement_time(k) = completion_time_re(k)-completion_time(k);
            
            
            %ͳ��ÿ��task������ֹ����Ĵ���(0-û��������1-����)
            collision = force_val(:,6);
            collision_p(k) = sum(collision == 1);
            cp_t = sum(collision_p~=0);   %������ֹ�������
            
            
            if(completion_time_re(k)>=14.8||collision_p(k)~=0||movement_time(k)<=0)            %%t>13��������ֹ�����û�д���ʼλ�ó�����Ӧ��trial��Ϊfail    
                  completion_time(k)=100;  %ID_time(k)=[];
%                   ID_number(k)=0;
                  ID(k)=0;
                  movement_time(k)=0;
            end
                                 

          %%             
            
            figure(k),
            plot(t(1:length(t)-500),force_val(1:length(force_val)-500,2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;     % �������궼Ҫȥ������5s�����ݣ�Ҳ����500����  % 3s  300
            %plot(t(1:length(t)),F(1:length(F),2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;
            
            xlim=get(gca,'Xlim'); % ��ȡ��ǰͼ�ε�����ķ�Χ
            
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
            set(gca,'FontSize',16);%ֻ��ͬʱ�ı�x y����ʾ�������С��
            set(get(gca,'YLabel'),'Fontsize',19);% ����Ա�ע�Ķ���������̶�
            set(get(gca,'XLabel'),'Fontsize',19);% ����Ա�ע�Ķ���������̶�
            h_i=legend ( 'Grip force', 'Fmax',' Fmin', 'Location' ,'SouthEast');  %Grip force  Pressure
            set(h_i,'Box','off');
            % ����ͼƬ����ǰĿ¼
            mm=sprintf('task_%d.png',k);
            nn=sprintf('task_%d.eps',k);
            saveas(figure(k),mm);
            saveas(figure(k),nn);      
            
        end
        
        %% ����ID��time������
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
         
        %% ����ÿ��sucess rate��ƽ��movement time
          fail_nu = sum(completion_time == 100);  %CT����Ϊ100��task������ÿ��ʧ�ܵ�task������
          SR(q,g) = 1 - fail_nu/6;
          
          break_rate(q,g) = cp_t/6;
          
%           MT_aver(q,g) = mean(movement_time);
          MT_aver(q,g) = sum(movement_time)/(6-fail_nu);       
          
        %% ����throughput(TP): TP= (ID1/CT1 + ID2/CT2 +...+ IDi/CTi )/N
         TP(q,g)=sum(ID./completion_time)/(6-fail_nu);
         
       %%
          mat_new_ct{q,g}(:,4)= movement_time;
          mat_new_ct{q,g}(:,3)= completion_time;   
          mat_new_ct{q,g}(:,2)= ID;
          mat_new_ct{q,g}(:,1)= ID_number;
          %aaaaa=sum(completion_time == 0);  aaaaa=find(completion_time == 0);        
          
%           csvwrite('S2_para2_1_',num2str(q),'.csv',mat_new_ct{q,1});
%           csvwrite('S2_para2_2_',num2str(q),'.csv',mat_new_ct{q,2});
%           csvwrite('S2_para2_1.csv',mat_new_ct{q,1});
%           csvwrite('S2_para2_2.csv',mat_new_ct{q,2});   
%      csvwrite('S2_para2_1.csv',mat_new_ct{q,1},((q-1)*6+1):((q-1)*6+6),0);
%      csvwrite('S2_para2_2.csv',mat_new_ct{q,2},((q-1)*6+1):((q-1)*6+6),0); 

    end      
            
end   
%%   Data Save
cd('D:\Luoqi\fitts_law\fitts_all_result_analysis\full_model_fitts\grip_force_control_task\S1_all_data\outcome_data');
        [row,col]=size(mat_new_ct);
        filename1='mode1.csv';%.csv���Ը���Ϊ.txt��
        filename2='mode2.csv';
        fid1=fopen(filename1,'w');
        fid2=fopen(filename2,'w');
        count=0;
        for index=1:row
            bbx1=mat_new_ct{index,1};
            bbx2=mat_new_ct{index,2};
            [a,b]=size(bbx1);
            for i=1:a
                count=count+1;
                fprintf(fid1,'%f,%f,%f, %f ,%f\n',count,bbx1(i,:));
                fprintf(fid2,'%f,%f,%f, %f ,%f\n',count,bbx2(i,:));
            end
        end

%     cd(path)
%     str1 = {'Number','ID','CT','MT'}
%     numcell = num2cell(mat_new_ct{q,g});      %�������ÿ����������һ��cellС��Ԫ��matalb�汾�Ϳ��ܲ�֧���������
%     celldata = [numcell;str1];
%     cell2csv('testdata.csv',celldata)
%%  �������Ϊ.mat�ļ�
save(['S1_grip_fitts_data.mat']);    % S1_single_finger_fitts_data
%cd \
