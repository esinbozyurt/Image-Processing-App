function normalizedImage = mynormalize(inputImage)
    normalizedImage = (inputImage - min(inputImage(:))) / (max(inputImage(:)) - min(inputImage(:)));
end
