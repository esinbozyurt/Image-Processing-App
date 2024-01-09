function hsiImage = rgbtohsi(inputImage)

    R = double(inputImage(:, :, 1)) / 255;
    G = double(inputImage(:, :, 2)) / 255;
    B = double(inputImage(:, :, 3)) / 255;


    H = atan2(2 * G - R - B, sqrt(3) * (R - G) .* (R - B));
    S = 1 - (3 ./ (R + G + B)) .* min(R, min(G, B));
    V = (R + G + B) / 3;
    hsiImage = cat(3, mod(H / (2 * pi), 1), S, V);
end
