function [train_data,valid_data,test_data] = MaxLittle_PD_sample_creat(MaxLittle_OriginalData195X24)
[m_s,n_s]=size(MaxLittle_OriginalData195X24); %��ȡԭʼ���ݾ��������������
data = MaxLittle_OriginalData195X24;  
Y = data(:,end); % [ȡ��ƴ�Ӻþ�������һ�У�����ǩ]������һ��end���Ǿ�������һ��
type_num = size(unique(Y),1);  % �����ǩ�������Ŀ�����ﷵ��Ϊ2��Ϊ2������
class=cell(1,type_num);     % ʹ��cell()��������һ��1��2�е�Ԫ�����顣
%% ��sakar���ݼ��У���ǩΪ0�����в��ģ�Ϊ�˷��ϰ�����ѧ�����㷨��˼·���Ȱ�Ϊ0�ı�ǩ����Ϊ2. 
   %����ʵ����Ϊ2��Ϊ��ƥ��LSVT���ݼ�����Ϊ��LSVT���ݼ��У��������ܽ��ܵģ���������Ϊ�в��˵��������������ñ�ǩΪ2��
%�޸����ݱ�ǩ���ϳ�������ã�PWP����Ϊ2��Helthy����Ϊ1
   for i = 1:m_s 
    if data(i,end) == 0
       data(i,end) = data(i,end) + 1;
    elseif data(i,end) == 1
           data(i,end) = data(i,end) + 1;
    end 
end                               % 
%% forѭ��˵��  
% �������forѭ�����������ձ�ǩ�ֿ���������ǩΪ1��2��2Ϊ�в���1Ϊ�����ˣ�
% ����2��class�У���һ��class�д�ŵ��ǵ�1���ǩ���ˣ�����1���д�ŵ��ǽ����ˣ���2���д�ŵ�����PD���ߵġ�
for i = 1:m_s                                    % m_sΪ��������������forѭ�����ã�����ѭ��������������ֿ���������潨���õ�Ԫ���������棬��Ԫ�������иպ���2�࣬�����ô��2��������
    for j = 1:type_num                           % type_num Ϊ�����Ŀ��
        if data(i,end) == j  
            class{1,j} = [class{1,j};data(i,:)];
        end
    end
end     

%% 
% ���� MaxLittle���ݼ��� һ�����ࡣPWP�ͽ����ˣ���ÿһ���а��������֣�ѵ����0.6������ ��֤��ȡ0.2�����������Լ�ȡ0.2��������
% һ���˵�������������֤��һ�����У�Ҫô��ѵ������Ҫô�ڲ��Լ���Ҫô����֤����
% ������maxlittle���ݼ��У�һ������6����������6������Ҫô��ѵ������Ҫô�ڲ��Լ���Ҫô����֤����        

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
    class_rand = class{1,i};
    index1 = [];
    index0 = [];
     switch i
         case  2  % �в�����
         % ѵ����
         for j = 9 : 16           %12������Ҫ����case2��ȡ12���ˣ�����ķ�λ��֤���˲��Լ�
            index0 = [index0;find(class_rand(:,1) == j)];  %ѵ����
         end
         train_data2 = [train_data2; class_rand(index0,:)];
         
         % ��֤��
         for j = 17 : 24
              index1 =  [index1;find(class_rand(:,1) == j)];
         end
         valid_data2 = [valid_data2;class_rand(index1,:)];
         
         % ���Լ�
         indexcase2 = [indexcase2;index0;index1]
         class_rand(indexcase2,:) = [];
         test_data2 = class_rand;

        case 1  %������
%         for k = 10 : (10 - 1) + round(length(unique(class_rand(:,1))) / 3) 
%         index0 = find(class_rand(:,1) == (2 * k + 1))
%         index1 = find(class_rand(:,1) == (2 * k + 2))
%         train_data1 = [train_data1; class_rand(index0,:)];
%         valid_data1 = [valid_data1 ;class_rand(index1,:)];
%         indexcase1 = [indexcase1 ;index0;index1]
%         end
%         class_rand(indexcase1,:) = [];
%         test_data1 = class_rand; 
%          train_data1 = class_rand(1:312,:);%12�ˣ�ÿ��26��������һ��312������
%          valid_data1 = class_rand(313:416,:);
%          test_data1 = class_rand(417:520,:)
%      end
  % ѵ����
         for j = 1: 3           %12������Ҫ����case2��ȡ12���ˣ�����ķ�λ��֤���˲��Լ�
            index0 = [index0;find(class_rand(:,1) == j)];  %ѵ����
         end
         train_data1 = [train_data1; class_rand(index0,:)];
         
         % ��֤��
         for j = 4 : 6
              index1 =  [index1;find(class_rand(:,1) == j)];
         end
         valid_data1 = [valid_data1;class_rand(index1,:)];
         
         % ���Լ�
         indexcase1 = [indexcase1;index0;index1]
         class_rand(indexcase1,:) = [];
         test_data1 = class_rand;
     end

       
%% �������λ��ֺ�֮�󣬱�ǩ������Ȼ�Ƚ����У�������Ҫ�Ѱ��մ��ұ�ǩ���У��Ӷ�����������Ҳ���ҡ�

% train_data_rand = train_data(randperm(size(train_data,1)),:); %�ٴδ��ѵ����
% valid_data_rand = valid_data(randperm(size(valid_data,1)),:);%�ٴδ����֤��
% test_data_rand = test_data(randperm(size(test_data,1)),:);%�ٴδ�ϲ��Լ�
% ��Ϊ����forѭ�������ݼ�ȡ�����ǲ������ȡ�����ģ����ǰ���������˳���ȡ�ģ����Խ���������3���ǰ����ݼ���ϣ�������ѵ����

% trainX = train_data_rand; 
% validX = valid_data_rand; 
% testX =test_data_rand;
end    
train_data = [train_data1;train_data2]   % �ܵ�ѵ����
valid_data = [valid_data1;valid_data2]   % �ܵ���֤��
test_data = [test_data1; test_data2]     % �ܵĲ��Լ�
   
end