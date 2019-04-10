clear; clc;
% for temp = 245.92       %0-0; 1-21.47; 2-26.86; 3-35.22; 4-43.57; 5-49.98; 6-80.15; 7-88.13; 8-96.27; 9-138.05; 10-147.42; 11-154.54; 12-161.31; 13-209.83; 14-216.39; 15-229.2; 16-239.74; 17-245.92
%%
cd  Amputee_data/Amputee1 
%%
filename = 'Task_3.csv';
M = csvread(filename,1,0);

T = M(:,1); 
[n,m] = size(T);
max_t = 0.01*n - 0.01;
t_ = 0: 0.01:max_t;
t = t_';

plot(t,M(:,2)-0.002,'linewidth',1.5,'color',[0,0,1]); hold on;             
plot(t,M(:,4)-0.002,'--','linewidth',1.5,'color',[1,0,0]); hold on;
plot(t,M(:,5)-0.002,'--','linewidth',1.5,'color',[0,1,0]); grid off;hold on;

axis([0 7 0 5]);
xlabel('Time(s)');
ylabel('Pressure(N)');

 set(gca,'FontSize',24);%只能同时改变x y轴显示的字体大小；
 set(get(gca,'YLabel'),'Fontsize',26);% 是针对标注的而不是坐标刻度
 set(get(gca,'XLabel'),'Fontsize',26);% 是针对标注的而不是坐标刻度

h=legend ( 'Pressure', 'Fmin',' Fmax', 'Location' ,'SouthEast');
set(h,'Box','off');
% % 保存图片到当前目录
% m=sprintf('task_%d.png',13);
% saveas(figure(13),m);
%%
cd ..
cd ..
%%
% xlabel('Time(s)'),
% ylabel('Elbow Velocity');
% title('Simulated vs.Original elbow velocity','linewidth',3.5);
% end