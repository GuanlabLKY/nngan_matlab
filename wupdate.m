%%
%error = sigma(aim - op)^2
%输入记为1层神经元,1到2层网络记为1层网络
%netn:网络层数,net(k).lyn:第k层节点个数,net(k).w:权重矩阵,net(k).b:bias
%net(k).w:net(k + 1).lyn*net(k).lyn阶矩阵
%op(k).iv:k层中间计算结果(过fs前),op(k).end: k层输出结果(列向量)
%aim:最后一层目标(列向量)
%%
function net2 = wupdate(netn,op,net,aim,step)
    enet = net;
    net1 = net;
    net2 = net;
    for k = 1:netn
        y(k + 1).iv = fs1(op(k + 1).iv);
        for r = 1:net(k+1).lyn
            enet(k).w(r,:) = net(k).w(r,:)*y(k + 1).iv(r);
        end
    end
    wn = 2*(op(netn + 1).end - aim)';
    for k = netn:-1:1
        if k < netn
            wn = wn*enet(k + 1).w;
        end
        a = wn'.*y(k + 1).iv;
        b = a*op(k).end';
        net1(k).w = b;
        %net1(k + 1).b = wn'.*y(k + 1).iv(r);
        net1(k + 1).b = wn'.*y(k + 1).iv;
    end
    for s = 1:netn
        net2(s).w = net2(s).w - net1(s).w*step;
        net2(s + 1).b = net2(s + 1).b - net1(s + 1).b*step;
    end
end