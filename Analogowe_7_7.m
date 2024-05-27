Ns = [2, 3, 4, 5, 6, 7, 8]; % różne wartości N, bieguny
f0s = [1, 10, 100]; % różne wartości f0, częstotliwość

% Pętle do przetestowania różnych przypadków
for i = 1:length(Ns)
    for j = 1:length(f0s)
        N = Ns(i);
        f0 = f0s(j);
        
        % Obliczenie biegunów i zer transmitancji (z, p)
        omega_p = tan(pi * f0); % Częstotliwość graniczna w dziedzinie cyfrowej
        n = 1:N;
        epsilon = 0.5; % Parametr epsilon
        
        beta = 1 / (N * acosh(1 / epsilon)); % Współczynnik beta
        
        p = -omega_p * sin((2 * n - 1) * pi / (2 * N)) + 1i * beta * cos((2 * n - 1) * pi / (2 * N));
        z = zeros(1, 0); % Filtr typu I ma zera w nieskończoności
        
        % Konwersja biegunów i zer na współczynniki a i b
        b = poly(z); % Współczynniki licznika (zer)
        a = poly(p); % Współczynniki mianownika (bieguny)
        
        % Normalizacja współczynników a i b
        a = a / a(1); % Normalizacja mianownika
        b = b / b(1); % Normalizacja licznika
        
        % Tworzenie charakterystyki amplitudowo-częstotliwościowej
        omega = logspace(-1, 3, 1000); % Zakres częstotliwości
        H = freqs(b, a, omega); % Transmitancja filtra
        
        % Wyświetlenie charakterystyki amplitudowo-częstotliwościowej
        figure;
        semilogx(omega, 20*log10(abs(H)));
        title(['Charakterystyka amplitudowo-częstotliwościowa dla N = ' num2str(N) ', f0 = ' num2str(f0)]);
        xlabel('Częstotliwość');
        ylabel('Amplituda (dB)');
        grid on;
    end
end
