clear ; close all; clc;warning('off');
% sample_statlog=xlsread('帕金森总数据集_total2.xlsx','sacker','A2:AB1209');
% sample_statlog = xlsread('H:\新建文件夹\1025\4MAXlittle数据集\maxlittle.xlsx','sheet1','A2:X196');

%# 加载数据集
load sakar_original1040X28_dataset
sample_statlog = sakar_original1040X28_dataset;

M = 200;%设置偏差与数据的比值
[m_s,n_s]=size(sample_statlog);
Y=sample_statlog(:,end);
type_num = size(unique(Y),1);
class=cell(1,type_num);
chouqu_ratio=0.8;%%抽取样本率，从训练集中抽取

%% # 确保 PWP患者标签为2的操作

%#   如果正常人为0 ，PWP患者标签为1 。直接按照下面代码
    if min(unique(Y))==0
        sample_statlog(:,end)=sample_statlog(:,end)+1; %确保标签是从0开始，但是还需要人工确保其是连续自然数
    end                                               % 在这里是把PWP患者设置为2 ，健康人设置为1

 %# 如果PWP患者为0 ，正常人标签为1 ，则按照下面代码  而sakar数据集符合这条件,所以sakar数据集使用这个方法
 index = find(sample_statlog(:,end)== 0)
 sample_statlog(index,end)=sample_statlog(index,end) + 2
 
 %# 按照标签类别将有病人和健康人进行分类
 for i=1:m_s
    for j=1:type_num
        if sample_statlog(i,end)==j
            class{1,j}=[class{1,j};sample_statlog(i,:)];
        end
    end
 end

%% 分训练、验证和测试样本 
%# 这里按照训练验证和测试几乎均等的情况下及进行划分的

train_data=[];
valid_data=[];
test_data=[];
% ID_label_i=size(unique(class{1,i}(:,1)),1);
for i=1:type_num
    m_class=size(unique(class{1,i}(:,1)),1);
%     class{1,i}(:,1)=class{1,i}(:,1)-min(class{1,i}(:,1))+1;
    if i == 1
        class_rand=randperm(m_class);
    else  
         class_rand = randperm(m_class) + min(class{1,i}(:,1))-1;
    end
       n=round(m_class/3);
        for j=1:size(class_rand,2)
            if j<n+1
                data_in=find(class{1,i}(:,1)==class_rand(1,j));
                train_data=[train_data;class{1,i}(data_in,:)];
            elseif j<2*n+1
                data_in=find(class{1,i}(:,1)==class_rand(1,j));
                valid_data=[valid_data;class{1,i}(data_in,:)];
            else
                data_in=find(class{1,i}(:,1)==class_rand(1,j));
                test_data=[test_data;class{1,i}(data_in,:)];
            end
        end
end

train_data_rand=train_data(randperm(size(train_data,1)),:);
valid_data_rand=valid_data(randperm(size(valid_data,1)),:);
test_data_rand=test_data(randperm(size(test_data,1)),:);

trainX=train_data_rand(:,1:end-1);
trainY=train_data_rand(:,end);
validX=valid_data_rand(:,1:end-1);
validY=valid_data_rand(:,end);
testX =test_data_rand(:,1:end-1);
testY =test_data_rand(:,end);
save('DataDivid_three.mat','trainX','trainY','validX','validY','testX','testY','type_num');

%% 

%加载maxlittle 原始数据集
clear ; close all; clc;warning('off');
load 'DataDivid_three'
train = [trainX trainY]
[m_s,n_s] = size(train); 


%%分开类别程序段
class = cell(1,type_num);     % 使用cell()函数建立一个1行2列的元胞数组。
for i = 1:m_s                                    % m_s为数据样本行数，for循环作用，经过循环后把两类样本分开存放在上面建立好的元胞数组里面，在元胞数组中刚好有2类，故正好存放2类样本。
    for j = 1:type_num                           % type_num 为类别数目。
        if train(i,end) == j
            class{1,j}= [class{1,j};train(i,:)];
        end
    end
end

%# 对训练数据集进行样本聚类
iter = 3;
traindataX = cell(1,iter);

% 按照受试者进行聚类

for i = 1: type_num
        B_H = unique(class{1,i}(:,1))
    for j = 1:size(unique(class{1,i}(:,1)),1)
        data1 = [];
        data2 = [];
        data3 = [];
        index = find(class{1,i}(:,1)==B_H(j));
        data1 = class{1,i}(index,:);
        %每一层样本输出率
        % size()
        P = 0.8; % 每一层样本输出率
        %对不是整数的数值四舍五入变成整数

        [m_s1,n_s1] = size(data1); 
        %第一层聚类
        N1 =  round( m_s1 * P);
        data2 = sampleCluster(data1,N1); %%这里调用聚类程序。
        %第二层聚类 
        N2 =  round(N1 * P);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
        data3 = sampleCluster(data2,N2);
        traindataX{1,1} = [traindataX{1,1}(:,:);data1];
        traindataX{1,2} = [traindataX{1,2}(:,:); data2];
        traindataX{1,3} = [traindataX{1,3}(:,:); data3]
    end
end
%traindataX是原始空间数据集经过2次K均值聚类之后组成的深度样本空间。不改变验证集和测试集

%% 把训练聚类后的训练数据集按照每一层打乱，并打乱验证集和测试集
%for循环加上把深度样本空间中每一个子空间的中的训练数据打乱

for j = 1:iter
    randseed = randperm(size(traindataX{1,j},1));
    traindataX{1,j} = traindataX{1,j}(randseed,:);
    
end
% 把验证数据集 和测试数据集按照同一个随机种子打乱

%  valid_data = valid_data(randperm(size(valid_data,1)),:);
%  test_data = test_data(randperm(size(test_data,1)),:);
%   valid_data = valid_data(:,2:end);
%   test_data = test_data(:,2:end);
   test_data = [testX testY];
   valid_data = [validX validY]
%之后把训练、验证和测试集合组成的新的数据集保存下来，供后面使用。
%保存数据,保存之后的数据都是已打乱的数据
save('sakar_sample0601.mat','traindataX','valid_data','test_data','type_num')


