% # 不带LDPP it参数寻优的 
% # 更正实验，要判断一下特异度spe 也就是真负类TNR的计算公式   Spe = TN / (FP + TN); 

clc;
clear all  ; 
close all; 
warning('off');

final_eval= {};
mean_final_eval = {};
iter = 1
for C = 1:iter
    [Result] = ProposedH_experiment()
    final_eval{C} =  Result;
end
mean_final_eval.ACC = (final_eval{1}.ACC + final_eval{2}.ACC + final_eval{3}.ACC+final_eval{4}.ACC + final_eval{5}.ACC + final_eval{6}.ACC+final_eval{7}.ACC + final_eval{8}.ACC + final_eval{9}.ACC + final_eval{10}.ACC)/10
mean_final_eval.ACCi = (final_eval{1}.ACCi + final_eval{2}.ACCi + final_eval{3}.ACCi + final_eval{4}.ACCi + final_eval{5}.ACCi + final_eval{6}.ACCi + final_eval{7}.ACCi + final_eval{8}.ACCi + final_eval{9}.ACCi + final_eval{10}.ACCi)/10
mean_final_eval.Pre = (final_eval{1}.Pre + final_eval{2}.Pre + final_eval{3}.Pre + final_eval{4}.Pre + final_eval{5}.Pre + final_eval{6}.Pre + final_eval{7}.Pre + final_eval{8}.Pre + final_eval{9}.Pre + final_eval{10}.Pre)/10
mean_final_eval.Prei = (final_eval{1}.Prei + final_eval{2}.Prei + final_eval{3}.Prei + final_eval{4}.Prei + final_eval{5}.Prei + final_eval{6}.Prei + final_eval{7}.Prei + final_eval{8}.Prei + final_eval{9}.Prei + final_eval{10}.Prei)/10
mean_final_eval.Rec = (final_eval{1}.Rec + final_eval{2}.Rec + final_eval{3}.Rec + final_eval{4}.Rec + final_eval{5}.Rec + final_eval{6}.Rec + final_eval{7}.Rec + final_eval{8}.Rec + final_eval{9}.Rec + final_eval{10}.Rec)/10
mean_final_eval.Reci = (final_eval{1}.Reci + final_eval{2}.Reci + final_eval{3}.Reci + final_eval{4}.Reci + final_eval{5}.Reci + final_eval{6}.Reci + final_eval{7}.Reci + final_eval{8}.Reci + final_eval{9}.Reci + final_eval{10}.Reci)/10

mean_final_eval.Spe = (final_eval{1}.Spe + final_eval{2}.Spe + final_eval{3}.Spe + final_eval{4}.Spe + final_eval{5}.Spe + final_eval{6}.Spe + final_eval{7}.Spe + final_eval{8}.Spe + final_eval{9}.Spe + final_eval{10}.Spe)/10
mean_final_eval.Spei = (final_eval{1}.Spei + final_eval{2}.Spei + final_eval{3}.Spei + final_eval{4}.Spei + final_eval{5}.Spei + final_eval{6}.Spei + final_eval{7}.Spei + final_eval{8}.Spei + final_eval{9}.Spei + final_eval{10}.Spei)/10
mean_final_eval.G_mean = (final_eval{1}.G_mean + final_eval{2}.G_mean + final_eval{3}.G_mean + final_eval{4}.G_mean + final_eval{5}.G_mean + final_eval{6}.G_mean + final_eval{7}.G_mean + final_eval{8}.G_mean + final_eval{9}.G_mean + final_eval{10}.G_mean)/10
mean_final_eval.G_meani = (final_eval{1}.G_meani + final_eval{2}.G_meani + final_eval{3}.G_meani + final_eval{4}.G_meani + final_eval{5}.G_meani + final_eval{6}.G_meani + final_eval{7}.G_meani + final_eval{8}.G_meani + final_eval{9}.G_meani + final_eval{10}.G_meani)/10
mean_final_eval.F1_score = (final_eval{1}.F1_score + final_eval{2}.F1_score + final_eval{3}.F1_score + final_eval{4}.F1_score + final_eval{5}.F1_score+ final_eval{6}.F1_score + final_eval{7}.F1_score + final_eval{8}.F1_score + final_eval{9}.F1_score + final_eval{10}.F1_score)/10
mean_final_eval.F1_scorei = (final_eval{1}.F1_scorei + final_eval{2}.F1_scorei + final_eval{3}.F1_scorei + final_eval{4}.F1_scorei + final_eval{5}.F1_scorei + final_eval{6}.F1_scorei + final_eval{7}.F1_scorei + final_eval{8}.F1_scorei + final_eval{9}.F1_scorei + final_eval{10}.F1_scorei)/10

