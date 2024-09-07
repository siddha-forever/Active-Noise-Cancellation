clc
clear all
close all

%spectral subraction method

% Read the noisy audio signal
noisyFilePath = '/Users/siddha-book/Downloads/active-noise-cancellation-master/Code/audio.wav'; % Replace with the path to your noisy audio file
[noisySignal, fs] = audioread(noisyFilePath);

% Parameters for Spectral Subtraction
frameSize = 512; % Frame size in samples
overlap = 0.75; % Overlap percentage between frames (0 to 1)
alpha = 2; % Over-subtraction factor
beta = 0.02; % Spectral floor (controls the amount of residual noise)

% Apply Spectral Subtraction
noisySignal = noisySignal(:, 1); % Consider only the first channel if it's a stereo audio

% Calculate the number of frames
frameShift = round(frameSize * (1 - overlap));
numFrames = floor((length(noisySignal) - frameSize) / frameShift) + 1;

% Initialize the processed signal
processedSignal = zeros((numFrames - 1) * frameShift + frameSize, 1);

for i = 1:numFrames
    % Extract the current frame
    startIndex = (i - 1) * frameShift + 1;
    endIndex = startIndex + frameSize - 1;
    frame = noisySignal(startIndex:endIndex);
    
    % Perform FFT on the frame
    frameFFT = fft(frame);
    
    % Calculate the magnitude spectrum and phase
    magSpectrum = abs(frameFFT);
    phase = angle(frameFFT);
    
    % Estimate the noise spectrum (assumed to be the first frame)
    if i == 1
        noiseMagSpectrum = magSpectrum;
    end
    
    % Perform Spectral Subtraction
    processedMagSpectrum = magSpectrum - alpha * noiseMagSpectrum;
    processedMagSpectrum = max(processedMagSpectrum, beta * noiseMagSpectrum);
    
    % Reconstruct the processed frame using the modified magnitude spectrum and the original phase
    processedFrame = real(ifft(processedMagSpectrum .* exp(1i * phase)));
    
    % Overlap and add the processed frame to the output signal
    processedSignal(startIndex:endIndex) = processedSignal(startIndex:endIndex) + processedFrame;
end

% Normalize the processed signal
processedSignal = processedSignal / max(abs(processedSignal));

% Save the processed audio to a file
outputFilePath = '/Users/siddha-book/Downloads/active-noise-cancellation-master/Code/processed_audio.wav'; % Replace with the desired output file path
audiowrite(outputFilePath, processedSignal, fs);

disp('Noise reduction completed and processed audio saved successfully.');
