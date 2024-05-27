% Load the MP3 file containing the EKG signal
filename = 'ekg-sounds.mp3';
[x, Fs] = audioread(filename); % Read the audio file

% Extract a single channel if the audio has multiple channels
if size(x, 2) > 1
    x = x(:, 1); % Taking only the first channel (assuming it's a stereo file)
end

% Assuming x contains the EKG signal and Fs is its sampling frequency
% Upsample the signal to 8000 Hz
desiredFs_1 = 8000;
upsampleFactor_1 = desiredFs_1 / Fs;
x_upsampled_1 = resample(x, desiredFs_1, Fs);

% Upsample the signal to 11025 Hz
desiredFs_2 = 11025;
upsampleFactor_2 = desiredFs_2 / Fs;
x_upsampled_2 = resample(x, desiredFs_2, Fs);

% Save the upsampled signals as audio files
audiowrite('ekg_upsampled_8000Hz.wav', x_upsampled_1, desiredFs_1);
audiowrite('ekg_upsampled_11025Hz.wav', x_upsampled_2, desiredFs_2);