%% 


function [ ProposedH_result ] = ProposedH_experiment()
clc;clear ;warning('off');
% load('ttraintestdata.mat');%数据集读取
load('PD_LSVTsample');%数据集读取

ACC_w1_all=[];
tr2=[]
TPi = [];
FNi = [];
FPi = [];
TNi = [];
ACCi = [];
Prei = [];
Reci = [];
Spei = [];
G_meani = [];
F1_scorei = [];
Mean_scores = {};    
CMi = {}; 
svml3 = [];
scores = [];
ensemble = [];
ProposedH_result = [];


for i=1:1
    FinalAcc=[];
    ensemble=[];
    for s=1:3
%       load('traintestdata.mat');%数据集读取 ,这里为什么要记加载两个数据集？
        trainX1 = traindataX{1,s}(:,1:end-1);
        trainY1 = traindataX{1,s}(:,end);
%       trainX1=trainX(1:42,:);
%       trainY1=trainY(1:42,1);
        validX = valid_data(:,1:end-1);  
        validY = valid_data(:,end);
        testX = test_data(:,1:end-1);
        testY = test_data(:,end);
       %% 样本标准化部分
       [trainX1, mu, sigma] = featureCentralize(trainX1);%%将样本标准化（服从N(0,1)分布）
       testX = bsxfun(@minus, testX, mu);
       testX = bsxfun(@rdivide, testX, sigma);
       validX = bsxfun(@minus, validX, mu);
       validX = bsxfun(@rdivide, validX, sigma);    
       a=[];
       m = 1;
       p=0;
       % l=1;
       tic
       iter=3; % number of iterations
%        Models=cell(iter,1); % For saving the models from each iteration 
       Us=cell(iter,1); % For saving the Us from each iteration
%        Trainingdata=cell(iter,1); % For saving the training data from each iteration to calculate the corresponding Alpha
       % while (m>0.0001)
       for z = 1:iter
           % [fea,U,model,indx,misX,misY] = adbstLDPP(trainX,trainY,testX,testY,type_num);
            %该语句中返回最好的fea,返回最好的model，返回最好的U.最好的U 肯定是维度比较低的
           [fea,U,model,indx,misX,misY] = ProposedH_adbstLDPP(trainX1,trainY1,validX,validY,type_num);
           Us{z}=U;
           feature{z,1}=fea; % Saving the features for each iteration
           Trainingdata{z,1} = [trainX1 trainY1]; % combining training data with its labels. Since in each iteration training data will be changed, we need to save corresponding labels
           Medels{z,1}=model;
           trainX1 = [misX;trainX1]; % combining the training data with miss classified samples
           trainY1 = [misY;trainY1];% combining the training lebels with miss classified labels
           for i = 1:size (misY)
               b = corr(misX(:,i),misY); % Finding the error. however result id NaN because miss classified samples belong to single class.
               a = [a b];
           end
        % m1=(sum(a))/size (misY,1);
        % p=[p m1];
        % m =[m abs(p(1,z)-p(1,z+1))];
        % a=[];
        % l=l+1;
        falgA = double(isempty(misX));
        if  falgA 
            break
        end
       end

       % Finding Alpha
       alpha=FInd_Alpha(Trainingdata); % finding the alpha for training data of each iteration
       % alpha(1)=0.5;
       % Test process
       svml8 = [];
       svm_prede=[]
       %测试集合进行测试模型,得出预测的结果
      
       
       for i=1:size(Trainingdata)
           test1=testX*(Us{i}); % Coressponding U
           mod1=Medels{i}% Corresponding model
           fea=feature{i};% Coressponding Feature
           test1=test1(:,fea);
           svm_pred1 = svmpredict(testY,test1,mod1);
              %% rf shihou huan
