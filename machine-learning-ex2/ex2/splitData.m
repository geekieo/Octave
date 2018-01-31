function [A, B] = splitData(data, threshold = 0.5)
	m = size(data,1);
	A = []; B =[];
	for i = 1 : 1 : m
		if data(i, end) >= threshold
			A = [A; data(i,:)];
		else
			B = [B; data(i,:)];
		end
	end
end