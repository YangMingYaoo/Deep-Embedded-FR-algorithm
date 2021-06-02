% ��Ϊ��������ռ乹����������и���Ⱦ���Ĵ���֮ǰ�Ȱ�ԭʼ���ݼ��ֳ�ѵ������֤�Ͳ��ԣ�֮�������ѵ������������������࣬���ı���֤���Ͳ��Լ���
%֮�󵥶���ѵ��������2����ȿռ��������2����������ռ䣬������k-means���й���
clc;close all;clear all;
tic;load 'ttraintestdata';
%% ���Բ��� 
%�������ݼ�

% TEST = [testX testY];
% TRAIN = [trainX trainY];
% DATA  =[TRAIN;TEST];
% % xlswrite('YYY.xlsx',); % XΪҪ����ľ��������YYYΪ����������
%  xlswrite('LSVT_DATA.xlsx',DATA); 
%% 


% ����ԭ����mat�����Ƿ���ģ�Ϊ�˷�������������ݣ�����׼�������ݺ��������ֳɲ�ͬ�����
train_data = [trainX trainY]; %��ѵ�����ݺͱ�ǩ�ŵ�һ��
test_data = [testX testY];   %�Ѳ������ݺͱ�ǩ�ŵ�һ��
trainX = train_data (1:42,:);
valid_data = train_data (43:84,:);
%% ���������ѵ������ �����
%��ȡѵ�����ݾ��������������
[m_s,n_s] = size(trainX); 
Y = trainX(:,end); % [ȡ��ѵ���������һ�У�����ǩ]������һ��end���Ǿ�������һ��
type_num = size(unique(Y),1);  % �����ǩ�������Ŀ�����ﷵ��Ϊ2��Ϊ2������
%�ֿ��������
class = cell(1,type_num);     % ʹ��cell()��������һ��1��2�е�Ԫ�����顣
for i = 1:m_s                                    % m_sΪ��������������forѭ�����ã�����ѭ��������������ֿ���������潨���õ�Ԫ���������棬��Ԫ�������иպ���2�࣬�����ô��2��������
    for j = 1:type_num                           % type_num Ϊ�����Ŀ��
        if trainX(i,end) == j
            class{1,j}= [class{1,j};trainX(i,:)];
        end
    end
end
%% ��ÿһ������������ȿռ����
iter = 3;
traindataX = cell(1,iter);
for i = 1 : type_num
    %ÿһ�����������
    % size()
    P = 0.8; % ÿһ�����������
    %�Բ�����������ֵ��������������
    data1 = class{1,i};
    [m_s1,n_s1] = size(data1); 
    %��һ�����
    N1 =  round( m_s1 * P);
    data2 = sampleCluster(data1,N1);
    %�ڶ������ 
    N2 =  round(N1 * P);
    data3 = sampleCluster(data1,N2);
    traindataX{1,1} = [traindataX{1,1};data1]
    traindataX{1,2} = [traindataX{1,2};data2];
    traindataX{1,3} = [traindataX{1,3};data3]
end
%traindataX��ԭʼ�ռ����ݼ�����2��K��ֵ����֮����ɵ���������ռ䡣���ı���֤���Ͳ��Լ�

%forѭ�����ϰ���������ռ���ÿһ���ӿռ���е�ѵ�����ݴ���
for j = 1:iter
    traindataX{1,j} = traindataX{1,j}(randperm(size( traindataX{1,j},1)),:);
end

%֮���ѵ������֤�Ͳ��Լ�����ɵ��µ����ݼ�����������������ʹ�á�
%��������,����֮������ݶ����Ѵ��ҵ�����
save('PD_LSVTsample1.mat','traindataX','valid_data','test_data','type_num');
toc
