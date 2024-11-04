function S=SM_simpson_int(f, res)
n=length(f);
%h=f(2)-f(1);

if mod(n, 2)==0
    s1=2*sum(f(3:2:n));
    s2=4*sum(f(2:2:n-2));    
else
    s1=2*sum(f(3:2:n-1));
    s2=4*sum(f(2:2:n));   
end

S=(res/3)*(f(1)+s1+s2+f(end));
    