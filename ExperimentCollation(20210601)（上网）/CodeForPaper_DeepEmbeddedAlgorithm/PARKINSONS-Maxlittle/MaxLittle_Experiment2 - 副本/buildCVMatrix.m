%�ú���Ϊ�������������
function [trnM, tstM] = buildCVMatrix(N, nfold)
blockSize = floor(N/nfold);
trnM = zeros(N, nfold);
tstM = zeros(N, nfold);

for i = 1:(nfold-1)
    index = repmat(false, N, 1);%��ָ�������0,����1-9�۽�����֤
    index(((i-1)*blockSize+1):(i*blockSize)) = true;
    tstM(index, i) = true;
    trnM(~index, i) = true;
end
index = repmat(false, N, 1);   %�ٴΰ�ָ�������0 ,���õ�10�۽�����֤
index( ((nfold-1)*blockSize+1):N ) = true;
tstM(index, nfold) = true;
trnM(~index, nfold) = true;
end
% ������������ý�����֤����,����˵10�۽�����֤,��ÿһ��������һ����Ϊ���Լ���,�������Ϊѵ����. 
% �������������������������Ҫ���õĲ���������������ı���,��ô��һ��forѭ���п������1-10��,
% ����:�ú���֮����û���ڵ�һ��forѭ�������1-10��,ԭ������ĳһ�ε��ú���ʱ��,������Ϊ42��,������������Ϊ4��
% ���Ǳ�����ϵ