function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% ========== feed forward ==========
% 注意 bias 项位置保持一致，本项目中 bias 项全部位于首列，而非尾列
a1 = [ones(m,1),X];     % L1 增加 bias 项, a1 size = 5000*401
z2 = a1 * Theta1';      % z2 size = 5000*25; Theta1 size = 25*401
a2 = sigmoid(z2);
a2 = [ones(m,1),a2];    % L2 增加 bias 项,  a2 size = 5000*26
z3 = a2 * Theta2';      % z3 size = 5000*26; Theta2 size = 10*26
a3 = sigmoid(z3);       % h(x) size = 5000*10

% 独热编码
y_label = zeros(m, num_labels); % size = 5000*10
for i = 1:1:m
    y_label(i,y(i))=1;  % y的取值范围是[1，10]，直接可以当作下标
end

Cost = -y_label.*log(a3)-(1-y_label).*log(1-a3);
J=1/m* sum(sum(Cost));
% Theta1 和 Theta2 第一列都是 bias 的权重向量，不计入正则项
r = lambda / (2 * m) * (sum(sum(Theta1(:, 2:end) .^ 2))+ sum(sum(Theta2(:, 2:end) .^ 2)));
J = J + r; 

% ========== back propagation ==========
delta3 = a3 -y_label;    % size = 5000 * 10
delta2 = (Theta2' * delta3' .* sigmoidGradient([ones(m,1),z2])')'; % size = 5000 * 26,含 bias 项

% 按样本遍历，累加求平均。输出层无 bias 项，全部节点计入BP。
for k = 1:m
    Theta2_grad += delta3(k,:)' * a2(k,:); % Theta2_grad size = 10*26
end
Theta2_grad *= 1/m;
Theta2_grad(:,2:end) += lambda/m * Theta2(:, 2:end); % 隐层除 bias 节点到输出层的参数，其余都加正则

% Theta1_grad 同理, 但是隐层存在 bias 节点，其误差不计入BP
for k = 1:m
    Theta1_grad += delta2(k,2:end)' * a1(k,:);  % Theta1_grad size = 25*401
end
Theta1_grad *= 1/m;
Theta1_grad(:,2:end) += lambda/m * Theta1(:, 2:end);


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
