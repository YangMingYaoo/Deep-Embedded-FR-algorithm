function stump = buildOneDStump(x, y, d, w)
%��������������������ʲô������ȥ�����ݵ��������е�һ�У�Ҳ����ȡ���������ݼ���ĳһ�������ȥ��
%�����ı�ǩ���Լ�������һά���ݵ�d,�Լ�������Ȩ��

[err_1, t_1] = searchThreshold(x, y, w, '>'); % > t_1 -> +1  %����searchThreshold����,�ú������ڱ�����������
[err_2, t_2] = searchThreshold(x, y, w, '<'); % < t_2 -> +1
%Ҫ֪��searchThreshold�������ص���:err_1,��t_1
% ����initStump()����                 %������x�ĵ�һ��,(ÿ�δ�����һ��,310ά�����Դ�����310��,)                   
stump = initStump(d);

if err_1 <= err_2
    stump.threshold = t_1;
    stump.error = err_1;
    stump.less = -1;
    stump.more = 1;%
else
    
    stump.threshold = t_2;
    stump.error = err_2;
    stump.less = 1;
    stump.more = -1;
end
end
%��������Ǹ�ɶ��,�������ż�? 
function [error, thresh] = searchThreshold(x, y, w, sign)
N = length(x);
err_n = zeros(N, 1);
y_predict = zeros(N, 1);
for n=1:N
    switch sign           
        case '>'                          % ����logical�����������߼�����������
            idx = logical(x >= x(n));    %�����X(n)�൱��һ���ż�,X(n)����nȡֵ�Ĳ�ͬ��ʾ������Ҳ��һ����
            y_predict(idx) = 1;
            y_predict(~idx) = -1;
        case '<'
            idx = logical(x < x(n));
            y_predict(idx) = 1;
            y_predict(~idx) = -1;
    end
    err_label = logical(y ~= y_predict);
    err_n(n) = sum(err_label.*w)/sum(w); %����ΪʲôҪ/sum(w)  ��%��Ϊ����һ��ѭ���У�����ѭ����֮�󣬱����ԭ������������
end                                      %��һ����������ÿ�������ڷ������ϵ�����ʡ�
[v, idx] = min(err_n);
error = v;
thresh = x(idx);
end
%��������2��searchThreshold,һ�η�����>,����һ�η�����<.�ڴ�������һ��,��С������һ��,����Ǵ��ںŵ����С,����С�ںŵ����С.�ҳ���С�����ʶ�Ӧ���ż�
