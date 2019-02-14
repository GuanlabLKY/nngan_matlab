function net = nntrain(train_data,ccn,aim,netn,net,step)
ly1n = net(1).lyn;
tn_data = train_data(ccn).data;
tn_data = double(tn_data);
tn_data = wipe_off_average(tn_data);
tx = reshape(tn_data,ly1n,1);
op = nnrun(netn,net,tx);
net = wupdate(netn,op,net,aim,step);
end