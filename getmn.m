function b = getmn(m,n)
%select n numbers from m-number-set
a = rand(m,1);
[~,c] = sort(a);
b = c(1:n);