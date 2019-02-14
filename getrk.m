function u = getrk(k,n)
%从n个数中随机抽取k个
%生成结果为行向量
if k > n
    u = ones(1,n);
else
    a = rand(n,1);
    [~,c] = sort(a);
    b = c(1:k);
    u = zeros(1,n);
    for q = 1:k
        u(b(q)) = 1;
    end
end