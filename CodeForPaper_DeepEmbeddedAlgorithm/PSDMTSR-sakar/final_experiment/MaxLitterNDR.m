%% 
clc;clear ;warning('off');
tic
final_eval= {};
mean_final_eval = {};
iter = 10
for C = 1:iter
    [MaxLittlerProposed_H_experiment1_s2] = NDR()
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

function [NDR_Result] = NDR()
        % ��סRFʱ������AUC
        clear all;close all ;clc;
         %# �������ݼ� 
         load('sakar_sample');%���ݼ���ȡ
         
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
         NDR_Result = [];
      
        for s = 1:3 
           %% ���ݼ�������
           % ������ݺͱ�ǩ
           trainX = traindataX{1,s}(:,2:end-1);
           trainY = traindataX{1,s}(:,end);
           validX = valid_data(:,2:end-1);  
           validY = valid_data(:,end);
           testX = test_data(:,2:end-1);
           testY = test_data(:,end);

           %# ������׼������
           [trainX, mu, sigma] = featureCentralize(trainX);%%��������׼��������N(0,1)�ֲ���
           testX = bsxfun(@minus, testX, mu);
           testX = bsxfun(@rdivide, testX, sigma); 
           validX = bsxfun(@minus, validX, mu);
           validX = bsxfun(@rdivide, validX, sigma); 

      %% ʹ�����б任���ѵ����ѵ��ģ�Ͳ�ʹ�ñ任��Ĳ��Լ���Ԥ������
      
             % SVM ���� 
%        mode2 = svmtrain(trainY,trainX,'-s 0 -t 0 -b 1'); 
%        [svm_pred1,~,Scores] = svmpredict(testY,testX,mode2,'-b 1');
%        svml3 =  [svml3 calculateAccuracy(test_data,testY,svm_pred1)];


       % SVM ��˹ 
       mode2 = svmtrain(trainY,trainX,'-s 0 -t 2 -b 1'); 
       [svm_pred1,~,Scores] = svmpredict(testY,testX,mode2,'-b 1');
       svml3 =  [svml3 calculateAccuracy(test_data,testY,svm_pred1)];
%       svml3 =  [svml3 mean(svm_pred1 == testY ) * 100];
       
%        mode2 = svmtrain(trainY,trainX,'-s 0 -t 2 -b 1'); 
%        [svm_pred1,~,Scores] = svmpredict(testY,testX,mode2,'-b 1');
%        svml3 =  [svml3 calculateAccuracy(test_data,testY,svm_pred1)];
%               
       
       % RF 
