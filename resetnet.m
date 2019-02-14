%%
%输入记为1层神经元,1到2层网络记为1层网络
%netn:网络层数(非节点层数),net(k).lyn:第k层节点个数,net(k).w:权重矩阵,net(k).b:bias,data:列向量
%net(k).w:net(k + 1).lyn*net(k).lyn阶矩阵
%op(k).iv:k层中间计算结果(过fs前),op(k).end:k层输出结果(列向量)
%%
function net = resetnet(netn,lyn)
for k = 1:netn
    net(k).lyn = lyn(k);
    net(k).w = rand(lyn(k + 1),lyn(k)) - 0.5;
    net(k).b = rand(lyn(k),1) - 0.5;
end
net(netn + 1).lyn = lyn(netn + 1);
net(netn + 1).b = rand(lyn(netn + 1),1) - 0.5;