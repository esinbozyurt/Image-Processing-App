function finalizedImage = mymorph(binaryImage, selectedColormap)
       switch selectedColormap
                case 'Jet'
                    colormapToUse = jet(256); 
                case 'Summer'
                    colormapToUse = summer(256); 
                case 'Winter'
                    colormapToUse = winter(256); 
                case 'Hot'
                    colormapToUse = hot(256); 
                case 'Cool'
                    colormapToUse = cool(256); 
                otherwise
                    error('Invalid colormap selection.');
        end
              
        try
            if ~ismember(selectedColormap, {'Jet', 'Hot', 'Cool', 'Summer', 'Winter'})
                error('Invalid colormap selection.');
                
            end
           
            if size(binaryImage, 3) == 3 
                grayImage = rgb2gray(binaryImage);
            else
                grayImage = binaryImage;  
            end
 
            labeledImage = bwlabel(grayImage);
            numLabels = max(labeledImage(:));
            colormapColors = colormapToUse(round(linspace(1, size(colormapToUse, 1), numLabels)), :);
            myColoredImage = label2rgb(labeledImage, colormapColors, 'k', 'shuffle');
            finalizedImage = im2double(myColoredImage);
        
        catch ME
            disp(['Error during colormaping: ', ME.message]);
            uialert('Error during colormaping', 'Error', 'Icon', 'error');  
        end

end
