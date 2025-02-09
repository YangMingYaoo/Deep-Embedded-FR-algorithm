%% 
clc;clear ;warning('off');
tic
final_eval= {};
mean_final_eval = {};
iter = 2
for C = 1:iter
    [MaxLittlerProposed_H_experiment1_s2] = ldpp()
    final_eval{C} = MaxLittlerProposed_H_experiment1_s2;
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
toc
%% 

% function [LDPP_Result] = ldpp()
%         % 记住RF时不返回AUC
%         clear all;close all ;clc;
%          %% 加载数据集 
%         load('maxlittle_sample4_06');%数据集读取
%          ACC_w1_all=[];
%          tr2=[];
%          Evaluation_index_i = [];
%          TPi = [];
%          FNi = [];
%          FPi = [];
%          TNi = [];
%          ACCi = [];
%          Prei = [];
%          Reci = [];
%          Spei = [];
%          G_meani = [];
%          F1_scorei = [];
%          Mean_scores = {};    
%          CMi = {}; 
%          AUCi = {};
%          svml3 = [];
%          scores = [];
%          ensemble = [];
%          LDPP_Result = [];
%       
%         for s = 1:3 
%            %% 数据集处理部分
%            % 拆分数据和标签
%            trainX = traindataX{1,s}(:,2:end-1);
%            trainY = traindataX{1,s}(:,end);
%            validX = valid_data(:,2:end-1);  
%            validY = valid_data(:,end);
%            testX = test_data(:,2:end-1);
%            testY = test_data(:,end);
% %            trainX0 = [trainX; validX];
% %            trainY0 = [ trainY;validY];
%            %% 样本标准化部分
%            % 下面给数据加1，想要区别与原始数据，可以把原始数据保留
%            [trainX, mu, sigma] = featureCentralize(trainX);%%将样本标准化（服从N(0,1)分布）
%            testX = bsxfun(@minus, testX, mu);
%            testX = bsxfun(@rdivide, testX, sigma);
% %            trainX1 = trainX0(1:size(trainX,1),:);
% %            trainY = trainY0(1:size(trainX,1),:);
% %            validX1 = trainX0(size(trainX,1)+1:size(trainX0,1),:)
% %            validY = trainY0(size(trainX,1)+1:size(trainX0,1),:)
%            validX = bsxfun(@minus, validX, mu);
%            validX = bsxfun(@rdivide, validX, sigma);  
%        %%    LDPP 
% 
%         kk=4;
%         mukgamma=[];
%         mean_svml8_max = 0;
%         for igamma=1:9
%             for imu=1:9
%                 method = [];
%                 method.mode = 'ldpp_u';
%                 method.mu = 0.00001 * power(10,imu);
%                 method.gamma = 0.00001 * power(10,igamma);
%                 method.M = 200;
%                 method.labda2 = 0.001;   %取[0.0001,0.001,...,1000,10000]
%                 method.ratio_b = 0.9;    %有时候不是很明白这个参数的含义
%                 method.ratio_w = 0.9;
% %                 method.weightmode = 'binary';
%                 method.weightmode = 'heatkernel'; %在这里可以更改模式
%                 method.knn_k = 5;
%                 U = featureExtract2(trainX,trainY,method,type_num); %使用之前的方法提取出来映射矩阵U
%                    for ik = 1:floor(size(trainX,2)/4)
%                         method.K = kk*ik;
%                         mukgamma = [mukgamma;[imu ik igamma]];    
%                         trainZ = projectData(trainX, U, method.K);
%                         validZ = projectData(validX, U, method.K);
% 
%         %                 % SVM高斯 
%                         model = svmtrain(trainY,trainZ,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
%                         svm_pred = svmpredict(validY,validZ,model);  % 这里的testZ还是valid
%                        svml8(ik) = calculateAccuracy(valid_data,validY,svm_pred);
% 
%                         %SVM 线性
% %                         model = svmtrain(trainY,trainZ,'-s 0 -t 0'); %%使用所有变换后的训练集训练模型
% %                         svm_pred = svmpredict(validY,validZ,model);  % 这里的testZ还是valid
% %                         svml8(ik) = calculateAccuracy(valid_data,validY,svm_pred);
% 
%                         % RF随机森林               
% %                         model = classRF_train(trainZ,trainY,'ntree',300)
% %                         [svm_pred,votes] = classRF_predict(validZ,model)
% %                         svml8(ik) = calculateAccuracy(valid_data,validY,svm_pred);
%                              %  ELM         
%         %                  [~, ~, ~, TestingAccuracy,svm_pred] = ELM([trainy trainZ1], [validy testZ], 1, 5000, 'sig', 10^2);
%                    end
% 
%                        [acc_svml_max,indx2] = max(svml8);
%                        Accuracy(igamma,imu) = acc_svml_max;
%                        best_svml_kk = kk * indx2; 
%                        bestK(igamma,imu) = best_svml_kk;
%             end
%         end
% 
%                 [loc_x,loc_y] = find(Accuracy==max(max(Accuracy)));%找到最大值的位置
%                 mean_svml8_max = max(max(Accuracy));
%         %       U_svml_best=U1_all;
%                 best_svml_kk = bestK(loc_x(1),loc_y(1));
%                 method.mu = 0.00001 * power(10,loc_y(1));%取[0.0001,0.001,...,1000,10000]
%                 method.gamma = 0.00001 * power(10,loc_x(1));
%                 
%                %% 上面代码找出最好的U矩阵参数存放在 method中通
%                 U = featureExtract2(trainX,trainY,method,type_num);  %使用找到的最好的U矩阵参数method得出最优参数对应的U矩阵
%                 U1 = U(:,1:best_svml_kk);
%                 trainZ1 = trainX * U(:,1:best_svml_kk);  %使用最好的U矩阵进行变换
%                 testZ1 = testX * U(:,1:best_svml_kk);
%                 svml2 = [];
%                 %% 使用test进行验证
%                  % SVM高斯 
% 
%                      model = svmtrain(trainY,trainZ1,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
%                      svm_pred1 = svmpredict(testY,testZ1,model);
%                       svml2 = [svml2 calculateAccuracy(test_data,testY,svm_pred1);];
% 
% 
%                       % SVM 线性
% %                      model = svmtrain(trainY,trainZ1,'-s 0 -t 0');%%使用所有变换后的训练集训练模型
% %                      svm_pred1 = svmpredict(testY,testZ1,model);
% %                       svml2 = [svml2 calculateAccuracy(test_data,testY,svm_pred1);];
%            
%                         % RF随机森林
% %                       model = classRF_train(trainZ1,trainY,'ntree',300)
% %                      [svm_pred1,votes] = classRF_predict(testZ1,model)
% %                        svml2 = [svml2 calculateAccuracy(test_data,testY,svm_pred1);];
% 
% 
% 
%        %% 每一个子空间的模型评价指标
%        % 因为后面程序按照标签为[-1,1]写的，所以这里把2变成-1.
%         [ind] = find(svm_pred1 == 2); % Because Sgn function works with labels -1 and 1 so here I changed all my labels from 2 to -1 to make it possible(1,-1) before saving
%         svm_pred1(ind,1) = -1;
%         % 把每一个子空间的预测保存下来
%         ensemble = [ensemble svm_pred1];
%         
%         [ind] = find(testY==2); % Changing labels having value 2 to -1 for calculation of accuracy
%         testY(ind,1) = -1;      %把testY中为-2的改为-1.
%          
%        Y_unique = unique(testY);
%        %把每一个子空间的混淆矩阵都保存下来
%        CMi{s} = zeros(size(Y_unique,1),size(Y_unique,1));
%        for n = 1:2
%            in = find(testY == Y_unique(n,1)); %找出实际标签为某一类标签的位置。
%            Y_pred =  svm_pred1(in,1);
%            CMi{s}(n,1) = size(find(Y_pred == Y_unique(1,1)),1)%找到预测标签和真实标签相等的数量
%            CMi{s}(n,2) = size(find(Y_pred == Y_unique(2,1)),1)%找到预测标签和真实标签不相等的数量
%        end
%        
%        % 把每一个子空间的混淆矩阵具体值记录下来
%        TPi(s,:) = CMi{s}(1,1);
%        FNi(s,:) = CMi{s}(1,2);
%        FPi(s,:) = CMi{s}(2,1);
%        TNi(s,:) = CMi{s}(2,2);
% 
%        %把每一个子空间的评价指标值记录下来
%        ACCi(s,:) = (TPi(s,:) + TNi(s,:)) / (TPi(s,:) + TNi(s,:) + FPi(s,:) + FNi(s,:));
%        Prei(s,:) = TPi(s,:) / (TPi(s,:) + FPi(s,:));
%        Reci(s,:) = TPi(s,:) / (TPi(s,:) + FNi(s,:));
%        Spei(s,:) = TNi(s,:) / (FPi(s,:) + TNi(s,:));
%        G_meani(s,:) = sqrt(Reci(s,:) * Spei(s,:));
%        F1_scorei(s,:) = 2 * ((Prei(s,:) * Reci(s,:)) / (Prei(s,:) + Reci(s,:)));
%        Evaluation_index_i(s,:) = [ACCi(s,:) Prei(s,:) Reci(s,:) Spei(s,:) G_meani(s,:) F1_scorei(s,:)]
%     %% 在RF时候要注释掉//整理每一个子空间 Scores得分 
%      % Scores 是每一个子空间的使用预测后的概率
% %         scores = [scores Scores];    %scores里面存放的是每一个子空间中所有次训练得到的Scores. 也机存放的是一个子空间中的东西
%      % 计算每一个子空间ROC曲线下方的面积AUC值
%     %% 计算AUC值得程序段  ,本程序在RF时候要注释掉
% %     让精度最好空间的AUC作为决策层的精度,也即最终的精度 
%        Final_scores1 = [];
%        Final_scores2 = [];
%        Column_number_scores = size(scores,2); %求scores的列数
%       for o = 1:Column_number_scores
%           if mod(o,2)
%              Final_scores1 = [Final_scores1 scores(:,o)] 
%           else
%              Final_scores2 = [Final_scores2 scores(:,o)] 
%           end
%       end 
%      % 对多个模型得到分数取平均存放 得到每一个子空间的分数
%      Mean_scores{s,1} = [(sum(Final_scores1,2)/(Column_number_scores/2)) (sum(Final_scores2,2)/(Column_number_scores/2))]; 
%      %% RF时候隐藏下面这句代码 
% %      AUCi{s} = plot_roc(Mean_scores{s,1}(:, 2),testY);  % Mean_scores{s,2}要注意输入的哪一列的概率值。
%  
%         end % 结束每一个子空间标志
%         
%         %% 下面部分使用网格权重搜索方法，集成三个子空间的预测
%        % 加载权重矩阵
%           load 'weight'%加载网格搜索法权重 
%            m_w = size(weight,1);     %网格搜索方法找寻最佳权重
%        for q = 1:m_w
%             w1= weight(q,:);
%             %% 考虑这里是否添加sign
%             P = sign(ensemble(:,1) * w1(1,1) + ensemble(:,2) * w1(1,2) + ensemble(:,3) * w1(1,3));
% %                 P = ensemble(:,1) * w1(1,1) + ensemble(:,2) * w1(1,2) + ensemble(:,3) * w1(1,3);
%             Final_Accuracy_with_ensebleL = mean(P == testY) * 100; % Final accuracy
%             ACC_w1_all = [ACC_w1_all; Final_Accuracy_with_ensebleL];
%        end
%        %% 评价指标相关代码
%        ACC_svml_tt = max(ACC_w1_all);
%        indx = find(ACC_w1_all == max(max(ACC_w1_all)));
%        best_weight = weight(indx(1,1),:);
%         %best_P是最好的预测吧，利用预测计算混淆矩阵。
% %        best_Pred = ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3);
%        best_Pred = sign(ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3));
%        % 下面是一个通用的建立混淆矩阵的代码,并计算几个评价指标的代码
%       % best_Pred 是预测标签，testY是真实标签。到了这一步之后，预测标签和真实标签都为1和-1，原本的2都转为-1了
%      CM = zeros(size(Y_unique,1),size(Y_unique,1));
%      for r = 1:2
%        in = find(testY == Y_unique(r,1)); %找出实际标签为某一类标签的位置。
%        Y_pred =  best_Pred(in,1);
%        CM(r,1) = size(find(Y_pred == Y_unique(1,1)),1);%找到预测标签和真实标签相等的数量
%        CM(r,2) = size(find(Y_pred == Y_unique(2,1)),1);%找到预测标签和真实标签不相等的数量
%      end
% 
%    TP = CM(1,1);
%    FN = CM(1,2);
%    FP = CM(2,1);  
%    TN = CM(2,2);
%    %下面写评价指标
%    ACC = (TP+TN) / (TP + TN + FP + FN);
%    Pre = TP / (TP + FP);
%    Rec = TP / (TP + FN);
%    Spe = TN / (FP + TN);
%    G_mean = sqrt(Rec * Spe);
%    F1_score = 2 * ((Pre * Rec) / (Pre + Rec));
%    %% RF时候要做修改
%    %下面这句代码得到最高精度子空间的判别分数,用最高子空间的分数作为决策层空间的分数
% %    Final_scores = Mean_scores{1} * best_weight(1,1) + Mean_scores{2} * best_weight(1,2) + Mean_scores{3} * best_weight(1,3)
% %    AUC_final = plot_roc(Final_scores(:,2),testY);
% %    Final_Evaluation_index = [ACC Pre Rec Spe G_mean  F1_score_Final  AUC_final ] 
%    % RF时候换用这句话
%    Final_Evaluation_index = [ACC Pre Rec Spe G_mean  F1_score  ] 
%    %%  
%    tr2 = [tr2;ACC_svml_tt]; 
%    ACC_final_mean = mean(tr2); 
%    LDPP_Result.ACC_final_mean = ACC_final_mean;
%    LDPP_Result.testACC = svml2 ;
%    LDPP_Result.ACC = ACC;   
%    LDPP_Result.ACCi = ACCi; 
%    LDPP_Result.Pre = Pre;
%    LDPP_Result.Prei = Prei;
%    LDPP_Result.Rec = Rec; 
%    LDPP_Result.Reci = Reci; 
%    LDPP_Result.Spe = Spe; 
%    LDPP_Result.Spei = Spei;
%    LDPP_Result.G_mean = G_mean; 
%    LDPP_Result.G_meani = G_meani; 
%    LDPP_Result.F1_score = F1_score; 
%    LDPP_Result.F1_scorei = F1_scorei; 
%  
%    LDPP_Result.svml3 = svml3; 
% end


