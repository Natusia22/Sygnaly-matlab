%H(f) = 1/pierwiastek z 1+e^2xT^2N(f)
%H(f) transmitacja filtru
%Tn(f) wielomian czybyszewa pierwszego rzędu Tn(f) = cos(cos^-1(f))
% e maksymalna falitostość, u mnie nie używana ze wzgledu na bibliotekę


% Definicja wartości liczby biegunów i częstotliwości granicznej
Ns = [2, 3, 4, 5, 6, 7, 8]; % różne wartości N, bieguny, filtry
f0s = [1, 10, 100]; % różne wartości f0, częstotliwość

% Pętle do przetestowania różnych przypadków
for i = 1:length(Ns)
    for j = 1:length(f0s)
        N = Ns(i);
        f0 = f0s(j);
        
        % Projektowanie filtra Czebyszewa typu I
        [b, a] = cheby1(N, 0.5, f0, 's'); % 's' dla dziedziny częstotliwości
        
        % Obliczenie zer i biegunów
        [z, p, ~] = tf2zp(b, a); %przekształcenie współczynników b i a, które opisują transmitancję filtra w dziedzinie czasu ciągłego, na ich odpowiedniki w dziedzinie częstotliwośc
        
        % Charakterystyka amplitudowo-częstotliwościowa
        figure;
        freqs(b, a, logspace(-1, 3, 1000)); % Generowanie charakterystyki
        title(['Charakterystyka amplitudowo-częstotliwościowa dla N = ' num2str(N) ', f0 = ' num2str(f0)]);
        xlabel('Częstotliwość');
        ylabel('Amplituda');
        grid on;
        legend('Czebyszew', 'Location', 'best');
    end
end

% Obliczenie biegunów i zer transmitancji (z, p)
%         omega_p = tan(pi * f0); % Częstotliwość graniczna w dziedzinie cyfrowej
%         n = 1:N;
%         epsilon = 0.5; % Parametr epsilon
% 
%         beta = 1 / (N * acosh(1 / epsilon)); % Współczynnik beta
% 
%         p = -omega_p * sin((2 * n - 1) * pi / (2 * N)) + 1i * beta * cos((2 * n - 1) * pi / (2 * N));
%         z = zeros(1, 0); % Filtr typu I ma zera w nieskończoności
% 
%         % Konwersja biegunów i zer na współczynniki a i b
%         b = poly(z); % Współczynniki licznika (zer)
%         a = poly(p); % Współczynniki mianownika (bieguny)
% 
%         % Normalizacja współczynników a i b
%         a = a / a(1); % Normalizacja mianownika
%         b = b / b(1); % Normalizacja licznika
% 
%         % Tworzenie charakterystyki amplitudowo-częstotliwościowej
%         omega = logspace(-1, 3, 1000); % Zakres częstotliwości
%         H = freqs(b, a, omega); % Transmitancja filtra