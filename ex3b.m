invmiu = 90;
p = 0.1;
S = 2;
lambda =8000/(7*24);
W = 5:5:80;
Ms = 2;
Mh = 5;
R = 10000;
N = 1000;

iterations = 40;
bSD = zeros(length(W), iterations);
bHD = zeros(length(W), iterations);
for j=1:length(W)
    for i=1:iterations
        [bsh, bhd] = simu2(lambda, p, invmiu, S, W(j), Ms, Mh, R, N);
        bSH(j, i) = bsh;
        bHD(j, i) = bhd;
    end
end