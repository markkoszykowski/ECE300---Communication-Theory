%% Problem Set 1 ECE300 Mark Koszykowski

clc;
clear;
close all;
%% 3f

A = 1;
W = 1;

range = 3;

f = -range:.001:range;
t = -range:.001:range;

pi_func = @(x) rectangularPulse(x);

X = (A/(2*W)) * (1 + cos((pi*f)/W)) .* pi_func(f/(2*W));

x = A*(sinc(2*W*t) + (1/2)*sinc(2*W*(t - (1/(2*W)))) + (1/2)*sinc(2*W*(t + (1/(2*W)))));

figure
subplot(2,1,1);
plot(f, X);
xticks(-range:(1/(2*W)):range);
title("X({\itf}), A=" + A + ", W=" + W);
xlabel("\itf");
ylabel("X({\itf})");

subplot(2,1,2);
plot(t, x);
xticks(-range:(1/(2*W)):range);
title("x({\itt}), A=" + A + ", W=" + W);
xlabel("\itt");
ylabel("x({\itt})");