%            [svm_pred1,votes] = classRF_predict(test1,mod1)
           [ind]=find(svm_pred1==2); % Because Sgn function works with labels -1 and 1 so here I changed all my labels from 2 to -1 to make it possible(1,-1) before saving
           svm_pred1(ind,1)=-1;
           svm_pred1=svm_pred1*alpha(i); % Multiplication of alpha with corresponding prediction
           svm_prede=[svm_prede svm_pred1];
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

      %% Prediction  预测精度计算
       [ind] = find(testY==2); % Changing labels having value 2 to -1 for calculation of accuracy
       testY(ind,1) = -1;      %把testY中为-2的改为-1.
       Final_predict=sum(svm_prede,2);
       Result=sign(Final_predict);
       Final_Accuracy_with_Adaboost = mean(Result == testY) * 100; % Final accuracy
       ensemble=[ensemble Result];
       FinalAcc=[FinalAcc Final_Accuracy_with_Adaboost];
       
       %% 每一个子空间的评价指标
       Y_unique = unique(testY);
       %把每一个子空间的混淆矩阵都保存下来
       CMi{s} = zeros(size(Y_unique,1),size(Y_unique,1));
       for n = 1:2
           in = find(testY == Y_unique(n,1)); %找出实际标签为某一类标签的位置。
           Y_pred = Result(in,1);
           CMi{s}(n,1) = size(find(Y_pred == Y_unique(1,1)),1)%找到预测标签和真实标签相等的数量
           CMi{s}(n,2) = size(find(Y_pred == Y_unique(2,1)),1)%找到预测标签和真实标签不相等的数量
       end
       % 把每一个子空间的混淆矩阵具体值记录下来
       TPi(s,:) = CMi{s}(1,1);
       FNi(s,:) = CMi{s}(1,2);
       FPi(s,:) = CMi{s}(2,1);
       TNi(s,:) = CMi{s}(2,2);
       %把每一个子空间的评价指标值记录下来
       ACCi(s,:) = (TPi(s,:) + TNi(s,:)) / (TPi(s,:) + TNi(s,:) + FPi(s,:) + FNi(s,:));
       Prei(s,:) = TPi(s,:) / (TPi(s,:) + FPi(s,:));
       Reci(s,:) = TPi(s,:) / (TPi(s,:) + FNi(s,:));
       Spei(s,:) = TNi(s,:) / (FPi(s,:) + TNi(s,:)); %# 检查spe公式
       G_meani(s,:) = sqrt(Reci(s,:) * Spei(s,:));
       F1_scorei(s,:) = (2 * Prei(s,:) * Reci(s,:)) / (Prei(s,:) + Reci(s,:))
       
       
       clear Trainingdata
    end
   load 'weight'%加载网格搜索法权重 
   m_w = size(weight,1);     %网格搜索方法找寻最佳权重
   for i = 1:m_w
       w1 = weight(i,:);
       P = sign(ensemble(:,1) * w1(1,1)+ ensemble(:,2) * w1(1,2) + ensemble(:,3) * w1(1,3));
       Final_Accuracy_with_ensebleL = mean(P == testY) * 100; % Final accuracy
       ACC_w1_all = [ACC_w1_all; Final_Accuracy_with_ensebleL];
   end
   %% 评价指标相关代码
   ACC_svml_tt = max(ACC_w1_all);
   [indx] = find(ACC_w1_all== max(max(ACC_w1_all)));
   best_weight = weight(indx,:);
   %% best_P是最好的预测吧，利用预测计算混淆矩阵。
   best_Pred = ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3);
