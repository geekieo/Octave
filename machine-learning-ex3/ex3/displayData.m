function [h, display_array] = displayData(X, example_width)
%DISPLAYDATA Display 2D data in a nice grid
%   [h, display_array] = DISPLAYDATA(X, example_width) displays 2D data
%   stored in X in a nice grid. It returns the figure handle h and the 
%   displayed array if requested.

% Set example_width automatically if not passed in
% 如果 'example_width' 这一项变量不存在的话，会选用X列数的算术平方根来定义example_width
if ~exist('example_width', 'var') || isempty(example_width) 
	example_width = round(sqrt(size(X, 2)));
end

% Gray Image
colormap(gray);

% Compute rows, cols
[m n] = size(X);
example_height = (n / example_width);

% Compute number of items to display
% 按 10 * 10 的size来安置子图，
display_rows = floor(sqrt(m));
display_cols = ceil(m / display_rows);

% Between images padding 设置子图间隔
pad = 1;

% Setup blank display 图像实例空间初始化
% display_array 是一个 （1 + 10 * （ 20 + 1），1 + 10 * （20 + 1））的矩阵。
display_array = - ones(pad + display_rows * (example_height + pad), ...
                       pad + display_cols * (example_width + pad));

% Copy each example into a patch on the display array
curr_ex = 1; %  当前是第几个样本
for j = 1:display_rows
	for i = 1:display_cols
		if curr_ex > m, 
			break; 
		end
		% Copy the patch
		
		% Get the max value of the patch, 获取当前样本元素(像素灰度)最大值，
		% 每个像素灰度除以这个最大值，可实现灰度归一化
		max_val = max(abs(X(curr_ex, :)));
		% 把原先的 X 里面每行标准化以后按 20 * 20 的形式 替代 display_array 中的相应位置的元素
		display_array(pad + (j - 1) * (example_height + pad) + (1:example_height), ...
		              pad + (i - 1) * (example_width + pad) + (1:example_width)) = ...
						reshape(X(curr_ex, :), example_height, example_width) / max_val;
		curr_ex = curr_ex + 1;
	end
	if curr_ex > m, 
		break; 
	end
end

% Display Image
h = imagesc(display_array, [-1 1]);

% Do not show axis
axis image off

drawnow;

end
