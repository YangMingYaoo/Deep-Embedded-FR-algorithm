
function[trainX,trainY,validX,validY,testX,testY,type_num]=Sample_creat(trainX,trainY,validX,validY,testX,testY)
sample_statlog=[[trainX trainY];[validX validY];[testX testY]]; %��ѵ�� ��֤ ���Լ� �����Լ���ǩ��ϵ�һ��[��ԭʼ���س������зֺõ����ݼ� ʹ�þ�������ƴ�ӡ��ķ�ʽƴ�Ӻ�]
[m_s,n_s]=size(sample_statlog); %��ȡƴ�Ӻ�֮�����ݾ��������������
Y=sample_statlog(:,end); % [ȡ��ƴ�Ӻþ�������һ�У�����ǩ]������һ��end���Ǿ�������һ��
type_num = size(unique(Y),1);  % �����ǩ�������Ŀ�����ﷵ��Ϊ2��Ϊ2������
class=cell(1,type_num);     % ʹ��cell()��������һ��1��2�е�Ԫ�����顣
    if min(unique(Y))==0    %�����С���б�ǩΪ0 ����1 
        sample_statlog(:,end)=sample_statlog(:,end)+1;
    end
for i=1:m_s                                    % m_sΪ��������������forѭ�����ã�����ѭ��������������ֿ���������潨���õ�Ԫ���������棬��Ԫ�������иպ���2�࣬�����ô��2��������
    for j=1:type_num                           % type_num Ϊ�����Ŀ��
        if sample_statlog(i,end)==j
            class{1,j}=[class{1,j};sample_statlog(i,:)];
        end
    end
end     % forѭ��������պð���װ�õ�2����������ֿ��ŵ�Ԫ�������У��ӷֿ���������ʾ��1����42��������2����84�����������Դ��ڲ�ƽ����������ݼ���


%% ��ѵ������֤�Ͳ�������
train_data=[];   % �����������飬������֮ǰ�Ƚ��ÿյľ����е���ռ�ӵĸо���ռ�ÿ�֮����������Ӷ��� 
valid_data=[];
test_data=[];
for i=1:type_num
    m_class=size(class{1,i},1);
    n=round(m_class/3);     %�������뺯��������һ����� ��������
    class_rand=class{1,i}(randperm(m_class),:);  %randperm(m_class) �������Ŀ���������������Ŀ���������ȡ����ÿ1�������
    train_data=[train_data;class_rand(1:n,:)];  %�����ȡ������ÿ1������ȡ1/n��ӽ� train_data��
    valid_data=[valid_data;class_rand(1+n:2*n,:)]; % ȡ1/n�Ž�valid_data
    test_data=[test_data;class_rand(1+2*n:end,:)];%ȡ1/n�Ž�test_data
end
 %�������forѭ�������ǰ� ÿһ���������ֳ�3�ݣ�Ҳ���ǰ�ÿһ���������ֳ�ѵ��������֤���Լ����Լ��ϡ�

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
% ������ֺõ����ݴ洢��sample_PD.mat,����������
save('sample_PD.mat','trainX','trainY','validX','validY','testX','testY','type_num');
end


%�����sample�ļ���������������������������
% �Ȱ�ԭʼ�ķֺõ�����ͨ������ƴ�� ��װ��һ���ڰ����ֿ�����ÿ������ж������ݷֳ�3���������ݣ��ֱ�Ϊѵ�� ���� ����֤��ÿһ������42������...
%2��������ͬһ���͵����ݷ���һ���ڴ��ң� ֮���ٴӴ����е������а������ͱ�ǩ���࣬���մ洢������յ�����
%��ô��������Ŀ����ʲô �� 