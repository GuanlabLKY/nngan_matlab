%%
%�����Ϊ1����Ԫ,1��2�������Ϊ1������
%netn:�������(�ǽڵ����),net(k).lyn:��k��ڵ����,net(k).w:Ȩ�ؾ���,net(k).b:bias,data:������
%net(k).w:net(k + 1).lyn*net(k).lyn�׾���
%op(k).iv:k���м������(��fsǰ),op(k).end:k��������(������)
%%
function net = resetnet(netn,lyn)
for k = 1:netn
    net(k).lyn = lyn(k);
    net(k).w = rand(lyn(k + 1),lyn(k)) - 0.5;
    net(k).b = rand(lyn(k),1) - 0.5;
end
net(netn + 1).lyn = lyn(netn + 1);
net(netn + 1).b = rand(lyn(netn + 1),1) - 0.5;