function Y = sampleCluster(X,N)

[Idx1,C1]=kmeans(X(:,1:end-1),N);
ctLb = [];%���о������ĵı�ǩ

%K��ֵ����ɴأ��ڶ�Ӧ��ԭʼ�����У��ҳ���Ϊͬһ�ص��������Ѹô�������
for i = 1:N   
    t1 = find(Idx1 == i);
    t2 = X (t1, :);%��i�������������
    t3 = t2 (:, end);%��i��������������ı�ǩ
    t4 = mean(t3);
    ctLb = [ctLb; t4];   
end

Y = [C1, ctLb];
end
% A = size(unique(Idx1))
%%�������
% for i = 1:N
%     t1 = find(idx==i);
%     t2 = X(t1, :);%��i�������������
%     t3 = t2(:, end);%��i��������������ı�ǩ
%     t4 = t2(:, 1:(end-1));
%     t5 = unique(t3);
%     if(length(t3)==length(t5))
%         t6 = knnclassify(ct(i, :), t4, t3);
%         ctLb = [ctLb; t6];
%     else
%         ctLb = [ctLb; mode(t3)];
%     end
% end
% 
% Y = [C1, ctLb];


%%

%% 
% len=length(X);
% for i=1:N
%     c_0=[];
%     data_age_all=0;
%    a=0;
%     for j=1:len
%         if X(j,8)==i;
%             c0=j;
%             c_0=[c_0;c0];
%             a=a+1;
%             data_age=X(j,7);
%             data_age_all=data_age_all+data_age;
%         end
%     end
%     data_age_new=data_age_all/a;
%     m=length(c_0);
%     for k=1:m
%         X(c_0(k),7)=data_age_new;
%     end
% end
% data_arr=X;
% end

    