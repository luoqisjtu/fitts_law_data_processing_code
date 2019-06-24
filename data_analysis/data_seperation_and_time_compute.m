%% Data seperation and Time compute
clear; clc;
%%
cd  amputee_data/amputee2 
filename = 'force_test_subject2.csv';
M = csvread(filename,1,0);
ID = M(:,3); 

m_v = max(ID);
ind = find(ID==m_v);
if ind(end)<length(ID)         %去掉task全部结束后，运动条回到默认值ID=0的数据
    ID(ind(end)+1:end,:)=[];
end

set_list = unique (ID);
mat_new = cell(length(set_list),1);
time = zeros(1,18);  r = 1;
for i = 1:length(set_list)
    ii = set_list(i);     
    ind = find(ID == ii);
    mat_new{i,1} = M(ind,:);  
    
    pre = mat_new{i,1}(:,2);         %把每个ID运动条回零这一时间段的数据置为0.002（除了第1个ID，后面的ID起始时都存贮了前一个ID运动条回到起始位置这一时间段的数据）
    min_v = min(pre);
    ind_min = find(pre == min_v);
    p_ = ind_min(end);
    pre(1:p_) = 0.002;     % 0.002——起始位置（零点位置）压力
    mat_new{i,1}(:,2) = pre;
    
    P = mat_new{i,1}(:,2);    
   [n,m] = size(P); 
for j = 1:n
    if P(j) > 0.002
        N = pre(j:end,1);
        break
    end
end  
    t = (n-j)*0.01
    time(r,1) = t;
    r = r+1;
    
    csvwrite('Task_1.csv',mat_new{1,1});
    csvwrite('Task_2.csv',mat_new{2,1});
    csvwrite('Task_3.csv',mat_new{3,1});
    csvwrite('Task_4.csv',mat_new{4,1});
    csvwrite('Task_5.csv',mat_new{5,1});
    csvwrite('Task_6.csv',mat_new{6,1});
    csvwrite('Task_7.csv',mat_new{7,1});
    csvwrite('Task_8.csv',mat_new{8,1});
    csvwrite('Task_9.csv',mat_new{9,1});
    csvwrite('Task_10.csv',mat_new{10,1});
    csvwrite('Task_11.csv',mat_new{11,1});
    csvwrite('Task_12.csv',mat_new{12,1});
    csvwrite('Task_13.csv',mat_new{13,1});
    csvwrite('Task_14.csv',mat_new{14,1});
    csvwrite('Task_15.csv',mat_new{15,1});
    csvwrite('Task_16.csv',mat_new{16,1});
    csvwrite('Task_17.csv',mat_new{17,1});
    csvwrite('Task_18.csv',mat_new{18,1});
end
cd ..





