% function [f,U1,mode2,indx,missed_samples,missed_labels] = LSVTProposed_adbstLDPP_H_RF(trainx,trainy,validx,validy,type_num)
% 
% kk = 2;
% mukgamma=[];
% mean_svml8_max=0;
% for igamma=1:9
%     for imu=1:9
%         method = [];
%         method.mode = 'ldpp_u';
%         method.mu = 0.00001*power(10,imu);
%         method.gamma = 0.00001*power(10,igamma);
%         method.M = 200;
%         method.labda2 = 0.001;   %取[0.0001,0.001,...,1000,10000]
%         method.ratio_b = 0.9;    %有时候不是很明白这个参数的含义
%         method.ratio_w = 0.9;
%         method.weightmode = 'heatkernel';
% %         method.weightmode = 'heatkernel'; %在这里可以更改模式
%         method.knn_k = 5;
%         U = featureExtract2(trainx,trainy,method,type_num); %使用之前的方法提取出来映射矩阵U
%            for ik = 1:floor(size(trainx,2)/2)
%                 method.K = kk*ik;
%                 mukgamma = [mukgamma;[imu ik igamma]];    
%                 trainZ1 = projectData(trainx, U, method.K);
%                 testZ = projectData(validx, U, method.K);
%                 
% %                 % SVM高斯 
% %                 model = svmtrain(trainy,trainZ1,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
% %                 svm_pred = svmpredict(validy,testZ,model);  % 这里的testZ还是valid
% %                 svml8(ik)= mean(svm_pred == validy) * 100;
% 
%                 %SVM 线性
% %                 model = svmtrain(trainy,trainZ1,'-s 0 -t 0'); %%使用所有变换后的训练集训练模型
% %                 svm_pred = svmpredict(validy,testZ,model);  % 这里的testZ还是valid
% %                 svml8(ik)= mean(svm_pred == validy) * 100;
%                 
%                 % RF随机森林               
%                 model = classRF_train(trainZ1,trainy,'ntree',300)
%                 [svm_pred,votes] = classRF_predict(testZ,model)
%                 svml8(ik) = mean(svm_pred == validy) * 100
%                 
%                      %  ELM         
% %                  [~, ~, ~, TestingAccuracy,svm_pred] = ELM([trainy trainZ1], [validy testZ], 1, 5000, 'sig', 10^2);
%            end
%             
%                [acc_svml_max,indx2] = max(svml8);
%                Accuracy(igamma,imu) = acc_svml_max;
%                best_svml_kk = kk * indx2; 
%                bestK(igamma,imu) = best_svml_kk;
%     end
% end
%         [loc_x,loc_y] = find(Accuracy==max(max(Accuracy)));%找到最大值的位置
%         mean_svml8_max = max(max(Accuracy));
% %       U_svml_best=U1_all;
%         best_svml_kk = bestK(loc_x(1),loc_y(1));
%         method.mu = 0.00001 * power(10,loc_y(1));%取[0.0001,0.001,...,1000,10000]
%         method.gamma = 0.00001 * power(10,loc_x(1));
%         
%        %% 上面代码找出最好的U矩阵参数存放在 method中通
%         U = featureExtract2(trainx,trainy,method,type_num);  %使用找到的最好的U矩阵参数method得出最优参数对应的U矩阵
%         U1 = U(:,1:best_svml_kk);
%         trainZ1 = trainx * U(:,1:best_svml_kk);  %使用最好的U矩阵进行变换
%         testZ = validx * U(:,1:best_svml_kk);
%         
%         %% 使用relief特征选择算法
%          [fea] = relieff(trainZ1,trainy, 5);
% %          kk = 5;
%          svml2 = [];
%          % 下面代码 依次增加特征列数进行训练并预测精度  
%         for ik=1:floor(size(trainZ1,2)/2 )
%             K = kk * ik;  
%             trainZ = trainZ1(:,fea(:,1:K));
%             test = testZ(:,fea(:,1:K));
%             
%             % SVM高斯 
%               
% %              model = svmtrain(trainy,trainZ,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
% %              svm_pred = svmpredict(validy,test,model);
% %              svml2 = [svml2 mean(svm_pred == validy) * 100;]; 
%              
% 
%               % SVM 线性
% %              model = svmtrain(trainy,trainZ,'-s 0 -t 0');%%使用所有变换后的训练集训练模型
% %              svm_pred = svmpredict(validy,test,model);
% %              svml2 = [svml2 mean(svm_pred == validy) * 100;];
% %                 
%                 % RF随机森林
%               model = classRF_train(trainZ,trainy,'ntree',300)
%              [svm_pred,votes] = classRF_predict(test,model)
%                svml2 = [svml2 mean(svm_pred == validy) * 100;]; 
% %                 
%                 
% 
%            
%         end
%        % 下面代码 选择出最优的特征 （大思路是先进性特征提取，在进行特征选择，没有玩样本，单纯的特征操作）
%         [acc_svml_max,indx2] = max(svml2);
%         best_svml_kk = kk * indx2;
%         
%       
%        %% 把选出来的最优特征列数 应用到LDPP特征映射后的数据库
%         f=fea(:,1:best_svml_kk);
%         train = trainZ1(:,f);
%         test = testZ(:,f);
%                
%       %% 使用所有变换后的训练集训练模型并预测
%       
%       % SVM 高斯 
% %        mode2 = svmtrain(trainy,train,'-s 0 -t 2'); 
% %        svm_pred = svmpredict(validy,test,mode2);
% 
%        % SVM 线性 
% %        mode2 = svmtrain(trainy,train,'-s 0 -t 0'); 
% %        svm_pred = svmpredict(validy,test,mode2);
%      
%        % RF 
%      mode2 = classRF_train(train,trainy,'ntree',300)
%      [svm_pred,votes] = classRF_predict(test,mode2)
%        
% 
%     
%       %% 找出错分的样本保存起来，返回到主函数
%        [indx,val]=find(0==(svm_pred==validy));    %Finding miss classified samples
%        missed_samples = validx(indx,:);
%        missed_labels = validy(indx,:);
%        
%        
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [f,U1,mode2,indx,missed_samples,missed_labels] = LSVTProposed_adbstLDPP_H_RF(trainx,trainy,validx,validy,type_num)

kk = 2;
mukgamma=[];
mean_svml8_max=0;
for it = 1:9
for igamma=1:9
    for imu=1:9
        method = [];
        method.mode = 'ldpp_u';
        method.mu = 0.00001*power(10,imu);
        method.gamma = 0.00001*power(10,igamma);
        method.t   =  0.00001 * power(10,it); 
        method.M = 200;
        method.labda2 = 0.001;   %取[0.0001,0.001,...,1000,10000]
        method.ratio_b = 0.9;    %有时候不是很明白这个参数的含义
        method.ratio_w = 0.9;
        method.weightmode = 'heatkernel';
        method.knn_k = 5;
        U = featureExtract2(trainx,trainy,method,type_num); %使用之前的方法提取出来映射矩阵U
           for ik = 1:floor(size(trainx,2)/2)
                method.K = kk*ik;
                mukgamma = [mukgamma;[imu ik igamma]];    
                trainZ = projectData(trainx, U, method.K);
                testZ = projectData(validx, U, method.K);
                
%                 % SVM高斯 
%                 model = svmtrain(trainy,trainZ1,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
%                 svm_pred = svmpredict(validy,testZ,model);  % 这里的testZ还是valid
%                 svml8(ik)= mean(svm_pred == validy) * 100;

                %SVM 线性
%                 model = svmtrain(trainy,trainZ1,'-s 0 -t 0'); %%使用所有变换后的训练集训练模型
%                 svm_pred = svmpredict(validy,testZ,model);  % 这里的testZ还是valid
%                 svml8(ik)= mean(svm_pred == validy) * 100;
                
                % RF随机森林               
                model = classRF_train(trainZ,trainy,'ntree',300)
                [svm_pred,votes] = classRF_predict(testZ,model)
                svml8(ik) = mean(svm_pred == validy) * 100
                
                     %  ELM         
%                  [~, ~, ~, TestingAccuracy,svm_pred] = ELM([trainy trainZ1], [validy testZ], 1, 5000, 'sig', 10^2);
           end
            
          
            [loc_x,loc_y] = find(svml8==max(max(svml8)));%找到最大值的位置
%         [loc_x,loc_y]=max(mean(svml8));%找到最大值的位置
        if  max(max(svml8))>mean_svml8_max
            mean_svml8_max=max(max(svml8));
% %             U_svml_best=U1_all;
            best_svml_kk = kk*loc_y(1,1);
            best_svml_mu = 0.00001*power(10,imu);%取[0.0001,0.001,...,1000,10000]
            best_svml_gamma = 0.00001*power(10,igamma);
            best_svml_t = 0.00001 * power(10,it); 
        end
     end
  end
end
          
        method.t = best_svml_t
        method.mu = best_svml_mu;%取[0.0001,0.001,...,1000,10000]
        method.gamma =  best_svml_gamma ;
        
       %% 上面代码找出最好的U矩阵参数存放在 method中通
        U = featureExtract2(trainx,trainy,method,type_num);  %使用找到的最好的U矩阵参数method得出最优参数对应的U矩阵
        U1 = U(:,1:best_svml_kk);
        trainZ1 = trainx * U(:,1:best_svml_kk);  %使用最好的U矩阵进行变换
        testZ1 = validx * U(:,1:best_svml_kk);
        
        %% 使用relief特征选择算法
         [fea] = relieff(trainZ1,trainy, 5);
%          kk = 5;
         svml2 = [];
         % 下面代码 依次增加特征列数进行训练并预测精度  
        for ik=1:floor(size(trainZ1,2)/2) 
              K = kk * ik;  
             trainZ2 = trainZ1(:,fea(:,1:K));
             testZ2 = testZ1(:,fea(:,1:K));
            
            % SVM高斯 
              
%              model = svmtrain(trainy,trainZ,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
%              svm_pred = svmpredict(validy,test,model);
%              svml2 = [svml2 mean(svm_pred == validy) * 100;]; 
             

              % SVM 线性
%              model = svmtrain(trainy,trainZ,'-s 0 -t 0');%%使用所有变换后的训练集训练模型
%              svm_pred = svmpredict(validy,test,model);
%              svml2 = [svml2 mean(svm_pred == validy) * 100;];
                
                % RF随机森林
              model = classRF_train(trainZ2,trainy,'ntree',300)
             [svm_pred,votes] = classRF_predict(testZ2,model)
            svml2 = [svml2 mean(svm_pred == validy) * 100;];
                

        end
       % 下面代码 选择出最优的特征 （大思路是先进性特征提取，在进行特征选择，没有玩样本，单纯的特征操作）
        [acc_svml_max,indx2] = max(svml2);
        best_svml_kk = kk * indx2;
        
      
       %% 把选出来的最优特征列数 应用到LDPP特征映射后的数据库
        f=fea(:,1:best_svml_kk);
        train = trainZ1(:,f);
        test = testZ1(:,f);
               
      %% 使用所有变换后的训练集训练模型并预测
      
      % SVM 高斯 
%        mode2 = svmtrain(trainy,train,'-s 0 -t 2'); 
%        svm_pred = svmpredict(validy,test,mode2);

       % SVM 线性 
%        mode2 = svmtrain(trainy,train,'-s 0 -t 0'); 
%        svm_pred = svmpredict(validy,test,mode2);
%      
       % RF 
     mode2 = classRF_train(train,trainy,'ntree',300)
     [svm_pred,votes] = classRF_predict(test,mode2)
       

    
      %% 找出错分的样本保存起来，返回到主函数
       [indx,val]=find(0==(svm_pred==validy));    %Finding miss classified samples
       missed_samples = validx(indx,:);
       missed_labels = validy(indx,:);
       
       
end