%%
h_t
function [LDPP_Result] = ldpp()
        % 记住RF时不返回AUC
        clear all;close all ;clc;
         %% 加载数据集 
        load('maxlittle_sample4_06');%数据集读取
         ACC_w1_all=[];
         tr2=[];
         Evaluation_index_i = [];
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
         AUCi = {};
         svml3 = [];
         scores = [];
         ensemble = [];
         LDPP_Result = [];
      
        for s = 1:3 
           %% 数据集处理部分
           % 拆分数据和标签
           trainX = traindataX{1,s}(:,2:end-1);
           trainY = traindataX{1,s}(:,end);
           validX = valid_data(:,2:end-1);  
           validY = valid_data(:,end);
           testX = test_data(:,2:end-1);
           testY = test_data(:,end);
%            trainX0 = [trainX; validX];
%            trainY0 = [ trainY;validY];
           %% 样本标准化部分
           % 下面给数据加1，想要区别与原始数据，可以把原始数据保留
           [trainX, mu, sigma] = featureCentralize(trainX);%%将样本标准化（服从N(0,1)分布）
           testX = bsxfun(@minus, testX, mu);
           testX = bsxfun(@rdivide, testX, sigma);
%            trainX1 = trainX0(1:size(trainX,1),:);
%            trainY = trainY0(1:size(trainX,1),:);
%            validX1 = trainX0(size(trainX,1)+1:size(trainX0,1),:)
%            validY = trainY0(size(trainX,1)+1:size(trainX0,1),:)
           validX = bsxfun(@minus, validX, mu);
           validX = bsxfun(@rdivide, validX, sigma);  
       %%    LDPP 

        kk=5;
        mukgamma=[];
        mean_svml8_max = 0;
        for it=1:9
        for igamma=1:9
            for imu=1:9
                method = [];
                method.mode = 'ldpp_u';
                method.mu = 0.00001 * power(10,imu);
                method.gamma = 0.00001 * power(10,igamma);
                method.t=0.00001*power(10,it);
                method.M = 200;
                method.labda2 = 0.001;   %取[0.0001,0.001,...,1000,10000]
                method.ratio_b = 0.9;    %有时候不是很明白这个参数的含义
                method.ratio_w = 0.9;
