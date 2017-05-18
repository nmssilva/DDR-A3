invmiu = 90;
R = 10000;
N = 1000;
Ms = 2;
Mh = 5;

p = 0.2;
lambda = 2 * subscribers / (7 * 24);
S = 20:30;
W = 95;

iterations = 40;
bSD = zeros(length(W), iterations);
bHS = zeros(length(W), iterations);

for j = 1:length(S)
    for i = 1:iterations
        [bsh, bhd] = simu2(lambda, p, invmiu, S(j), W, Ms, Mh, R, N);
        bSD(j, i) = bsd;
        bHS(j, i) = bhd;
    end
    
    fprintf('%d;', S(j));
    fprintf('%.6f;', mean(bSD(j, :)));
    fprintf('%.6f\n', mean(bHS(j, :)));
end