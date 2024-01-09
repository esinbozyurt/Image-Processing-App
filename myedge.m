function edgeImage = myedge(inputImage, kernelType, useDiagonal)
    switch kernelType
        case 'Prewitt'

            if ~useDiagonal 
                XKernel = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
                YKernel = [-1, -1, -1; 0, 0, 0; 1, 1, 1];

                hGradient = conv2(double(inputImage), XKernel, 'same');
                vGradient = conv2(double(inputImage), YKernel, 'same');

                gradientMagnitude = sqrt(hGradient.^2 + vGradient.^2);
            end


            if  useDiagonal
                X1diagonal = [-1, -1, 0; -1, 0, 1; 0, 1, 1];
                X2diagonal = [1, 1, 0; 1, 0, -1; 0, -1, -1];
    
                Y1diagonal = [0, -1, -1; 1, 0, -1; 1, 1, 0];
                Y2diagonal = [0, 1, 1; -1, 0, 1; -1, -1, 0];


                X1Gradient = conv2(double(inputImage), X1diagonal, 'same');
                X2Gradient = conv2(double(inputImage), X2diagonal, 'same');
                Y1Gradient = conv2(double(inputImage), Y1diagonal, 'same');
                Y2Gradient = conv2(double(inputImage), Y2diagonal, 'same');

                gradientMagnitude = sqrt(X1Gradient.^2 + X2Gradient.^2 + Y1Gradient.^2 + Y2Gradient.^2);
            end
            

        case 'Sobel'  
            if ~useDiagonal
                sobelHorizontal = [-1, -2, -1; 
                                    0, 0, 0; 
                                    1, 2, 1];

                sobelVertical = [-1, 0, 1; 
                                 -2, 0, 2; 
                                 -1, 0, 1];

                gradientX = conv2(inputImage, sobelHorizontal, 'same');
                gradientY = conv2(inputImage, sobelVertical, 'same');
                gradientMagnitude = sqrt(gradientX.^2 + gradientY.^2);
            end

            if useDiagonal
                sobelDiagonal1 = [0, -1, -2; 1, 0, -1; 2, 1, 0];
                sobelDiagonal2 = [0, 1, 2; -1, 0, 1; -2, -1, 0];

                sobelDiagonal3 = [-2, -1, 0; -1, 0, 1; -0, 1, 2];
                sobelDiagonal4 = [2, 1, 0; 1, 0, -1; 0, -1, -2];

                gradientDiagonal1 = conv2(inputImage, sobelDiagonal1, 'same');
                gradientDiagonal2 = conv2(inputImage, sobelDiagonal2, 'same');
                gradientDiagonal3 = conv2(inputImage, sobelDiagonal3, 'same');
                gradientDiagonal4 = conv2(inputImage, sobelDiagonal4, 'same');
            
                gradientMagnitude = sqrt(gradientDiagonal3.^2 + gradientDiagonal4.^2 + gradientDiagonal1.^2 + gradientDiagonal2.^2);
            end


        case 'Kirsch'
            if ~useDiagonal
                g1=[5,5,5; -3,0,-3; -3,-3,-3];
                g2=[5,5,-3; 5,0,-3; -3,-3,-3];
                g3=[5,-3,-3; 5,0,-3; 5,-3,-3];
                g4=[-3,-3,-3; 5,0,-3; 5,5,-3];
                g5=[-3,-3,-3; -3,0,-3; 5,5,5];
                g6=[-3,-3,-3; -3,0,5;-3,5,5];
                g7=[-3,-3,5; -3,0,5;-3,-3,5];
                g8=[-3,5,5; -3,0,5;-3,-3,-3];
    
                filteredImage = cell(1, 8);

                for i = 1:8
                    filteredImage{i} = imfilter(inputImage, eval(['g', num2str(i)]), 'replicate');
                end

                edgeImage = filteredImage{1};
                for i = 2:8
                    edgeImage = max(edgeImage, filteredImage{i});
                end
            end
            
            if  useDiagonal
                g1 = [5, 5, 5; -3, 0, -3; -3, -3, -3];
                g2 = [-3, -3, -3; 5, 0, -3; 5, 5, -3];
                g3 = [-3, -3, -3; -3, 0, -3; 5, 5, 5];
                g4 = [5, -3, -3; 5, 0, -3; 5, -3, -3];

                filteredImage = cell(1, 4);

                for i = 1:4
                    filteredImage{i} = imfilter(inputImage, eval(['g', num2str(i)]), 'replicate');
                end

                edgeImage = filteredImage{1};
                for i = 2:4
                    edgeImage = max(edgeImage, filteredImage{i});
                end
                return;
            else
                return;
            end

        case 'Scharr'
            scharrHorizontal = [-3, 0, 3; -10, 0, 10; -3, 0, 3];
            scharrVertical = [-3, -10, -3; 0, 0, 0; 3, 10, 3];
        
            gradientX = conv2(inputImage, scharrHorizontal, 'same');
            gradientY = conv2(inputImage, scharrVertical, 'same');
       
            gradientMagnitude = sqrt(gradientX.^2 + gradientY.^2);

        otherwise
            error('Invalid kernel type. Please choose a valid option.');
    end

    normalizedMagnitude = mynormalize(gradientMagnitude);
    threshold = 0.1;  
    edgeImage = normalizedMagnitude > threshold;

end