fpr = 2000; % Częstotliwość próbkowania (Hz)
f0 = 100; % Częstotliwość graniczna
M = 100; % Połowa długości filtra, N=2M+1

% typ filtru i wagi dla poszczególnych pasm
filter_type = 'band-pass'; % Typ filtra: low-pass, high-pass, band-pass
wp = 1; % Wagi dla PassBand
wt = 1; % Wagi dla TransientBand
ws = 10000; % Wagi dla StopBand

% Projektowanie filtra
design_filter(fpr, f0, M, filter_type, wp, wt, ws);

function design_filter(fpr, f0, M, filter_type, wp, wt, ws)
    % Parametry
    K = 4; % nadprobkowanie w dziedzinie czestotliwosci
    % P punktow zadanej ch-ki amplitudowej Ad() dla czestotliwosci katowych 2*pi*p/P, p=0...P-1
    P = K*2*M; % liczba punktow ch-ki amplitudowej (parzysta; P >= N=2M+1)
    L1 = floor(f0/fpr*P); % liczba pierwszych punktow o wzmocnieniu 1
    
    % Tworzenie sygnału amplitudy dla różnych typów filtrów
    if strcmp(filter_type, 'low-pass')
        Ad = [ ones(1,L1) 0.5 zeros(1,P-(2*L1-1)-2) 0.5 ones(1,L1-1)];
    elseif strcmp(filter_type, 'high-pass')
        Ad = [ zeros(1,L1) 0.5 ones(1,P-(2*L1-1)-2) 0.5 zeros(1,L1-1)];
    elseif strcmp(filter_type, 'band-pass')
        band_center = floor(P/2); % Środek pasma
        band_width = 20; % Szerokość pasma
        Ad = zeros(1, P);
        Ad(band_center-band_width/2 : band_center+band_width/2) = 1;
    else
        error('Niepoprawny typ filtra. Dostępne typy: low-pass, high-pass, band-pass');
    end
    Ad = Ad';
    
    % Wybor wspolczynnikow wagowych w(p) optymalizacji, p=0...P-1, dla pasm Pass/Transit/Stop
    w = [ wp*ones(1,L1) wt ws*ones(1,P-(2*L1-1)-2) wt wp*ones(1,L1-1) ];
    W = diag(w); % Macierz diagonalna z wagami
    
    % Znajdz macierz F, bedaca rozwiazaniem rownania macierzowego W*F*h = W*(Ad + err)
    F = construct_F_matrix(P, M, filter_type);
    
    % Znajdz wagi h(n), minimalizujace blad LS sum( (W*F*h - W*Ad).^2 )
    h = (W*F)\(W*Ad);
    b = [ h; h(M:-1:1) ]';
    
    % Opcjonalne zastosowanie dowolnej funkcji okna
    % b = b .* chebwin(N,100)';
    
    % Rysunek
    figure;
    stem(-M:M,b);
    title('b(n)');
    grid on;
end

function F = construct_F_matrix(P, M, filter_type)
    F = zeros(P, M + 1);
    n = 0 : M-1;
    if nargin < 3
        error('Nie podano wszystkich argumentów. Brakuje typu filtra.');
    end
    if strcmp(filter_type, 'low-pass')
        for p = 0 : P-1
            F(p+1, :) = [2*cos(2*pi*(M-n)*p/P) 1 ];
        end
    elseif strcmp(filter_type, 'high-pass')
        for p = 0 : P-1
            F(p+1, :) = [2*cos(2*pi*(M-n)*p/P) (-1)^p ];
        end
    elseif strcmp(filter_type, 'band-pass')
        band_center = floor(P/2); % Środek pasma
        band_width = 20; % Szerokość pasma
        for p = 0 : P-1
            if p >= band_center-band_width/2 && p <= band_center+band_width/2
                F(p+1, :) = [2*cos(2*pi*(M-n)*p/P) 1 ];
            else
                F(p+1, :) = [2*cos(2*pi*(M-n)*p/P) 0 ];
            end
        end
    else
        error('Niepoprawny typ filtra. Dostępne typy: low-pass, high-pass, band-pass');
    end
end
