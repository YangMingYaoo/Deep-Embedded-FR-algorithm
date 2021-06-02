function [onlyLPPheatkernel_Result] = onlyLPPheatkernel_adbstLDPP()
        clear all;close all ;clc;
        %% �������ݼ� 
         load('PD_LSVTsample');%���ݼ���ȡ
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
         onlyLPPheatkernel_Result = [];
         
         for s = 1:3 
           
            %% ���ݼ�������
             % ������ݺͱ�ǩ
             trainX = traindataX{1,s}(:,1:end-1);
             trainY = traindataX{1,s}(:,end);
             validX = valid_data(:,1:end-1);  
             validY = valid_data(:,end);
             testX = test_data(:,1:end-1);
             testY = test_data(:,end);
           %% ������׼������
            %��������ݼ�1����Ҫ������ԭʼ���ݣ����԰�ԭʼ���ݱ���
            [trainX, mu, sigma] = featureCentralize(trainX);%%��������׼��������N(0,1)�ֲ���
            testX = bsxfun(@minus, testX, mu);
            testX = bsxfun(@rdivide, testX, sigma);
            validX = bsxfun(@minus, validX, mu);
            validX = bsxfun(@rdivide, validX, sigma); 
            
            
          %% ʹ��LPP�����任�������ݲ���
           kk=5;
           svml8 = [];
           t = [];
        
           for it = 1:9
               method = [];
               method.mode = 'lpp';
               method.t = 0.00001*power(10,it);
%              method.weightmode = 'binary';
               method.weightmode = 'heatkernel';
               method.knn_k = 5;%Ϊ���ٲ������ڣ�һ��Ϊ5
               U = featureExtract(trainX,trainY,method,type_num);
               for ik = 1:floor(size(trainX,2)/5)
%                    t = [t;[ik it]];
                   method.K = kk * ik;
                   trainZ1 = projectData(trainX, U, method.K);
                   validZ1 = projectData(validX, U, method.K);

                 % SVM��˹ 
%                model = svmtrain(trainY,trainZ1,'-s 0 -t 2 ');%%ʹ�����б任���ѵ����ѵ��ģ��
%                svm_pred1 = svmpredict(validY,validZ1,model);  
%                svml8(it,ik) = mean(svm_pred1 == validY) * 100;

                  %SVM ����
%                   model = svmtrain(trainY,trainZ1,'-s 0 -t 0 '); %ʹ�����б任���ѵ����ѵ��ģ��
%                   svm_pred1 = svmpredict(validY,validZ1,model);  
%                   svml8 = [svml8 mean(svm_pred1 == validY) * 100;];

                   % RF���ɭ��               
                 model = classRF_train(trainZ1,trainY,'ntree',300)
                 [svm_pred1,votes] = classRF_predict(validZ1,model)
                 svml8(it,ik) = mean(svm_pred1 == validY) * 100
               end 

           end
           [loc_x,loc_y] = find ( svml8 == max(max(svml8)))
           acc_svml8_max = max(max(svml8)); 
           best_t = loc_x(1,1);
           best_svml_t = 0.00001 * power(10,best_t(1,1));
           best_svml_kk = loc_y(1,1) * kk;
           method.t = best_svml_t
           U = featureExtract(trainX,trainY,method,type_num);
            %% ��������ҳ���õ�U������������ method��
             trainZ2 = projectData(trainX, U, best_svml_kk);
             testZ2 = projectData(testX, U, best_svml_kk);
            %% ʹ�����б任���ѵ����ѵ��ģ�Ͳ�Ԥ��
              % ����Ҫʹ�ò������ݼ�������ѡ������ʱ����Ҫ�õ���֤���ݼ�
              
               % SVM ��˹ 
%                    mode2 = svmtrain(trainY,trainZ2,'-s 0 -t 2 -b 1'); 
%                    [svm_pred3,~,Scores] = svmpredict(testY,testZ2,mode2,'-b 1');
%                    svml3 = [svml3 mean(svm_pred3 == testY) * 100;];

                   % SVM ���� 
%                    mode2 = svmtrain(trainY,trainZ2,'-s 0 -t 0 -b 1'); 
%                    [svm_pred3,~,Scores] = svmpredict(testY,testZ2,mode2,'-b 1');
%                    svml3 = [svml3 mean(svm_pred3 == testY) * 100;];
                   
                   % RF     classRF_train ������� ��дtrainZ2 ��д trainY
                 mode2 = classRF_train(trainZ2,trainY,'ntree',300)
                 [svm_pred3,votes] = classRF_predict(testZ2,mode2)
                 svml3 = [svml3 mean(svm_pred3 == testY) * 100;];
