function [show_rt_number,sr1,sr2,g_fig] = nnmultitest(aim_typen,type_kt_number,cg_number,ly1n,...
    test_data,g_data,inetn,inet,show_on)
ng = 1;
rt_number = zeros(2*aim_typen,2*aim_typen);%ÕıÈ·Êı
%ris1 = getrk(type_kt_number,type_kt_number);
ris1 = ones(type_kt_number,1);
ris2 = getrk(min(cg_number,type_kt_number),type_kt_number);
g_fig = zeros(cg_number,1);
for s = 1:type_kt_number
    if ris1(s) > 0
        for r = 1:10
            aim_n = r;
            ccn = (aim_n - 1)*100000 + s;
            %tn_data = train_data(ccn).data;
            tn_data = test_data(ccn).data;
            tn_data = double(tn_data);
            tn_data = wipe_off_average(tn_data);
            tx = reshape(tn_data,ly1n,1);
            op = nnrun(inetn,inet,tx);
            [~,r_aim] = max(op(inetn + 1).end);
            rt_number(aim_n,r_aim) = rt_number(aim_n,r_aim) + 1;
        end
    end
    if ris2(s) > 0
        aim_n = find(g_data(ng).aim == 1) + aim_typen;
        gn_data = g_data(ng).data;
        gn_data = double(gn_data);
        gn_data = wipe_off_average(gn_data);
        gx = reshape(gn_data,ly1n,1);
        op = nnrun(inetn,inet,gx);
        [~,r_aim] = max(op(inetn + 1).end);
        g_fig(ng) = r_aim;
        rt_number(aim_n,r_aim) = rt_number(aim_n,r_aim) + 1;
        ng = ng + 1;
    end
end
show_rt_number = show_rt(rt_number')';
sr1 = 0;
for s = 1:10
    sr1 = sr1 + show_rt_number(s + 10,s);
end
sr1 = sr1/10;
sr2 = 0;
for s = 1:10
    sr2 = sr2 + show_rt_number(s,s);
end
sr2 = sr2/10;
if show_on == 1
    subplot(1,3,3);
    imagesc(show_rt_number);
    pause(0.1);
end