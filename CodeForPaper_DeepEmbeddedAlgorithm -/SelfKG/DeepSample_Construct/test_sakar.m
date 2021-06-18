clc;clear all; close all;
load 'sakar_original1040X28_dataset'
[m_s,n_s]=size(sakar_original1040X28_dataset); %��ȡԭʼ���ݾ��������������
data = sakar_original1040X28_dataset;  
Y = data(:,end); % [ȡ��ƴ�Ӻþ�������һ�У�����ǩ]������һ��end���Ǿ�������һ��
type_num = size(unique(Y),1);  % �����ǩ�������Ŀ�����ﷵ��Ϊ2��Ϊ2������
class=cell(1,type_num);     % ʹ��cell()��������һ��1��2�е�Ԫ�����顣
%% ��sakar���ݼ��У���ǩΪ0�����в��ģ�Ϊ�˷��ϰ�����ѧ�����㷨��˼·���Ȱ�Ϊ0�ı�ǩ����Ϊ2. 
   %����ʵ����Ϊ2��Ϊ��ƥ��LSVT���ݼ�����Ϊ��LSVT���ݼ��У��������ܽ��ܵģ���������Ϊ�в��˵��������������ñ�ǩΪ2��
for i = 1:m_s 
    if data(i,end) == 0
       data(i,end) = data(i,end) + 2;
    end   
end
%% forѭ��˵��  ���sakar ���ݼ��� 1040 * 28
% �������forѭ�����������ձ�ǩ�ֿ���������ǩΪ1��2��2Ϊ�в���1Ϊ�����ˣ�
% ����2��class�У���һ��class�д�ŵ��ǵ�1���ǩ���ˣ�����1���д�ŵ��ǽ����ˣ���2���д�ŵ�����PD���ߵġ�
for i = 1:m_s                                    % m_sΪ��������������forѭ�����ã�����ѭ��������������ֿ���������潨���õ�Ԫ���������棬��Ԫ�������иպ���2�࣬�����ô��2��������
    for j = 1:type_num                           % type_num Ϊ�����Ŀ��
        if data(i,end) == j  
            class{1,j} = [class{1,j};data(i,:)];
        end
    end
end     

%% ԭʼ���ݼ������бȽ����룬����ʹ��randperm����һ�£�������7/7/6�ı������������ݼ���
train_data1=[];   % �����������飬������֮ǰ�Ƚ��ÿյľ����е���ռ�ӵĸо���ռ�ÿ�֮����������Ӷ��� 
valid_data1=[];
test_data1=[];
train_data2=[];   % �����������飬������֮ǰ�Ƚ��ÿյľ����е���ռ�ӵĸо���ռ�ÿ�֮����������Ӷ��� 
valid_data2=[];
test_data2=[];
indexcase1 = [];
indexcase2 = [];
for i =  1:type_num
    m_class = size(class{1,i},1); %ѡ��class �е�һ�У���i�С�
    class_rand = class{1,i}(randperm(m_class),:)
     switch i
         case  2
        for j = 0 : round(length(unique(class_rand(:,1))) / 3) - 1
        index0 = find(class_rand(:,1) == (2 * j + 1))
        index1 = find(class_rand(:,1) == (2 * j + 2))
        train_data2 = [train_data2; class_rand(index0,:)];
        valid_data2 = [valid_data2;class_rand(index1,:)];
        indexcase2 = [indexcase2;index0;index1]
        end
        class_rand(indexcase2,:) = [];
        test_data2 = class_rand;
        
        case 1 
        for k = 10 : (10 - 1) + round(length(unique(class_rand(:,1))) / 3) 
        index0 = find(class_rand(:,1) == (2 * k + 1))
        index1 = find(class_rand(:,1) == (2 * k + 2))
        train_data1 = [train_data1; class_rand(index0,:)];
        valid_data1 = [valid_data1 ;class_rand(index1,:)];
        indexcase1 = [indexcase1 ;index0;index1]
        end
        class_rand(indexcase1,:) = [];
        test_data1 = class_rand; 

     end
  
     

end
train_data = [train_data1;train_data2]  
valid_data = [valid_data1;valid_data2]
test_data = [test_data1; test_data2]


%% �������λ��ֺ�֮�󣬱�ǩ������Ȼ�Ƚ����У�������Ҫ�Ѱ��մ��ұ�ǩ���У��Ӷ�����������Ҳ���ҡ�

train_data_rand = train_data(randperm(size(train_data,1)),:); %�ٴδ��ѵ����
valid_data_rand = valid_data(randperm(size(valid_data,1)),:);%�ٴδ����֤��
test_data_rand = test_data(randperm(size(test_data,1)),:);%�ٴδ�ϲ��Լ�
% ��Ϊ����forѭ�������ݼ�ȡ�����ǲ������ȡ�����ģ����ǰ���������˳���ȡ�ģ����Խ���������3���ǰ����ݼ���ϣ�������ѵ����

trainX = train_data_rand(:,1:end-1);  %end�������һ�б�ǩ�У�end-1������ǰ�ƶ�һ�У����������ֻȡ����ѵ�����ݼ�����ȡ��ǩ
trainY = train_data_rand(:,end);
validX = valid_data_rand(:,1:end-1); %�����⼸��һ��������
validY = valid_data_rand(:,end);
testX =test_data_rand(:,1:end-1);
testY =test_data_rand(:,end);

     