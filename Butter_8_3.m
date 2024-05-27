%low-pass(dolno) dobry do usuwania szumów i zakłoceń/marnowanie energii

%high-pass(górno) usuwanie niskich częstotliwości(np szumy
%środowiskowe)/poddatnośc na szumy w wysokich częstotliwościach

%band-pass (pasmowo-przepustowe) izolacja pożądanego pasma/ szerokie pasmo
%przejściowe

%band-stop(pasmowo-zaporowy) eliminacja niepożadanych pasm, ochrona przed
%zakłoceniami/ większa złożoność

% Parametry filtrów
f_low = 100; % Dolna częstotliwość graniczna dla high-pass i band-stop
f_high = 600; % Górna częstotliwość graniczna dla high-pass i band-stop
f_band_low = 400; % Dolna częstotliwość graniczna dla band-pass
f_band_high = 600; % Górna częstotliwość graniczna dla band-pass
Fs = 2000; % Częstotliwość próbkowania

% Obliczenie częstotliwości granicznych w skali znormalizowanej
Wn_low = f_low / (Fs/2);
Wn_high = f_high / (Fs/2);
Wn_band = [f_band_low, f_band_high] / (Fs/2);

% Projektowanie filtrów
order = 4; % Stopień filtru
[b_low, a_low] = butter(order, Wn_low, 'low');
[b_high, a_high] = butter(order, Wn_high, 'high');
[b_band, a_band] = butter(order, Wn_band, 'bandpass');
[b_stop, a_stop] = butter(order, [Wn_low, Wn_high], 'stop');

% Wyświetlanie charakterystyk amplitudowych filtrów na jednym wykresie
figure;
freqz(b_low, a_low, 1024, Fs);
hold on;
freqz(b_high, a_high, 1024, Fs);
freqz(b_band, a_band, 1024, Fs);
freqz(b_stop, a_stop, 1024, Fs);
legend('Low-pass', 'High-pass', 'Band-pass', 'Band-stop');
title('Charakterystyki amplitudowe różnych filtrów');
hold off;
