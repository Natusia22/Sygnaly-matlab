% Częstotliwości składowych sygnału
f1 = 300; % częstotliwość do usunięcia
f2 = 400; % częstotliwość do wzmocnienia

% Częstotliwość próbkowania
Fs = 1000; % dla przykładu

% Tworzenie filtru
N = 100; % długość filtra

% Normalizacja częstotliwości
normalized_f1 = f1 / (Fs/2);
normalized_f2 = f2 / (Fs/2);

% Tworzenie wektora częstotliwości dla funkcji fir1
frequencies = [normalized_f1, normalized_f2];
amplitudes = [1, 1]; % charakterystyka amplitudowa

% Projektowanie filtru FIR
b = fir1(N, frequencies);

% Wyświetlanie odpowiedzi impulsowej filtru
figure;
stem(b);
title('Odpowiedź impulsowa filtra');

% Wyświetlanie charakterystyki amplitudowej filtra
figure;
freqz(b, 1, 1024, Fs);
title('Charakterystyka amplitudowa filtra');