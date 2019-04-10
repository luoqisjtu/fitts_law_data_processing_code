clear;clc;
filename = 'D:/Luoqi/fitts_law/experiement_results/amputee_luxin_2018_10_23/MT_line_chart_data_left_amputee_luxin.csv';
M = csvread(filename,1,1);

ID_number= M(:,1); 
ID = M(:,2); 
MT = M(:,3);

y=zeros(1,9);

set_list = unique (ID_number);
mat_new = cell(length(set_list),1);

for i = 1:length(set_list)
    ii = set_list(i);
    ind = find(ID_number == ii);
    mat_new{i,1} = M(ind,:);  
    
    y(i)=mean(mat_new{i,1}(:,2)./mat_new{i,1}(:,3));      % X =(ID)./MT     把ID编号相同的归到一起做(ID)./MT处理，然后求均值;

end






%   histc(val,unique(val));    计算向量中每个相同元素的个数，并排序输出不同元素的个数       
%   B=unique(a) %求出a中所有不同元素
%   numel（B）%求出B中元素的个数











