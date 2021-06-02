function abClassifier = buildAdaBoost(trnX, trnY, iter, tstX, tstY) %������ÿһ�۽�����֤������ ѵ���Ͳ��� 
if nargin < 4
    tstX = []; 
    tstY = [];
end                                 
abClassifier = initAdaBoost(iter); %���ó�ʼ��Adaboost������
% ���濪ʼ����Adaboost,������������Adaboost��ԭ����һ����.
N = size(trnX, 1); % Number of training samples,ѵ������������
sampleWeight = repmat(1/N, N, 1);   %��ʼ������Ȩ��

for i = 1 : iter
    weakClassifier = buildStump(trnX, trnY, sampleWeight);  %���øú��� �ҵ������������������������Щ�����������������ҳ���������С�ķ���,������С���ķ�����������һ����
    abClassifier.WeakClas{i} = weakClassifier;%����洢ÿһ�ֵ�������������
    abClassifier.nWC = i;
    % Compute the weight of this classifier  ����Ȩ��
    %���㷵��������������ϵ�����������Ϊ��������Ȩ��
    abClassifier.Weight(i) = 0.5*(log((1-weakClassifier.error)/weakClassifier.error));  % ������������Ȩ��
    % Update sample weight ����ȫ�¹���
    label = predStump(trnX, weakClassifier);                                               %���濪ʼ����������Ȩ�أ���һ��ʼ��ÿ��������Ȩ��һ���������ڵĸ��� ��ͱ�ò�һ����
    tmpSampleWeight = -1*abClassifier.Weight(i)*(trnY.*label); % N x 1
    tmpSampleWeight = sampleWeight.*exp(tmpSampleWeight); % N x 1
    sampleWeight = tmpSampleWeight./sum(tmpSampleWeight); % Normalized��׼��    
    % �����⼸���Ǹ���������Ȩ�ء�����Adaboostԭ��д�ģ�ûë��
    
    
    % Predict on training data
    % ����predAdaBoost()������
    [ttt, abClassifier.trnErr(i)] = predAdaBoost(abClassifier, trnX, trnY);
    % Predict on test data
    if ~isempty(tstY)
        abClassifier.hasTestData = true;
        [ttt, abClassifier.tstErr(i)] = predAdaBoost(abClassifier, tstX, tstY);
    end
    % fprintf('\tIteration %d, Training error %f\n', i, abClassifier.trnErr(i));
end
end
