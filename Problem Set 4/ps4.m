%% Problem Set 4 ECE300 Mark Koszykowski

clc;
clear;
close all;
%% 2

Fc = 10;
Fs = 100;

% a

t = 0:1/Fs:20;

% b

N = 4096;

f = -Fs/2:Fs/N:Fs/2 - Fs/N;

% c

m = 1 ./ (1 + (t - 10).^2);

M = pi * exp(-1j * 40 * pi * f) .* exp(-2 * pi * abs(f));

figure;

plot(f, mag2db(abs(M)));
title("{\itm}({\itt}) in Frequency Domain");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itM}({\itf})| (dB)");
xlim([-1 1]);

% d

modulation_indices = [.1 .9];

am_signals = zeros(length(modulation_indices), length(m));

figure;

for i = 1:length(modulation_indices)
    A = 1;
    ka = modulation_indices(i) / max(abs(m));
    
    am_signals(i, :) = A * (1 + ka * m) .* cos(2 * pi * Fc * t);
    
    subplot(2, 1, i);
    plot(t, am_signals(i, :), t, sqrt((1 + ka * m).^2));
    title("AM Signal (" + modulation_indices(i) * 100 + "% Modulation Index)");
    xlabel("{\itt} ({\its})");
    ylabel("{\itx}({\itt})");
end

figure;

for i = 1:length(modulation_indices)
   subplot(2, 2, 2*(i - 1) + 1);
   plot(f, mag2db(abs(fftshift(fft(am_signals(i, :), N)))));
   title("Frequency Spectrum (" + modulation_indices(i) * 100 + "% Modulation Index)");
   xlabel("{\itf} ({\itHz})");
   ylabel("|{\itX}({\itf})| (dB)");
   
   subplot(2, 2, 2*(i - 1) + 2);
   plot(f, mag2db(abs(fftshift(fft(am_signals(i, :), N)))));
   title("Frequency Spectrum (" + modulation_indices(i) * 100 + "% Modulation Index)");
   xlabel("{\itf} ({\itHz})");
   ylabel("|{\itX}({\itf})| (dB)");
   xlim([8 12]);
end

% e

m_hat = (t - 10) ./ (1 + (t - 10).^2);

cos_c = cos(2 * pi * Fc * t);
sin_c = sin(2 * pi * Fc * t);

dsb = m .* cos_c;
ussb = m .* cos_c - m_hat .* sin_c;
lssb = m .* cos_c - -m_hat .* sin_c;

figure;

subplot(3, 1, 1);
plot(t, dsb, t, sqrt(m.^2));
title("DSB-SC");
xlabel("{\itt} ({\its})");
ylabel("{\itx}({\itt})");

subplot(3, 1, 2);
plot(t, ussb, t, sqrt(m.^2 + m_hat.^2));
title("USSB");
xlabel("{\itt} ({\its})");
ylabel("{\itx}({\itt})");

subplot(3, 1, 3);
plot(t, lssb, t, sqrt(m.^2 + (-m_hat).^2));
title("LSSB");
xlabel("{\itt} ({\its})");
ylabel("{\itx}({\itt})");

% g

dsb_spectrum = fftshift(fft(dsb, N));

figure;

subplot(3, 2, 1);
plot(f, mag2db(abs(dsb_spectrum)));
title("DSB-SC Spectrum");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})| (dB)");

subplot(3, 2, 2);
plot(f, mag2db(abs(dsb_spectrum)));
title("DSB-SC Spectrum");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})| (dB)");
xlim([8 12]);

subplot(3, 2, 3);
plot(f, mag2db(abs(fftshift(fft(ussb, N)))));
title("USSB Spectrum");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})| (dB)");

subplot(3, 2, 4);
plot(f, mag2db(abs(fftshift(fft(ussb, N)))));
title("USSB Spectrum");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})| (dB)");
xlim([8 12]);

subplot(3, 2, 5);
plot(f, mag2db(abs(fftshift(fft(lssb, N)))));
title("LSSB Spectrum");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})| (dB)");

subplot(3, 2, 6);
plot(f, mag2db(abs(fftshift(fft(lssb, N)))));
title("LSSB Spectrum");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})| (dB)");
xlim([8 12]);

% h

A = 1;
kf = .5;
phi = 0;

v = pi / 2 + atan(t - 10);

fm  = A * cos(2 * pi * Fc * t + 2 * pi * kf * v + phi);

figure;

subplot(2, 1, 1);
plot(t, fm);
title("FM Signal");
xlabel("{\itt} ({\its})");
ylabel("{\itx}({\itt})");

subplot(2, 1, 2);
plot(t, fm);
title("FM Signal");
xlabel("{\itt} ({\its})");
ylabel("{\itx}({\itt})");
xlim([8 12]);

% i

figure;

fm_spectrum = fftshift(fft(fm, N));

subplot(2, 1, 1);
plot(f, mag2db(abs(fm_spectrum)));
title("Frequency Spectrum of FM Signal");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})| (dB)");

subplot(2, 1, 2);
plot(f, mag2db(abs(fm_spectrum)));
title("Frequency Spectrum of FM Signal");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})| (dB)");
xlim([8 12]);

% j

figure;

plot(f, abs(dsb_spectrum) / max(abs(dsb_spectrum)), f, abs(fm_spectrum) / max(abs(fm_spectrum)));
title("Spectrum of DSB-SC and FM");
xlabel("{\itf} ({\itHz})");
ylabel("|{\itX}({\itf})|");
legend("DSB-SC", "FM");
xlim([8 12]);