%      mode2 = classRF_train(trainX,trainY,'ntree',300)
%      [svm_pred1,votes] = classRF_predict(testX,mode2)
%    svml3 =  [svml3 calculateAccuracy(test_data,testY,svm_pred1)];

       %% ÿһ���ӿռ��ģ������ָ��
       % ��Ϊ��������ձ�ǩΪ[-1,1]д�ģ����������2���-1.��ǩΪ2���ǻ���,�ѻ��ߵı�ǩ���-1
        [ind] = find(svm_pred1 == 2); % Because Sgn function works with labels -1 and 1 so here I changed all my labels from 2 to -1 to make it possible(1,-1) before saving
        svm_pred1(ind,1) = -1;
        % ��ÿһ���ӿռ��Ԥ�Ᵽ������
        ensemble = [ensemble svm_pred1];
        [ind] = find(testY==2); % Changing labels having value 2 to -1 for calculation of accuracy
        testY(ind,1) = -1;      %��testY��Ϊ-2�ĸ�Ϊ-1.
         
       Y_unique = unique(testY);
       
       %# ������������
       CMi{s} = zeros(size(Y_unique,1),size(Y_unique,1));
       for n = 1:2
             in = find(testY == Y_unique(n,1)); %�ҳ�ʵ�ʱ�ǩΪĳһ���ǩ��λ�á�
             Y_pred =  svm_pred1(in,1);
             CMi{s}(n,1) = size(find(Y_pred == Y_unique(1,1)),1)%����positive��.�ҵ�Ԥ���ǩ����ʵ��ǩ��ȵ�����/����negtivel���ҵ�Ԥ���ǩ����ʵ��ǩ����ȵ�����
             CMi{s}(n,2) = size(find(Y_pred == Y_unique(2,1)),1)%����positive��.�ҵ�Ԥ���ǩ����ʵ��ǩ����ȵ�����/����negtivel���ҵ�Ԥ���ǩ����ʵ��ǩ��ȵ�����
       end
       % ��ÿһ���ӿռ�Ļ����������ֵ��¼����
       TPi(s,:) = CMi{s}(1,1);
       FNi(s,:) = CMi{s}(1,2);
       FPi(s,:) = CMi{s}(2,1);
       TNi(s,:) = CMi{s}(2,2);
       
       ACCi(s,:) = (TPi(s,:) + TNi(s,:)) / (TPi(s,:) + TNi(s,:) + FPi(s,:) + FNi(s,:));
       Prei(s,:) = TPi(s,:) / (TPi(s,:) + FPi(s,:));
       Reci(s,:) = TPi(s,:) / (TPi(s,:) + FNi(s,:));
       Spei(s,:) = TNi(s,:) / (FPi(s,:) + TNi(s,:));  %#spe����ָ����޸�
       
       G_meani(s,:) = sqrt(Reci(s,:) * Spei(s,:));
       F1_scorei(s,:) = 2 * ((Prei(s,:) * Reci(s,:)) / (Prei(s,:) + Reci(s,:)));
%        Evaluation_index_i(s,:) = [ACCi(s,:) Prei(s,:) Reci(s,:) Spei(s,:) G_meani(s,:) F1_scorei(s,:)]
    %% ��RFʱ��Ҫע�͵�//����ÿһ���ӿռ� Scores�÷� 
     % Scores ��ÿһ���ӿռ��ʹ��Ԥ���ĸ���
%         scores = [scores Scores];    %scores�����ŵ���ÿһ���ӿռ������д�ѵ���õ���Scores. Ҳ����ŵ���һ���ӿռ��еĶ���
     % ����ÿһ���ӿռ�ROC�����·������AUCֵ
    %% ����AUCֵ�ó����  ,��������RFʱ��Ҫע�͵�
%     �þ�����ÿռ��AUC��Ϊ���߲�ľ���,Ҳ�����յľ��� 
       Final_scores1 = [];
       Final_scores2 = [];
       Column_number_scores = size(scores,2); %��scores������
      for o = 1:Column_number_scores
          if mod(o,2)
             Final_scores1 = [Final_scores1 scores(:,o)] 
          else
             Final_scores2 = [Final_scores2 scores(:,o)] 
          end
      end 
     % �Զ��ģ�͵õ�����ȡƽ����� �õ�ÿһ���ӿռ�ķ���
     Mean_scores{s,1} = [(sum(Final_scores1,2)/(Column_number_scores/2)) (sum(Final_scores2,2)/(Column_number_scores/2))]; 
     %% RFʱ���������������� 
%      AUCi{s} = plot_roc(Mean_scores{s,1}(:, 2),testY);  % Mean_scores{s,2}Ҫע���������һ�еĸ���ֵ��
  end % ����ÿһ���ӿռ��־
        
  %% ���沿��ʹ������Ȩ���������������������ӿռ��Ԥ��
       % ����Ȩ�ؾ���
          load 'weight'%��������������Ȩ�� 
           m_w = size(weight,1);     %��������������Ѱ���Ȩ��
       for q = 1:m_w
            w1= weight(q,:);
            % ���������Ƿ����sign
            P = sign(ensemble(:,1) * w1(1,1) + ensemble(:,2) * w1(1,2) + ensemble(:,3) * w1(1,3));
