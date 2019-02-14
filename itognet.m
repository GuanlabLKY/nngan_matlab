function gnet1 = itognet(gnet,inet,gnetn,inetn)
gnet1 = gnet;
for k = 1:inetn
    k1 = k + gnetn - inetn;
    gnet1(k1).w = inet(k).w;
    gnet1(k1 + 1).b = inet(k + 1).b;
end