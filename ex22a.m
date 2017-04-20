lambda = 1;
invmiu = 90;
C = 10;
M = 2;

R = 10000;

N = 20; %número de simulações
results= zeros(1,N); %vetor com os N resultados de simulação
for it= 1:N
results(it)= simu1(lambda,invmiu,C,M,R);
end

alfa= 0.1; %intervalo de confiança a 90%
media = (results);
termo = norminv(1-alfa/2)*sqrt(var(results)/N);
fprintf('resultado = %.2e +- %.2e\n',media,termo)

