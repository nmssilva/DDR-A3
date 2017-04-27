lambda = 50;
p = 0.4;
invmiu = 90;
S = 3;
W = 240;
Ms = 2;
Mh = 5;

R = 10000;
N = 1000;

No = 40; %número de simulações
results= zeros(No, 2); %vetor com os N resultados de simulação
for it= 1:No
[results(it,1) results(it, 2)] = simu2( lambda, p, invmiu, S, W, Ms, Mh, R, N);
end

alfa= 0.1; %intervalo de confiança a 90%
media = mean(results(:,1));
termo = norminv(1-alfa/2)*sqrt(var(results(:,1))/No);
fprintf('p(bs) = %.2e +- %.2e\n',media,termo);

alfa= 0.1; %intervalo de confiança a 90%
media = mean(results(:,2));
termo = norminv(1-alfa/2)*sqrt(var(results(:,2))/No);
fprintf('p(bh) = %.2e +- %.2e\n',media,termo);