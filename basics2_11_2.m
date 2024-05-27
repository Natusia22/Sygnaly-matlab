% Parametry sygnału
Nx = 1000;
fs = 2000;
f0 = fs/40;

% Generowanie sygnału kosinusoidalnego
x = cos(2*pi*(f0/fs)*(0:Nx-1));

% Parametry filtru Hilberta
M = 50;
N = 2*M+1;
n = -M:M;
h = (1 - cos(pi*n)) ./ (pi*n);
h(M+1) = 0;

% Wyświetlanie odpowiedzi impulsowej filtra Hilberta
figure;
stem(n, h);
title('Odpowiedź impulsowa filtra Hilberta');
xlabel('n');
grid on;
pause;

% Okienkowanie odpowiedzi impulsowej
w = kaiser(N, 10)';
h = h .* w;

% Obliczanie odpowiedzi amplitudowo-częstotliwościowej i fazowo-częstotliwościowej filtra Hilberta
f = -fs/2 : fs/2000 : fs/2;
H1 = polyval(h(end:-1:1), exp(-1j*2*pi*f/fs));
H1 = H1 .* exp(1j*2*pi*f/fs*M);

H2 = freqz(h, 1, f, fs);

% Wykresy odpowiedzi amplitudowo-częstotliwościowej i fazowo-częstotliwościowej
figure;
subplot(2, 1, 1);
plot(f, 20*log10(abs(H1)));
grid on;
xlabel('f [Hz]');
title('Odpowiedź amplitudowo-częstotliwościowa filtra Hilberta');

subplot(2, 1, 2);
plot(f, unwrap(angle(H1)));
grid on;
xlabel('f [Hz]');
title('Odpowiedź fazowo-częstotliwościowa filtra Hilberta');

% Porównanie odpowiedzi fazowej z uwzględnieniem przesunięcia
figure;
plot(f, angle(exp(1j*2*pi*f/fs*M).*H1));
grid on;
xlabel('f [Hz]');
title('Odpowiedź fazowa z uwzględnieniem przesunięcia');

% Wyświetlanie sygnałów
figure;
subplot(2, 1, 1);
plot(1:Nx, x, 'b-', 1:Nx, abs(hilbert(x)), 'r--');
title('Sygnały x i Hilbert(x)');
legend('x', 'Hilbert(x)');

subplot(2, 1, 2);
plot(1:Nx, x, 'b-', 1:Nx, abs(imag(conv(x, h, 'same'))), 'r--');
title('Porównanie sygnałów x i Hilbert(x) z użyciem konwolucji');
legend('x', 'Hilbert(x)');

