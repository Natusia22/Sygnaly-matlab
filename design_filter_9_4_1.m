% Parametry
fpr = 2000; % czestotliwosc probkowania (Hz)
f0 = 100; % czestotliwosc graniczna
M = 100; % polowa dlugosci filtra, N=2M+1
K = 4; % nadprobkowanie w dziedzinie czestotliwosci
% P punktow zadanej ch-ki amplitudowej Ad() dla czestotliwosci katowych 2*pi*p/P, p=0...P-1
P = K*2*M; % liczba punktow ch-ki amplitudowej (parzysta; P >= N=2M+1)
L1 = floor(f0/fpr*P); % liczba pierwszych punktow o wzmocnieniu 1
Ad = [ ones(1,L1) 0.5 zeros(1,P-(2*L1-1)-2) 0.5 ones(1,L1-1)];
% Wybor wspolczynnikow wagowych w(p) optymalizacji, p=0...P-1, dla pasm Pass/Transit/Stop
wp = 1; % wagi dla PassBand
wt = 1; % wagi dla TransientBand
ws = 10000; % wagi dla StopBand
w = [ wp*ones(1,L1) wt ws*ones(1,P-(2*L1-1)-2) wt wp*ones(1,L1-1) ];
W = zeros(P,P); %
for p=1:P % macierz z wagami optymalizacji na glownej przekatnej
W(p,p)=w(p); %
end %
% Znajdz macierz F, bedaca rozwiazaniem rownania macierzowego W*F*h = W*(Ad + err)
for p = 1:P
    W(p,p) = w(p); % Wypełnienie macierzy W wartościami z wektora w
end

F = []; % Inicjalizacja pustej macierzy F poza pętlą

for p = 0:P-1
    newRow = [2*cos(2*pi*(M-n)*p/P), 1]; % Tworzenie nowego wiersza dla macierzy F
    F = [F; newRow]; % Dodanie nowego wiersza do macierzy F
end

n = 0 : M-1;
for p = 0 : P-1
F = [ F; 2*cos(2*pi*(M-n)*p/P) 1 ];
end
% Znajdz wagi h(n), minimalizujace blad LS sum( (W*F*h - W*Ad).^2 )
% h = pinv(W*F)*(W*Ad); % metoda #1
h = (W*F)\(W*Ad); % metoda #2
b = [ h; h(M:-1:1) ]; % odbicie symetryczne
%b = b .* chebwin(N,100)’; % opcjonalne zastosowanie dowolnej funkcji okna
figure; stem(-M:M,b); title('Odpowiedź impulsowa filtra'); grid on; % poprawione wywołanie funkcji title() i dodanie grid on
pause;

figure; stem(b); title('Wagi filtra'); grid on; pause; % poprawione wywołanie funkcji title() i dodanie grid on
% Projekt/wybor wartosci wspolczynnikow "b" filtra FIR
fpr = 2000; % czestotliwosc probkowania
M = 101; % liczba wspolczynnikow filtra
b = [ 1 2 3 ]; % wagi filtra [b0, b1, b2, b3,...]
%b = fir1(M-1, 100/(fpr/2)); % metoda okien: M wspolczynnkow, filtr low-pass, f0=100Hz
%b = fir2(M-1,[0 75 250 fpr/2]/(fpr/2),[1 1 0 0]); % odwrotne DFT: czestotliwosc->wzmocnienie
%b = firls(M-1,[0 75 250 fpr/2]/(fpr/2),[1 1 0 0],[1 10]); % optymalizacja LS
%b = firpm(M-1,[0 75 250 fpr/2]/(fpr/2),[1 1 0 0],[1 10]); % minimalny blad maksymalny
figure; stem(b); title(b(k)); grid; pause
% Polozenie zer transmitancji
z = roots(b); % pierwiastki wielomianu licznika
figure;
var = 0 : pi/1000 : 2*pi; c=cos(var); s=sin(var);
plot(real(z),imag(z),bo, c,s,k); grid;
title('TF Zeros'); xlabel('Real'); ylabel('Imag'); pause;

% Weryfikacja zaprojektowanego filta
% Odpowiedzi: amplitudowa, fazowa, impulsowa, skokowa
f = 0 : 0.1 : 1000; % czestotliwosc w hercach
wn = 2*pi*f/fpr; % czestotliwosc katowa unormowana (/fpr)
zz = exp(-1i * wn); % Odwrotność zmiennej transformacji Z: z^(-1)

H = polyval(b(end:-1:1),zz); % odpowiedz czestotliwosciowa, transmitancja dla zz=exp(-j*wn)
% H = freqz(b,1,f,fpr); % to samo za pomoca jednej funkcji Matlaba
figure; plot(f,20*log10(abs(H))); xlabel('f [Hz]'); title('|H(f)| [dB]'); grid on; pause;

figure; plot(f,unwrap(angle(H))); xlabel('f [Hz]'); title('angle(H(f)) [rad]'); grid on; pause;

% Sygnal wejsciowy x(n) - suma dwoch sinusoid: 20 oraz 500 Hz
Nx = 2000; % liczba probek sygnalu
dt = 1/fpr; t = dt*(0:Nx-1); % chwile pobierania probek (probkowania)
%x = zeros(1,Nx); x(1) = 1; % impuls jednostkowy (delta Kroneckera)
x = sin(2*pi*20*t+pi/3) + sin(2*pi*500*t+pi/7); % suma dwoch sinusow
% Cyfrowa filtracja FIR: x(n) --> [ b ] --> y(n)
M = length(b); % liczba wspolczynnikow b(k) filtra FIR
bx = zeros(1,M); % bufor na probki wejsciowe sygnalu x(n)
for n = 1 : Nx % PETLA GLOWNA
bx = [ x(n) bx(1:M-1) ]; % umiesc kolejna probke x(n) w buforze bx
y = conv(bx, b); % wykonaj filtrację (splot) - conv() oblicza splot między bx a b
end %
%y = filter(b,1,x); % to samo z uzyciem funkcji filter()
%y = conv(x,b); y=y(1:NX); % to samo z uzyciem funkcji conv()


igure;
subplot(211); plot(t,x); grid; % sygnal wejsciowy x(n)
subplot(212); plot(t,y); grid; pause % sygnal wyjsciowy y(n)
figure; % widma DFT drugich polowek obu sygnalow (usuniecie stanu przejsciowego z WY)
k=Nx/2+1:Nx; f0 = fpr/(Nx/2); f=f0*(0:Nx/2-1);
subplot(211); plot(f,20*log10(abs(2*fft(x(k)))/(Nx/2))); grid;
subplot(212); plot(f,20*log10(abs(2*fft(y(k)))/(Nx/2))); grid; pause
figure; % synchronizacja sygnalow WE i WY
subplot(211); plot(t, x, 'r-', t, y, 'b-'); grid on; % brak synchronizacji WE i WY
P = (M - 1) / 2; t = t(P + 1:end - P); x = x(P + 1:end - P); y = y(2 * P + 1:end); % kompensacja opóźnienia
subplot(212); plot(t, x, 'r-', t, y, 'b-'); grid on; pause; % po synchronizacji WE i WY