%   best_Pred = sign(ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3));
  
   %%
   % 下面是一个通用的建立混淆矩阵的代码,并计算几个评价指标的代码
   % best_Pred 是预测标签，testY是真实标签。到了这一步之后，预测标签和真实标签都为1和-1，原本的2都转为-1了。
   Y_unique = unique(testY);
   CM = zeros(size(Y_unique,1),size(Y_unique,1));
   for i = 1:2
       in = find(testY == Y_unique(i,1)); %找出实际标签为某一类标签的位置。
       Y_pred =  best_Pred(in,1);
       CM(i,1) = size(find(Y_pred == Y_unique(1,1)),1);%找到预测标签和真实标签相等的数量
       CM(i,2) = size(find(Y_pred == Y_unique(2,1)),1);%找到预测标签和真实标签不相等的数量
   end
   %下面语句为非必需的，只有在不满足原始混淆矩阵的形式时才使用。
   CM1 = zeros(2,2);
   CM1(1,1) = CM(2,2);
   CM1(1,2) = CM(2,1);
   CM1(2,1) = CM(1,2);
   CM1(2,2) = CM(1,1);
   TP = CM1(1,1);
   FN = CM1(1,2);
   FP = CM1(2,1);
   TN = CM1(2,2);
   %下面写评价指标
   ACC = (TP+TN) / (TP + TN + FP + FN);
   Pre = TP / (TP + FP);
   Rec = TP / (TP + FN);     %# 检查spe公式
   Spe = TN / (FP + TN);    % 真负类，就是TNR 也是特异度SPE计算公式 为 TN / (FP + TN)
   G_mean = sqrt(Rec * Spe);
    F1_score_Final = (2 * Pre * Rec) / (Pre + Rec);
   %%
   fprintf('\nproposed with binary+svml Accuracy(train&test): %f\n', ACC_svml_tt);
   tr2=[tr2;ACC_svml_tt];   
   ProposedH_result.ACC = ACC;   
   ProposedH_result.ACCi = ACCi; 
   
   
   ProposedH_result.Pre = Pre;
   ProposedH_result.Prei = Prei; 
   ProposedH_result.Rec = Rec; 
   ProposedH_result.Reci = Reci; 
   ProposedH_result.Spe = Spe; 
   ProposedH_result.Spei = Spei;
  ProposedH_result.G_mean = G_mean; 
   ProposedH_result.G_meani = G_meani; 
   ProposedH_result.F1_score_Final = F1_score_Final; 
   ProposedH_result.F1_scorei = F1_scorei; 
end
toc
end


function [f,U1,mode2,indx,missed_samples,missed_labels]= ProposedH_adbstLDPP(trainx,trainy,validx,validy,type_num)

kk=1;
mukgamma=[];
mean_svml8_max=0;
for igamma=1:9
    for imu=1:9
        method = [];
        method.mode = 'ldpp_u';
        method.mu = 0.00001*power(10,imu);
        method.gamma = 0.00001*power(10,igamma);
        method.M = 200;
        method.labda2 = 0.001;   %取[0.0001,0.001,...,1000,10000]
        method.ratio_b = 0.9;    %有时候不是很明白这个参数的含义
        method.ratio_w = 0.9;
        
        method.weightmode = 'heatkernel'; %在这里可以更改模式
        method.knn_k = 5;
        svml8 = [];
        U = featureExtract2(trainx,trainy,method,type_num); %使用之前的方法提取出来映射矩阵U
           for ik = 1:floor(size(trainx,2)/1)
                method.K = kk * ik;
                mukgamma = [mukgamma;[imu ik igamma]];    
                trainZ1 = projectData(trainx, U, method.K);
                testZ = projectData(validx, U, method.K);
                
