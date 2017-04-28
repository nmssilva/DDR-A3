lambda = 1;
invmiu = 90;
C = 10;
M = 2;

R = 10000;

No = 100; %n�mero de simula��es
results= zeros(No, 2); %vetor com os N resultados de simula��o
for it= 1:No
[results(it,1) results(it, 2)]= simu1(lambda,invmiu,C,M,R,N);
end

alfa= 0.1; %intervalo de confian�a a 90%
media = mean(results(:,1));
termo = norminv(1-alfa/2)*sqrt(var(results(:,1))/No);
fprintf('p(b) = %.2e +- %.2e\n',media,termo);

alfa= 0.1; %intervalo de confian�a a 90%
media = mean(results(:,2));
termo = norminv(1-alfa/2)*sqrt(var(results(:,2))/No);
fprintf('p(o) = %.2e +- %.2e\n',media,termo);
