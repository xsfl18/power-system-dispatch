function result = fitness(pre_X0, X0)
n = length(X0);
m = size(pre_X0, 1);
sum = 0;
for i = 1:m
	for j = 1:n
		sum = sum + (pre_X0(i, j) - X0(1, j)) ^ 2;
	end
	result(i, :) = sum;
	sum = 0;
end
end


