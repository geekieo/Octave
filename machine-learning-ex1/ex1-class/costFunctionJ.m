function J = costFunctionJ(X, y, theta)

% X �ǡ�������ơ���ѵ����������ÿ��Ϊһ����������
% y ������ǩ����������ÿ�ж�Ӧһ��ѵ�������ı�ǩ��
% theta �� n ά����ʽ�Ĳ�������������n �� X ������������������ά��

m = size(X,1);	%ѵ������������ X ������, length(X)
predictions = X*theta;	%���� m �������Ķ���ʽԤ�⺯��
sqrErrors = (predictions -y).^2;	%ƽ��������
J = 1/(2*m)*sum(sqrErrors);	%���ۺ���
