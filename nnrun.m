%输入记为1层神经元,1到2层网络记为1层网络
%netn:网络层数(非节点层数),net(k).lyn:第k层节点个数,net(k).w:权重矩阵,net(k).b:bias,data:列向量
%net(k).w:net(k + 1).lyn*net(k).lyn阶矩阵
%op(k).iv:k层中间计算结果(过fs前),op(k).end:k层输出结果(列向量)
function [op] = nnrun(netn,net,data)
    op(1).end = data;
    for k = 1:netn
        op(k + 1).iv = net(k).w*op(k).end + net(k + 1).b;
        op(k + 1).end = fs(op(k + 1).iv);
    end
end

