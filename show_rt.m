function y = show_rt(a)
[xa,ya] = size(a);
y = zeros(xa,ya);
ma = sum(a);
for k = 1:ya
    if ma(k) > 0
        y(1:xa,k) = a(1:xa,k)/ma(k);
    end
end