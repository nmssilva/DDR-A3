% offered load of ro erlangs
% capacity of N units
lambda = 350;
invmiu = 95;
C = 1000;
M = 2;
ro = lambda/60 * invmiu;
N = C/M;

a= 1; p= 1;
for n= N:-1:1
 a= a*n/ro;
 p= p+a;
end
p= 1/p  %blocking prabability

a= N;
numerator= a;
for i= N-1:-1:1
 a= a*i/ro;
 numerator= numerator+a;
end
a= 1;
denominator= a;
for i= N:-1:1
 a= a*i/ro;
 denominator= denominator+a;
end
o= numerator/denominator;
%ocupacao media do servidor
o = M*o