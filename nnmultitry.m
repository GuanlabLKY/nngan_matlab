%对抗网络
start = 1;
if start == 0
    clear all;
    load('data.mat');
    ly1n = 28^2;
    ly2n = 87;%
    ly3n = 2*10;
    aim_typen = ly3n/2;
    multi = 5;
    g_type = 3;%(multi,g_type) = 1
    inh = 5;
    inh_type = g_type;
    gy1n = multi*aim_typen*g_type + inh*inh_type;%50
    gy2n = 30;
    gy3n = 60;%200
    dropn = 4;
    drop = 0.1;
    inetn = 2;
    gnetn = 5;
    ilyn = [ly1n,ly2n,ly3n];
    glyn = [gy1n,gy2n,gy3n,ly1n,ly2n,ly3n];
    inet = resetnet(inetn,ilyn);
    gnet = resetnet(gnetn,glyn);
    niter = 4000;
    type_kn_number = 4000;
    type_kt_number = 800;
end
%istepn = 30;%identification network
istepn = 200;%20
gstepn = 20;%generate network
max_g = 10;
max_c = 10000;
ci_number = 30;%要修改
cg_number = aim_typen*g_type;%要修改
fig1 = figure;
set(gcf,'position',[10 50 1800 700]);
for k = 1:niter
    k
    tic;
    %gstep = 10^(-1)/k^(1/4);
    gstep = 10^(0);
    %istep = 10^(-2)/k^(1/4);
    istep = 10^(-3);
    %生成网络训练
    drop = 0.8;
    for v = 1:max_c
        v
        for r = 1:cg_number
            %gr1 = round(rand(gy1n - aim_typen,1));
            %gr2 = getrk(1,aim_typen)';%末10位表示数字
            s1 = mod(r,aim_typen) + 1;
            s2 = mod(r,g_type) + 1;
            gr2 = zeros(aim_typen,1);
            gr2(s1) = 1;
            %gr1 = rand(multi*aim_typen,1) + 0.2;
            gr1 = zeros(multi*aim_typen*g_type,1);
            gr1(multi*((s1 - 1)*g_type + (s2 - 1)) + 1:multi*((s1 - 1)*g_type + s2)) = 1.2;
            g_noise(r).aim = [gr2;zeros(aim_typen,1)];
            g_inh = zeros(inh*inh_type,1);
            g_inh((s2 - 1)*inh + 1:s2*inh) = floor(rand(inh,1) + 1/k^(1/2));
            g_noise(r).data = [gr1;g_inh];
        end
        for r = 1:gstepn
            if k == 1
                break;
            end
            for s = 1:cg_number
                s1 = mod(s,aim_typen) + 1;
                if s1 ~= g_fig(s)
                    aim = g_noise(s).aim;
                    tn_data = g_noise(s).data;
                    gnet = d_g_nntrain(tn_data,aim,gnetn,gnetn - inetn,gnet,gstep,drop,dropn);
                end
            end
        end
        for r = 1:cg_number
            g_data(r).data = zeros(ly1n,1);
            g_rnoise = g_noise(r).data;
            ag = nnrun(gnetn - inetn,gnet,g_rnoise);
            g_data(r).data(1:ly1n) = ag(gnetn - inetn + 1).end(1:ly1n);
            g_data(r).aim = g_noise(r).aim;
        end
        for r = 1:4
            cr = 10;
            r1 = 2*r - 1 + cr;
            r2 = 2*r + cr;
            g_fig = reshape(g_data(r1).data,28,28);
            subplot(4,6,6*(r - 1) + 1);
            imagesc(g_fig);colormap('gray');
            gn = find(g_noise(r1).aim == 1);
            gccn = (gn - 1)*100000 + floor(rand(1)*type_kn_number + 1);
            subplot(4,6,6*(r - 1) + 2);
            real_fig = reshape(train_data(gccn).data,28,28);
            imagesc(real_fig);colormap('gray');
            g_fig = reshape(g_data(r2).data,28,28);
            subplot(4,6,6*(r - 1) + 3);
            imagesc(g_fig);colormap('gray');
            gn = find(g_noise(r2).aim == 1);
            gccn = (gn - 1)*100000 + floor(rand(1)*type_kn_number + 1);
            subplot(4,6,6*(r - 1) + 4);
            real_fig = reshape(train_data(gccn).data,28,28);
            imagesc(real_fig);colormap('gray');
        end
        pause(0.1);
        [~,sr1,sr2,g_fig] = nnmultitest(aim_typen,type_kt_number,cg_number,ly1n,...
            test_data,g_data,inetn,inet,1);
        if sr1 >= sr2 + 0.05
            break;
        end
        if k == 1
            break;
        end
    end
    toc;
    tic;
    %识别网络训练
    drop = 0.5;
    for v = 1:max_c
        v
        for r = 1:istepn
            ris1 = getrk(ci_number,type_kn_number);
            ris2 = getrk(cg_number,type_kn_number);
            ng = 1;
            for s = 1:type_kn_number
                if ris1(s) > 0
                    aim = [getrk(1,aim_typen)';zeros(aim_typen,1)];
                    aim_n = find(aim == 1) - 1;
                    ccn = s + aim_n*100000;
                    inet = nntrain(train_data,ccn,aim,inetn,inet,istep);
                end
                if ris2(s) > 0
                    aim1 = g_data(ng).aim;
                    aim = zeros(2*aim_typen,1);
                    aim(aim_typen + 1:2*aim_typen) = aim1(1:aim_typen);
                    inet = i_nntrain(g_data,ng,aim,inetn,inet,istep);
                    ng = ng + 1;
                end
            end
        end
        gnet = itognet(gnet,inet,gnetn,inetn);
        %验证
        [~,sr1,sr2,~] = nnmultitest(aim_typen,type_kt_number,cg_number,ly1n,...
            test_data,g_data,inetn,inet,0);
        if sr1 <= sr2 && sr2 > 0.8
            break;
        end
    end
    toc;
    save all
end