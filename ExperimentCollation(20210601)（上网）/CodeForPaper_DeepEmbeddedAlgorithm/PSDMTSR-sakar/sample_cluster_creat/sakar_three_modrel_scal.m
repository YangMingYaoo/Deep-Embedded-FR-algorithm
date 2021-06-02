clear ; close all; clc;warning('off');
% sample_statlog=xlsread('����ɭ�����ݼ�_total2.xlsx','sacker','A2:AB1209');
% sample_statlog = xlsread('H:\�½��ļ���\1025\4MAXlittle���ݼ�\maxlittle.xlsx','sheet1','A2:X196');

%# �������ݼ�
load sakar_original1040X28_dataset
sample_statlog = sakar_original1040X28_dataset;

M = 200;%����ƫ�������ݵı�ֵ
[m_s,n_s]=size(sample_statlog);
Y=sample_statlog(:,end);
type_num = size(unique(Y),1);
class=cell(1,type_num);
chouqu_ratio=0.8;%%��ȡ�����ʣ���ѵ�����г�ȡ

%% # ȷ�� PWP���߱�ǩΪ2�Ĳ���

%#   ���������Ϊ0 ��PWP���߱�ǩΪ1 ��ֱ�Ӱ����������
    if min(unique(Y))==0
        sample_statlog(:,end)=sample_statlog(:,end)+1; %ȷ����ǩ�Ǵ�0��ʼ�����ǻ���Ҫ�˹�ȷ������������Ȼ��
    end                                               % �������ǰ�PWP��������Ϊ2 ������������Ϊ1

 %# ���PWP����Ϊ0 �������˱�ǩΪ1 �������������  ��sakar���ݼ�����������,����sakar���ݼ�ʹ���������
 index = find(sample_statlog(:,end)== 0)
 sample_statlog(index,end)=sample_statlog(index,end) + 2
 
 %# ���ձ�ǩ����в��˺ͽ����˽��з���
 for i=1:m_s
    for j=1:type_num
        if sample_statlog(i,end)==j
            class{1,j}=[class{1,j};sample_statlog(i,:)];
        end
    end
 end

%% ��ѵ������֤�Ͳ������� 
%# ���ﰴ��ѵ����֤�Ͳ��Լ������ȵ�����¼����л��ֵ�

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

%����maxlittle ԭʼ���ݼ�
clear ; close all; clc;warning('off');
load 'DataDivid_three'
train = [trainX trainY]
[m_s,n_s] = size(train); 


%%�ֿ��������
class = cell(1,type_num);     % ʹ��cell()��������һ��1��2�е�Ԫ�����顣
for i = 1:m_s                                    % m_sΪ��������������forѭ�����ã�����ѭ��������������ֿ���������潨���õ�Ԫ���������棬��Ԫ�������иպ���2�࣬�����ô��2��������
    for j = 1:type_num                           % type_num Ϊ�����Ŀ��
        if train(i,end) == j
            class{1,j}= [class{1,j};train(i,:)];
        end
    end
end

%# ��ѵ�����ݼ�������������
iter = 3;
traindataX = cell(1,iter);

% ���������߽��о���

for i = 1: type_num
        B_H = unique(class{1,i}(:,1))
    for j = 1:size(unique(class{1,i}(:,1)),1)
        data1 = [];
        data2 = [];
        data3 = [];
        index = find(class{1,i}(:,1)==B_H(j));
        data1 = class{1,i}(index,:);
        %ÿһ�����������
        % size()
        P = 0.8; % ÿһ�����������
        %�Բ�����������ֵ��������������

        [m_s1,n_s1] = size(data1); 
        %��һ�����
        N1 =  round( m_s1 * P);
        data2 = sampleCluster(data1,N1); %%������þ������
        %�ڶ������ 
        N2 =  round(N1 * P);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
        data3 = sampleCluster(data2,N2);
        traindataX{1,1} = [traindataX{1,1}(:,:);data1];
        traindataX{1,2} = [traindataX{1,2}(:,:); data2];
        traindataX{1,3} = [traindataX{1,3}(:,:); data3]
    end
end
%traindataX��ԭʼ�ռ����ݼ�����2��K��ֵ����֮����ɵ���������ռ䡣���ı���֤���Ͳ��Լ�

%% ��ѵ��������ѵ�����ݼ�����ÿһ����ң���������֤���Ͳ��Լ�
%forѭ�����ϰ���������ռ���ÿһ���ӿռ���е�ѵ�����ݴ���

for j = 1:iter
    randseed = randperm(size(traindataX{1,j},1));
    traindataX{1,j} = traindataX{1,j}(randseed,:);
    
end
% ����֤���ݼ� �Ͳ������ݼ�����ͬһ��������Ӵ���

%  valid_data = valid_data(randperm(size(valid_data,1)),:);
%  test_data = test_data(randperm(size(test_data,1)),:);
%   valid_data = valid_data(:,2:end);
%   test_data = test_data(:,2:end);
   test_data = [testX testY];
   valid_data = [validX validY]
%֮���ѵ������֤�Ͳ��Լ�����ɵ��µ����ݼ�����������������ʹ�á�
%��������,����֮������ݶ����Ѵ��ҵ�����
save('sakar_sample0601.mat','traindataX','valid_data','test_data','type_num')


