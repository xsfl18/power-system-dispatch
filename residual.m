function delta = residual(X, flg)
X0 = X;
%disp(X0);
%生成累加数列
n = length(X0);
X1 = zeros(1, n);
for i = 1:n
    if i == 1
        X1(1, i) = X0(1, i);
    else
        X1(1, i) = X1(1, i - 1) + X0(1, i);
    end
end

%建立数据矩阵Y和数据矩阵B
Y = zeros(n - 1, 1);
B = zeros(n - 1, 2);
for i = 1:n - 1
	Y(i, 1) = X0(1, i + 1);
	B(i, 1) = -0.5 * X1(1, i) - 0.5 * X1(1, i + 1); 
	B(i, 2) = 1;
end

%计算GM(1,1)模型的发展灰数a和内生控制系数u
A = zeros(2, 1);
%disp(B);
%disp(Y);
A = pinv(B) * Y;
a = A(1, 1);
u = A(2, 1);
%disp(A);
if flg == 0
    for i = 2:n
        delta(1, i - 1) = (-a) * (X0(1, 1) - u / a) * exp(-a * (i - 1));
		disp(delta);
    end
else
    delta = (-a) * (X0(1, 1) - u / a) * exp(-a * n);
end
end

