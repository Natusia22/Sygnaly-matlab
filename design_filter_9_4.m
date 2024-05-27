fpr = 2000; % Częstotliwość próbkowania (Hz)
f0 = 100; % Częstotliwość graniczna
M = 100; % Połowa długości filtra, N=2M+1

% Wybierz typ filtru i wagi dla poszczególnych pasm
filter_type = 'low-pass'; % Typ filtra: low-pass, high-pass, band-pass, band-stop
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
    Ad = [ ones(1,L1) 0.5 zeros(1,P-(2*L1-1)-2) 0.5 ones(1,L1-1)];
    Ad = Ad';
    
    % Wybor wspolczynnikow wagowych w(p) optymalizacji, p=0...P-1, dla pasm Pass/Transit/Stop
    w = [ wp*ones(1,L1) wt ws*ones(1,P-(2*L1-1)-2) wt wp*ones(1,L1-1) ];
    W = diag(w); % Macierz diagonalna z wagami
    
    % Znajdz macierz F, bedaca rozwiazaniem rownania macierzowego W*F*h = W*(Ad + err)
    F = construct_F_matrix(P, M);
    
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

function F = construct_F_matrix(P, M)
    F = [];
    n = 0 : M-1;
    for p = 0 : P-1
        F = [ F; 2*cos(2*pi*(M-n)*p/P) 1 ];
    end
end
