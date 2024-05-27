% Wczytanie pliku audio
filename = 'ekg-sounds.mp3';
[y, Fs] = audioread(filename);

% W przypadku wielokanałowych danych, wybieramy tylko jeden kanał
if size(y, 2) > 1
    y = y(:, 1);
end

% Docelowe częstotliwości próbkowania
desiredFs_1 = 8000;
desiredFs_2 = 11025;

% Określenie stosunku podwyższenia próbkowania
upsampleFactor_1 = desiredFs_1 / Fs;
upsampleFactor_2 = desiredFs_2 / Fs;

% Interpolacja liniowa (upsampling)
y_upsampled_1 = zeros(ceil(length(y) * upsampleFactor_1), 1);
y_upsampled_2 = zeros(ceil(length(y) * upsampleFactor_2), 1);

% Interpolacja dla pierwszej docelowej częstotliwości próbkowania
for i = 1:length(y_upsampled_1)
    index = (i - 1) / upsampleFactor_1 + 1;
    lowerIndex = floor(index);
    upperIndex = min(ceil(index), length(y));
    
    if lowerIndex == upperIndex
        y_upsampled_1(i) = y(lowerIndex);
    else
        y_upsampled_1(i) = y(lowerIndex) + (index - lowerIndex) * (y(upperIndex) - y(lowerIndex));
    end
end

% Interpolacja dla drugiej docelowej częstotliwości próbkowania
for i = 1:length(y_upsampled_2)
    index = (i - 1) / upsampleFactor_2 + 1;
    lowerIndex = floor(index);
    upperIndex = min(ceil(index), length(y));
    
    if lowerIndex == upperIndex
        y_upsampled_2(i) = y(lowerIndex);
    else
        y_upsampled_2(i) = y(lowerIndex) + (index - lowerIndex) * (y(upperIndex) - y(lowerIndex));
    end
end

% Zapis do plików audio
audiowrite('ekg_upsampled_8000Hz.wav', y_upsampled_1, desiredFs_1);
audiowrite('ekg_upsampled_11025Hz.wav', y_upsampled_2, desiredFs_2);
