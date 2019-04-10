%% �����ļ���
clear; clc;                                                                         %��t>=14s��������ֹ�����Ӧ��trial��MTȥ��
%%
G = 2;%on/off������� 
H = 2;
Q = 3;%test�ظ����� 
level = 9;   % ����ID�ȼ�������     ÿ��test�ļ������csv�ļ�����



mat_new_off = cell(10,1);
% mat_new_on = cell(10,1);
%%
for g = 1:G
    
    foldername = strcat(['D:/Luoqi/fitts_law/able-bodied_subject_raw_data_and_results/raw_data/S1/neuromorphic_',num2str(g-1)]);
    cd(foldername);
  
  for h_a = 1:H
     cd(strcat(['D:/Luoqi/fitts_law/able-bodied_subject_raw_data_and_results/raw_data/S1/neuromorphic_' num2str(g-1) '/brittleness_',num2str(h_a-1)]));
  
     
    for q = 1:Q

        cd(strcat(['D:/Luoqi/fitts_law/able-bodied_subject_raw_data_and_results/raw_data/S1/neuromorphic_' num2str(g-1) '/brittleness_',num2str(h_a-1) '/test',num2str(q)]));
        %     files = dir([foldername '\*.csv']);
        
        %% ��ȡ���Ĵ�Сֵ
        filename1 = 'D:/Luoqi/fitts_law/ID_9_force_Fmin_Fmax.csv';
        file = csvread(filename1,1,0);
        fmin = file(1:level,4);
        fmax = file(1:level,5);
        %%
        ID_time=zeros(level,1);
        ID_time_re=zeros(level,1);
        reaction_time=zeros(level,1);
        collision_p=zeros(level,1);
        
        for k=1:level
            
            fname_read = ['Force_bar', num2str(k-1),'.csv'];
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
            
            ID_time(k)=t(length(t)-300)-t(start_time);
            ID_time_re(k)=t(length(t)-300)-0.2;
            reaction_time(k) = ID_time_re(k)-ID_time(k);
            
            
            %ͳ��ÿ��task������ֹ����Ĵ���(0-û��������1-����)
            collision =  F(:,6);
            collision_p(k) = sum(collision == 1);
            cp_t = sum(collision_p~=0);   %������ֹ�������
            
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
            title(['ID =',num2str(k-1)]);
            set(gca,'FontSize',16);%ֻ��ͬʱ�ı�x y����ʾ�������С��
            set(get(gca,'YLabel'),'Fontsize',19);% ����Ա�ע�Ķ���������̶�
            set(get(gca,'XLabel'),'Fontsize',19);% ����Ա�ע�Ķ���������̶�
            h_i=legend ( 'Pressure', 'Fmax',' Fmin', 'Location' ,'SouthEast');
            set(h_i,'Box','off');
            % ����ͼƬ����ǰĿ¼
            m=sprintf('task_%d.png',k);
            saveas(figure(k),m);
        end
        
        %% ����ID��time������
        %ID_true=[3.32 3.7 3.74 4.12 4.17 4.32 4.39 4.52 4.58 4.64 4.7 4.81 4.94 5.06 5.17 5.39 5.52 5.64];
        % ID=[4.32,4.12,4.64,5.17,3.32,4.7,4.39,3.7,4.58,5.39,4.17,4.81,5.64,5.52,3.74,4.94,5.06,4.52];
        ID=[5.17,3.74,4.64,4.32,4.17,5.64,4.58,3.32,5.06];
        figure(level+1)
        plot(ID(1:level),ID_time,'.','Markersize',15);
        xlabel('ID');
        ylabel('Time(s)')
        %title('Hand group5')
        png=sprintf('time_ID.png');
        saveas(figure(level+1),png);
        
        %% ����throughput(TP): TP= (ID1/MT1 + ID2/MT2 +...+ IDi/MTi )/N
        X=(ID)'./ID_time;
        TP=mean(X);
             
        
    end
    
    mat_new_off(g:1) = ID_time;
    
  end
  

 
  
end

%%  �������Ϊ.mat�ļ�
cd('D:\Luoqi\fitts_law\able-bodied_subject_raw_data_and_results\raw_data\S1');
save(['S1_fitts_law.mat']);
%cd \
