invmiu = 90;
p = 0.2;
S = 1:6;
S = repmat(S, 1, 3)';
W = [repmat([40], 6, 1); repmat([50], 6, 1); repmat([60], 6, 1)];
lambda =17000 / (7 * 24);
Ms = 2;
Mh = 5;
R = 10000;
N = 1000;

iterations = 40;
bsD = zeros(length(W), iterations);
bHD = zeros(length(W), iterations);

for j = 1:length(W)
    for i = 1:iterations
        [sd, hd] = simu2(lambda, p, invmiu, S, W(j), Ms, Mh, R, N);
        bsD(j, i) = sd;
        bHD(j, i) = hd;
    end
    
    fprintf('%d;%d;', W(j), S(j));
    fprintf('%.6f;', mean(bsD(j, :)));
    fprintf('%.6f\n', mean(bHD(j, :)));
end