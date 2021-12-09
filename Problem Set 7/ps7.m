%% Problem Set 6 ECE300 Mark Koszykowski

clc;
clear;
close all;
%% 2


Rs = 1e6;
L = 16;
beta = 0.3;
span = 4;

p = rcosdesign(beta, span, L, "sqrt");

% a


N = length(p);

figure;
stem(0:N-1, p);
title("{\surdRC} (\beta=" + beta + ", span=" + span + ", L=" + L + ")");
xlabel("{\itn}");
ylabel("{\itp}[{\itn}]");
xlim([0 N-1]);

[~, kp_peak] = max(p);
disp("kp_peak = " + kp_peak);

% b


g = conv(p, fliplr(p));

figure;
stem(0:2*N-2, g);
title("{\surdRC} Matched Filter (\beta=" + beta + ", span=" + span + ", L=" + L + ")");
xlabel("{\itn}");
ylabel("{\itg}[{\itn}]");
xlim([0 2*N-2]);

[~, kp_peak] = max(g);

maxes = zeros(1, 8);

for i = 1:4
    maxes(2*(i-1) + 1) = g(kp_peak + i*L);
    maxes(2*(i-1) + 2) = g(kp_peak - i*L);
end

SIR = 20*log10(1/sum(abs(maxes)));
disp("SIR = " + SIR + "db");

% c


fs = L*Rs;

freq_points = linspace(0, Rs, 1000);

P = freqz(p, 1, freq_points, fs);
G = freqz(g, 1, freq_points, fs);

G_flipped = fliplr(G);

figure;
plot(freq_points, abs(P));
title("Magnitude Spectrum");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itP}({\itf})|");

figure;
plot(freq_points, abs(G), freq_points, abs(G_flipped), freq_points, abs(G_flipped)+abs(G));
title("Magnitude Spectrum");
legend(["|{\itG}({\itf})|", "|{\itG}({\itR_{s}}-{\itf})|", "|{\itG}({\itf})|+|{\itG}({\itR_{s}}-{\itf})|"]);
xlabel("{\itf} ({\itHz})");
ylabel("|{\itG}({\itf})|");

figure;
plot(freq_points, 20*log10(abs(G)), freq_points, 20*log10(abs(G_flipped)), ...
        freq_points, 20*log10(abs(G_flipped)+abs(G)));
title("Magnitude Spectrum");
legend(["|{\itG}({\itf})|", "|{\itG}({\itR_{s}}-{\itf})|", "|{\itG}({\itf})|+|{\itG}({\itR_{s}}-{\itf})|"]);
xlabel("{\itf} ({\itHz})");
ylabel("|{\itG}({\itf})| ({\itdB})");
ylim([-100 30]);