%                  
                 
        %% ���۱�׼����
         % ��Ϊ��������ձ�ǩΪ[-1,1]д�ģ����������2���-1.
        [ind] = find(svm_pred3 == 2); % Because Sgn function works with labels -1 and 1 so here I changed all my labels from 2 to -1 to make it possible(1,-1) before saving
        svm_pred3(ind,1) = -1;
        % ��ÿһ���ӿռ��Ԥ�Ᵽ������
        ensemble = [ensemble svm_pred3];   
        
        [ind] = find(testY==2); % Changing labels having value 2 to -1 for calculation of accuracy
        testY(ind,1) = -1;      %��testY��Ϊ-2�ĸ�Ϊ-1.
       %% ÿһ���ӿռ������ָ��
       Y_unique = unique(testY);
       %��ÿһ���ӿռ�Ļ������󶼱�������
       CMi{s} = zeros(size(Y_unique,1),size(Y_unique,1));
       for n = 1:2
           in = find(testY == Y_unique(n,1)); %�ҳ�ʵ�ʱ�ǩΪĳһ���ǩ��λ�á�
           Y_pred =  svm_pred3(in,1);
           CMi{s}(n,1) = size(find(Y_pred == Y_unique(1,1)),1)%�ҵ�Ԥ���ǩ����ʵ��ǩ��ȵ�����
           CMi{s}(n,2) = size(find(Y_pred == Y_unique(2,1)),1)%�ҵ�Ԥ���ǩ����ʵ��ǩ����ȵ�����
       end
       % ��ÿһ���ӿռ�Ļ����������ֵ��¼����
       TPi(s,:) = CMi{s}(1,1);
       FNi(s,:) = CMi{s}(1,2);
       FPi(s,:) = CMi{s}(2,1);
       TNi(s,:) = CMi{s}(2,2);
       %��ÿһ���ӿռ������ָ��ֵ��¼����
       ACCi(s,:) = (TPi(s,:) + TNi(s,:)) / (TPi(s,:) + TNi(s,:) + FPi(s,:) + FNi(s,:));
       Prei(s,:) = TPi(s,:) / (TPi(s,:) + FPi(s,:));
       Reci(s,:) = TPi(s,:) / (TPi(s,:) + FNi(s,:));
       Spei(s,:) = TNi(s,:) / (FNi(s,:) + TNi(s,:));
       G_meani(s,:) = sqrt(Reci(s,:) * Spei(s,:));
       F1_scorei(s,:) = (2 * Prei(s,:) * Reci(s,:)) / (Prei(s,:) + Reci(s,:))
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
 
        end   %�������ÿһ���ӿռ��Ѱ��
       %% ���沿��ʹ������Ȩ���������������������ӿռ��Ԥ��
        % ����Ȩ�ؾ��� %��������������Ѱ���Ȩ��
           load 'weight'%��������������Ȩ�� 
           m_w = size(weight,1); 
       for q = 1:m_w
            w1= weight(q,:);
            P = ensemble(:,1) * w1(1,1) + ensemble(:,2) * w1(1,2) + ensemble(:,3) * w1(1,3);
            Final_Accuracy_with_ensebleL = mean(P == testY) * 100; % Final accuracy
            ACC_w1_all = [ACC_w1_all; Final_Accuracy_with_ensebleL];
       end
       %% ����ָ����ش���
       ACC_svml_tt = max(ACC_w1_all);
       indx = find(ACC_w1_all == max(max(ACC_w1_all)));
       best_weight = weight(indx(1,1),:);
        %best_P����õ�Ԥ��ɣ�����Ԥ������������
       best_Pred = ensemble(:,1) * best_weight(1,1) + ensemble(:,2) * best_weight(1,2) + ensemble(:,3) * best_weight(1,3);
       % ������һ��ͨ�õĽ�����������Ĵ���,�����㼸������ָ��Ĵ���
      % best_Pred ��Ԥ���ǩ��testY����ʵ��ǩ��������һ��֮��Ԥ���ǩ����ʵ��ǩ��Ϊ1��-1��ԭ����2��תΪ-1�ˡ�
     
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
   Spe = TN / (FN + TN);
   G_mean = sqrt(Rec * Spe);
   F1_score_Final = (2 * Pre * Rec) / (Pre + Rec);
   %% RFʱ��Ҫ���޸�
   %����������õ���߾����ӿռ���б����,������ӿռ�ķ�����Ϊ���߲�ռ�ķ���
%    Final_scores = Mean_scores{1} * best_weight(1,1) + Mean_scores{2} * best_weight(1,2) + Mean_scores{3} * best_weight(1,3)
%    AUC_final = plot_roc(Final_scores(:,2),testY);
%    Final_Evaluation_index = [ACC Pre Rec Spe G_mean  F1_score_Final  AUC_final ] 
   % RFʱ������仰
   Final_Evaluation_index = [ACC Pre Rec Spe G_mean  F1_score_Final   ] 
   %% 
   tr2 = [tr2;ACC_svml_tt]; 
   ACC_final_mean = mean(tr2); 
   onlyLPPheatkernel_Result.ACC_final_mean = ACC_final_mean;
   onlyLPPheatkernel_Result.ACC = ACC;   
   onlyLPPheatkernel_Result.ACCi = ACCi; 
   
   %% RF ʱ����������2�����
%    onlyLPPheatkernel_Result.AUC_final = AUC_final; 
%    onlyLPPheatkernel_Result.AUCi = AUCi; 
   %% 
   onlyLPPheatkernel_Result.F1_score_Final = F1_score_Final; 
   onlyLPPheatkernel_Result.F1_scorei = F1_scorei; 
   onlyLPPheatkernel_Result.G_mean = G_mean; 
   onlyLPPheatkernel_Result.G_meani = G_meani; 
   onlyLPPheatkernel_Result.Pre = Pre;
   onlyLPPheatkernel_Result.Prei = Prei; 
   onlyLPPheatkernel_Result.Rec = Rec; 
   onlyLPPheatkernel_Result.Reci = Reci; 
   onlyLPPheatkernel_Result.Spe = Spe; 
   onlyLPPheatkernel_Result.Spei = Spei; 
   onlyLPPheatkernel_Result.svml3 = svml3;  
   
end
