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
    
    y(i)=mean(mat_new{i,1}(:,2)./mat_new{i,1}(:,3));      % X =(ID)./MT     ��ID�����ͬ�Ĺ鵽һ����(ID)./MT����Ȼ�����ֵ;

end






%   histc(val,unique(val));    ����������ÿ����ͬԪ�صĸ����������������ͬԪ�صĸ���       
%   B=unique(a) %���a�����в�ͬԪ��
%   numel��B��%���B��Ԫ�صĸ���











