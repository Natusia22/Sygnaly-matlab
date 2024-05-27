% Parametry sygnału
Nx = 1000;
fs = 2000;
f0 = fs/40;

% Generowanie sygnału kosinusoidalnego
x = cos(2*pi*(f0/fs)*(0:Nx-1));

% Obliczanie sygnału analitycznego za pomocą funkcji hilbert
xa1 = hilbert(x);

% Obliczanie sygnału analitycznego za pomocą definicji odpowiedzi częstotliwościowej filtra Hilberta
X = fft(x);
n = 1:Nx/2;
X(n) = -1j * X(n); % dodatnie częstotliwości
X(1) = 0;
X(Nx/2+1) = 0;
n = Nx/2+2:Nx;
X(n) = 1j * X(n); % ujemne częstotliwości
xH = real(ifft(X));
xa2 = x + 1j*xH; % sygnał analityczny

% Wyświetlanie sygnałów
figure;
subplot(3, 1, 1);
plot(1:Nx, x, 'b-', 1:Nx, xH, 'r--');
title('Sygnały x i xH');
legend('x', 'xH');

subplot(3, 1, 2);
plot(1:Nx, x, 'b-', 1:Nx, abs(xa1), 'r--');
title('Porównanie sygnałów xa1 i x');

subplot(3, 1, 3);
plot(1:Nx, abs(xa1), 'b-', 1:Nx, abs(xa2), 'r--');
title('Porównanie sygnałów xa1 i xa2');

% Wykreślenie punktów w pętli z opóźnieniem
figure;
for n = 1:100
    plot(x(n), xH(n), 'bo');
    hold on;
    pause(0.05);
end
title('Punkty w pętli');

% Obliczanie i wyświetlanie widm FFT
X_fft = fft(x);
Xa1_fft = fft(xa1);

figure;
subplot(2, 1, 1);
plot(1:Nx, abs(X_fft), 'b-', 1:Nx, abs(Xa1_fft), 'r--');
title('Widma FFT sygnału x i xa1');
legend('FFT(x)', 'FFT(xa1)');

% Wczytanie sygnału mowy
% Wczytaj swój własny plik audio lub użyj funkcji audioread do wczytania sygnału mowy
% [audio, fs_audio] = audioread('nazwa_pliku_audio.wav');

% Obliczanie sygnału analitycznego dla sygnału mowy
% xa_mowa = hilbert(audio);
% Xa_mowa_fft = fft(xa_mowa);

% subplot(2, 1, 2);
% plot(1:length(audio), abs(fft(audio)), 'b-', 1:length(audio), abs(Xa_mowa_fft), 'r--');
% title('Widma FFT sygnału mowy i xa_mowa');
% legend('FFT(audio)', 'FFT(xa_mowa)');
