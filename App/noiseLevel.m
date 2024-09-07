clc
clear all
close all

[y, fs] = audioread('audio.wav');

segmentDuration = 1; % Duration of each segment in seconds
segmentLength = round(segmentDuration * fs); % Length of each segment in samples

numSegments = floor(length(y) / segmentLength); % Number of segments

energy = zeros(numSegments, 1); % Array to store the energy of each segment

% Compute the energy of each segment
for i = 1:numSegments
    startIndex = (i - 1) * segmentLength + 1;
    endIndex = i * segmentLength;
    segment = y(startIndex:endIndex);
    energy(i) = sum(segment.^2);
end

% Find the segment with the lowest energy
[minEnergy, minIndex] = min(energy);

% Set the start and end indices of the noise segment
startSample = (minIndex - 1) * segmentLength + 1;
endSample = minIndex * segmentLength;

noiseSegment = y(startSample:endSample);
noiselevel = mad(noiseSegment);

fprintf('Noise Level: %.2f\n', noiselevel);

