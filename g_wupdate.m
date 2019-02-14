function net2 = g_wupdate(netn,pgnetn,op,net,aim,step)
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
    for s = 1:pgnetn
        net2(s).w = net2(s).w - net1(s).w*step;
        net2(s + 1).b = net2(s + 1).b - net1(s + 1).b*step;
    end
end