function net = d_g_nntrain(tn_data,aim,netn,pgnetn,net,step,drop,dropn)
%drop out gan train
ly1n = net(1).lyn;
tn_data = double(tn_data);
tn_data = wipe_off_average(tn_data);
tx = reshape(tn_data,ly1n,1);
c(1).index = 1:net(1).lyn;
net1(1).lyn = net(1).lyn;
for k = 1:dropn - 1
    net1(k + 1).lyn = round(net(k + 1).lyn*drop);
    c(k + 1).index = getmn(net(k + 1).lyn,net1(k + 1).lyn);
end
for k = dropn:netn
    c(k + 1).index = 1:net(k + 1).lyn;
    net1(k + 1).lyn = net(k + 1).lyn;
end
for k = 1:dropn
    for r = 1:net1(k).lyn
        r1 = c(k).index(r);
        net1(k).w(1:net1(k + 1).lyn,r) = net(k).w(c(k + 1).index(1:net1(k + 1).lyn),r1);
    end
    net1(k).b(1:net1(k).lyn,1) = net(k).b(c(k).index(1:net1(k).lyn));
end
for k = dropn + 1:netn
    net1(k).w = net(k).w;
    net1(k).b(1:net1(k).lyn,1) = net(k).b(1:net1(k).lyn);
end
net1(netn + 1).b(1:net1(netn + 1).lyn,1) = net(netn + 1).b(1:net1(netn + 1).lyn);
op = nnrun(netn,net1,tx);
net1 = g_wupdate(netn,pgnetn,op,net1,aim,step);
for k = 1:dropn
    for r = 1:net1(k).lyn
        r1 = c(k).index(r);
        net(k).w(c(k + 1).index(1:net1(k + 1).lyn),r1) = net1(k).w(1:net1(k + 1).lyn,r);
    end
    net(k).b(c(k).index(1:net1(k).lyn)) = net1(k).b(1:net1(k).lyn,1);
end
for k = dropn + 1:netn
    net(k).w = net1(k).w;
    net(k).b(1:net1(k).lyn) = net1(k).b(1:net1(k).lyn,1);
end
net(netn + 1).b(1:net1(netn + 1).lyn) = net1(netn + 1).b(1:net1(netn + 1).lyn,1); 
end