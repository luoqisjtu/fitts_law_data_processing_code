%% �����ļ���
clear; clc;                                                                         %��t>=14s��������ֹ�����Ӧ��trial��MTȥ��
%%
G = 2; %model off on
Q = 6;%test�ظ����� 
level = 6;   % ����ID�ȼ�������     ÿ��test�ļ������csv�ļ�����

mat_new_mt = cell(6,2);
SR = zeros(Q,2);
overshoot = zeros(Q,2);
RT = zeros(Q,2);
TP = zeros(Q,2);
%%  
for g = 1:G
    
    cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/S6_all_data/outcome_data/model_',num2str(g)]));  
    
    for q = 1:Q

        cd(strcat(['D:/Luoqi/fitts_law/fitts_all_result_analysis/S6_all_data/outcome_data/model_',num2str(g),'/model',num2str(g),'_ba_test_',num2str(q)]));
        %     files = dir([foldername '\*.csv']);                                      
        
        %% ��ȡ���Ĵ�Сֵ
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
            
            fname_read = ['Force_bar', num2str(k),'.csv'];   %��ʼID�������ݲ�����ȥ ���� ��k-1��Ϊk
            F = csvread(fname_read,1,0);
            %  F= csvread(list(k+2).name,1,0);
            
            T = F(:,1);
            [n,m] = size(T);
            max_t = 0.01*n - 0.01;
            t_ = 0: 0.01:max_t;
            t = t_';
            
            %ͳ������������ʱ�䣬��������ʼ�ƶ���ʱ������ %%%%��ʼ��ѹ��ֵ����ʵ�ʵ�������Ե�������������û�п��ǵ�
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
            
            
            %ͳ��ÿ��task������ֹ����Ĵ���(0-û��������1-����)
            collision =  F(:,6);
            collision_p(k) = sum(collision == 1);
            cp_t = sum(collision_p~=0);   %������ֹ�������
            
            
            if(ID_time(k)>13||collision_p(k)~=0)
                  ID_time(k)=100;  %ID_time(k)=[];
%                   ID_number(k)=0;
                  ID(k)=0;
                  reaction_time(k)=0;
            end
                                 

          %%             
            
            figure(k),
            plot(t(1:length(t)-300),F(1:length(F)-300,2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;     % �������궼Ҫȥ������3s�����ݣ�Ҳ����300����
            %plot(t(1:length(t)),F(1:length(F),2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;
            
            xlim=get(gca,'Xlim'); % ��ȡ��ǰͼ�ε�����ķ�Χ
            
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
            set(gca,'FontSize',16);%ֻ��ͬʱ�ı�x y����ʾ�������С��
            set(get(gca,'YLabel'),'Fontsize',19);% ����Ա�ע�Ķ���������̶�
            set(get(gca,'XLabel'),'Fontsize',19);% ����Ա�ע�Ķ���������̶�
            h_i=legend ( 'Pressure', 'Fmax',' Fmin', 'Location' ,'SouthEast');
            set(h_i,'Box','off');
            % ����ͼƬ����ǰĿ¼
            m=sprintf('task_%d.png',k);
            n=sprintf('task_%d.eps',k);
            saveas(figure(k),m);
            saveas(figure(k),n);
            
        end
        
        %% ����ID��time������
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
         
        %% ����ÿ��sucess rate��ƽ��reaction time
          fail_nu = sum(ID_time == 100);  %MT����Ϊ100��task������ÿ��ʧ�ܵ�task������
          SR(q,g) = 1 - fail_nu/6;
          
          overshoot(q,g) = cp_t/6;
          
%           RT(q,g) = mean(reaction_time);
          RT(q,g) = sum(reaction_time)/(6-fail_nu);       
        %% ����throughput(TP): TP= (ID1/MT1 + ID2/MT2 +...+ IDi/MTi )/N
         TP(q,g)=sum(ID./ID_time)/(6-fail_nu);
       %%
          mat_new_mt{q,g}(:,4)= reaction_time;
          mat_new_mt{q,g}(:,3)= ID_time;   
          mat_new_mt{q,g}(:,2)= ID;
          mat_new_mt{q,g}(:,1)= ID_number;
          %aaaaa=sum(ID_time == 0);  aaaaa=find(ID_time == 0);        
          
%           csvwrite('S6_ba_1_',num2str(q),'.csv',mat_new_mt{q,1});
%           csvwrite('S6_ba_2_',num2str(q),'.csv',mat_new_mt{q,2});
           
          csvwrite('S6_ba_1_1.csv',mat_new_mt{1,1});
          csvwrite('S6_ba_1_2.csv',mat_new_mt{2,1});
          csvwrite('S6_ba_1_3.csv',mat_new_mt{3,1});
          csvwrite('S6_ba_1_4.csv',mat_new_mt{4,1});
          csvwrite('S6_ba_1_5.csv',mat_new_mt{5,1});
          csvwrite('S6_ba_1_6.csv',mat_new_mt{6,1});
%           csvwrite('S6_ba_1_7.csv',mat_new_mt{7,1});
%           csvwrite('S6_ba_1_8.csv',mat_new_mt{8,1});
          
          csvwrite('S6_ba_2_1.csv',mat_new_mt{1,2});
          csvwrite('S6_ba_2_2.csv',mat_new_mt{2,2});
          csvwrite('S6_ba_2_3.csv',mat_new_mt{3,2});
          csvwrite('S6_ba_2_4.csv',mat_new_mt{4,2});
          csvwrite('S6_ba_2_5.csv',mat_new_mt{5,2});
          csvwrite('S6_ba_2_6.csv',mat_new_mt{6,2});
%           csvwrite('S6_ba_2_7.csv',mat_new_mt{7,2});
%           csvwrite('S6_ba_2_8.csv',mat_new_mt{8,2});

    end       

end   


%%  �������Ϊ.mat�ļ�
cd('D:\Luoqi\fitts_law\fitts_all_result_analysis\S6_all_data\outcome_data');
save(['S6_ba.mat']);    % 
%cd \