%              P  = ensemble(:,1) * w1(1,1) + ensemble(:,2) * w1(1,2) + ensemble(:,3) * w1(1,3);
             Final_Accuracy_with_ensebleL = mean(P == testY) * 100; % Final accuracy
            ACC_w1_all = [ACC_w1_all; Final_Accuracy_with_ensebleL];
       end
       %% ����ָ����ش���
       ACC_svml_tt = max(ACC_w1_all);
       indx = find(ACC_w1_all == max(max(ACC_w1_all)));
       best_weight = weight(indx(1,1),:);
        %best_P����õ�Ԥ��ɣ�����Ԥ������������
       best_Pred = sign(ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3));
%        best_Pred = ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3);
       
      
       % best_Pred ��Ԥ���ǩ��testY����ʵ��ǩ��������һ��֮��Ԥ���ǩ����ʵ��ǩ��Ϊ1��-1��ԭ����2��תΪ-1�ˡ�
      Final_Acc = calculateAccuracy(test_data,testY, best_Pred);
      
      % # �������߲�Ļ������� ��
     CM = zeros(size(Y_unique,1),size(Y_unique,1));
     for r = 1:2
       in = find(testY == Y_unique(r,1)); %�ҳ�ʵ�ʱ�ǩΪĳһ���ǩ��λ�á�
       Y_pred =  best_Pred(in,1);
       CM(r,1) = size(find(Y_pred == Y_unique(1,1)),1);%�ҵ�Ԥ���ǩ����ʵ��ǩ��ȵ�����
       CM(r,2) = size(find(Y_pred == Y_unique(2,1)),1);%�ҵ�Ԥ���ǩ����ʵ��ǩ����ȵ�����
     end

   TP = CM(1,1);
   FN = CM(1,2);
   FP = CM(2,1);  
   TN = CM(2,2);
   %����д����ָ��
   ACC = (TP+TN) / (TP + TN + FP + FN);
   Pre = TP / (TP + FP);
   Rec = TP / (TP + FN);
   Spe = TN / (FP + TN); %#spe����ָ����޸�
   
   G_mean = sqrt(Rec * Spe);
   F1_score = 2 * ((Pre * Rec) / (Pre + Rec));
   %% RFʱ��Ҫ���޸�
   %����������õ���߾����ӿռ���б����,������ӿռ�ķ�����Ϊ���߲�ռ�ķ���
%    Final_scores = Mean_scores{1} * best_weight(1,1) + Mean_scores{2} * best_weight(1,2) + Mean_scores{3} * best_weight(1,3)
%    AUC_final = plot_roc(Final_scores(:,2),testY);
%    Final_Evaluation_index = [ACC Pre Rec Spe G_mean  F1_score_Final  AUC_final ] 
   % RFʱ������仰
   Final_Evaluation_index = [ACC Pre Rec Spe G_mean  F1_score  ] 
 
   %# ���۱�׼�洢
   tr2 = [tr2;ACC_svml_tt]; 
   ACC_final_mean = mean(tr2); 
   NDR_Result.ACC_final_mean = ACC_final_mean;
   NDR_Result.ACC = ACC;   
   NDR_Result.ACCi = ACCi; 
   NDR_Result.acci_subject = svml3; 
   NDR_Result.acc_subject  = Final_Acc;
   NDR_Result.Pre = Pre;
   NDR_Result.Prei = Prei;
   NDR_Result.Rec = Rec; 
   NDR_Result.Reci = Reci;
   NDR_Result.Spe = Spe; 
   NDR_Result.Spei = Spei;
   NDR_Result.G_mean = G_mean; 
   NDR_Result.G_meani = G_meani; 
   NDR_Result.F1_score = F1_score; 
   NDR_Result.F1_scorei = F1_scorei; 
 
   NDR_Result.svml3 = svml3; 
end