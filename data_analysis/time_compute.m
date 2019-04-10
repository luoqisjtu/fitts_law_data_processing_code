% 注释：ctrl+r  取消注释：ctrl+t
%% 同一个文件夹多个csv文件批量处理
%%
cd  fitts_law_pressure_ID_18
for j = 1:18
fileName = ['fitts_law_pressure_' num2str(j) '.csv'];      % filename = 'fitts_law_pressure_17.csv';  
M = csvread(fileName,1,0);
P = M(:,2);
[n,m] = size(P);
for i = 1:n
    if P(i) > 0.002
        N = P(i:end,1);
        break
    end
end
%[a,b] = size(N)    
t = (n-i)*0.01
end
cd ..
%%

%%  同一个xlsx/csv文件下多个sheet子文件批量处理
%%
cd hand_control_18tasks
[~,SheetNames]  = xlsfinfo('force_test1.xlsx')
nSheets = length(SheetNames)
for iSheet = 1:nSheets
 Name = SheetNames{iSheet}; 
 Data = readtable('force_test1.xlsx','Sheet',Name) ; 
 S(iSheet).Name = Name;
 S(iSheet).Data = Data;
 Data = table2array(Data); %将表转换为同构数组
 P = Data(:,2);
%  P = S(1).Data.Pressure;
 [n,m] = size(P);
for i = 1:n
    if P(i) > 0.002
        N = P(i:end,1);
        break
    end
end
%[a,b] = size(N)    
t = (n-i)*0.01 
end
cd ..



