%                 method.weightmode = 'binary';
                method.weightmode = 'heatkernel'; %在这里可以更改模式
                method.knn_k = 5;
                U = featureExtract2(trainX,trainY,method,type_num); %使用之前的方法提取出来映射矩阵U
                   for ik = 1:floor(size(trainX,2)/5)
                        method.K = kk*ik;
                        mukgamma = [mukgamma;[imu ik igamma]];    
                        trainZ = projectData(trainX, U, method.K);
                        validZ = projectData(validX, U, method.K);

        %                 % SVM高斯 
                        model = svmtrain(trainY,trainZ,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
                        svm_pred = svmpredict(validY,validZ,model);  % 这里的testZ还是valid
                       svml8(ik) = calculateAccuracy(valid_data,validY,svm_pred);

                        %SVM 线性
%                         model = svmtrain(trainY,trainZ,'-s 0 -t 0'); %%使用所有变换后的训练集训练模型
%                         svm_pred = svmpredict(validY,validZ,model);  % 这里的testZ还是valid
%                         svml8(ik) = calculateAccuracy(valid_data,validY,svm_pred);

                        % RF随机森林               
%                         model = classRF_train(trainZ,trainY,'ntree',300)
%                         [svm_pred,votes] = classRF_predict(validZ,model)
%                         svml8(ik) = calculateAccuracy(valid_data,validY,svm_pred);
                             %  ELM         
        %                  [~, ~, ~, TestingAccuracy,svm_pred] = ELM([trainy trainZ1], [validy testZ], 1, 5000, 'sig', 10^2);
                   end
           [loc_x,loc_y]=find(svml8==max(max(svml8)));%找到最大值的位置
            if max(max(svml8))>mean_svml8_max
                mean_svml8_max=max(max(svml8));
%                 U_svml_best=U1_all;
                best_svml_kk = kk*loc_y(1,1);
                best_svml_mu=0.00001*power(10,imu);%取[0.0001,0.001,...,1000,10000]
                best_svml_gamma =0.00001*power(10,igamma);
                best_svml_t=0.00001*power(10,it);
            end
        end
    end
end
        % 找出最优秀的参数
        method.mu = best_svml_mu;
        method.gamma = best_svml_gamma;
        method.t =  best_svml_t;
               %% 上面代码找出最好的U矩阵参数存放在 method中通
                U = featureExtract2(trainX,trainY,method,type_num);  %使用找到的最好的U矩阵参数method得出最优参数对应的U矩阵
                U1 = U(:,1:best_svml_kk);
                trainZ1 = trainX * U(:,1:best_svml_kk);  %使用最好的U矩阵进行变换
                testZ1 = testX * U(:,1:best_svml_kk);
                svml2 = [];
                %% 使用test进行验证
                 % SVM高斯 

                     model = svmtrain(trainY,trainZ1,'-s 0 -t 2');%%使用所有变换后的训练集训练模型
                     svm_pred1 = svmpredict(testY,testZ1,model);
                      svml2 = [svml2 calculateAccuracy(test_data,testY,svm_pred1);];


                      % SVM 线性
%                      model = svmtrain(trainY,trainZ1,'-s 0 -t 0');%%使用所有变换后的训练集训练模型
%                      svm_pred1 = svmpredict(testY,testZ1,model);
%                       svml2 = [svml2 calculateAccuracy(test_data,testY,svm_pred1);];
           
                        % RF随机森林
%                       model = classRF_train(trainZ1,trainY,'ntree',300)
%                      [svm_pred1,votes] = classRF_predict(testZ1,model)
%                        svml2 = [svml2 calculateAccuracy(test_data,testY,svm_pred1);];



       %% 每一个子空间的模型评价指标
       % 因为后面程序按照标签为[-1,1]写的，所以这里把2变成-1.
        [ind] = find(svm_pred1 == 2); % Because Sgn function works with labels -1 and 1 so here I changed all my labels from 2 to -1 to make it possible(1,-1) before saving
        svm_pred1(ind,1) = -1;
        % 把每一个子空间的预测保存下来
        ensemble = [ensemble svm_pred1];
        
        [ind] = find(testY==2); % Changing labels having value 2 to -1 for calculation of accuracy
        testY(ind,1) = -1;      %把testY中为-2的改为-1.
         
       Y_unique = unique(testY);
       %把每一个子空间的混淆矩阵都保存下来
       CMi{s} = zeros(size(Y_unique,1),size(Y_unique,1));
       for n = 1:2
           in = find(testY == Y_unique(n,1)); %找出实际标签为某一类标签的位置。
           Y_pred =  svm_pred1(in,1);
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
       Spei(s,:) = TNi(s,:) / (FPi(s,:) + TNi(s,:));
       G_meani(s,:) = sqrt(Reci(s,:) * Spei(s,:));
       F1_scorei(s,:) = 2 * ((Prei(s,:) * Reci(s,:)) / (Prei(s,:) + Reci(s,:)));
%        Evaluation_index_i(s,:) = [ACCi(s,:) Prei(s,:) Reci(s,:) Spei(s,:) G_meani(s,:) F1_scorei(s,:)]
    %% 在RF时候要注释掉//整理每一个子空间 Scores得分 
     % Scores 是每一个子空间的使用预测后的概率
%         scores = [scores Scores];    %scores里面存放的是每一个子空间中所有次训练得到的Scores. 也机存放的是一个子空间中的东西
     % 计算每一个子空间ROC曲线下方的面积AUC值
    %% 计算AUC值得程序段  ,本程序在RF时候要注释掉
%     让精度最好空间的AUC作为决策层的精度,也即最终的精度 
       Final_scores1 = [];
       Final_scores2 = [];
       Column_number_scores = size(scores,2); %求scores的列数
      for o = 1:Column_number_scores
          if mod(o,2)
             Final_scores1 = [Final_scores1 scores(:,o)] 
          else
             Final_scores2 = [Final_scores2 scores(:,o)] 
          end
      end 
     % 对多个模型得到分数取平均存放 得到每一个子空间的分数
     Mean_scores{s,1} = [(sum(Final_scores1,2)/(Column_number_scores/2)) (sum(Final_scores2,2)/(Column_number_scores/2))]; 
     %% RF时候隐藏下面这句代码 
%      AUCi{s} = plot_roc(Mean_scores{s,1}(:, 2),testY);  % Mean_scores{s,2}要注意输入的哪一列的概率值。
 
        end % 结束每一个子空间标志
        
       % 下面部分使用网格权重搜索方法，集成三个子空间的预测
       % 加载权重矩阵
          load 'weight'%加载网格搜索法权重 
           m_w = size(weight,1);     %网格搜索方法找寻最佳权重
       for q = 1:m_w
            w1= weight(q,:);
            %% 考虑这里是否添加sign
            P = sign(ensemble(:,1) * w1(1,1) + ensemble(:,2) * w1(1,2) + ensemble(:,3) * w1(1,3));
%                 P = ensemble(:,1) * w1(1,1) + ensemble(:,2) * w1(1,2) + ensemble(:,3) * w1(1,3);
            Final_Accuracy_with_ensebleL = mean(P == testY) * 100; % Final accuracy
            ACC_w1_all = [ACC_w1_all; Final_Accuracy_with_ensebleL];
       end
       %% 评价指标相关代码
       ACC_svml_tt = max(ACC_w1_all);
       indx = find(ACC_w1_all == max(max(ACC_w1_all)));
       best_weight = weight(indx(1,1),:);
        %best_P是最好的预测吧，利用预测计算混淆矩阵。
%        best_Pred = ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3);
       best_Pred = sign(ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3));
       % 下面是一个通用的建立混淆矩阵的代码,并计算几个评价指标的代码
      % best_Pred 是预测标签，testY是真实标签。到了这一步之后，预测标签和真实标签都为1和-1，原本的2都转为-1了
     CM = zeros(size(Y_unique,1),size(Y_unique,1));
     for r = 1:2
       in = find(testY == Y_unique(r,1)); %找出实际标签为某一类标签的位置。
       Y_pred =  best_Pred(in,1);
       CM(r,1) = size(find(Y_pred == Y_unique(1,1)),1);%找到预测标签和真实标签相等的数量
       CM(r,2) = size(find(Y_pred == Y_unique(2,1)),1);%找到预测标签和真实标签不相等的数量
     end
     
   TP = CM(1,1);
   FN = CM(1,2);
   FP = CM(2,1);  
   TN = CM(2,2);
   %下面写评价指标
   ACC = (TP+TN) / (TP + TN + FP + FN);
   Pre = TP / (TP + FP);
   Rec = TP / (TP + FN);
   Spe = TN / (FP + TN);
   G_mean = sqrt(Rec * Spe);
   F1_score = 2 * ((Pre * Rec) / (Pre + Rec));
   %% RF时候要做修改
   %下面这句代码得到最高精度子空间的判别分数,用最高子空间的分数作为决策层空间的分数
