%% Problem Set 6 ECE300 Mark Koszykowski

clc;
clear;
close all;
%% 3d

E_0 = 1;
E_b = 2 * E_0;
M = 8;

k = [20 12 8 8 4 4];
d = [2*sqrt(E_0) 2*sqrt(2*E_0) 4*sqrt(E_0) 2*sqrt(5*E_0) 6*sqrt(E_0) 2*sqrt(10*E_0)];

assert(length(k) == length(d));

a = k / M;
b = d.^2 / (2*E_b);

%% 3f

gamma_b_db = 2:.01:8;

gamma_b = 10 .^ (gamma_b_db / 10);

[b_min, min_i] = min(b);
a_min = a(min_i);

Pe_bound_min_term = a_min * qfunc(sqrt(b_min * gamma_b));

Pe_bound = zeros(1, length(gamma_b));
for i = 1:length(gamma_b)
    Pe_bound(i) = sum(a .* qfunc(sqrt(b .* gamma_b(i))));
end

figure;
semilogy(gamma_b_db, Pe_bound_min_term, gamma_b_db, Pe_bound);
title("SNR vs. {\itP_{b}}");
xlabel("{\it\gamma_{b}} ({\itdB})");
ylabel("\it{P_{b}}");
legend(["one term ({\itmin(\beta)})" "all terms"]);

ratio = @(P_one, P_all) 1 - (P_one / P_all);

disp("Ratio at 2dB: " + ratio(Pe_bound_min_term(1), Pe_bound(1)));
disp("Ratio at 8dB: " + ratio(Pe_bound_min_term(end), Pe_bound(end)));