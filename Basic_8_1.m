clear all; close all;

fpr = 2000; 
f1 = 400; 
f2 = 600; 
N = 8; 
Rp = 3; 
Rs = 80;

% Filtr Butterwortha
[b_butter, a_butter] = butter(N, [f1, f2]/(fpr/2), 'stop');

% Filtr Chebysheva typu I
[b_cheby1, a_cheby1] = cheby1(N, Rp, [f1, f2]/(fpr/2), 'stop');

% Filtr Chebysheva typu II
[b_cheby2, a_cheby2] = cheby2(N, Rs, [f1, f2]/(fpr/2), 'stop');

% Filtr FIR
b_fir = fir1(N, [f1, f2]/(fpr/2), 'stop');
a_fir = 1;

% Sprawdzenie H(f) dla każdego filtra
Npunkt = 1000; 
freqz(b_butter, a_butter, Npunkt, fpr);
title('Butterworth Filter');

figure;
freqz(b_cheby1, a_cheby1, Npunkt, fpr);
title('Chebyshev Type I Filter');

figure;
freqz(b_cheby2, a_cheby2, Npunkt, fpr);
title('Chebyshev Type II Filter');

figure;
freqz(b_fir, a_fir, Npunkt, fpr);
title('FIR Filter');

% Wymagania dla sygnału
Nx = 1000; 
dt = 1/fpr; 
t = dt*(0:Nx-1); 
fx1 = 10; 
fx2 = 500;

% Generacja sygnału
x = sin(2*pi*fx1*t) + sin(2*pi*fx2*t);

% Filtracja sygnału dla każdego filtra
y_butter = filter(b_butter, a_butter, x);
y_cheby1 = filter(b_cheby1, a_cheby1, x);
y_cheby2 = filter(b_cheby2, a_cheby2, x);
y_fir = filter(b_fir, a_fir, x);

% Wyświetlenie wyników
figure;
subplot(2, 2, 1);
plot(t, x, 'b-', t, y_butter, 'r-');
title('Butterworth Filter');
legend('We', 'Wy');

subplot(2, 2, 2);
plot(t, x, 'b-', t, y_cheby1, 'r-');
title('Chebyshev Type I Filter');
legend('We', 'Wy');

subplot(2, 2, 3);
plot(t, x, 'b-', t, y_cheby2, 'r-');
title('Chebyshev Type II Filter');
legend('We', 'Wy');

subplot(2, 2, 4);
plot(t, x, 'b-', t, y_fir, 'r-');
title('FIR Filter');
legend('We', 'Wy');
