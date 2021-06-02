%������ÿһ�۽�����֤��ѵ�����ݺ�ѵ�����ݱ�ǩ���Լ�������Ȩ�ء�
%��  �������ҳ��� Ȼ���ڷ���ȥ��
% �ú��������þ�����������ķ���������������ķ��������ҳ���������С�ģ�������һ��������
function stump = buildStump(X, y, weight)   
D = size(X, 2); % �õ����ݼ���ά�ȣ�Ҳ������������

if nargin <= 2
    weight = ones(size(X,1), 1);
end

cellDS = cell(D, 1);
Err = zeros(D, 1);
for i = 1:D
    cellDS{i} = buildOneDStump(X(:,i), y, i, weight);   %���ú���
    Err(i) = cellDS{i}.error;
end

%cellDS ����ʲô 
[v, idx] = min(Err);
stump = cellDS{idx}; %�������ҳ���С�����ʶ�Ӧ��stump���ص���һ��������
end
%�ú�������տ�ʼ������������ǿ���������Ķ�����Adaboost���ж��塣 