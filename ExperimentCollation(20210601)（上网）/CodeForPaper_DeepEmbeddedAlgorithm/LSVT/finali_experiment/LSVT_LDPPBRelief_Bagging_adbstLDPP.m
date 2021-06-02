function [f,U1,mode2,indx,missed_samples,missed_labels] = LSVT_LDPPBRelief_Bagging_adbstLDPP(trainX,trainY,validX,validY,type_num)
kk=5;
mukgamma=[];
mean_svml8_max=0;
for igamma=1:9
    for imu=1:9
        method = [];
        method.mode = 'ldpp_u';
        method.mu=0.00001*power(10,imu);
        method.gamma=0.00001*power(10,igamma);  
        method.M = 200;
        method.labda2 = 0.001;%ȡ[0.0001,0.001,...,1000,10000]
        method.ratio_b = 0.9;
        method.ratio_w = 0.9;
        method.weightmode = 'binary';
        method.knn_k = 5;
        svml8 = [];
        
%             trainX = train_data_all(:,1:end);
%             testX=test_data(:,1:end);
%             trainY=train_label_all;
%           %% �������������
%             train_cqX = traindataX{iter,i}(:,1:end-1);
%             train_cqY = traindataX{iter,i}(:,end);
% %             testX = test_data(:,1:end-1)
% %             testY = test_data(:,end)
%             validX = valid_data(:,1:end-1)
%             validY = valid_data(:,end)
%             [train_cqX, mu, sigma] = featureCentralize(train_cqX)
% %             testX = bsxfun(@minus, testX, mu);
% %             testX = bsxfun(@rdivide, testX, sigma);%%������ѵ��������׼��
%             validX = bsxfun(@minus, validX, mu);
%             validX = bsxfun(@rdivide, validX, sigma);
            U = featureExtract2(trainX,trainY,method,type_num);
%             U1_all{1,s} = U;
            for ik = 1:floor(size(trainX,2)/5)
                method.K = kk * ik;
                mukgamma=[mukgamma;[imu ik igamma]];    
                trainZ=projectData(trainX, U, method.K);
                validZ = projectData(validX, U, method.K);
       
                % SVM ��˹ 
%                 model = svmtrain(trainY,trainZ,'-s 0 -t 2');
%                  svm_pred1 = svmpredict(validY,validZ,model);
%                 svml8(ik) = mean(svm_pred1 == validY) * 100;
                %% RF 
%             model = classRF_train(trainZ,trainY,'ntree',300)
%             [svm_pred1,votes] = classRF_predict(validZ,model)
%             svml8(ik) = mean(svm_pred1 == validY) * 100
    
            %% SVM����  
                model = svmtrain(trainY,trainZ,'-s 0 -t 0');%%ʹ�����б任���ѵ����ѵ��ģ��
                svm_pred1 = svmpredict(validY,validZ,model);
                svml8(ik) = mean(svm_pred1 == validY) * 100;
            end
        end
%         U1=(U1_all{1,1}+U1_all{1,2}+U1_all{1,3})/3;
        [loc_x,loc_y] = find(svml8==max(max(svml8)));%�ҵ����ֵ��λ��
%         [loc_x,loc_y]=max(mean(svml8));%�ҵ����ֵ��λ��
        if  max(max(svml8))>mean_svml8_max
            mean_svml8_max=max(max(svml8));
% %             U_svml_best=U1_all;
            best_svml_kk = kk*loc_y(1,1);
            best_svml_mu = 0.00001*power(10,imu);%ȡ[0.0001,0.001,...,1000,10000]
            best_svml_gamma = 0.00001*power(10,igamma);
        end
    end

method.mu = best_svml_mu;
method.gamma = best_svml_gamma;
method.K = best_svml_kk;
U = featureExtract2(trainX,trainY,method,type_num);
trainZ1 = projectData(trainX, U, method.K);
validZ1 = projectData(validX, U, method.K);
% relief
[fea] = relieff(trainZ1,trainY, 5)
svml7 = [];
for p = 1:floor(size(trainZ1,2)/5) %  size(train,2) ����train���������
  K = kk * p ;
    trainZ2 = trainZ1(:,fea(:,1:K));   %�����к����������ѡ��Ȩ�ؽϴ����������ʵ�飬����ѡ���������顣
    validZ2 = validZ1(:,fea(:,1:K)); 
    %�������� ���ݼ�������LDPP ����ʹ��relief. ��LDPP�任�������������ڽ�������ѡ��
    %% SVM ����
    model = svmtrain(trainY,trainZ2,'-s 0 -t 0');
    svm_pred2 = svmpredict(validY,validZ2,model);
    svml7(p) = mean(svm_pred2 == validY) * 100 ;
%     
  %% SVM ��˹
%         model = svmtrain(trainY,trainZ2,'-s 0 -t 2');
%         svm_pred2 = svmpredict(validY,validZ2,model);
%        svml7(p) = mean(svm_pred2 == validY) * 100 ;
    %% RF
%         model = classRF_train(trainZ2,trainY,'ntree',300)
%         [svm_pred2,votes] = classRF_predict(validZ2,model)
%        svml7(p) = mean(svm_pred2 == validY) * 100 
        
    
 end

[ACClr_max,index] = max( svml7);
best_fea = fea(:,1:index);
%% ���Ҵ������
trainZ2 = trainZ1(:,best_fea);;   %�����к����������ѡ��Ȩ�ؽϴ����������ʵ�飬����ѡ���������顣
validZ2 = validZ1(:,best_fea);;
% ѵ��
%svm ����
model2 = svmtrain(trainY,trainZ2,'-s 0 -t 0');
svm_pred3 = svmpredict(validY,validZ2,model2);

% SVM ��˹
% model2 = svmtrain(trainY,trainZ2,'-s 0 -t 2');
% svm_pred3 = svmpredict(validY,validZ2,model2);

% rf
%  model2 = classRF_train(trainZ2,trainY,'ntree',300)
%  [svm_pred3,votes] = classRF_predict(validZ2,model2)
 
 % �ҳ�ÿһ��ѵ�����Ժ�Ĵ������
[indx,val] = find(0 == (svm_pred3 == validY));    %Finding miss classified samples
missed_samples = validX(indx,:);
missed_labels = validY(indx,:);
f = best_fea;
U1 = U;
mode2 = model2;
end