%    Final_scores = Mean_scores{1} * best_weight(1,1) + Mean_scores{2} * best_weight(1,2) + Mean_scores{3} * best_weight(1,3)
%    AUC_final = plot_roc(Final_scores(:,2),testY);
%    Final_Evaluation_index = [ACC Pre Rec Spe G_mean  F1_score_Final  AUC_final ] 
   % RF时候换用这句话
   Final_Evaluation_index = [ACC Pre Rec Spe G_mean  F1_score  ] 
   %%  
   tr2 = [tr2;ACC_svml_tt]; 
   ACC_final_mean = mean(tr2); 
   LDPP_Result.ACC_final_mean = ACC_final_mean;
   LDPP_Result.testACC = svml2 ;
   LDPP_Result.ACC = ACC;   
   LDPP_Result.ACCi = ACCi; 
   LDPP_Result.Pre = Pre;
   LDPP_Result.Prei = Prei;
   LDPP_Result.Rec = Rec; 
   LDPP_Result.Reci = Reci; 
   LDPP_Result.Spe = Spe; 
   LDPP_Result.Spei = Spei;
   LDPP_Result.G_mean = G_mean; 
   LDPP_Result.G_meani = G_meani; 
   LDPP_Result.F1_score = F1_score; 
   LDPP_Result.F1_scorei = F1_scorei; 
   LDPP_Result.svml3 = svml3; 
end