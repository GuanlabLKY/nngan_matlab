%�����Ϊ1����Ԫ,1��2�������Ϊ1������
%netn:�������(�ǽڵ����),net(k).lyn:��k��ڵ����,net(k).w:Ȩ�ؾ���,net(k).b:bias,data:������
%net(k).w:net(k + 1).lyn*net(k).lyn�׾���
%op(k).iv:k���м������(��fsǰ),op(k).end:k��������(������)
function [op] = nnrun(netn,net,data)
    op(1).end = data;
    for k = 1:netn
        op(k + 1).iv = net(k).w*op(k).end + net(k + 1).b;
        op(k + 1).end = fs(op(k + 1).iv);
    end
end