%                 % SVM高斯 
%                 model = svmtrain(trainy,trainZ1,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
%                 svm_pred = svmpredict(validy,testZ,model);  % 这里的testZ还是valid
%                 svml8(ik)=  mean(svm_pred == validy) * 100;
%            
              
                %SVM 线性
                model = svmtrain(trainy,trainZ1,'-s 0 -t 0'); %%使用所有变换后的训练集训练模型
                svm_pred = svmpredict(validy,testZ,model);  % 这里的testZ还是valid
               svml8(ik)= mean(svm_pred == validy) * 100;
           
%                 
                % RF随机森林               
%                 model = classRF_train(trainZ1,trainy,'ntree',300)
%                 [svm_pred,votes] = classRF_predict(testZ,model)
%                  svml8(ik)=  mean(svm_pred == validy) * 100;
%                 
                     %  ELM         
%                  [~, ~, ~, TestingAccuracy,svm_pred] = ELM([trainy trainZ1], [validy testZ], 1, 5000, 'sig', 10^2);
           end
            
               [acc_svml_max,indx2] = max(svml8);
               Accuracy(igamma,imu) = acc_svml_max;
%                best_svml_kk = kk * indx2; 
                best_svml_kk =  kk * indx2;
               bestK(igamma,imu) = best_svml_kk;
    end
end
        [loc_x,loc_y] = find(Accuracy == max(max(Accuracy)));%找到最大值的位置
        mean_svml8_max = max(max(Accuracy));
%       U_svml_best=U1_all;
        best_svml_kk = bestK(loc_x(1),loc_y(1));
        method.mu = 0.00001 * power(10,loc_y(1));%取[0.0001,0.001,...,1000,10000]
        method.gamma = 0.00001 * power(10,loc_x(1));

       %% 上面代码找出最好的U矩阵参数存放在 method中通
        U = featureExtract2(trainx,trainy,method,type_num);  %使用找到的最好的U矩阵参数method得出最优参数对应的U矩阵
        U1 = U(:,1:best_svml_kk);
        trainZ1 = trainx * U(:,1:best_svml_kk);  %使用最好的U矩阵进行变换
%         trainZ1 = projectData(trainx, U, best_svml_kk);
        testZ = validx * U(:,1:best_svml_kk);
%         testZ = projectData(validx, U, best_svml_kk);
        
        %% 使用relief特征选择算法
         [fea] = relieff(trainZ1,trainy, 5);    
         svml2 = [];
         % 下面代码 依次增加特征列数进行训练并预测精度  
          for ik = 1:floor(size(trainZ1,2)/1) 
            K = kk * ik;  
            trainZ = trainZ1(:,fea(:,1:K));
            test = testZ(:,fea(:,1:K));
            
            % SVM高斯 
              
%              model = svmtrain(trainy,trainZ,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
%              svm_pred = svmpredict(validy,test,model);
%             svml2 = [svml2 mean(svm_pred == validy) * 100;];
             

              % SVM 线性
             model = svmtrain(trainy,trainZ,'-s 0 -t 0');%%使用所有变换后的训练集训练模型
             svm_pred = svmpredict(validy,test,model);
                svml2 = [svml2 mean(svm_pred == validy) * 100;];
                
                % RF随机森林
%               model = classRF_train(trainZ,trainy,'ntree',300)
%              [svm_pred,votes] = classRF_predict(test,model)
%               svml2 = [svml2 mean(svm_pred == validy) * 100;];
%                 
                

           
        end
       % 下面代码 选择出最优的特征 （大思路是先进性特征提取，在进行特征选择，没有玩样本，单纯的特征操作）
        [acc_svml_max,indx2] = max(svml2);
        best_svml_kk = kk * indx2;

        
      
       %% 把选出来的最优特征列数 应用到LDPP特征映射后的数据库
        f = fea(:,1:best_svml_kk);
        train = trainZ1(:,f);
        test = testZ(:,f);
               
      %% 使用所有变换后的训练集训练模型并预测
%       svml3 = [];
      % SVM 高斯 
%        mode2 = svmtrain(trainy,train,'-s 0 -t 2'); 
%        svm_pred = svmpredict(validy,test,mode2);
% %        
       % SVM 线性 
       mode2 = svmtrain(trainy,train,'-s 0 -t 0'); 
       svm_pred = svmpredict(validy,test,mode2);
%      
       % RF 
%      mode2 = classRF_train(train,trainy,'ntree',300)
%      [svm_pred,votes] = classRF_predict(test,mode2)
%        

    
     %% 找出错分的样本保存起来，返回到主函数
       [indx,val] = find(0 == ( svm_pred == validy));    %Finding miss classified samples
       missed_samples = validx(indx,:);
       missed_labels = validy(indx,:);
end

