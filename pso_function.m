clear all;
clc;
load wind_power1
X0 = wind_outpower(81:96, 1)' / 10;  %导入2017-11-26的风电出力作为初始值
X_real = wind_outpower(1:96, 2)' / 10;  %导入2017-11-27的风电出力
pre_X1 = zeros(1, length(X_real));
%初始化条件
c1 = 2; %学习因子1
c2 = 2; %学习因子2
w = 0.7298; %惯性权重
MaxGeneration = 200; %最大迭代次数
D = 1; %搜索空间维数lambda
N = 50; %初始粒子群个体数目
eps = 10 ^ (-6); %设置精度
x = zeros(N, D); %初始化粒子位置
v = zeros(N, D); %初始化粒子速度
%初始化种群个体
for i = 1:N
	for j = 1:D
		x(i, j) = rand;
		v(i, j) = rand;
	end
end

for k = 1:length(X_real)
	%计算各个粒子的适应度，定义全局最优
	pre_X0 = wind_prediction(x, X0, 0);
	result = fitness(pre_X0, X0);
	pi = result;
	pg_value = zeros(1, length(X0));
	pg_value = result(1, :);
	pg = x(1, :);
	y = x;
	for i = 2:N
		if result(i) < pg_value
			pg = x(i, :);
			pg_value = result(i, :);
	    end
    end

    %进入主要循环，按照公式一次迭代
    for t = 1:MaxGeneration
	    for i = 1:N
		    v(i, :) = w * v(i, :) + c1 * rand * (y(i, :) - x(i, :)) + c2 * rand * (pg - x(i, :));
		    x(i, :) = x(i, :) + v(i, :);
		    if x(i, :) > 1
			    x(i, :) = 1
		    elseif x(i, :) < 0
			    x(i, :) = 0
		    end
	    end
	    pre_X0 = wind_prediction(x, X0, 0);
	    result = fitness(pre_X0, X0);
	    for i = 1:N
		    if result(i, :) < pi(i, :)
			    pi(i, :) = result(i, :);
			    y(i, :) = x(i, :);
		    end
		    if result(i, :) < pg_value
			    pg_value = result(i, :);
			    pg = x(i, :);
		    end
	    end
	    pre_X0 = wind_prediction(pg, X0, 0);
	    Pbest(t, :) = pre_X0;
    end
    pre_X1(1, k) = wind_prediction(pg, X0, 1);
    X0(1, 1:length(X0) - 1) = X0(1, 2:length(X0));
	X0(1, length(X0)) = X_real(1, k);
end


%模型精度检验
%残差检验
%n = length(X0);
%e = 0;
%for i =1:n
    %e = e + abs(X0(1, i) - Pbest(MaxGeneration, i)) / X0(1, i);
%end
%e = e / n;
%if e <= 0.01
    %disp('预测模型为优');
  %elseif e >= 0.01 && e <= 0.05
     %disp('预测模型合格');
    %elseif e >= 0.05 && e <= 0.1
	   %disp('预测模型勉强合格');
       %else
	      %disp('预测模型不合格');
%end

%后验差检验
%计算原始序列标准差
%aver = 0; %原始序列平均值
%for i = 1:n
	%aver = aver + X0(1, i);
%end
%aver = aver / n;

%S0 = 0; %原始序列标准差
%for i = 1:n
	%S0 = S0 + (X0(1, i) - aver) ^ 2;
%end
%S0 = sqrt(S0 / (n - 1));

%Eaver = 0; %绝对误差平均值
%for i = 1:n
	%Eaver = Eaver + X0(1, i) - Pbest(MaxGeneration, i);
%end
%Eaver = Eaver / n;

%Es0 = 0; %绝对误差方差
%for i = 1:n
	%Es0 = Es0 + (X0(1, i) - Pbest(MaxGeneration, i) - Eaver) ^ 2;
%end
%Es0 = sqrt(Es0 / (n - 1));

%C = Es0 / S0; %计算方差比

%count = 0; %计算小概率误差
%for i = 1:n
	%if abs(X0(1, i) - Pbest(MaxGeneration, i) - Eaver) < 0.6754 * S0
		%count = count + 1;
	%end
%end
%P = count / n;
%if P > 0.95 && C < 0.35
	%disp('预测精度好');
%elseif P > 0.8 && p < 0.95 && C > 0.35 && C < 0.5
	%disp('预测精度合格');
%elseif P > 0.7 && P < 0.8 && C > 0.5 && C < 0.65
	%disp('预测精度勉强合格');
%else
	%disp('不合格');
%end



	

