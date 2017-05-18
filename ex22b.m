lambda = 300;
invmiu = 95;
C = 1000;
M = 2;

R = 100000;
N = 1000;

No = 10; %número de simulações
results= zeros(No, 2); %vetor com os N resultados de simulação
for it= 1:No
[results(it,1) results(it, 2)]= simu1(lambda,invmiu,C,M,R,N);
end

alfa= 0.1; %intervalo de confiança a 90%
media = mean(results(:,1));
termo = norminv(1-alfa/2)*sqrt(var(results(:,1))/No);
fprintf('p(b) = %.2e +- %.2e\n',media,termo);

alfa= 0.1; %intervalo de confiança a 90%
media = mean(results(:,2));
termo = norminv(1-alfa/2)*sqrt(var(results(:,2))/No);
fprintf('p(o) = %.2e +- %.2e\n',media,termo);
