lambda = 47.619;
p = 0.1;
invmiu = 90;
S = 2;
W = 9;
Ms = 2;
Mh = 5;

R = 10000;
N = 1000;
list=[];
for W = 0:250
fprintf('W= %d\n', W);
No = 10; %n�mero de simula��es
results= zeros(No, 2); %vetor com os N resultados de simula��o
for it= 1:No
[results(it,1) results(it, 2)] = simu2( lambda, p, invmiu, S, W, Ms, Mh, R, N);
end


alfa= 0.1; %intervalo de confian�a a 90%
media = mean(results(:,1));
termo = norminv(1-alfa/2)*sqrt(var(results(:,1))/No);
%fprintf('p(bs) = %.2e +- %.2e\n',media,termo);

alfa= 0.1; %intervalo de confian�a a 90%
media = mean(results(:,2));
termo = norminv(1-alfa/2)*sqrt(var(results(:,2))/No);
%fprintf('p(bh) = %.2e +- %.2e\n',media,termo);
list=[list; mean(results(:,1)) mean(results(:,2))];
end

aux=find(list==min(list));
list(aux)