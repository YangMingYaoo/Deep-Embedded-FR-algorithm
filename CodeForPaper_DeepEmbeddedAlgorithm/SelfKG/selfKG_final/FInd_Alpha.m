% ���ڸú���Ҫ�����Ҫ�ҵ�ֻ��һ������Ȩ�ء�
% ����Ȩ����ô���ġ� ��˭��Ȩ�أ�Ȩ������ô�����������ġ�
function [alpha] = FInd_Alpha(Trainingdata)
% function [alpha] = FInd_Alpha()
% load('Trainingdata.mat')
% [trainX, mu, sigma] = featureCentralize(trainX);%%��������׼��������N(0,1)�ֲ���
% testX = bsxfun(@minus, testX, mu);
% testX = bsxfun(@rdivide, testX, sigma);
% trainX1=trainX(1:42,:);
% trainY1=trainY(1:42,:);
% trainX2=trainX(43:84,:);
% trainY2=trainY(43:84,:);
alpha=[];
% for o=1:2;
    for p = 1:size(Trainingdata)
        X = Trainingdata{p,1};
        trainX = X(:,1:end-1);     %trainX��trainY �Ǵ�Trainingdata ȡ����������
        trainY = X(:,end);
        [ind] = find(trainY==2);
        trainY(ind,1) = -1;         
        nfold = 10;
        iter = 3;
        tstError = zeros(nfold, iter);%�������ݼ����   10�����У��������
        trnError = zeros(nfold, iter);%ѵ�����ݼ����
        %���õ�һ�����������ʲô���ú������������������������Լ��Ľ�������ѵ�����Ľ������
        [trnM, tstM] = buildCVMatrix(size(trainX, 1), nfold); %�����������,��һЩ�������������������
        %��ʼ nfold�۽�����֤. 
        for n = 1:nfold          
            fprintf('\tFold %d\n', n);          
            %logical()����������ֵת��Ϊ�߼�ֵ������Ԫ��ת��Ϊ1,0Ԫ��ת��Ϊ0.
            idx_trn = logical(trnM(:, n) == 1); %�о���һ���е���࣬��ΪtrnM�������Ǿ���1��0.
            trnX = trainX(idx_trn, :); %ȡ��ÿһ�۽�����֤��ѵ������X
            tstX = trainX(~idx_trn, :); %ȡ��ÿһ�۽�����֤�Ĳ�������X
            trnY = trainY(idx_trn);    %ȡ��ÿһ�۽�����֤��ѵ�����ݱ�ǩY
            tstY = trainY(~idx_trn);  %ȡ��ÿһ�۽�����֤�Ĳ������ݱ�ǩY          %�ߵ����﷢��tstM û����,һ��trnM�Ϳ��Ը㶨�� 
            %���õڶ�������������ÿһ�۽�����֤��ѵ�����ݡ�ѵ�����ݱ�ǩ���������ݡ��������ݱ�ǩ����ô���ʲô��?
            abClassifier = buildAdaBoost(trnX, trnY, iter, tstX, tstY);
            %10�۽�����֤���ݼ���ÿһ�����ݶ��������һ�Σ�ÿһ��������������3�Σ��õ�3��Ȩ�ء�
            %10�������ȥ���ջ���3��Ȩ�أ���Ϊÿһ�۶��ڸ��µĻ���������Ȩ�ء� 
            trnError(n, :) = abClassifier.trnErr;
            tstError(n, :) = abClassifier.tstErr;
        end
        A = abClassifier.Weight; %���ε������ ������Ȩ��
        B = sum(A)/3;            % �����ε�����ķ�����Ȩ�ؽ�����ƽ������
        alpha(p)=B;            %�������ӿռ����ݼ�Ȩ�ص�ƽ��ֵ���ظ��������� 

% plot(1:iter, mean(trnError, 1)); % Training error
% hold on;
% plot(1:iter, mean(tstError, 1));% Test error
%     end
    end
end
