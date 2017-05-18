G= [ 1 2
     1 3
     1 4
     1 5
     1 6
     1 14
     1 15
     2 3
     2 4
     2 5
     2 7
     2 8
     3 4
     3 5
     3 8
     3 9
     3 10
     4 5
     4 10
     4 11
     4 12
     4 13
     5 12
     5 13
     5 14
     6 7
     6 16
     6 17
     6 18
     6 19
     7 19
     7 20
     8 9
     8 21
     8 22
     9 10
     9 22
     9 23
     9 24
     9 25
     10 11
     10 26
     10 27
     11 27
     11 28
     11 29
     11 30
     12 30
     12 31
     12 32
     13 14
     13 33
     13 34
     13 35
     14 15
     14 36
     14 37
     14 38
     15 16
     15 39
     15 40];

for j = 6:40
    I(j, j) = 0;
    
    for i = 1:40
        if i ~= j
            for k = 1:length(G)
                if (G(k, 1) == j && G(k, 2) == i) || (G(k, 2) == j && G(k, 1) == i)
                    I(j, i) = 1;
                    for l = 1:length(G)
                        if G(l, 1) == i
                            n = G(l,2);
                            if I(j, n) == -1
                                I(j, n) = 2;
                            end;
                        elseif G(l, 2) == i
                            n = G(l,1);
                            if I(j, n) == -1
                                I(j, n) = 2;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

%OPEX costs
costT2 = 8;
costT3 = 6;

%Number of AS
n = 40;

%---------------------------------------------
% Write LP file to be run at
% https://neos-server.org/neos/solvers/lp:CPLEX/LP.html
%---------------------------------------------
file = fopen('problem.lp','w');

%Minimize cost
fprintf(file, 'Minimize\n');
for j = 6:15
    fprintf(file, ' + %d x%d', costT2, j);
end;
for j = 16:40
    fprintf(file, ' + %d x%d', costT3, j);
end;

%Constrains
fprintf(file, '\nSubject To\n');

%sum Yji = 4
for j = 6:40
    for i = 6:40
        if I(j, i) > -1
            fprintf(file, ' + y%d,%d' ,j ,i);
        end
    end
    fprintf(file, ' = 1\n');
end

%Yji <= Xi
for j = 6:40
    for i = 6:40
        if I(j, i) > -1
            fprintf(file,' + y%d,%d - x%d <= 0\n', j, i, i);
        end;
    end
end

%Binary variables
fprintf(file, 'Binary\n');
for j = 6:40
    fprintf(file, ' x%d\n', j);
    for i = 6:40
        if I(j, i) > -1
            fprintf(file, ' y%d,%d\n', j, i);
        end;
    end;
end;

%End
fprintf(file, 'End\n');
fclose(file);

%Configuration
file = fopen('display.txt','w');
fprintf(file, 'display solution variables -');
fclose(file);

%% C

AS = [9, 14, 19, 30];
cost = 28;

S = zeros(40, 1);

for i = 1:length(S)
    closer = -1;
    for j = 1:length(AS)
        if I(AS(j), i) ~= -1
            if closer == -1 || I(AS(j), i) < I(closer, i)
                closer = AS(j);
            end;
        end;
    end;
    
    S(i) = closer;
end;

subs = zeros(length(AS), 1);
server = zeros(length(AS), 1);

totalServers = 25;

subsT2 = 2500;
subsT3 = 1000;

for i = 1:length(AS)
    S(S == AS(i)) = i;
end;

%Calculate how many subs per AS
for i = 6:15
    subs(S(i)) = subs(S(i)) + subsT2;
end;
for i = 16:40
    subs(S(i)) = subs(S(i)) + subsT3;
end;

totalSubscrivers = sum(subs);

%How many server to place in each AS
for i = 1:length(AS)
    server(i) = round(totalServers * subs(i)/totalSubscrivers);
end;

for i = 1:length(AS)
    fprintf('%d;', AS(i));
end;
fprintf('\n');
for i = 1:length(AS)
    fprintf('%d;', subs(i));
end;
fprintf('\n');
for i = 1:length(AS)
    fprintf('%d;', server(i));
end;
fprintf('\n');