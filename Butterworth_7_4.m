% Projektowanie dolnoprzepustowego i górnoprzepustowego filtru Butterwortha

% Parametry
f0 = 1; % Częstotliwość odcięcia (Hz)
N_values = 2:10; % Wartości N (stopnie filtru)

% Dolnoprzepustowy filtr Butterwortha
figure;
for N = N_values
    [b, a] = butter(N, 2*pi*f0, 'low', 's');
    
    % Charakterystyka transmitancji
    subplot(2, 1, 1);
    zplane(b, a);
    title(['Transmitancja dolnoprzepustowego filtra Butterwortha, N = ' num2str(N)]);
    hold on;
    
    % Charakterystyka amplitudowo-częstotliwościowa
    [H, f] = freqs(b, a, logspace(-1, 2, 1000));
    subplot(2, 1, 2);
    semilogx(f, 20*log10(abs(H)));
    hold on;
end

subplot(2, 1, 1);
legend(arrayfun(@(N) ['N = ' num2str(N)], N_values, 'UniformOutput', false));
hold off;

subplot(2, 1, 2);
title('Charakterystyka amplitudowo-częstotliwościowa dla dolnoprzepustowego filtra Butterwortha');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda (dB)');
legend(arrayfun(@(N) ['N = ' num2str(N)], N_values, 'UniformOutput', false));
hold off;

% Górnoprzepustowy filtr Butterwortha
figure;
for N = N_values
    [b, a] = butter(N, 2*pi*f0, 'high', 's');
    
    % Charakterystyka transmitancji
    subplot(2, 1, 1);
    zplane(b, a);
    title(['Transmitancja górnoprzepustowego filtra Butterwortha, N = ' num2str(N)]);
    hold on;
    
    % Charakterystyka amplitudowo-częstotliwościowa
    [H, f] = freqs(b, a, logspace(-1, 2, 1000));
    subplot(2, 1, 2);
    semilogx(f, 20*log10(abs(H)));
    hold on;
end

subplot(2, 1, 1);
legend(arrayfun(@(N) ['N = ' num2str(N)], N_values, 'UniformOutput', false));
hold off;

subplot(2, 1, 2);
title('Charakterystyka amplitudowo-częstotliwościowa dla górnoprzepustowego filtra Butterwortha');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda (dB)');
legend(arrayfun(@(N) ['N = ' num2str(N)], N_values, 'UniformOutput', false));
hold off;

% Porównanie z funkcją butter
figure;
for N = N_values
    [b, a] = butter(N, 2*pi*f0, 'low', 's');
    [b_ref, a_ref] = butter(N, 2*pi*f0, 'low', 's');
    
    % Charakterystyka amplitudowo-częstotliwościowa
    [H, f] = freqs(b, a, logspace(-1, 2, 1000));
    [H_ref, ~] = freqs(b_ref, a_ref, logspace(-1, 2, 1000));
    
    semilogx(f, 20*log10(abs(H)), 'b');
    hold on;
    semilogx(f, 20*log10(abs(H_ref)), 'r--');
end

title('Porównanie z funkcją butter dla dolnoprzepustowego filtra Butterwortha');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda (dB)');
legend('Projektowany filtr', 'Funkcja butter');
hold off;
