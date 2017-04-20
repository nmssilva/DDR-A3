lambda = 1;
invmiu = 90;
C = 10;
M = 2;

R = 10000;

No = 100; %n�mero de simula��es
results= zeros(1,No); %vetor com os N resultados de simula��o
for it= 1:No
results(it)= simu1(lambda,invmiu,C,M,R,N);
end

alfa= 0.1; %intervalo de confian�a a 90%
media = (results);
termo = norminv(1-alfa/2)*sqrt(var(results)/No);
fprintf('resultado = %.2e +- %.2e\n',media,termo)

