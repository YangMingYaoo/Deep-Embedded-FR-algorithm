
clc;clear ;warning('off');
load('ttraintestdata.mat');%���ݼ���ȡ
% for i=1:3
% [Data]=Mixdata(Data,Labels);
% data=Data(:,1:end-1);
% labels=Data(:,end);
% trainC=data(1:84,:);
% testX=data(85:end,:);
% testY=labels(85:end,1);

ACC_w1_all=[];
tr2=[];
for J=1:1  %��forѭ�����������������10�Σ����յľ���ȡ10�����е�ƽ��ֵ 
    FinalAcc=[];
    ensemble=[];
    for s=1:3           % Sֻ��һ���������ӿռ����������
%         load('traintestdata.mat');%���ݼ���ȡ ,����ΪʲôҪ�Ǽ����������ݼ���
        trainX1 = train_x{J,s}(:,1:end-1);
        trainY1 = train_x{J,s}(:,end);
%       trainX1 = trainX(1:42,:);
%       trainY1 = trainY(1:42,1);
        validX = trainX(43:84,:);  %����Ϊ��Ҫ�ӵ�43�п�ʼ�ɼ��أ� ��ΪҪ��trainX�з�����֤��
        validY = trainY(43:84,1);
       % ������׼������ ,suo you de shuju dou tongyi chuli 
       [trainX1, mu, sigma] = featureCentralize(trainX1);%%��������׼��������N(0,1)�ֲ���
       testX = bsxfun(@minus, testX, mu);
       testX = bsxfun(@rdivide, testX, sigma);
       validX = bsxfun(@minus, validX, mu);
       validX = bsxfun(@rdivide, validX, sigma);    
       % trainX1=trainX(1:42,:);
       % trainY1=trainY(1:42,1);
       % validX=trainX(43:84,:);
       % validY=trainY(43:84,1);
       % [trainX1,trainY1,validX,validY,testX,testY,type_num]=Sample_creat(trainX1,trainY1,validX,validY,testX,testY)
       a=[];
       m = 1;
       p=0;
       % l=1;
       tic
       iter=3; % number of iterations   ��iterָ��ÿһ�����ݼ��ӿռ� ����ѵ�����ٴ�
       Models = cell(iter,1); % For saving the models from each iteration 
       Us = cell(iter,1); % For saving the Us from each iteration
       Trainingdata = cell(iter,1); % For saving the training data from each iteration to calculate the corresponding Alpha
       % while (m>0.0001)
       %% 
       for z=1:iter
           % [fea,U,model,indx,misX,misY] = adbstLDPP(trainX,trainY,testX,testY,type_num);
           
           [fea,U,model,indx,misX,misY] = adbstLDPP(trainX1,trainY1,validX,validY,type_num);
           %? ��һ���������ʱ�ҳ�����������ҳ��������֮��û�жԴ�ֵ�������ȡʲô��ʩ������
           Us{z}=U;
           feature{z,1}=fea; % Saving the features for each iteration
           Trainingdata{z,1} = [trainX1 trainY1]; % combining training data with its labels. Since in each iteration training data will be changed, we need to save corresponding labels
           Medels{z,1}=model;
           trainX1 = [misX;trainX1]; % combining the training data with miss classified samples
           trainY1 = [misY;trainY1]; % combining the training lebels with miss classified labels
           % ��һ����Ӧ������������ͼ����˵�� ��En��?
           for i = 1:size (misY)       % iter=3 .ʱ��ִ�����Ϊ0������û���ڼ������ϵ�������ˡ�
               b = corr(misX(:,i),misY); % Finding the error. however result id NaN because miss classified samples belong to single class.
               a = [a b];
           end                
               
       end                  %����ô���� ��һ�δ��������⣬Ӧ�ð�53��54�з��� 51��֮ǰ��
       % ��������Ѿ������ε���ѭ���õ��ķ�����ѵ�������,���濪ʼ������ѵ���õķ�������Ȩ�أ�Ҳ�����Ƕ�Σ������������Ρ���
       %% 
       %����Ӧ���˽�һ��Trainingdata ���������ʲô ��
       % Finding Alpha  
       alpha = FInd_Alpha(Trainingdata);   % ����ԭ�����Ͳ��ԣ����Ӧ���Ƿ��صķ�����Ȩ�ء�% finding the alpha for training data of each iteration
       % alpha(1)=0.5;

       % Test process ���Դ������
       svml8 = [];
       svm_prede=[]

       for i = 1:iter  %��ÿһ���ӿռ�����������´���
           %�����֮ǰѵ������������ʱ����Ķ�����LDPPӳ�����US��ѵ���ķ���ģ��model,����ѡ�����������relief���ٴ���ȡ����
           test1 = testX * (Us{i}); % Coressponding U
           mod1 = Medels{i};  % Corresponding model
           fea = feature{i};  % Coressponding Feature
           test1 = test1(:,fea);
           svm_pred1 = svmpredict(testY,test1,mod1);
           [ind] = find(svm_pred1==2); % Because Sgn function works with labels -1 and 1 so here I changed all my labels from 2 to -1 to make it possible(1,-1) before saving
           svm_pred1(ind,1)= -1;
           svm_pred1 = svm_pred1 * alpha(i);  %alpha��i������֮ǰ���ص�ÿһ�������ӿռ�������������Ȩ�� ��  % Multiplication of alpha with corresponding prediction ��
           svm_prede = [svm_prede svm_pred1];
       end

       % for i=1:iter;
       % test1=testX*(Us{i}); % Coressponding U
       % mod1=Medels{i}% Corresponding model
       % fea=feature{i};% Coressponding Feature
       % test1=test1(:,fea(1:100));
       % svm_pred1 = svmpredict(testY,test1,mod1);
       % [ind]=find(svm_pred1==2); % Because Sgn function works with labels -1 and 1 so here I changed all my labels from 2 to -1 to make it possible(1,-1) before saving
       % svm_pred1(ind,1)=-1;
       % svm_pred1=svm_pred1*alpha(i); % Multiplication of alpha with corresponding prediction
       % svm_prede=[svm_prede svm_pred1];
       % end

      %% Final Prediction ���յ�Ԥ�� 
       [ind]= find(testY==2); % Changing labels having value 2 to -1 for calculation of accuracy    ����Ϊ֮ǰ��Ԥ������ı�ǩ�޸ĳ���1��-1 ������Ҫ��testY���жԱȣ�����ҲҪ��testy���1��-1
       testY(ind,1) = -1;
       Final_predict = sum(svm_prede,2);
       Result = sign(Final_predict);    %sign�����Ѵ���0������Ϊ1��С��0 ������Ϊ-2������0������Ϊ0��
       Final_Accuracy_with_Adaboost = mean(Result == testY) * 100 % Final accuracy ����Ϊ֮ǰ��testY�����-1��1�����Կ��Ժ�Result���жԱ�
       ensemble = [ensemble Result];
       FinalAcc = [FinalAcc Final_Accuracy_with_Adaboost];
       
    end   %���������ÿ���ӿռ������ѵ��
    
   %%   
    % Apply to stack   Ӧ�ö�ջ��˼������ж����ķ������ѵ��������γ����յ�Ԥ��
    m_w = size(weight,1);
    for i=1:m_w
       w1 = weight(i,:);
       P = ensemble(:,1)*w1(1,1) + ensemble(:,2)*w1(1,2) + ensemble(:,3)*w1(1,3);   %���P�������յ�Ԥ�⡣������Ϊ�����
       Final_Accuracy_with_ensebleL = mean(P == testY) * 100; % Final accuracy      %�����������Ԥ��ľ��ȡ� 
       ACC_w1_all = [ACC_w1_all; Final_Accuracy_with_ensebleL];
     end
   [ACC_svml_tt,indx1] = max(max(ACC_w1_all));
   fprintf('\nproposed with binary+svml Accuracy(train&test): %f\n', ACC_svml_tt);
   tr2 = [tr2;ACC_svml_tt]; 
end

A_final = sum(tr2)/10;
toc
% һЩ����˵����
%����������10��ѭ��֮�¹����ġ�
% i����1-10�� ǰ���85.7143 �������88.0952 �� ƽ��ֵ 86.9048
% S��S��1:3���� ���������ӿռ��
%iter ������ÿһ���ӿռ�ѵ���Ĵ���������Ϊ3 ������ǰ������Ҳ����3�β�������Ҫ�������Ƿ��д��������������Ԥ�����õĴ����ʡ