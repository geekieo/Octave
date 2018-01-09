function J = costFunctionJ(X, y, theta)

% X 是“经过设计”的训练样本矩阵，每行为一个特征向量
% y 是类别标签，列向量（每行对应一个训练样本的标签）
% theta 是 n 维多项式的参数，列向量，n 是 X 的列数，特征向量的维数

m = size(X,1);	%训练样本数，即 X 的行数, length(X)
predictions = X*theta;	%所有 m 个样本的多项式预测函数
sqrErrors = (predictions -y).^2;	%平方误差矩阵
J = 1/(2*m)*sum(sqrErrors);	%代价函数
